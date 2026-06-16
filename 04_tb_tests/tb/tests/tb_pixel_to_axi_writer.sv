`timescale 1ns/1ps

module tb_pixel_to_axi_writer;

    localparam int ADDR_WIDTH = 32;
    localparam int DATA_WIDTH = 128;
    localparam int MEM_WORDS  = 256;

    logic                         clk_sys;
    logic                         clk_axi;
    logic                         rst_n;
    logic                         enable_i;
    logic                         clear_i;
    logic                         clear_busy_o;
    logic [ADDR_WIDTH-1:0]        frame_base_addr_i;
    logic [ADDR_WIDTH-1:0]        line_stride_i;
    logic [15:0]                  frame_height_i;
    logic [8:0]                   max_burst_len_i;
    logic                         frame_start_i;
    logic                         line_end_i;
    logic                         discard_line_i;
    logic                         recap_active_i;
    logic [15:0]                  recap_line_id_i;
    logic                         pixel_valid_i;
    logic                         pixel_ready_o;
    logic [23:0]                  pixel_data_i;
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

    pixel_to_axi_writer #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_BURST_LEN(4),
        .FIFO_ADDR_WIDTH(4)
    ) dut (
        .clk_sys(clk_sys),
        .clk_axi(clk_axi),
        .rst_n(rst_n),
        .enable_i(enable_i),
        .clear_i(clear_i),
        .clear_busy_o(clear_busy_o),
        .frame_base_addr_i(frame_base_addr_i),
        .line_stride_i(line_stride_i),
        .frame_height_i(frame_height_i),
        .max_burst_len_i(max_burst_len_i),
        .frame_start_i(frame_start_i),
        .line_end_i(line_end_i),
        .discard_line_i(discard_line_i),
        .recap_active_i(recap_active_i),
        .recap_line_id_i(recap_line_id_i),
        .pixel_valid_i(pixel_valid_i),
        .pixel_ready_o(pixel_ready_o),
        .pixel_data_i(pixel_data_i),
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

    initial begin
        clk_sys = 1'b0;
        forever #5 clk_sys = ~clk_sys;
    end

    initial begin
        clk_axi = 1'b0;
        forever #5 clk_axi = ~clk_axi;
    end

    task automatic fail(input string msg);
        begin
            $display("[%0t] FAIL: %s", $time, msg);
            $fatal(1);
        end
    endtask

    integer i;

    always_ff @(posedge clk_axi) begin
        if (!rst_n) begin
            m_axi_awready_i    <= 1'b1;
            m_axi_wready_i     <= 1'b1;
            m_axi_bvalid_i     <= 1'b0;
            m_axi_bresp_i      <= 2'b00;
            model_burst_active <= 1'b0;
            model_addr_word    <= 32'd0;
            model_awlen        <= 8'd0;
            model_beat_idx     <= 9'd0;
            for (i = 0; i < MEM_WORDS; i = i + 1) begin
                mem[i] <= 32'd0;
            end
        end else begin
            if (m_axi_awvalid_o && m_axi_awready_i) begin
                if (model_burst_active) begin
                    fail("overlapping bursts are not expected");
                end
                model_burst_active <= 1'b1;
                model_addr_word    <= m_axi_awaddr_o >> 2;
                model_awlen        <= m_axi_awlen_o;
                model_beat_idx     <= 9'd0;
            end

            if (m_axi_wvalid_o && m_axi_wready_i) begin
                if (!model_burst_active) begin
                    fail("W channel fired without AW");
                end
                mem[model_addr_word + (model_beat_idx * 4) + 0] <= m_axi_wdata_o[31:0];
                mem[model_addr_word + (model_beat_idx * 4) + 1] <= m_axi_wdata_o[63:32];
                mem[model_addr_word + (model_beat_idx * 4) + 2] <= m_axi_wdata_o[95:64];
                mem[model_addr_word + (model_beat_idx * 4) + 3] <= m_axi_wdata_o[127:96];
                if (m_axi_wlast_o !== (model_beat_idx == {1'b0, model_awlen})) begin
                    fail("WLAST mismatch in pixel_to_axi_writer");
                end

                if (m_axi_wlast_o) begin
                    model_burst_active <= 1'b0;
                    m_axi_bvalid_i     <= 1'b1;
                end else begin
                    model_beat_idx <= model_beat_idx + 9'd1;
                end
            end

            if (m_axi_bvalid_i && m_axi_bready_o) begin
                m_axi_bvalid_i <= 1'b0;
            end
        end
    end

    task automatic apply_reset;
        begin
            rst_n             = 1'b0;
            enable_i          = 1'b0;
            clear_i           = 1'b0;
            frame_base_addr_i = 32'h0000_0100;
            line_stride_i     = 32'h0000_0020;
            frame_height_i    = 16'd4;
            max_burst_len_i   = 9'd4;
            frame_start_i     = 1'b0;
            line_end_i        = 1'b0;
            discard_line_i    = 1'b0;
            recap_active_i    = 1'b0;
            recap_line_id_i   = 16'd0;
            pixel_valid_i     = 1'b0;
            pixel_data_i      = 24'd0;
            repeat (5) @(posedge clk_sys);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_sys);
        end
    endtask

    task automatic pulse_frame_start;
        begin
            @(negedge clk_sys);
            frame_start_i = 1'b1;
            @(posedge clk_sys);
            #1;
            frame_start_i = 1'b0;
        end
    endtask

    task automatic pulse_line_end;
        begin
            @(negedge clk_sys);
            line_end_i = 1'b1;
            @(posedge clk_sys);
            #1;
            line_end_i = 1'b0;
        end
    endtask

    task automatic pulse_discard_line_end;
        begin
            @(negedge clk_sys);
            discard_line_i = 1'b1;
            line_end_i     = 1'b1;
            @(posedge clk_sys);
            #1;
            discard_line_i = 1'b0;
            line_end_i     = 1'b0;
        end
    endtask

    task automatic pulse_clear;
        begin
            @(negedge clk_sys);
            clear_i = 1'b1;
            @(posedge clk_sys);
            #1;
            clear_i = 1'b0;
            while (clear_busy_o) begin
                @(posedge clk_sys);
            end
        end
    endtask

    task automatic send_pixel(input logic [23:0] pixel_data);
        begin
            @(negedge clk_sys);
            pixel_valid_i = 1'b1;
            pixel_data_i  = pixel_data;
            @(posedge clk_sys);
            while (!pixel_ready_o) begin
                @(posedge clk_sys);
            end
            #1;
            pixel_valid_i = 1'b0;
            pixel_data_i  = 24'd0;
        end
    endtask

    task automatic wait_idle;
        begin
            repeat (20) @(posedge clk_axi);
            while (busy_o || m_axi_bvalid_i || model_burst_active) begin
                @(posedge clk_axi);
            end
        end
    endtask

    initial begin
        apply_reset();

        enable_i = 1'b1;
        repeat (4) @(posedge clk_axi);
        pulse_frame_start();

        send_pixel(24'h11_22_33);
        send_pixel(24'h44_55_66);
        send_pixel(24'h77_88_99);
        pulse_line_end();

        send_pixel(24'haa_bb_cc);
        send_pixel(24'hdd_ee_ff);
        pulse_discard_line_end();

        wait_idle();

        if (err_axi_o) begin
            fail("unexpected AXI error");
        end

        if (mem[32'h100 >> 2] !== 32'h00_11_22_33) begin
            fail("line0 pixel0 write mismatch");
        end
        if (mem[(32'h100 >> 2) + 1] !== 32'h00_44_55_66) begin
            fail("line0 pixel1 write mismatch");
        end
        if (mem[(32'h100 >> 2) + 2] !== 32'h00_77_88_99) begin
            fail("line0 pixel2 write mismatch");
        end
        if (mem[32'h120 >> 2] !== 32'd0) begin
            fail("discarded line should not write pixel0");
        end
        if (mem[(32'h120 >> 2) + 1] !== 32'd0) begin
            fail("discarded line should not write pixel1");
        end

        apply_reset();

        enable_i = 1'b1;
        repeat (4) @(posedge clk_axi);
        pulse_frame_start();

        send_pixel(24'hde_ad_be);
        send_pixel(24'hef_12_34);
        send_pixel(24'h56_78_9a);
        send_pixel(24'hbc_de_f0);
        pulse_clear();

        pulse_frame_start();
        send_pixel(24'h12_34_56);
        send_pixel(24'h65_43_21);
        pulse_line_end();

        wait_idle();

        if (mem[32'h100 >> 2] !== 32'h00_12_34_56) begin
            fail("clear recovery pixel0 write mismatch");
        end
        if (mem[(32'h100 >> 2) + 1] !== 32'h00_65_43_21) begin
            fail("clear recovery pixel1 write mismatch");
        end
        if (mem[(32'h100 >> 2) + 2] !== 32'd0) begin
            fail("clear did not remove stale packed beat data");
        end

        $display("[%0t] PASS: tb_pixel_to_axi_writer", $time);
        $finish;
    end

endmodule
