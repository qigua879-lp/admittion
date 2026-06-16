`timescale 1ns/1ps

// T4 / T5-C2 boundary: the retry context holds only ONE outstanding request
// (retry_request_ctrl latches the latest located error). If line errors arrive
// faster than they are serviced/recaptured, the earlier line's request is
// overwritten and that line is NOT recovered. This is the simulation analogue
// of the feasibility window C2: a request must be serviced before the next, or
// it falls outside the recoverable window.
//
// Scenario (one RAW8 frame, H=8): corrupt line 3 AND line 5 with no recapture
// in between, then issue a single recapture. Expect:
//   * retry context = the LATEST error (line 5, frame-relative 1-based = 6)
//   * the single recapture overwrites slot 5 (clean)
//   * slot 3 stays empty (its request was overwritten -> permanently lost)
module tb_recapture_window_limit;

    localparam int LANE_NUM = 2;
    localparam logic [5:0] DATA_TYPE = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID = 2'd0;

    localparam int H = 8;
    localparam int BAD_EARLY = 3;            // earlier error (will be lost)
    localparam int BAD_LATE  = 5;            // later error (will be recaptured)
    localparam int WORDS_PER_LINE = 4;
    localparam int SLOT_EARLY_WORD = 16 * BAD_EARLY;
    localparam int SLOT_LATE_WORD  = 16 * BAD_LATE;

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

    logic [31:0] retry_line_seen;
    logic        recap_active_seen;

    mipi_csi2_capture_recap_wrapper #(
        .LANE_NUM(LANE_NUM), .IMG_WIDTH(16'd4), .IMG_HEIGHT(H[15:0]), .LINE_STRIDE(32'd64)
    ) dut (
        .clk_sys(clk_sys), .clk_byte(clk_byte), .clk_axi(clk_axi), .clk_ddr(clk_ddr), .rst_n(rst_n),
        .lane_data_0(lane_data_0), .lane_data_1(lane_data_1), .lane_data_2(lane_data_2), .lane_data_3(lane_data_3),
        .lane_valid_0(lane_valid_0), .lane_valid_1(lane_valid_1), .lane_valid_2(lane_valid_2), .lane_valid_3(lane_valid_3),
        .hs_mode(hs_mode), .lp_mode(lp_mode),
        .src_recap_line_valid_i(src_recap_line_valid),
        .frame_start_o(frame_start_o), .frame_end_o(frame_end_o), .line_start_o(line_start_o), .line_end_o(line_end_o),
        .err_ecc_o(err_ecc_o), .err_crc_o(err_crc_o), .err_sync_o(err_sync_o),
        .pixel_data_o(pixel_data_o), .pixel_valid_o(pixel_valid_o), .pixel_sof_o(pixel_sof_o), .pixel_sol_o(pixel_sol_o),
        .retry_req_o(retry_req_o), .retry_pending_o(retry_pending_o), .retry_mode_o(retry_mode_o),
        .retry_frame_id_o(retry_frame_id_o), .retry_line_id_o(retry_line_id_o), .cfg_init_done_o(cfg_init_done_o)
    );

    assign sensor_lane_ready = dut.u_mipi_csi2_capture_top.phy_lane_ready[LANE_NUM-1:0];

    always_comb begin
        lane_data_0  = {24'd0, sensor_lane_data[0]};
        lane_data_1  = {24'd0, sensor_lane_data[1]};
        lane_data_2  = 32'd0; lane_data_3 = 32'd0;
        lane_valid_0 = sensor_lane_valid[0];
        lane_valid_1 = sensor_lane_valid[1];
        lane_valid_2 = 1'b0; lane_valid_3 = 1'b0;
    end

    task automatic clear_lane_drive; begin sensor_lane_valid = '0; sensor_lane_data = '0; end endtask
    task automatic push_lane_group(input logic [7:0] b0, input logic [7:0] b1);
        begin
            while (!(sensor_lane_ready[0] && sensor_lane_ready[1])) @(posedge clk_byte);
            @(negedge clk_byte);
            sensor_lane_valid[0]=1'b1; sensor_lane_valid[1]=1'b1;
            sensor_lane_data[0]=b0;    sensor_lane_data[1]=b1;
            @(posedge clk_byte); @(negedge clk_byte);
            clear_lane_drive();
        end
    endtask
    task automatic send_short_packet(input logic [5:0] dt);
        logic [31:0] h;
        begin
            h = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, dt, 16'd0, 1'b0);
            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(h,0), csi2_reference_helpers_pkg::csi2_packet_byte(h,1));
            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(h,2), csi2_reference_helpers_pkg::csi2_packet_byte(h,3));
        end
    endtask
    task automatic send_long_packet(input bit corrupt);
        logic [31:0] hd; logic [15:0] cr; logic [7:0] p0;
        begin
            hd = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, DATA_TYPE, csi2_reference_helpers_pkg::csi2_payload_byte_count(DATA_TYPE), 1'b0);
            cr = csi2_reference_helpers_pkg::csi2_payload_crc(DATA_TYPE);
            p0 = csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE,0);
            if (corrupt) p0 = p0 ^ 8'h01;
            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(hd,0), csi2_reference_helpers_pkg::csi2_packet_byte(hd,1));
            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(hd,2), csi2_reference_helpers_pkg::csi2_packet_byte(hd,3));
            push_lane_group(p0, csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE,1));
            push_lane_group(csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE,2), csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE,3));
            push_lane_group(cr[7:0], cr[15:8]);
        end
    endtask
    task automatic send_line(input bit corrupt);
        begin
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
            send_long_packet(corrupt);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LE);
        end
    endtask

    initial begin clk_sys=0; forever #5 clk_sys=~clk_sys; end
    initial begin clk_byte=0; forever #4 clk_byte=~clk_byte; end
    initial begin clk_axi=0; forever #5 clk_axi=~clk_axi; end
    initial begin clk_ddr=0; forever #5 clk_ddr=~clk_ddr; end

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin retry_line_seen <= 32'd0; recap_active_seen <= 1'b0; end
        else begin
            if (retry_req_o) retry_line_seen <= retry_line_id_o;
            if (dut.u_mipi_csi2_capture_top.recap_active) recap_active_seen <= 1'b1;
        end
    end

    function automatic bit slot_clean(input int wb);
        begin
            slot_clean = (dut.u_axi_write_null_slave.mem[wb+0]===32'h11) &&
                         (dut.u_axi_write_null_slave.mem[wb+1]===32'h22) &&
                         (dut.u_axi_write_null_slave.mem[wb+2]===32'h33) &&
                         (dut.u_axi_write_null_slave.mem[wb+3]===32'h44);
        end
    endfunction
    function automatic bit slot_empty(input int wb);
        begin
            slot_empty = (dut.u_axi_write_null_slave.mem[wb+0]===32'd0) &&
                         (dut.u_axi_write_null_slave.mem[wb+1]===32'd0) &&
                         (dut.u_axi_write_null_slave.mem[wb+2]===32'd0) &&
                         (dut.u_axi_write_null_slave.mem[wb+3]===32'd0);
        end
    endfunction

    int i;
    initial begin
        rst_n=1'b0; hs_mode=1'b1; lp_mode=1'b0; src_recap_line_valid=1'b0;
        clear_lane_drive();
        repeat (6) @(posedge clk_sys);
        rst_n=1'b1;
        wait (cfg_init_done_o);
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_enable_o            = 1'b1;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_num_minus1_o   = 2'd1;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_enable_mask_o  = 4'b0011;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_dt_code_o           = 8'h2a;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_line_stride_o       = 32'd64;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_drop_on_crc_error_o = 1'b1;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_enable_retry_o      = 1'b1;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_retry_line_mode_o   = 1'b1;
        repeat (4) @(posedge clk_byte);

        // Two errors (line 3 and line 5) with no recapture between -> the line-3
        // request is overwritten by line 5 in the single-entry retry context.
        send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
        for (i = 0; i < H; i = i + 1)
            send_line((i == BAD_EARLY) || (i == BAD_LATE));

        wait (retry_pending_o);
        repeat (20) @(posedge clk_sys);

        // Single recapture: services whatever is in the context (the latest = line 5).
        @(negedge clk_sys);
        src_recap_line_valid = 1'b1;
        send_line(1'b0);
        repeat (40) @(posedge clk_sys);
        src_recap_line_valid = 1'b0;
        send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);
        repeat (200) @(posedge clk_axi);

        // Latest error wins the single outstanding slot (line 5 -> 1-based 6).
        if (retry_line_seen !== 32'd6) begin
            $display("FAIL: latest located line = %0d, expected 6 (line5 frame-relative)", retry_line_seen);
            $fatal(1);
        end
        if (!recap_active_seen) begin $display("FAIL: recap_active never asserted"); $fatal(1); end
        // Late line recovered, early line lost (request overwritten) -> C2 boundary.
        if (!slot_clean(SLOT_LATE_WORD)) begin
            $display("FAIL: late line (slot %0d) not recovered", BAD_LATE); $fatal(1);
        end
        if (!slot_empty(SLOT_EARLY_WORD)) begin
            $display("FAIL: early line (slot %0d) unexpectedly present - C2 demo invalid", BAD_EARLY); $fatal(1);
        end

        $display("PASS: tb_recapture_window_limit  single outstanding request: line5 recovered (slot%0d clean), line3 lost (slot%0d empty), context=%0d",
                 BAD_LATE, BAD_EARLY, retry_line_seen);
        $finish;
    end

    initial begin
        repeat (60000) @(posedge clk_sys);
        $display("FAIL: tb_recapture_window_limit timeout pending=%0b line=%0d", retry_pending_o, retry_line_seen);
        $fatal(1);
    end

endmodule
