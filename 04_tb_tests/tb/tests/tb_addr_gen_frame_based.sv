`timescale 1ns/1ps

module tb_addr_gen_frame_based;

    localparam int ADDR_WIDTH = 32;

    logic                  clk_axi;
    logic                  rst_n;
    logic                  cfg_valid_i;
    logic                  cfg_ready_o;
    logic [ADDR_WIDTH-1:0] cfg_frame_base_addr_i;
    logic [ADDR_WIDTH-1:0] cfg_line_stride_i;
    logic [15:0]           cfg_line_bytes_i;
    logic [15:0]           cfg_frame_height_i;
    logic [8:0]            cfg_max_burst_len_i;
    logic [ADDR_WIDTH-1:0] frame_base_addr_o;
    logic [ADDR_WIDTH-1:0] line_stride_o;
    logic [15:0]           line_bytes_o;
    logic [15:0]           frame_height_o;
    logic [8:0]            max_burst_len_o;

    logic                  addr_req_valid_i;
    logic                  addr_req_ready_o;
    logic [15:0]           line_id_i;
    logic [ADDR_WIDTH-1:0] byte_offset_i;
    logic                  addr_valid_o;
    logic                  addr_ready_i;
    logic [ADDR_WIDTH-1:0] addr_o;

    mem_map_ctrl #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_mem_map_ctrl (
        .clk_sys(clk_axi),
        .rst_n(rst_n),
        .cfg_valid_i(cfg_valid_i),
        .cfg_ready_o(cfg_ready_o),
        .cfg_frame_base_addr_i(cfg_frame_base_addr_i),
        .cfg_line_stride_i(cfg_line_stride_i),
        .cfg_line_bytes_i(cfg_line_bytes_i),
        .cfg_frame_height_i(cfg_frame_height_i),
        .cfg_max_burst_len_i(cfg_max_burst_len_i),
        .frame_base_addr_o(frame_base_addr_o),
        .line_stride_o(line_stride_o),
        .line_bytes_o(line_bytes_o),
        .frame_height_o(frame_height_o),
        .max_burst_len_o(max_burst_len_o)
    );

    addr_gen_frame_based #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk_axi(clk_axi),
        .rst_n(rst_n),
        .addr_req_valid_i(addr_req_valid_i),
        .addr_req_ready_o(addr_req_ready_o),
        .frame_base_addr_i(frame_base_addr_o),
        .line_stride_i(line_stride_o),
        .line_id_i(line_id_i),
        .byte_offset_i(byte_offset_i),
        .addr_valid_o(addr_valid_o),
        .addr_ready_i(addr_ready_i),
        .addr_o(addr_o)
    );

    initial clk_axi = 1'b0;
    always #5 clk_axi = ~clk_axi;

    task automatic fail(input string msg);
        begin
            $display("[%0t] FAIL: %s", $time, msg);
            $fatal(1);
        end
    endtask

    task automatic apply_reset;
        begin
            rst_n                 = 1'b0;
            cfg_valid_i           = 1'b0;
            cfg_frame_base_addr_i = 32'd0;
            cfg_line_stride_i     = 32'd0;
            cfg_line_bytes_i      = 16'd0;
            cfg_frame_height_i    = 16'd0;
            cfg_max_burst_len_i   = 9'd0;
            addr_req_valid_i      = 1'b0;
            line_id_i             = 16'd0;
            byte_offset_i         = 32'd0;
            addr_ready_i          = 1'b1;
            repeat (5) @(posedge clk_axi);
            rst_n = 1'b1;
            repeat (2) @(posedge clk_axi);
        end
    endtask

    task automatic write_cfg(
        input logic [31:0] base_addr,
        input logic [31:0] line_stride,
        input logic [15:0] line_bytes,
        input logic [15:0] frame_height,
        input logic [8:0]  max_burst
    );
        begin
            @(negedge clk_axi);
            cfg_valid_i           = 1'b1;
            cfg_frame_base_addr_i = base_addr;
            cfg_line_stride_i     = line_stride;
            cfg_line_bytes_i      = line_bytes;
            cfg_frame_height_i    = frame_height;
            cfg_max_burst_len_i   = max_burst;
            @(posedge clk_axi);
            #1;
            cfg_valid_i = 1'b0;
        end
    endtask

    task automatic request_addr(
        input logic [15:0] line_id,
        input logic [31:0] byte_offset
    );
        begin
            @(negedge clk_axi);
            addr_req_valid_i = 1'b1;
            line_id_i        = line_id;
            byte_offset_i    = byte_offset;
            while (!addr_req_ready_o) begin
                @(posedge clk_axi);
            end
            @(posedge clk_axi);
            #1;
            addr_req_valid_i = 1'b0;
        end
    endtask

    task automatic expect_addr(input logic [31:0] exp_addr);
        begin
            while (!addr_valid_o) begin
                @(posedge clk_axi);
            end
            if (addr_o !== exp_addr) begin
                fail($sformatf("address mismatch exp=0x%08h got=0x%08h", exp_addr, addr_o));
            end
            @(posedge clk_axi);
            #1;
        end
    endtask

    initial begin
        apply_reset();

        write_cfg(32'h0000_1000, 32'h0000_0040, 16'd32, 16'd4, 9'd4);
        if (frame_base_addr_o !== 32'h0000_1000 || line_stride_o !== 32'h0000_0040 ||
            line_bytes_o !== 16'd32 || frame_height_o !== 16'd4 || max_burst_len_o !== 9'd4) begin
            fail("mem_map_ctrl config mismatch");
        end

        request_addr(16'd0, 32'd0);
        expect_addr(32'h0000_1000);

        request_addr(16'd2, 32'd8);
        expect_addr(32'h0000_1088);

        addr_ready_i = 1'b0;
        request_addr(16'd3, 32'd4);
        repeat (3) @(posedge clk_axi);
        if (!addr_valid_o || addr_o !== 32'h0000_10c4 || addr_req_ready_o) begin
            fail("address output was not held under backpressure");
        end
        addr_ready_i = 1'b1;
        @(posedge clk_axi);
        #1;

        write_cfg(32'h0000_2000, 32'h0000_0100, 16'd64, 16'd8, 9'd8);
        request_addr(16'd1, 32'h20);
        expect_addr(32'h0000_2120);

        $display("[%0t] PASS: tb_addr_gen_frame_based", $time);
        $finish;
    end

endmodule
