`timescale 1ns/1ps

// Multi-frame line-level recapture: proves the closed loop works beyond the
// first frame. A clean frame 1 is streamed first; then frame 2 corrupts line 2.
//
// The discriminating proof is that the LOCATED line index is FRAME-RELATIVE:
//   with the fix  -> retry_line_id = 3  (line 2 of frame 2, 1-based in-frame)
//   without it    -> retry_line_id = 7  (free-running line_cnt = 4+3) and the
//                    write-back would target slot 6 instead of slot 2.
// We assert both the located index (==3) and the internal recap slot (==2),
// then confirm slot 2 holds the clean pattern and pending is cleared.
module tb_recapture_multiframe;

    localparam int LANE_NUM = 2;
    localparam logic [5:0] DATA_TYPE = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID = 2'd0;

    localparam int H        = 4;     // lines per frame
    localparam int BAD_LINE = 2;     // 0-based writer slot corrupted in frame 2
    localparam int SLOTK_WORD = 16 * BAD_LINE;
    localparam int SLOT0_WORD = 0;
    localparam int WORDS_PER_LINE = 4;

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

    logic        retry_seen, retry_mode_seen;
    logic [31:0] retry_line_seen, retry_frame_seen;
    logic        recap_active_seen;
    logic [15:0] recap_slot_seen;

    mipi_csi2_capture_recap_wrapper #(
        .LANE_NUM(LANE_NUM), .IMG_WIDTH(16'd4), .IMG_HEIGHT(16'd4), .LINE_STRIDE(32'd64)
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
        lane_data_2  = 32'd0;  lane_data_3 = 32'd0;
        lane_valid_0 = sensor_lane_valid[0];
        lane_valid_1 = sensor_lane_valid[1];
        lane_valid_2 = 1'b0;   lane_valid_3 = 1'b0;
    end

    task automatic clear_lane_drive; begin sensor_lane_valid = '0; sensor_lane_data = '0; end endtask

    task automatic push_lane_group(input logic [7:0] b0, input logic [7:0] b1);
        begin
            while (!(sensor_lane_ready[0] && sensor_lane_ready[1])) @(posedge clk_byte);
            @(negedge clk_byte);
            sensor_lane_valid[0] = 1'b1; sensor_lane_valid[1] = 1'b1;
            sensor_lane_data[0]  = b0;   sensor_lane_data[1]  = b1;
            @(posedge clk_byte); @(negedge clk_byte);
            clear_lane_drive();
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
                VC_ID, DATA_TYPE, csi2_reference_helpers_pkg::csi2_payload_byte_count(DATA_TYPE), 1'b0);
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

    initial begin clk_sys = 0;  forever #5 clk_sys = ~clk_sys; end
    initial begin clk_byte = 0; forever #4 clk_byte = ~clk_byte; end
    initial begin clk_axi = 0;  forever #5 clk_axi = ~clk_axi; end
    initial begin clk_ddr = 0;  forever #5 clk_ddr = ~clk_ddr; end

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            retry_seen <= 1'b0; retry_mode_seen <= 1'b0;
            retry_line_seen <= 32'd0; retry_frame_seen <= 32'd0;
            recap_active_seen <= 1'b0; recap_slot_seen <= 16'hffff;
        end else begin
            if (retry_req_o) begin
                retry_seen      <= 1'b1;
                retry_mode_seen <= retry_mode_o;
                retry_line_seen <= retry_line_id_o;
                retry_frame_seen<= retry_frame_id_o;
            end
            if (dut.u_mipi_csi2_capture_top.recap_active) begin
                recap_active_seen <= 1'b1;
                recap_slot_seen   <= dut.u_mipi_csi2_capture_top.recap_line_id;
            end
        end
    end

    function automatic bit slot_equal(input int wa, input int wb);
        int i; begin
            slot_equal = 1'b1;
            for (i = 0; i < WORDS_PER_LINE; i = i + 1)
                if (dut.u_axi_write_null_slave.mem[wa+i] !== dut.u_axi_write_null_slave.mem[wb+i])
                    slot_equal = 1'b0;
        end
    endfunction

    task automatic send_clean_frame;
        int i;
        begin
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
            for (i = 0; i < H; i = i + 1) send_line(1'b0);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);
        end
    endtask

    initial begin
        rst_n = 1'b0; hs_mode = 1'b1; lp_mode = 1'b0; src_recap_line_valid = 1'b0;
        clear_lane_drive();
        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

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

        // ---- Frame 1: fully clean (advances free-running line_cnt to H) ----
        send_clean_frame();
        repeat (60) @(posedge clk_axi);
        if (retry_pending_o) begin
            $display("FAIL: retry pending after a clean frame 1"); $fatal(1);
        end

        // ---- Frame 2: line 2 corrupted, then recaptured ----
        send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
        send_line(1'b0);   // f2 line0
        send_line(1'b0);   // f2 line1
        send_line(1'b1);   // f2 line2 CORRUPTED
        send_line(1'b0);   // f2 line3

        fork : wr
            begin repeat (3000) @(posedge clk_sys); end
            begin wait (retry_pending_o); end
        join_any
        disable wr;
        if (!retry_pending_o) begin $display("FAIL: no retry pending in frame 2"); $fatal(1); end

        @(negedge clk_sys);
        src_recap_line_valid = 1'b1;
        send_line(1'b0);   // clean re-send of line2 -> write-back to slot 2
        repeat (40) @(posedge clk_sys);
        src_recap_line_valid = 1'b0;
        send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);

        repeat (200) @(posedge clk_axi);

        // ---- Checks ----
        if (retry_frame_seen !== 32'd2) begin
            $display("FAIL: error attributed to frame %0d, expected 2", retry_frame_seen); $fatal(1);
        end
        if (retry_line_seen !== 32'd3) begin
            $display("FAIL: located line index = %0d, expected 3 (FRAME-RELATIVE). A free-running value (e.g. 7) means the multi-frame fix is missing.", retry_line_seen);
            $fatal(1);
        end
        if (recap_slot_seen !== 16'd2) begin
            $display("FAIL: write-back targeted slot %0d, expected 2", recap_slot_seen); $fatal(1);
        end
        if (!recap_active_seen || !retry_mode_seen) begin
            $display("FAIL: recap_active=%0b line_mode=%0b", recap_active_seen, retry_mode_seen); $fatal(1);
        end
        if (!slot_equal(SLOTK_WORD, SLOT0_WORD)) begin
            $display("FAIL: recaptured slot 2 != clean line0"); $fatal(1);
        end
        if (retry_pending_o !== 1'b0) begin
            $display("FAIL: retry_pending not cleared"); $fatal(1);
        end

        $display("PASS: tb_recapture_multiframe  frame=%0d located_line=%0d (frame-relative) recap_slot=%0d overwritten clean",
                 retry_frame_seen, retry_line_seen, recap_slot_seen);
        $finish;
    end

    initial begin
        repeat (60000) @(posedge clk_sys);
        $display("FAIL: global timeout retry_seen=%0b recap_seen=%0b pending=%0b line_seen=%0d",
                 retry_seen, recap_active_seen, retry_pending_o, retry_line_seen);
        $fatal(1);
    end

endmodule
