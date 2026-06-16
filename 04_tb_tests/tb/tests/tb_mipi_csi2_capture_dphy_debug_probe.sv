`timescale 1ns/1ps

module tb_mipi_csi2_capture_dphy_debug_probe;

    logic        clk_sys;
    logic        clk_axi;
    logic        clk_ddr;
    logic        rxbyteclkhs;
    logic        rst_n;
    logic        cl_stopstate;

    logic [7:0]  dl0_rxdatahs;
    logic [7:0]  dl1_rxdatahs;
    logic [7:0]  dl2_rxdatahs;
    logic [7:0]  dl3_rxdatahs;
    logic        dl0_rxvalidhs;
    logic        dl1_rxvalidhs;
    logic        dl2_rxvalidhs;
    logic        dl3_rxvalidhs;
    logic        dl0_rxactivehs;
    logic        dl1_rxactivehs;
    logic        dl2_rxactivehs;
    logic        dl3_rxactivehs;
    logic        dl0_rxsynchs;
    logic        dl1_rxsynchs;
    logic        dl2_rxsynchs;
    logic        dl3_rxsynchs;
    logic        dl0_stopstate;
    logic        dl1_stopstate;
    logic        dl2_stopstate;
    logic        dl3_stopstate;
    logic        dl0_errsoths;
    logic        dl1_errsoths;
    logic        dl2_errsoths;
    logic        dl3_errsoths;
    logic        dl0_errsotsynchs;
    logic        dl1_errsotsynchs;
    logic        dl2_errsotsynchs;
    logic        dl3_errsotsynchs;

    logic        frame_start_o;
    logic        frame_end_o;
    logic        line_start_o;
    logic        line_end_o;
    logic        err_ecc_o;
    logic        err_crc_o;
    logic        err_sync_o;
    logic [23:0] pixel_data_o;
    logic        pixel_valid_o;
    logic        pixel_sof_o;
    logic        pixel_sol_o;
    logic        retry_req_o;
    logic        retry_pending_o;
    logic        retry_mode_o;
    logic [31:0] retry_frame_id_o;
    logic [31:0] retry_line_id_o;
    logic        no_backpressure_drop_event_o;
    logic        no_backpressure_drop_active_o;
    logic        cfg_init_done_o;
    logic        dphy_hs_mode_o;
    logic        dphy_lp_mode_o;
    logic [3:0]  dphy_lane_active_hs_o;
    logic [3:0]  dphy_lane_valid_hs_o;
    logic [3:0]  dphy_lane_sync_hs_o;
    logic [3:0]  dphy_lane_stopstate_o;
    logic        dphy_err_sot_hs_o;
    logic        dphy_err_sot_sync_hs_o;
    logic [63:0] ila_probe_o;

    mipi_csi2_capture_dphy_wrapper #(
        .LANE_NUM(2),
        .DESKEW_DEPTH(4),
        .BYTE_FIFO_ADDR_WIDTH(4),
        .AXI_FIFO_ADDR_WIDTH(4),
        .AXI_DATA_WIDTH(128)
    ) dut (
        .clk_sys(clk_sys),
        .clk_axi(clk_axi),
        .clk_ddr(clk_ddr),
        .rst_n(rst_n),
        .rxbyteclkhs(rxbyteclkhs),
        .cl_stopstate(cl_stopstate),
        .dl0_rxdatahs(dl0_rxdatahs),
        .dl1_rxdatahs(dl1_rxdatahs),
        .dl2_rxdatahs(dl2_rxdatahs),
        .dl3_rxdatahs(dl3_rxdatahs),
        .dl0_rxvalidhs(dl0_rxvalidhs),
        .dl1_rxvalidhs(dl1_rxvalidhs),
        .dl2_rxvalidhs(dl2_rxvalidhs),
        .dl3_rxvalidhs(dl3_rxvalidhs),
        .dl0_rxactivehs(dl0_rxactivehs),
        .dl1_rxactivehs(dl1_rxactivehs),
        .dl2_rxactivehs(dl2_rxactivehs),
        .dl3_rxactivehs(dl3_rxactivehs),
        .dl0_rxsynchs(dl0_rxsynchs),
        .dl1_rxsynchs(dl1_rxsynchs),
        .dl2_rxsynchs(dl2_rxsynchs),
        .dl3_rxsynchs(dl3_rxsynchs),
        .dl0_stopstate(dl0_stopstate),
        .dl1_stopstate(dl1_stopstate),
        .dl2_stopstate(dl2_stopstate),
        .dl3_stopstate(dl3_stopstate),
        .dl0_errsoths(dl0_errsoths),
        .dl1_errsoths(dl1_errsoths),
        .dl2_errsoths(dl2_errsoths),
        .dl3_errsoths(dl3_errsoths),
        .dl0_errsotsynchs(dl0_errsotsynchs),
        .dl1_errsotsynchs(dl1_errsotsynchs),
        .dl2_errsotsynchs(dl2_errsotsynchs),
        .dl3_errsotsynchs(dl3_errsotsynchs),
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
        .no_backpressure_drop_event_o(no_backpressure_drop_event_o),
        .no_backpressure_drop_active_o(no_backpressure_drop_active_o),
        .cfg_init_done_o(cfg_init_done_o),
        .dphy_hs_mode_o(dphy_hs_mode_o),
        .dphy_lp_mode_o(dphy_lp_mode_o),
        .dphy_lane_active_hs_o(dphy_lane_active_hs_o),
        .dphy_lane_valid_hs_o(dphy_lane_valid_hs_o),
        .dphy_lane_sync_hs_o(dphy_lane_sync_hs_o),
        .dphy_lane_stopstate_o(dphy_lane_stopstate_o),
        .dphy_err_sot_hs_o(dphy_err_sot_hs_o),
        .dphy_err_sot_sync_hs_o(dphy_err_sot_sync_hs_o),
        .ila_probe_o(ila_probe_o)
    );

    always #5 clk_sys = ~clk_sys;
    always #5 clk_axi = ~clk_axi;
    always #6 clk_ddr = ~clk_ddr;
    always #4 rxbyteclkhs = ~rxbyteclkhs;

    task automatic fail(input string msg);
        begin
            $display("FAIL: %s", msg);
            $fatal(1);
        end
    endtask

    task automatic set_lp_idle;
        begin
            cl_stopstate      = 1'b1;
            dl0_rxvalidhs     = 1'b0;
            dl1_rxvalidhs     = 1'b0;
            dl2_rxvalidhs     = 1'b0;
            dl3_rxvalidhs     = 1'b0;
            dl0_rxactivehs    = 1'b0;
            dl1_rxactivehs    = 1'b0;
            dl2_rxactivehs    = 1'b0;
            dl3_rxactivehs    = 1'b0;
            dl0_rxsynchs      = 1'b0;
            dl1_rxsynchs      = 1'b0;
            dl2_rxsynchs      = 1'b0;
            dl3_rxsynchs      = 1'b0;
            dl0_stopstate     = 1'b1;
            dl1_stopstate     = 1'b1;
            dl2_stopstate     = 1'b1;
            dl3_stopstate     = 1'b1;
            dl0_errsoths      = 1'b0;
            dl1_errsoths      = 1'b0;
            dl2_errsoths      = 1'b0;
            dl3_errsoths      = 1'b0;
            dl0_errsotsynchs  = 1'b0;
            dl1_errsotsynchs  = 1'b0;
            dl2_errsotsynchs  = 1'b0;
            dl3_errsotsynchs  = 1'b0;
        end
    endtask

    initial begin
        clk_sys       = 1'b0;
        clk_axi       = 1'b0;
        clk_ddr       = 1'b0;
        rxbyteclkhs   = 1'b0;
        rst_n         = 1'b0;
        dl0_rxdatahs  = 8'h00;
        dl1_rxdatahs  = 8'h00;
        dl2_rxdatahs  = 8'h00;
        dl3_rxdatahs  = 8'h00;
        set_lp_idle();

        repeat (4) @(posedge clk_sys);
        rst_n = 1'b1;

        wait (cfg_init_done_o);
        #1;
        if (ila_probe_o[0] != dphy_hs_mode_o || ila_probe_o[1] != dphy_lp_mode_o) begin
            fail("probe bits 0/1 should mirror dphy hs/lp mode");
        end
        if (ila_probe_o[17:14] != 4'b0011 || ila_probe_o[56] != cfg_init_done_o) begin
            fail("probe should expose stopstate and cfg init done in LP idle");
        end

        @(negedge rxbyteclkhs);
        cl_stopstate     = 1'b0;
        dl0_rxdatahs     = 8'haa;
        dl1_rxdatahs     = 8'h55;
        dl0_rxvalidhs    = 1'b1;
        dl1_rxvalidhs    = 1'b1;
        dl0_rxactivehs   = 1'b1;
        dl1_rxactivehs   = 1'b1;
        dl0_rxsynchs     = 1'b1;
        dl1_rxsynchs     = 1'b0;
        dl0_stopstate    = 1'b0;
        dl1_stopstate    = 1'b0;
        dl0_errsoths     = 1'b1;
        dl1_errsotsynchs = 1'b1;
        #1;

        if (ila_probe_o[5:2] != 4'b0011 || ila_probe_o[9:6] != 4'b0011) begin
            fail("probe should expose active and valid lane masks");
        end
        if (ila_probe_o[13:10] != 4'b0001) begin
            fail("probe should expose masked rxsynchs bits");
        end
        if (!ila_probe_o[18] || !ila_probe_o[19]) begin
            fail("probe should expose D-PHY SoT error summaries");
        end
        if (ila_probe_o[58] != no_backpressure_drop_event_o ||
            ila_probe_o[59] != no_backpressure_drop_active_o ||
            ila_probe_o[63:60] != 4'd0) begin
            fail("probe should expose no-backpressure drop bits and keep upper reserve zero");
        end

        $display("PASS: tb_mipi_csi2_capture_dphy_debug_probe");
        $finish;
    end

endmodule
