`timescale 1ns/1ps

// T3 baseline comparison: measure the recovery cost of three strategies under
// the SAME injected error (one corrupted line in an 8-line RAW8 frame).
//
//   STRATEGY = 1  A: line-level recapture  -> re-send only the bad line
//   STRATEGY = 2  B: full-frame retransmit -> re-send the whole frame on error
//   STRATEGY = 0  C: discard, no recovery  -> drop the bad line, do nothing
//
// Measured per run (printed as METRIC lines for the model overlay):
//   recovery_groups   lane groups (x2 bytes) transmitted FOR RECOVERY
//   recovery_latency  ns from the error to the bad slot holding correct data
//   recovered         1 if the bad slot ends up clean, else 0
//   buffer_lines      upstream buffer the strategy needs (D for A, H for B, 0 for C)
//
// Select the strategy at compile time: xvlog -d STRATEGY_SEL=<n> (default 1).
// Strategy selected at elaboration: xelab -generic_top "STRATEGY=<n>"
// (0 = C discard, 1 = A line-level recapture, 2 = B full-frame retransmit).
module tb_recapture_strategy_compare #(
    parameter int STRATEGY = 1
);

    localparam int LANE_NUM = 2;
    localparam logic [5:0] DATA_TYPE = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID = 2'd0;

    localparam int H         = 8;     // lines per frame
    localparam int BAD_LINE  = 3;     // 0-based writer slot of the corrupted line
    localparam int SLOTK_WORD = 16 * BAD_LINE;
    localparam int D_LINES   = 1;     // modelled upstream window (lines) for A

    logic clk_sys, clk_byte, clk_axi, clk_ddr, rst_n;
    logic [31:0] lane_data_0, lane_data_1, lane_data_2, lane_data_3;
    logic        lane_valid_0, lane_valid_1, lane_valid_2, lane_valid_3;
    logic        hs_mode, lp_mode;
    logic        frame_start_o, frame_end_o, line_start_o, line_end_o;
    logic        err_ecc_o, err_crc_o, err_sync_o;
    logic [23:0] pixel_data_o;
    logic        pixel_valid_o, pixel_sof_o, pixel_sol_o;
    logic        retry_req_o, retry_pending_o, retry_mode_o;
    logic [31:0] retry_frame_id_o, retry_line_id_o;
    logic        cfg_init_done_o;
    logic        src_recap_line_valid;

    logic [LANE_NUM-1:0]      sensor_lane_valid;
    logic [LANE_NUM-1:0][7:0] sensor_lane_data;
    logic [LANE_NUM-1:0]      sensor_lane_ready;

    int   group_count;          // total lane groups sent
    realtime t_error;

    mipi_csi2_capture_recap_wrapper #(
        .LANE_NUM(LANE_NUM),
        .IMG_WIDTH(16'd4),
        .IMG_HEIGHT(H[15:0]),
        .LINE_STRIDE(32'd64)
    ) dut (
        .clk_sys(clk_sys), .clk_byte(clk_byte), .clk_axi(clk_axi), .clk_ddr(clk_ddr), .rst_n(rst_n),
        .lane_data_0(lane_data_0), .lane_data_1(lane_data_1),
        .lane_data_2(lane_data_2), .lane_data_3(lane_data_3),
        .lane_valid_0(lane_valid_0), .lane_valid_1(lane_valid_1),
        .lane_valid_2(lane_valid_2), .lane_valid_3(lane_valid_3),
        .hs_mode(hs_mode), .lp_mode(lp_mode),
        .src_recap_line_valid_i(src_recap_line_valid),
        .frame_start_o(frame_start_o), .frame_end_o(frame_end_o),
        .line_start_o(line_start_o), .line_end_o(line_end_o),
        .err_ecc_o(err_ecc_o), .err_crc_o(err_crc_o), .err_sync_o(err_sync_o),
        .pixel_data_o(pixel_data_o), .pixel_valid_o(pixel_valid_o),
        .pixel_sof_o(pixel_sof_o), .pixel_sol_o(pixel_sol_o),
        .retry_req_o(retry_req_o), .retry_pending_o(retry_pending_o),
        .retry_mode_o(retry_mode_o), .retry_frame_id_o(retry_frame_id_o),
        .retry_line_id_o(retry_line_id_o), .cfg_init_done_o(cfg_init_done_o)
    );

    assign sensor_lane_ready = dut.u_mipi_csi2_capture_top.phy_lane_ready[LANE_NUM-1:0];

    always_comb begin
        lane_data_0  = {24'd0, sensor_lane_data[0]};
        lane_data_1  = {24'd0, sensor_lane_data[1]};
        lane_data_2  = 32'd0;
        lane_data_3  = 32'd0;
        lane_valid_0 = sensor_lane_valid[0];
        lane_valid_1 = sensor_lane_valid[1];
        lane_valid_2 = 1'b0;
        lane_valid_3 = 1'b0;
    end

    task automatic clear_lane_drive;
        begin sensor_lane_valid = '0; sensor_lane_data = '0; end
    endtask

    task automatic push_lane_group(input logic [7:0] byte0, input logic [7:0] byte1);
        begin
            while (!(sensor_lane_ready[0] && sensor_lane_ready[1])) @(posedge clk_byte);
            @(negedge clk_byte);
            sensor_lane_valid[0] = 1'b1; sensor_lane_valid[1] = 1'b1;
            sensor_lane_data[0]  = byte0; sensor_lane_data[1] = byte1;
            @(posedge clk_byte); @(negedge clk_byte);
            clear_lane_drive();
            group_count = group_count + 1;
        end
    endtask

    task automatic send_short_packet(input logic [5:0] dt);
        logic [31:0] header;
        begin
            header = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, dt, 16'd0, 1'b0);
            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(header, 0),
                            csi2_reference_helpers_pkg::csi2_packet_byte(header, 1));
            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(header, 2),
                            csi2_reference_helpers_pkg::csi2_packet_byte(header, 3));
        end
    endtask

    task automatic send_long_packet(input bit corrupt);
        logic [31:0] header; logic [15:0] payload_crc; logic [7:0] p0;
        begin
            header = csi2_reference_helpers_pkg::csi2_pack_header(
                VC_ID, DATA_TYPE,
                csi2_reference_helpers_pkg::csi2_payload_byte_count(DATA_TYPE), 1'b0);
            payload_crc = csi2_reference_helpers_pkg::csi2_payload_crc(DATA_TYPE);
            p0 = csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 0);
            if (corrupt) p0 = p0 ^ 8'h01;
            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(header, 0),
                            csi2_reference_helpers_pkg::csi2_packet_byte(header, 1));
            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(header, 2),
                            csi2_reference_helpers_pkg::csi2_packet_byte(header, 3));
            push_lane_group(p0, csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 1));
            push_lane_group(csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 2),
                            csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 3));
            push_lane_group(payload_crc[7:0], payload_crc[15:8]);
        end
    endtask

    task automatic send_line(input bit corrupt);
        begin
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
            send_long_packet(corrupt);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LE);
        end
    endtask

    function automatic bit slot_clean(input int word_base);
        begin
            slot_clean = (dut.u_axi_write_null_slave.mem[word_base+0] === 32'h00000011) &&
                         (dut.u_axi_write_null_slave.mem[word_base+1] === 32'h00000022) &&
                         (dut.u_axi_write_null_slave.mem[word_base+2] === 32'h00000033) &&
                         (dut.u_axi_write_null_slave.mem[word_base+3] === 32'h00000044);
        end
    endfunction

    initial begin clk_sys = 0;  forever #5 clk_sys = ~clk_sys; end
    initial begin clk_byte = 0; forever #4 clk_byte = ~clk_byte; end
    initial begin clk_axi = 0;  forever #5 clk_axi = ~clk_axi; end
    initial begin clk_ddr = 0;  forever #5 clk_ddr = ~clk_ddr; end

    int   recovery_groups;
    int   buffer_lines;
    realtime t_recovered;
    bit   recovered;
    int   i;
    int   poll;

    initial begin
        rst_n = 1'b0; hs_mode = 1'b1; lp_mode = 1'b0;
        src_recap_line_valid = 1'b0; group_count = 0;
        recovery_groups = 0; t_error = 0; t_recovered = 0; recovered = 1'b0;
        clear_lane_drive();
        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        wait (cfg_init_done_o);
        // Force config deterministically (force overrides boot config).
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_enable_o            = 1'b1;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_num_minus1_o   = 2'd1;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_enable_mask_o  = 4'b0011;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_dt_code_o           = 8'h2a;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_img_height_o        = H[15:0];
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_line_stride_o       = 32'd64;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_drop_on_crc_error_o = 1'b1;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_enable_retry_o      = 1'b1;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_retry_line_mode_o   =
              (STRATEGY == 1) ? 1'b1 : 1'b0;
        repeat (4) @(posedge clk_byte);

        // ---- Stream one frame; line BAD_LINE corrupted ----
        send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
        for (i = 0; i < H; i = i + 1) begin
            send_line(i == BAD_LINE);
            if (i == BAD_LINE) t_error = $realtime;   // error happens here

            // Strategy A: recapture the bad line in-frame, D lines later.
            if ((STRATEGY == 1) && (i == BAD_LINE + D_LINES)) begin
                wait (retry_pending_o);
                recovery_groups = group_count;
                @(negedge clk_sys);
                src_recap_line_valid = 1'b1;
                send_line(1'b0);                 // clean re-send of bad line
                repeat (40) @(posedge clk_sys);
                src_recap_line_valid = 1'b0;
                recovery_groups = group_count - recovery_groups;
            end
        end
        send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);

        // Strategy B: retransmit the entire frame (all clean).
        if (STRATEGY == 2) begin
            recovery_groups = group_count;
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
            for (i = 0; i < H; i = i + 1) send_line(1'b0);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);
            recovery_groups = group_count - recovery_groups;
        end

        // ---- Poll for recovery of the bad slot ----
        recovered = 1'b0;
        for (poll = 0; poll < 4000; poll = poll + 1) begin
            @(posedge clk_axi);
            if (!recovered && slot_clean(SLOTK_WORD)) begin
                recovered   = 1'b1;
                t_recovered = $realtime;
            end
        end

        buffer_lines = (STRATEGY == 1) ? D_LINES : (STRATEGY == 2) ? H : 0;

        $display("METRIC strategy=%0d label=%s recovery_groups=%0d recovery_bytes=%0d buffer_lines=%0d recovered=%0d recovery_latency_ns=%0d",
                 STRATEGY,
                 (STRATEGY==1) ? "A_line_recapture" : (STRATEGY==2) ? "B_frame_retransmit" : "C_discard",
                 recovery_groups, recovery_groups*2, buffer_lines, recovered,
                 recovered ? int'((t_recovered - t_error)/1ns) : -1);
        $display("PASS: tb_recapture_strategy_compare strategy=%0d recovered=%0d", STRATEGY, recovered);
        $finish;
    end

    initial begin
        repeat (60000) @(posedge clk_sys);
        $display("FAIL: tb_recapture_strategy_compare timeout strategy=%0d", STRATEGY);
        $fatal(1);
    end

endmodule
