`timescale 1ns/1ps

// D-PHY PPI error-injection hardening for mipi_csi2_capture_dphy_wrapper:
//   1. SoT error pulse (dl0_errsoths) at HS entry        -> dphy_err_sot_hs_o observed
//   2. SoT sync error pulse (dl0_errsotsynchs)           -> dphy_err_sot_sync_hs_o observed
//   3. rxvalidhs gaps inside the long-packet payload     -> frame still parses cleanly
//      (real D-PHY byte streams are not back-to-back; valid gaps are normal)
//   4. a clean frame after the error events              -> stream recovers, pixels intact
//
// Error flags are PHY-layer indications and must be observable without
// corrupting protocol parsing: expect ZERO ECC/CRC/sync errors and exactly
// 2 frames x 4 RAW8 pixels of correct data at the pixel output.
module tb_mipi_csi2_capture_dphy_error_inject;

    localparam int LANE_NUM = 2;
    localparam logic [5:0] DATA_TYPE = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID = 2'd0;

    logic clk_sys, clk_axi, clk_ddr, rst_n;
    logic rxbyteclkhs;
    logic cl_stopstate;

    logic [7:0] dl0_rxdatahs, dl1_rxdatahs, dl2_rxdatahs, dl3_rxdatahs;
    logic dl0_rxvalidhs, dl1_rxvalidhs, dl2_rxvalidhs, dl3_rxvalidhs;
    logic dl0_rxactivehs, dl1_rxactivehs, dl2_rxactivehs, dl3_rxactivehs;
    logic dl0_rxsynchs, dl1_rxsynchs, dl2_rxsynchs, dl3_rxsynchs;
    logic dl0_stopstate, dl1_stopstate, dl2_stopstate, dl3_stopstate;
    logic dl0_errsoths, dl1_errsoths, dl2_errsoths, dl3_errsoths;
    logic dl0_errsotsynchs, dl1_errsotsynchs, dl2_errsotsynchs, dl3_errsotsynchs;

    logic frame_start_o, frame_end_o, line_start_o, line_end_o;
    logic err_ecc_o, err_crc_o, err_sync_o;
    logic [23:0] pixel_data_o;
    logic pixel_valid_o, pixel_sof_o, pixel_sol_o;
    logic retry_req_o, retry_pending_o, retry_mode_o;
    logic [31:0] retry_frame_id_o, retry_line_id_o;
    logic cfg_init_done_o;
    logic dphy_hs_mode_o, dphy_lp_mode_o;
    logic [3:0] dphy_lane_active_hs_o, dphy_lane_valid_hs_o;
    logic [3:0] dphy_lane_sync_hs_o, dphy_lane_stopstate_o;
    logic dphy_err_sot_hs_o, dphy_err_sot_sync_hs_o;

    mipi_csi2_capture_dphy_wrapper #(
        .LANE_NUM(LANE_NUM),
        .BYTE_FIFO_ADDR_WIDTH(4),
        .AXI_FIFO_ADDR_WIDTH(6),
        .AXI_DATA_WIDTH(128)
    ) dut (
        .clk_sys(clk_sys), .clk_axi(clk_axi), .clk_ddr(clk_ddr), .rst_n(rst_n),
        .rxbyteclkhs(rxbyteclkhs), .cl_stopstate(cl_stopstate),
        .dl0_rxdatahs(dl0_rxdatahs), .dl1_rxdatahs(dl1_rxdatahs),
        .dl2_rxdatahs(dl2_rxdatahs), .dl3_rxdatahs(dl3_rxdatahs),
        .dl0_rxvalidhs(dl0_rxvalidhs), .dl1_rxvalidhs(dl1_rxvalidhs),
        .dl2_rxvalidhs(dl2_rxvalidhs), .dl3_rxvalidhs(dl3_rxvalidhs),
        .dl0_rxactivehs(dl0_rxactivehs), .dl1_rxactivehs(dl1_rxactivehs),
        .dl2_rxactivehs(dl2_rxactivehs), .dl3_rxactivehs(dl3_rxactivehs),
        .dl0_rxsynchs(dl0_rxsynchs), .dl1_rxsynchs(dl1_rxsynchs),
        .dl2_rxsynchs(dl2_rxsynchs), .dl3_rxsynchs(dl3_rxsynchs),
        .dl0_stopstate(dl0_stopstate), .dl1_stopstate(dl1_stopstate),
        .dl2_stopstate(dl2_stopstate), .dl3_stopstate(dl3_stopstate),
        .dl0_errsoths(dl0_errsoths), .dl1_errsoths(dl1_errsoths),
        .dl2_errsoths(dl2_errsoths), .dl3_errsoths(dl3_errsoths),
        .dl0_errsotsynchs(dl0_errsotsynchs), .dl1_errsotsynchs(dl1_errsotsynchs),
        .dl2_errsotsynchs(dl2_errsotsynchs), .dl3_errsotsynchs(dl3_errsotsynchs),
        .frame_start_o(frame_start_o), .frame_end_o(frame_end_o),
        .line_start_o(line_start_o), .line_end_o(line_end_o),
        .err_ecc_o(err_ecc_o), .err_crc_o(err_crc_o), .err_sync_o(err_sync_o),
        .pixel_data_o(pixel_data_o), .pixel_valid_o(pixel_valid_o),
        .pixel_sof_o(pixel_sof_o), .pixel_sol_o(pixel_sol_o),
        .retry_req_o(retry_req_o), .retry_pending_o(retry_pending_o),
        .retry_mode_o(retry_mode_o),
        .retry_frame_id_o(retry_frame_id_o), .retry_line_id_o(retry_line_id_o),
        .cfg_init_done_o(cfg_init_done_o),
        .dphy_hs_mode_o(dphy_hs_mode_o), .dphy_lp_mode_o(dphy_lp_mode_o),
        .dphy_lane_active_hs_o(dphy_lane_active_hs_o),
        .dphy_lane_valid_hs_o(dphy_lane_valid_hs_o),
        .dphy_lane_sync_hs_o(dphy_lane_sync_hs_o),
        .dphy_lane_stopstate_o(dphy_lane_stopstate_o),
        .dphy_err_sot_hs_o(dphy_err_sot_hs_o),
        .dphy_err_sot_sync_hs_o(dphy_err_sot_sync_hs_o)
    );

    // ---- clocks ----
    initial begin clk_sys = 0;     forever #5 clk_sys = ~clk_sys; end
    initial begin clk_axi = 0;     forever #5 clk_axi = ~clk_axi; end
    initial begin clk_ddr = 0;     forever #5 clk_ddr = ~clk_ddr; end
    initial begin rxbyteclkhs = 0; forever #4 rxbyteclkhs = ~rxbyteclkhs; end

    // ---- PPI drive tasks (same discipline as the raw8 smoke TB) ----
    task automatic set_lp_idle;
        begin
            cl_stopstate = 1'b1;
            {dl3_rxvalidhs, dl2_rxvalidhs, dl1_rxvalidhs, dl0_rxvalidhs} = '0;
            {dl3_rxactivehs, dl2_rxactivehs, dl1_rxactivehs, dl0_rxactivehs} = '0;
            {dl3_rxsynchs, dl2_rxsynchs, dl1_rxsynchs, dl0_rxsynchs} = '0;
            {dl3_stopstate, dl2_stopstate, dl1_stopstate, dl0_stopstate} = '1;
            {dl3_errsoths, dl2_errsoths, dl1_errsoths, dl0_errsoths} = '0;
            {dl3_errsotsynchs, dl2_errsotsynchs, dl1_errsotsynchs, dl0_errsotsynchs} = '0;
            {dl3_rxdatahs, dl2_rxdatahs, dl1_rxdatahs, dl0_rxdatahs} = '0;
        end
    endtask

    task automatic enter_hs;
        begin
            cl_stopstate   = 1'b0;
            dl0_rxactivehs = 1'b1;
            dl1_rxactivehs = 1'b1;
            dl0_stopstate  = 1'b0;
            dl1_stopstate  = 1'b0;
        end
    endtask

    task automatic exit_hs;
        begin
            set_lp_idle();
        end
    endtask

    task automatic clear_ppi_valid;
        begin
            {dl1_rxdatahs, dl0_rxdatahs} = '0;
            {dl1_rxvalidhs, dl0_rxvalidhs} = '0;
            {dl1_rxsynchs, dl0_rxsynchs} = '0;
        end
    endtask

    // valid_gap: idle byteclk cycles inserted BEFORE this group (models the
    // non-back-to-back byte delivery of a real D-PHY RX).
    task automatic push_ppi_lane_group(
        input logic [7:0] byte0,
        input logic [7:0] byte1,
        input logic       sync_marker,
        input int         valid_gap
    );
        begin
            repeat (valid_gap) @(negedge rxbyteclkhs);
            @(negedge rxbyteclkhs);
            dl0_rxdatahs  = byte0;
            dl1_rxdatahs  = byte1;
            dl0_rxvalidhs = 1'b1;
            dl1_rxvalidhs = 1'b1;
            dl0_rxsynchs  = sync_marker;
            dl1_rxsynchs  = sync_marker;
            @(posedge rxbyteclkhs);
            @(negedge rxbyteclkhs);
            clear_ppi_valid();
        end
    endtask

    task automatic send_short_packet(input logic [5:0] dt);
        logic [31:0] h;
        begin
            h = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, dt, 16'd0, 1'b0);
            push_ppi_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(h,0),
                                csi2_reference_helpers_pkg::csi2_packet_byte(h,1), 1'b1, 0);
            push_ppi_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(h,2),
                                csi2_reference_helpers_pkg::csi2_packet_byte(h,3), 1'b0, 0);
        end
    endtask

    // Long packet with optional rxvalidhs gaps between byte groups.
    task automatic send_long_packet(input int gap);
        logic [31:0] hd; logic [15:0] cr;
        begin
            hd = csi2_reference_helpers_pkg::csi2_pack_header(
                VC_ID, DATA_TYPE,
                csi2_reference_helpers_pkg::csi2_payload_byte_count(DATA_TYPE), 1'b0);
            cr = csi2_reference_helpers_pkg::csi2_payload_crc(DATA_TYPE);
            push_ppi_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(hd,0),
                                csi2_reference_helpers_pkg::csi2_packet_byte(hd,1), 1'b1, 0);
            push_ppi_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(hd,2),
                                csi2_reference_helpers_pkg::csi2_packet_byte(hd,3), 1'b0, gap);
            push_ppi_lane_group(csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE,0),
                                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE,1), 1'b0, gap);
            push_ppi_lane_group(csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE,2),
                                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE,3), 1'b0, gap);
            push_ppi_lane_group(cr[7:0], cr[15:8], 1'b0, gap);
        end
    endtask

    task automatic send_frame(input int gap);
        begin
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
            send_long_packet(gap);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LE);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);
        end
    endtask

    // ---- monitors ----
    logic sot_err_seen, sot_sync_err_seen;
    logic proto_err_seen;
    int   pixel_cnt;
    int   pixel_bad;
    logic [7:0] exp_seq [0:3];

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            proto_err_seen <= 1'b0;
            pixel_cnt      <= 0;
            pixel_bad      <= 0;
        end else begin
            if (err_ecc_o || err_crc_o || err_sync_o) proto_err_seen <= 1'b1;
            if (pixel_valid_o) begin
                if (pixel_data_o[7:0] !== exp_seq[pixel_cnt % 4]) pixel_bad <= pixel_bad + 1;
                pixel_cnt <= pixel_cnt + 1;
            end
        end
    end

    always_ff @(posedge rxbyteclkhs) begin
        if (!rst_n) begin
            sot_err_seen      <= 1'b0;
            sot_sync_err_seen <= 1'b0;
        end else begin
            if (dphy_err_sot_hs_o)      sot_err_seen      <= 1'b1;
            if (dphy_err_sot_sync_hs_o) sot_sync_err_seen <= 1'b1;
        end
    end

    initial begin
        exp_seq[0] = 8'h11; exp_seq[1] = 8'h22; exp_seq[2] = 8'h33; exp_seq[3] = 8'h44;
        rst_n = 1'b0;
        set_lp_idle();
        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;
        wait (cfg_init_done_o);
        repeat (4) @(posedge rxbyteclkhs);

        // ---- Frame 1: SoT error pulse at HS entry + valid gaps in payload ----
        enter_hs();
        @(negedge rxbyteclkhs);
        dl0_errsoths = 1'b1;                 // recoverable SoT error indication
        @(negedge rxbyteclkhs);
        dl0_errsoths = 1'b0;
        send_frame(2);                        // 2-cycle valid gaps between groups
        exit_hs();
        repeat (20) @(posedge clk_sys);

        // ---- SoT sync error pulse between frames (fatal-class indication) ----
        enter_hs();
        @(negedge rxbyteclkhs);
        dl0_errsotsynchs = 1'b1;
        @(negedge rxbyteclkhs);
        dl0_errsotsynchs = 1'b0;
        exit_hs();
        repeat (10) @(posedge clk_sys);

        // ---- Frame 2: clean, back-to-back (recovery after error events) ----
        enter_hs();
        send_frame(0);
        exit_hs();

        repeat (200) @(posedge clk_sys);

        if (!sot_err_seen) begin
            $display("FAIL: dphy_err_sot_hs_o was not observed"); $fatal(1);
        end
        if (!sot_sync_err_seen) begin
            $display("FAIL: dphy_err_sot_sync_hs_o was not observed"); $fatal(1);
        end
        if (proto_err_seen) begin
            $display("FAIL: PHY-layer error indications corrupted protocol parsing (ecc/crc/sync seen)");
            $fatal(1);
        end
        if (pixel_cnt !== 8) begin
            $display("FAIL: expected 8 pixels (2 frames x 4), got %0d", pixel_cnt); $fatal(1);
        end
        if (pixel_bad !== 0) begin
            $display("FAIL: %0d pixel data mismatches", pixel_bad); $fatal(1);
        end

        $display("PASS: tb_mipi_csi2_capture_dphy_error_inject pixels=%0d sot=%0b sot_sync=%0b gaps_ok=1 recovery_ok=1",
                 pixel_cnt, sot_err_seen, sot_sync_err_seen);
        $finish;
    end

    initial begin
        repeat (40000) @(posedge clk_sys);
        $display("FAIL: timeout pixels=%0d sot=%0b sot_sync=%0b proto_err=%0b",
                 pixel_cnt, sot_err_seen, sot_sync_err_seen, proto_err_seen);
        $fatal(1);
    end

endmodule
