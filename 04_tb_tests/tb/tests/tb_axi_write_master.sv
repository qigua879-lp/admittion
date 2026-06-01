`timescale 1ns/1ps

module tb_axi_write_master;

    localparam int ADDR_WIDTH = 32;
    localparam int DATA_WIDTH = 32;
    localparam int DATA_BYTES = DATA_WIDTH / 8;
    localparam int MEM_WORDS  = 256;

    logic                         clk_axi;
    logic                         rst_n;
    logic                         cmd_valid_i;
    logic                         cmd_ready_o;
    logic [ADDR_WIDTH-1:0]        cmd_addr_i;
    logic [15:0]                  cmd_byte_len_i;
    logic [8:0]                   cfg_max_burst_len_i;
    logic                         wr_valid_i;
    logic                         wr_ready_o;
    logic [DATA_WIDTH-1:0]        wr_data_i;
    logic [(DATA_WIDTH/8)-1:0]    wr_strb_i;
    logic [ADDR_WIDTH-1:0]        m_axi_awaddr_o;
    logic [7:0]                   m_axi_awlen_o;
    logic [2:0]                   m_axi_awsize_o;
    logic [1:0]                   m_axi_awburst_o;
    logic                         m_axi_awvalid_o;
    logic                         m_axi_awready_i;
    logic [DATA_WIDTH-1:0]        m_axi_wdata_o;
    logic [(DATA_WIDTH/8)-1:0]    m_axi_wstrb_o;
    logic                         m_axi_wlast_o;
    logic                         m_axi_wvalid_o;
    logic                         m_axi_wready_i;
    logic [1:0]                   m_axi_bresp_i;
    logic                         m_axi_bvalid_i;
    logic                         m_axi_bready_o;
    logic                         busy_o;
    logic                         done_o;
    logic                         err_axi_o;

    logic [31:0] mem [0:MEM_WORDS-1];
    logic        model_burst_active;
    logic [31:0] model_addr_word;
    logic [7:0]  model_awlen;
    logic [8:0]  model_beat_idx;
    logic [7:0]  aw_cnt;
    logic [31:0] awaddr_seen [0:7];
    logic [7:0]  awlen_seen [0:7];
    logic [31:0] cycle_cnt;
    int unsigned timeout_cycle_cnt;

    axi_write_master #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_BURST_LEN(4)
    ) dut (
        .clk_axi(clk_axi),
        .rst_n(rst_n),
        .cmd_valid_i(cmd_valid_i),
        .cmd_ready_o(cmd_ready_o),
        .cmd_addr_i(cmd_addr_i),
        .cmd_byte_len_i(cmd_byte_len_i),
        .cfg_max_burst_len_i(cfg_max_burst_len_i),
        .wr_valid_i(wr_valid_i),
        .wr_ready_o(wr_ready_o),
        .wr_data_i(wr_data_i),
        .wr_strb_i(wr_strb_i),
        .m_axi_awaddr_o(m_axi_awaddr_o),
        .m_axi_awlen_o(m_axi_awlen_o),
        .m_axi_awsize_o(m_axi_awsize_o),
        .m_axi_awburst_o(m_axi_awburst_o),
        .m_axi_awvalid_o(m_axi_awvalid_o),
        .m_axi_awready_i(m_axi_awready_i),
        .m_axi_wdata_o(m_axi_wdata_o),
        .m_axi_wstrb_o(m_axi_wstrb_o),
        .m_axi_wlast_o(m_axi_wlast_o),
        .m_axi_wvalid_o(m_axi_wvalid_o),
        .m_axi_wready_i(m_axi_wready_i),
        .m_axi_bresp_i(m_axi_bresp_i),
        .m_axi_bvalid_i(m_axi_bvalid_i),
        .m_axi_bready_o(m_axi_bready_o),
        .busy_o(busy_o),
        .done_o(done_o),
        .err_axi_o(err_axi_o)
    );

    initial clk_axi = 1'b0;
    always #5 clk_axi = ~clk_axi;

    initial begin
        timeout_cycle_cnt = 0;
        forever begin
            @(posedge clk_axi);
            if (rst_n) begin
                timeout_cycle_cnt++;
                if (timeout_cycle_cnt > 1000) begin
                    $display("[%0t] TIMEOUT", $time);
                    $display("dut.state=%0d beat_cnt=%0d cur_beat_cnt=%0d cur_burst_last=%0b",
                             dut.state, dut.beat_cnt, dut.cur_beat_cnt, dut.cur_burst_last);
                    $display("AW v/r=%0b/%0b addr=0x%08h len=%0d",
                             m_axi_awvalid_o, m_axi_awready_i, m_axi_awaddr_o, m_axi_awlen_o);
                    $display("W  v/r/last=%0b/%0b/%0b data=0x%08h",
                             m_axi_wvalid_o, m_axi_wready_i, m_axi_wlast_o, m_axi_wdata_o);
                    $display("B  v/r/resp=%0b/%0b/%0b",
                             m_axi_bvalid_i, m_axi_bready_o, m_axi_bresp_i);
                    $display("burst valid/ready=%0b/%0b addr=0x%08h beats=%0d last=%0b remaining=%0d",
                             dut.burst_valid, dut.burst_ready, dut.burst_addr,
                             dut.burst_beat_cnt, dut.burst_last,
                             dut.u_axi_burst_gen.remaining_beat_cnt);
                    $display("model active=%0b beat_idx=%0d aw_cnt=%0d done=%0b busy=%0b err=%0b",
                             model_burst_active, model_beat_idx, aw_cnt, done_o, busy_o, err_axi_o);
                    $fatal(1);
                end
            end
        end
    end

    task automatic fail(input string msg);
        begin
            $display("[%0t] FAIL: %s", $time, msg);
            $fatal(1);
        end
    endtask

    integer i;

    always @(posedge clk_axi) begin
        if (!rst_n) begin
            cycle_cnt          <= 32'd0;
            m_axi_awready_i    <= 1'b0;
            m_axi_wready_i     <= 1'b0;
            m_axi_bvalid_i     <= 1'b0;
            m_axi_bresp_i      <= 2'b00;
            model_burst_active <= 1'b0;
            model_addr_word    <= 32'd0;
            model_awlen        <= 8'd0;
            model_beat_idx     <= 9'd0;
            aw_cnt             <= 8'd0;
            for (i = 0; i < MEM_WORDS; i = i + 1) begin
                mem[i] <= 32'd0;
            end
            for (i = 0; i < 8; i = i + 1) begin
                awaddr_seen[i] <= 32'd0;
                awlen_seen[i]  <= 8'd0;
            end
        end else begin
            cycle_cnt       <= cycle_cnt + 32'd1;
            m_axi_awready_i <= cycle_cnt[0];
            m_axi_wready_i  <= (cycle_cnt[1:0] != 2'b00);

            if (m_axi_awvalid_o && m_axi_awready_i) begin
                $display("[%0t] AW fire addr=0x%08h len=%0d state=%0d",
                         $time, m_axi_awaddr_o, m_axi_awlen_o, dut.state);
                if (model_burst_active) begin
                    fail("AW accepted while previous burst active");
                end
                if (m_axi_awsize_o !== 3'd2 || m_axi_awburst_o !== 2'b01) begin
                    fail("unexpected AXI AW size or burst type");
                end
                awaddr_seen[aw_cnt] <= m_axi_awaddr_o;
                awlen_seen[aw_cnt]  <= m_axi_awlen_o;
                aw_cnt              <= aw_cnt + 8'd1;
                model_burst_active <= 1'b1;
                model_addr_word    <= m_axi_awaddr_o >> 2;
                model_awlen        <= m_axi_awlen_o;
                model_beat_idx     <= 9'd0;
            end

            if (m_axi_wvalid_o && m_axi_wready_i) begin
                $display("[%0t] W fire data=0x%08h last=%0b beat_idx=%0d state=%0d",
                         $time, m_axi_wdata_o, m_axi_wlast_o, model_beat_idx, dut.state);
                if (!model_burst_active) begin
                    fail("W accepted without active AW");
                end
                if (m_axi_wstrb_o !== 4'hf) begin
                    fail("unexpected WSTRB");
                end
                if (m_axi_wlast_o !== (model_beat_idx == {1'b0, model_awlen})) begin
                    fail("WLAST mismatch");
                end
                mem[model_addr_word + model_beat_idx] <= m_axi_wdata_o;
                if (m_axi_wlast_o) begin
                    model_burst_active <= 1'b0;
                    m_axi_bvalid_i     <= 1'b1;
                    m_axi_bresp_i      <= 2'b00;
                end else begin
                    model_beat_idx <= model_beat_idx + 9'd1;
                end
            end

            if (m_axi_bvalid_i && m_axi_bready_o) begin
                $display("[%0t] B fire resp=%0b state=%0d cur_burst_last=%0b done=%0b",
                         $time, m_axi_bresp_i, dut.state, dut.cur_burst_last, done_o);
                m_axi_bvalid_i <= 1'b0;
            end
        end
    end

    task automatic apply_reset;
        begin
            rst_n               = 1'b0;
            cmd_valid_i         = 1'b0;
            cmd_addr_i          = 32'd0;
            cmd_byte_len_i      = 16'd0;
            cfg_max_burst_len_i = 9'd4;
            wr_valid_i          = 1'b0;
            wr_data_i           = 32'd0;
            wr_strb_i           = 4'hf;
            repeat (5) @(posedge clk_axi);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_axi);
        end
    endtask

    task automatic send_cmd(input logic [31:0] addr, input logic [15:0] byte_len);
        begin
            @(negedge clk_axi);
            cmd_valid_i    = 1'b1;
            cmd_addr_i     = addr;
            cmd_byte_len_i = byte_len;
            @(posedge clk_axi);
            while (!cmd_ready_o) begin
                @(posedge clk_axi);
            end
            #1;
            cmd_valid_i = 1'b0;
        end
    endtask

    task automatic send_word(input logic [31:0] data);
        begin
            @(negedge clk_axi);
            wr_valid_i = 1'b1;
            wr_data_i  = data;
            wr_strb_i  = 4'hf;
            @(posedge clk_axi);
            while (!wr_ready_o) begin
                @(posedge clk_axi);
            end
            #1;
            wr_valid_i = 1'b0;
            wr_data_i  = 32'd0;
        end
    endtask

    task automatic wait_done;
        begin
            while (!done_o) begin
                @(posedge clk_axi);
                #1;
            end
            if (err_axi_o) begin
                fail("AXI error reported unexpectedly");
            end
        end
    endtask

    initial begin
        apply_reset();

        send_cmd(32'h0000_0040, 16'd24);
        send_word(32'ha000_0000);
        send_word(32'ha000_0001);
        send_word(32'ha000_0002);
        send_word(32'ha000_0003);
        send_word(32'ha000_0004);
        send_word(32'ha000_0005);
        wait_done();

        if (aw_cnt !== 8'd2 || awaddr_seen[0] !== 32'h0000_0040 ||
            awlen_seen[0] !== 8'd3 || awaddr_seen[1] !== 32'h0000_0050 ||
            awlen_seen[1] !== 8'd1) begin
            fail("burst split metadata mismatch");
        end

        for (i = 0; i < 6; i = i + 1) begin
            if (mem[(32'h40 >> 2) + i] !== (32'ha000_0000 + i)) begin
                fail($sformatf("memory data mismatch at beat %0d", i));
            end
        end

        send_cmd(32'h0000_0080, 16'd4);
        send_word(32'h55aa_1234);
        wait_done();
        if (aw_cnt !== 8'd3 || awaddr_seen[2] !== 32'h0000_0080 ||
            awlen_seen[2] !== 8'd0 || mem[32'h80 >> 2] !== 32'h55aa_1234) begin
            fail("single burst write mismatch");
        end

        $display("[%0t] PASS: tb_axi_write_master", $time);
        $finish;
    end

endmodule
