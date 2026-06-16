`timescale 1ns/1ps

module tb_mipi_dphy_ppi_adapter;

    logic        rxbyteclkhs_i;
    logic        cl_stopstate_i;
    logic [7:0]  dl0_rxdatahs_i;
    logic [7:0]  dl1_rxdatahs_i;
    logic [7:0]  dl2_rxdatahs_i;
    logic [7:0]  dl3_rxdatahs_i;
    logic        dl0_rxvalidhs_i;
    logic        dl1_rxvalidhs_i;
    logic        dl2_rxvalidhs_i;
    logic        dl3_rxvalidhs_i;
    logic        dl0_rxactivehs_i;
    logic        dl1_rxactivehs_i;
    logic        dl2_rxactivehs_i;
    logic        dl3_rxactivehs_i;
    logic        dl0_rxsynchs_i;
    logic        dl1_rxsynchs_i;
    logic        dl2_rxsynchs_i;
    logic        dl3_rxsynchs_i;
    logic        dl0_stopstate_i;
    logic        dl1_stopstate_i;
    logic        dl2_stopstate_i;
    logic        dl3_stopstate_i;
    logic        dl0_errsoths_i;
    logic        dl1_errsoths_i;
    logic        dl2_errsoths_i;
    logic        dl3_errsoths_i;
    logic        dl0_errsotsynchs_i;
    logic        dl1_errsotsynchs_i;
    logic        dl2_errsotsynchs_i;
    logic        dl3_errsotsynchs_i;

    logic        clk_byte_o;
    logic [31:0] lane_data_0_o;
    logic [31:0] lane_data_1_o;
    logic [31:0] lane_data_2_o;
    logic [31:0] lane_data_3_o;
    logic        lane_valid_0_o;
    logic        lane_valid_1_o;
    logic        lane_valid_2_o;
    logic        lane_valid_3_o;
    logic        hs_mode_o;
    logic        lp_mode_o;
    logic [3:0]  lane_active_hs_o;
    logic [3:0]  lane_valid_hs_o;
    logic [3:0]  lane_sync_hs_o;
    logic [3:0]  lane_stopstate_o;
    logic        err_sot_hs_o;
    logic        err_sot_sync_hs_o;

    mipi_dphy_ppi_adapter #(
        .LANE_NUM(2)
    ) dut (
        .rxbyteclkhs_i(rxbyteclkhs_i),
        .cl_stopstate_i(cl_stopstate_i),
        .dl0_rxdatahs_i(dl0_rxdatahs_i),
        .dl1_rxdatahs_i(dl1_rxdatahs_i),
        .dl2_rxdatahs_i(dl2_rxdatahs_i),
        .dl3_rxdatahs_i(dl3_rxdatahs_i),
        .dl0_rxvalidhs_i(dl0_rxvalidhs_i),
        .dl1_rxvalidhs_i(dl1_rxvalidhs_i),
        .dl2_rxvalidhs_i(dl2_rxvalidhs_i),
        .dl3_rxvalidhs_i(dl3_rxvalidhs_i),
        .dl0_rxactivehs_i(dl0_rxactivehs_i),
        .dl1_rxactivehs_i(dl1_rxactivehs_i),
        .dl2_rxactivehs_i(dl2_rxactivehs_i),
        .dl3_rxactivehs_i(dl3_rxactivehs_i),
        .dl0_rxsynchs_i(dl0_rxsynchs_i),
        .dl1_rxsynchs_i(dl1_rxsynchs_i),
        .dl2_rxsynchs_i(dl2_rxsynchs_i),
        .dl3_rxsynchs_i(dl3_rxsynchs_i),
        .dl0_stopstate_i(dl0_stopstate_i),
        .dl1_stopstate_i(dl1_stopstate_i),
        .dl2_stopstate_i(dl2_stopstate_i),
        .dl3_stopstate_i(dl3_stopstate_i),
        .dl0_errsoths_i(dl0_errsoths_i),
        .dl1_errsoths_i(dl1_errsoths_i),
        .dl2_errsoths_i(dl2_errsoths_i),
        .dl3_errsoths_i(dl3_errsoths_i),
        .dl0_errsotsynchs_i(dl0_errsotsynchs_i),
        .dl1_errsotsynchs_i(dl1_errsotsynchs_i),
        .dl2_errsotsynchs_i(dl2_errsotsynchs_i),
        .dl3_errsotsynchs_i(dl3_errsotsynchs_i),
        .clk_byte_o(clk_byte_o),
        .lane_data_0_o(lane_data_0_o),
        .lane_data_1_o(lane_data_1_o),
        .lane_data_2_o(lane_data_2_o),
        .lane_data_3_o(lane_data_3_o),
        .lane_valid_0_o(lane_valid_0_o),
        .lane_valid_1_o(lane_valid_1_o),
        .lane_valid_2_o(lane_valid_2_o),
        .lane_valid_3_o(lane_valid_3_o),
        .hs_mode_o(hs_mode_o),
        .lp_mode_o(lp_mode_o),
        .lane_active_hs_o(lane_active_hs_o),
        .lane_valid_hs_o(lane_valid_hs_o),
        .lane_sync_hs_o(lane_sync_hs_o),
        .lane_stopstate_o(lane_stopstate_o),
        .err_sot_hs_o(err_sot_hs_o),
        .err_sot_sync_hs_o(err_sot_sync_hs_o)
    );

    task automatic fail(input string msg);
        begin
            $display("FAIL: %s", msg);
            $fatal(1);
        end
    endtask

    task automatic wait_lp_sync;
        begin
            repeat (2) @(posedge rxbyteclkhs_i);
            #1;
        end
    endtask

    always #5 rxbyteclkhs_i = ~rxbyteclkhs_i;

    initial begin
        rxbyteclkhs_i       = 1'b0;
        cl_stopstate_i      = 1'b1;
        dl0_rxdatahs_i      = 8'haa;
        dl1_rxdatahs_i      = 8'h55;
        dl2_rxdatahs_i      = 8'hcc;
        dl3_rxdatahs_i      = 8'h33;
        dl0_rxvalidhs_i     = 1'b0;
        dl1_rxvalidhs_i     = 1'b0;
        dl2_rxvalidhs_i     = 1'b1;
        dl3_rxvalidhs_i     = 1'b1;
        dl0_rxactivehs_i    = 1'b0;
        dl1_rxactivehs_i    = 1'b0;
        dl2_rxactivehs_i    = 1'b1;
        dl3_rxactivehs_i    = 1'b1;
        dl0_rxsynchs_i      = 1'b0;
        dl1_rxsynchs_i      = 1'b0;
        dl2_rxsynchs_i      = 1'b1;
        dl3_rxsynchs_i      = 1'b1;
        dl0_stopstate_i     = 1'b1;
        dl1_stopstate_i     = 1'b1;
        dl2_stopstate_i     = 1'b0;
        dl3_stopstate_i     = 1'b0;
        dl0_errsoths_i      = 1'b0;
        dl1_errsoths_i      = 1'b0;
        dl2_errsoths_i      = 1'b1;
        dl3_errsoths_i      = 1'b1;
        dl0_errsotsynchs_i  = 1'b0;
        dl1_errsotsynchs_i  = 1'b0;
        dl2_errsotsynchs_i  = 1'b1;
        dl3_errsotsynchs_i  = 1'b1;
        wait_lp_sync();

        if (clk_byte_o != rxbyteclkhs_i) begin
            fail("rxbyteclkhs should pass through as clk_byte");
        end
        if (!lp_mode_o || hs_mode_o) begin
            fail("stop-state on configured lanes should report LP mode only");
        end
        if ({lane_valid_3_o, lane_valid_2_o, lane_valid_1_o, lane_valid_0_o} != 4'b0000) begin
            fail("inactive configured lanes should suppress lane valid");
        end
        if (err_sot_hs_o || err_sot_sync_hs_o) begin
            fail("errors from lanes above LANE_NUM should be masked");
        end

        cl_stopstate_i      = 1'b0;
        dl0_rxvalidhs_i     = 1'b1;
        dl1_rxvalidhs_i     = 1'b1;
        dl0_rxactivehs_i    = 1'b1;
        dl1_rxactivehs_i    = 1'b1;
        dl0_rxsynchs_i      = 1'b1;
        dl1_rxsynchs_i      = 1'b0;
        dl0_stopstate_i     = 1'b0;
        dl1_stopstate_i     = 1'b0;
        dl0_errsoths_i      = 1'b1;
        dl1_errsotsynchs_i  = 1'b1;
        wait_lp_sync();

        if (clk_byte_o != rxbyteclkhs_i) begin
            fail("clk_byte should follow rxbyteclkhs");
        end
        if (!hs_mode_o || lp_mode_o) begin
            fail("active HS lanes should report HS mode and leave LP mode");
        end
        if ({lane_valid_3_o, lane_valid_2_o, lane_valid_1_o, lane_valid_0_o} != 4'b0011) begin
            fail("configured active+valid lanes should drive lane valid");
        end
        if (lane_data_0_o != 32'h0000_00aa || lane_data_1_o != 32'h0000_0055) begin
            fail("PPI bytes should be zero-extended to existing lane words");
        end
        if (lane_data_2_o != 32'h0000_00cc || lane_data_3_o != 32'h0000_0033) begin
            fail("unconfigured lane data should still be observable for debug");
        end
        if (lane_active_hs_o != 4'b0011 || lane_valid_hs_o != 4'b0011) begin
            fail("debug active/valid masks should follow configured lanes");
        end
        if (lane_sync_hs_o != 4'b0001) begin
            fail("sync debug mask should be lane-masked");
        end
        if (!err_sot_hs_o || !err_sot_sync_hs_o) begin
            fail("configured lane errors should be aggregated");
        end

        dl1_rxactivehs_i = 1'b0;
        @(posedge rxbyteclkhs_i);
        #1;
        if ({lane_valid_3_o, lane_valid_2_o, lane_valid_1_o, lane_valid_0_o} != 4'b0001) begin
            fail("rxvalidhs without rxactivehs should not be accepted");
        end

        dl0_rxactivehs_i = 1'b0;
        dl0_rxvalidhs_i  = 1'b0;
        dl1_rxvalidhs_i  = 1'b0;
        cl_stopstate_i   = 1'b1;
        dl0_stopstate_i  = 1'b1;
        dl1_stopstate_i  = 1'b0;
        wait_lp_sync();
        if (lp_mode_o) begin
            fail("all configured lanes must be in stop-state for LP mode");
        end

        dl1_stopstate_i = 1'b1;
        wait_lp_sync();
        if (!lp_mode_o) begin
            fail("LP mode should return when all configured lanes stop");
        end

        $display("PASS: tb_mipi_dphy_ppi_adapter");
        $finish;
    end

endmodule
