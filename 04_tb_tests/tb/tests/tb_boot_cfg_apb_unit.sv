`timescale 1ns/1ps

// Focused unit check: drive cfg_reg_if_apb purely from the on-chip boot
// sequencer fpga_apb_boot_cfg (no force) and confirm the boot register set is
// actually latched. Proves the APB SETUP/ACCESS phasing fix.
module tb_boot_cfg_apb_unit;

    logic clk_sys;
    logic rst_n;

    logic        psel;
    logic        penable;
    logic        pwrite;
    logic [15:0] paddr;
    logic [31:0] pwdata;
    logic [31:0] prdata;
    logic        pready;
    logic        pslverr;
    logic        cfg_init_done;

    // Count how many APB write beats actually fire on the bus.
    int unsigned write_fire_cnt;

    fpga_apb_boot_cfg #(
        .ADDR_WIDTH(16),
        .DATA_WIDTH(32),
        .AXI_ADDR_WIDTH(32),
        .AXI_MAX_BURST_LEN(16),
        .ERR_POLICY_VALUE(32'h0000_007D)  // line-mode retry (bit6) + crc-drop (bit2)
    ) u_boot (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .psel_o(psel),
        .penable_o(penable),
        .pwrite_o(pwrite),
        .paddr_o(paddr),
        .pwdata_o(pwdata),
        .prdata_i(prdata),
        .pready_i(pready),
        .pslverr_i(pslverr),
        .init_done_o(cfg_init_done)
    );

    cfg_reg_if_apb #(
        .ADDR_WIDTH(16),
        .DATA_WIDTH(32),
        .AXI_ADDR_WIDTH(32),
        .AXI_MAX_BURST_LEN(16)
    ) u_cfg (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .psel_i(psel),
        .penable_i(penable),
        .pwrite_i(pwrite),
        .paddr_i(paddr),
        .pwdata_i(pwdata),
        .prdata_o(prdata),
        .pready_o(pready),
        .pslverr_o(pslverr),
        // status/feedback inputs tied off
        .frame_active_i(1'b0), .line_active_i(1'b0), .parser_busy_i(1'b0),
        .axi_busy_i(1'b0), .err_pending_i(1'b0), .overflow_event_i(1'b0),
        .active_lane_num_i(3'd0), .hs_mode_i(1'b0), .lp_mode_i(1'b0),
        .frame_cnt_i(32'd0), .line_cnt_i(32'd0), .err_cnt_ecc_i(32'd0),
        .err_cnt_crc_i(32'd0), .err_cnt_sync_i(32'd0), .last_err_type_i(3'd0),
        .last_err_priority_i(2'd0), .last_err_frame_id_i(32'd0),
        .last_err_line_id_i(32'd0), .last_err_vc_i(2'd0), .last_err_dt_i(6'd0),
        .retry_pending_i(1'b0), .retry_mode_i(1'b0), .retry_err_type_i(3'd0),
        .retry_frame_id_i(32'd0), .retry_line_id_i(32'd0), .retry_vc_i(2'd0),
        .retry_dt_i(6'd0), .adaptive_stretch_gain_i(8'd0),
        .adaptive_awb_gain_r_i(8'd0), .adaptive_awb_gain_g_i(8'd0),
        .adaptive_awb_gain_b_i(8'd0), .stats_mean_r_i(16'd0),
        .stats_mean_g_i(16'd0), .stats_mean_b_i(16'd0),
        .stats_luma_min_i(8'd0), .stats_luma_max_i(8'd0)
    );

    initial clk_sys = 1'b0;
    always #5 clk_sys = ~clk_sys;

    always_ff @(posedge clk_sys) begin
        if (!rst_n)
            write_fire_cnt <= 0;
        else if (psel && penable && pwrite)
            write_fire_cnt <= write_fire_cnt + 1;
    end

    int errors = 0;
    task automatic chk(string nm, logic [31:0] got, logic [31:0] exp);
        if (got !== exp) begin
            $display("  FAIL %-22s got=0x%08h exp=0x%08h", nm, got, exp);
            errors++;
        end else begin
            $display("  ok   %-22s = 0x%08h", nm, got);
        end
    endtask

    initial begin
        rst_n = 1'b0;
        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        // Wait for the boot sequencer to finish, with a hard timeout.
        fork
            begin
                wait (cfg_init_done);
            end
            begin
                repeat (2000) @(posedge clk_sys);
                $display("FAIL: boot never asserted init_done");
                $fatal(1);
            end
        join_any
        disable fork;

        repeat (4) @(posedge clk_sys);

        $display("APB write beats observed on bus: %0d", write_fire_cnt);
        if (write_fire_cnt == 0) begin
            $display("FAIL: no APB writes ever fired (penable never reached bus)");
            $fatal(1);
        end

        // Boot defaults from fpga_apb_boot_cfg parameters.
        chk("cfg_enable",        {31'd0, u_cfg.cfg_enable_o},      32'd1);
        chk("cfg_img_width",     {16'd0, u_cfg.cfg_img_width_o},   32'd1920);
        chk("cfg_img_height",    {16'd0, u_cfg.cfg_img_height_o},  32'd1080);
        chk("cfg_lane_num_m1",   {30'd0, u_cfg.cfg_lane_num_minus1_o}, 32'd1);
        chk("cfg_lane_mask",     {28'd0, u_cfg.cfg_lane_enable_mask_o}, 32'h3);
        chk("cfg_dt_code",       {24'd0, u_cfg.cfg_dt_code_o},     32'h2a);
        chk("cfg_line_stride",   u_cfg.cfg_line_stride_o,          32'd4096);
        chk("cfg_axi_burst_len", {23'd0, u_cfg.cfg_axi_max_burst_len_o}, 32'd16);
        // ERR_POLICY = 0x7D -> drop_on_crc (bit2)=1, retry_line_mode (bit6)=1
        chk("cfg_drop_on_crc",   {31'd0, u_cfg.cfg_drop_on_crc_error_o}, 32'd1);
        chk("cfg_retry_line_mode",{31'd0, u_cfg.cfg_retry_line_mode_o},  32'd1);

        if (errors == 0)
            $display("PASS: boot sequencer configured cfg_reg_if_apb with no force");
        else
            $display("FAIL: %0d config mismatches", errors);

        $finish;
    end

endmodule
