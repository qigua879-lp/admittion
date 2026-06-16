`timescale 1ns/1ps

// T2.5 system-level demonstration of the line-level recapture closed loop.
//
// Scenario (single RAW8 frame, 4 lines of 4 pixels):
//   line0 clean, line1 clean, line2 CORRUPTED (CRC), line3 clean.
//   The corrupted line is CRC-dropped (slot 2 left empty). retry_request_ctrl
//   locates it (line-level mode) and raises retry_pending. The controllable
//   source then re-sends line2 cleanly with src_recap_line_valid asserted; the
//   recapture write-back addresses slot 2 and overwrites the dropped line.
//
// Proof in one run (frame buffer = internal AXI sink memory):
//   * before recapture: slot 2 == 0   (bad line dropped, not written)
//   * after  recapture: slot 2 == slot 0 (clean pattern written to the right slot)
//   * retry fired in line mode with the located line index
//   * retry_pending cleared by the write-back ack
//
// Note: clean lines carry identical payload (csi2_payload_byte depends only on
// DT/byte index), so a recovered line equals any clean line byte-for-byte.
module tb_recapture_line_level_closed_loop;

    localparam int LANE_NUM = 2;
    localparam logic [5:0] DATA_TYPE = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID = 2'd0;

    localparam int IMG_HEIGHT = 4;
    localparam int BAD_LINE   = 2;        // 0-based writer slot of the corrupted line
    // LINE_STRIDE=64 bytes -> slot k occupies mem words [16k .. 16k+3]
    localparam int WORDS_PER_LINE = 4;
    localparam int SLOT0_WORD = 0;
    localparam int SLOTK_WORD = 16 * BAD_LINE;

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

    // Monitors
    logic        retry_seen, retry_mode_seen;
    logic [31:0] retry_line_seen;
    logic        recap_active_seen;

    mipi_csi2_capture_recap_wrapper #(
        .LANE_NUM(LANE_NUM),
        .IMG_WIDTH(16'd4),
        .IMG_HEIGHT(IMG_HEIGHT[15:0]),
        .LINE_STRIDE(32'd64)
    ) dut (
        .clk_sys(clk_sys),
        .clk_byte(clk_byte),
        .clk_axi(clk_axi),
        .clk_ddr(clk_ddr),
        .rst_n(rst_n),
        .lane_data_0(lane_data_0),
        .lane_data_1(lane_data_1),
        .lane_data_2(lane_data_2),
        .lane_data_3(lane_data_3),
        .lane_valid_0(lane_valid_0),
        .lane_valid_1(lane_valid_1),
        .lane_valid_2(lane_valid_2),
        .lane_valid_3(lane_valid_3),
        .hs_mode(hs_mode),
        .lp_mode(lp_mode),
        .src_recap_line_valid_i(src_recap_line_valid),
        .frame_start_o(frame_start_o),
        .frame_end_o(frame_end_o),
        .line_start_o(line_start_o),
        .line_end_o(line_end_o),
        .err_ecc_o(err_ecc_o),
        .err_crc_o(err_crc_o),
        .err_sync_o(err_sync_o),
        .pixel_data_o(pixel_data_o),
        .pixel_valid_o(pixel_valid_o),
        .pixel_sof_o(pixel_sof_o),
        .pixel_sol_o(pixel_sol_o),
        .retry_req_o(retry_req_o),
        .retry_pending_o(retry_pending_o),
        .retry_mode_o(retry_mode_o),
        .retry_frame_id_o(retry_frame_id_o),
        .retry_line_id_o(retry_line_id_o),
        .cfg_init_done_o(cfg_init_done_o)
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
        begin
            sensor_lane_valid = '0;
            sensor_lane_data  = '0;
        end
    endtask

    task automatic push_lane_group(input logic [7:0] byte0, input logic [7:0] byte1);
        begin
            while (!(sensor_lane_ready[0] && sensor_lane_ready[1])) @(posedge clk_byte);
            @(negedge clk_byte);
            sensor_lane_valid[0] = 1'b1;
            sensor_lane_valid[1] = 1'b1;
            sensor_lane_data[0]  = byte0;
            sensor_lane_data[1]  = byte1;
            @(posedge clk_byte);
            @(negedge clk_byte);
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

    // RAW8 long packet: 4 header + 4 payload + 2 CRC bytes over 2 lanes.
    task automatic send_long_packet(input bit corrupt);
        logic [31:0] header;
        logic [15:0] payload_crc;
        logic [7:0]  p0;
        begin
            header = csi2_reference_helpers_pkg::csi2_pack_header(
                VC_ID, DATA_TYPE,
                csi2_reference_helpers_pkg::csi2_payload_byte_count(DATA_TYPE), 1'b0);
            payload_crc = csi2_reference_helpers_pkg::csi2_payload_crc(DATA_TYPE);
            p0 = csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 0);
            if (corrupt) p0 = p0 ^ 8'h01;   // break payload -> CRC mismatch

            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(header, 0),
                            csi2_reference_helpers_pkg::csi2_packet_byte(header, 1));
            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(header, 2),
                            csi2_reference_helpers_pkg::csi2_packet_byte(header, 3));
            push_lane_group(p0,
                            csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 1));
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

    // Clocks
    initial begin clk_sys = 0;  forever #5 clk_sys = ~clk_sys; end
    initial begin clk_byte = 0; forever #4 clk_byte = ~clk_byte; end
    initial begin clk_axi = 0;  forever #5 clk_axi = ~clk_axi; end
    initial begin clk_ddr = 0;  forever #5 clk_ddr = ~clk_ddr; end

    // Monitors
    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            retry_seen        <= 1'b0;
            retry_mode_seen   <= 1'b0;
            retry_line_seen   <= 32'd0;
            recap_active_seen <= 1'b0;
        end else begin
            if (retry_req_o) begin
                retry_seen      <= 1'b1;
                retry_mode_seen <= retry_mode_o;
                retry_line_seen <= retry_line_id_o;
            end
            if (dut.u_mipi_csi2_capture_top.recap_active) recap_active_seen <= 1'b1;
        end
    end

    function automatic bit slot_equal(input int word_a, input int word_b);
        int i;
        begin
            slot_equal = 1'b1;
            for (i = 0; i < WORDS_PER_LINE; i = i + 1) begin
                if (dut.u_axi_write_null_slave.mem[word_a + i] !==
                    dut.u_axi_write_null_slave.mem[word_b + i])
                    slot_equal = 1'b0;
            end
        end
    endfunction

    function automatic bit slot_zero(input int word_base);
        int i;
        begin
            slot_zero = 1'b1;
            for (i = 0; i < WORDS_PER_LINE; i = i + 1)
                if (dut.u_axi_write_null_slave.mem[word_base + i] !== 32'd0)
                    slot_zero = 1'b0;
        end
    endfunction

    initial begin
        rst_n = 1'b0;
        hs_mode = 1'b1;
        lp_mode = 1'b0;
        src_recap_line_valid = 1'b0;
        clear_lane_drive();

        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        wait (cfg_init_done_o);

        // The on-chip boot sequencer's APB writes do not latch (cfg_reg pready is
        // always high, so the boot FSM never enters the APB access phase). Every
        // wrapper TB therefore forces the config registers directly; do the same.
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_enable_o            = 1'b1;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_num_minus1_o   = 2'd1;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_lane_enable_mask_o  = 4'b0011;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_dt_code_o           = 8'h2a;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_line_stride_o       = 32'd64;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_drop_on_crc_error_o = 1'b1;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_enable_retry_o      = 1'b1;
        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_retry_line_mode_o   = 1'b1;

        repeat (4) @(posedge clk_byte);

        // ---- Stream one frame: lines 0..3, line 2 corrupted ----
        send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
        send_line(1'b0);                 // line0 clean
        send_line(1'b0);                 // line1 clean
        send_line(1'b1);                 // line2 CORRUPTED -> CRC drop + retry
        send_line(1'b0);                 // line3 clean (models in-frame latency)

        // Retry must be pending now (located line2 = sync line_cnt 3).
        fork : wait_retry
            begin repeat (2000) @(posedge clk_sys); end
            begin wait (retry_pending_o); end
        join_any
        disable wait_retry;

        if (!retry_pending_o) begin
            $display("FAIL: retry_pending never asserted after corrupted line");
            $fatal(1);
        end

        // Let normal-line writes drain, then confirm the bad line slot is empty.
        repeat (120) @(posedge clk_axi);
        if (!slot_zero(SLOTK_WORD)) begin
            $display("FAIL: pre-recapture slot %0d (word %0d) not empty: %08h %08h %08h %08h",
                     BAD_LINE, SLOTK_WORD,
                     dut.u_axi_write_null_slave.mem[SLOTK_WORD],
                     dut.u_axi_write_null_slave.mem[SLOTK_WORD+1],
                     dut.u_axi_write_null_slave.mem[SLOTK_WORD+2],
                     dut.u_axi_write_null_slave.mem[SLOTK_WORD+3]);
            $fatal(1);
        end
        if (slot_zero(SLOT0_WORD)) begin
            $display("FAIL: clean line0 slot is empty - normal write path broken");
            $fatal(1);
        end

        // ---- Controllable source re-sends line2 cleanly (recapture) ----
        @(negedge clk_sys);
        src_recap_line_valid = 1'b1;     // sideband held across the recapture line
        send_line(1'b0);                 // clean line2 re-sent -> write-back to slot 2

        // Hold sideband until the recapture line_end has propagated, then drop.
        repeat (40) @(posedge clk_sys);
        src_recap_line_valid = 1'b0;

        send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);

        // ---- Drain and check the overwrite ----
        repeat (200) @(posedge clk_axi);

        if (!recap_active_seen) begin
            $display("FAIL: recap_active was never asserted inside the core");
            $fatal(1);
        end
        if (!retry_seen || retry_mode_seen !== 1'b1) begin
            $display("FAIL: retry not seen in line mode (seen=%0b mode=%0b)",
                     retry_seen, retry_mode_seen);
            $fatal(1);
        end
        if (retry_line_seen !== 32'd3) begin
            $display("FAIL: located line index mismatch, expected 3 got %0d", retry_line_seen);
            $fatal(1);
        end
        if (!slot_equal(SLOTK_WORD, SLOT0_WORD)) begin
            $display("FAIL: recaptured slot %0d != clean line0. slotK=%08h %08h %08h %08h  slot0=%08h %08h %08h %08h",
                     BAD_LINE,
                     dut.u_axi_write_null_slave.mem[SLOTK_WORD],
                     dut.u_axi_write_null_slave.mem[SLOTK_WORD+1],
                     dut.u_axi_write_null_slave.mem[SLOTK_WORD+2],
                     dut.u_axi_write_null_slave.mem[SLOTK_WORD+3],
                     dut.u_axi_write_null_slave.mem[SLOT0_WORD],
                     dut.u_axi_write_null_slave.mem[SLOT0_WORD+1],
                     dut.u_axi_write_null_slave.mem[SLOT0_WORD+2],
                     dut.u_axi_write_null_slave.mem[SLOT0_WORD+3]);
            $fatal(1);
        end
        if (retry_pending_o !== 1'b0) begin
            $display("FAIL: retry_pending not cleared by write-back ack");
            $fatal(1);
        end
        if (err_ecc_o || err_sync_o) begin
            $display("FAIL: unexpected non-crc errors ecc=%0b sync=%0b", err_ecc_o, err_sync_o);
            $fatal(1);
        end

        $display("PASS: tb_recapture_line_level_closed_loop  located_line=%0d slot%0d overwritten clean, pending cleared",
                 retry_line_seen, BAD_LINE);
        $finish;
    end

    // Global safety timeout
    initial begin
        repeat (40000) @(posedge clk_sys);
        $display("FAIL: global timeout cfg_done=%0b retry_seen=%0b recap_seen=%0b pending=%0b",
                 cfg_init_done_o, retry_seen, recap_active_seen, retry_pending_o);
        $fatal(1);
    end

endmodule
