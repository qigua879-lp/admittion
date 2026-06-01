`timescale 1ns/1ps

module tb_phy_digital_adapter;

    logic                     hs_mode_i;
    logic                     lp_mode_i;
    logic [1:0]               cfg_lane_num_minus1_i;
    logic [3:0]               cfg_lane_enable_mask_i;
    logic [31:0]              lane_data_0_i;
    logic [31:0]              lane_data_1_i;
    logic [31:0]              lane_data_2_i;
    logic [31:0]              lane_data_3_i;
    logic                     lane_valid_0_i;
    logic                     lane_valid_1_i;
    logic                     lane_valid_2_i;
    logic                     lane_valid_3_i;
    logic [3:0]               lane_valid_o;
    logic [3:0][7:0]          lane_data_o;
    logic [3:0]               lane_enable_o;
    logic                     phy_active_o;

    phy_digital_adapter #(
        .LANE_NUM(4)
    ) dut (
        .hs_mode_i(hs_mode_i),
        .lp_mode_i(lp_mode_i),
        .cfg_lane_num_minus1_i(cfg_lane_num_minus1_i),
        .cfg_lane_enable_mask_i(cfg_lane_enable_mask_i),
        .lane_data_0_i(lane_data_0_i),
        .lane_data_1_i(lane_data_1_i),
        .lane_data_2_i(lane_data_2_i),
        .lane_data_3_i(lane_data_3_i),
        .lane_valid_0_i(lane_valid_0_i),
        .lane_valid_1_i(lane_valid_1_i),
        .lane_valid_2_i(lane_valid_2_i),
        .lane_valid_3_i(lane_valid_3_i),
        .lane_valid_o(lane_valid_o),
        .lane_data_o(lane_data_o),
        .lane_enable_o(lane_enable_o),
        .phy_active_o(phy_active_o)
    );

    task automatic fail(input string msg);
        begin
            $display("FAIL: %s", msg);
            $fatal(1);
        end
    endtask

    initial begin
        hs_mode_i              = 1'b0;
        lp_mode_i              = 1'b1;
        cfg_lane_num_minus1_i  = 2'd1;
        cfg_lane_enable_mask_i = 4'b1111;
        lane_data_0_i          = 32'h11_22_33_44;
        lane_data_1_i          = 32'h55_66_77_88;
        lane_data_2_i          = 32'h99_aa_bb_cc;
        lane_data_3_i          = 32'hdd_ee_ff_00;
        lane_valid_0_i         = 1'b1;
        lane_valid_1_i         = 1'b1;
        lane_valid_2_i         = 1'b1;
        lane_valid_3_i         = 1'b1;
        #1;

        if (phy_active_o || lane_valid_o != 4'b0000) begin
            fail("LP mode should suppress all lanes");
        end

        hs_mode_i = 1'b1;
        lp_mode_i = 1'b0;
        #1;
        if (!phy_active_o) begin
            fail("HS mode should activate PHY adapter");
        end
        if (lane_enable_o != 4'b0011 || lane_valid_o != 4'b0011) begin
            fail("2-lane configuration mismatch");
        end
        if (lane_data_o[0] != 8'h44 || lane_data_o[1] != 8'h88) begin
            fail("byte extraction mismatch");
        end

        cfg_lane_enable_mask_i = 4'b0101;
        #1;
        if (lane_enable_o != 4'b0001 || lane_valid_o != 4'b0001) begin
            fail("lane mask should gate active lanes");
        end

        cfg_lane_num_minus1_i = 2'd3;
        cfg_lane_enable_mask_i = 4'b1101;
        #1;
        if (lane_enable_o != 4'b1101 || lane_valid_o != 4'b1101) begin
            fail("4-lane mask application mismatch");
        end
        if (lane_data_o[2] != 8'hcc || lane_data_o[3] != 8'h00) begin
            fail("upper lane byte extraction mismatch");
        end

        lane_valid_2_i = 1'b0;
        #1;
        if (lane_valid_o != 4'b1001) begin
            fail("per-lane valid gating mismatch");
        end

        $display("PASS: tb_phy_digital_adapter");
        $finish;
    end

endmodule
