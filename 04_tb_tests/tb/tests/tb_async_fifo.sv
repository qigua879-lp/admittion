`timescale 1ns/1ps

module tb_async_fifo;

    localparam int DATA_WIDTH = 8;
    localparam int ADDR_WIDTH = 2;
    localparam int DEPTH      = (1 << ADDR_WIDTH);

    logic                  clk_wr;
    logic                  clk_rd;
    logic                  rst_n;
    logic                  wr_valid;
    logic                  wr_ready;
    logic [DATA_WIDTH-1:0] wr_data;
    logic                  clear_wr_i;
    logic                  clear_rd_i;
    logic                  rd_valid;
    logic                  rd_ready;
    logic [DATA_WIDTH-1:0] rd_data;
    logic                  full;
    logic                  empty;
    logic [ADDR_WIDTH:0]   wr_level;
    logic [ADDR_WIDTH:0]   rd_level;

    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk_wr(clk_wr),
        .clk_rd(clk_rd),
        .rst_n(rst_n),
        .clear_wr_i(clear_wr_i),
        .clear_rd_i(clear_rd_i),
        .wr_valid(wr_valid),
        .wr_ready(wr_ready),
        .wr_data(wr_data),
        .rd_valid(rd_valid),
        .rd_ready(rd_ready),
        .rd_data(rd_data),
        .full(full),
        .empty(empty),
        .wr_level(wr_level),
        .rd_level(rd_level)
    );

    initial clk_wr = 1'b0;
    always #3 clk_wr = ~clk_wr;

    initial clk_rd = 1'b0;
    always #5 clk_rd = ~clk_rd;

    task automatic fail(input string msg);
        begin
            $display("[%0t] FAIL: %s", $time, msg);
            $fatal(1);
        end
    endtask

    task automatic apply_reset;
        begin
            rst_n    = 1'b0;
            wr_valid = 1'b0;
            wr_data  = '0;
            rd_ready = 1'b0;
            clear_wr_i = 1'b0;
            clear_rd_i = 1'b0;
            repeat (5) @(posedge clk_wr);
            repeat (5) @(posedge clk_rd);
            rst_n = 1'b1;
            repeat (4) @(posedge clk_wr);
            repeat (4) @(posedge clk_rd);
        end
    endtask

    task automatic write_byte(input logic [7:0] data);
        begin
            @(posedge clk_wr);
            wr_valid <= 1'b1;
            wr_data  <= data;
            while (!wr_ready) begin
                @(posedge clk_wr);
            end
            @(posedge clk_wr);
            wr_valid <= 1'b0;
            wr_data  <= '0;
        end
    endtask

    task automatic read_expect(input logic [7:0] expected);
        begin
            rd_ready <= 1'b0;
            @(posedge clk_rd);
            while (!rd_valid) begin
                @(posedge clk_rd);
            end
            @(negedge clk_rd);
            if (rd_data !== expected) begin
                fail($sformatf("expected 0x%02h, got 0x%02h", expected, rd_data));
            end
            rd_ready <= 1'b1;
            @(posedge clk_rd);
            rd_ready <= 1'b0;
        end
    endtask

    initial begin
        apply_reset();

        if (!empty || rd_valid) begin
            fail("FIFO was not empty after reset");
        end
        if (full || !wr_ready) begin
            fail("FIFO was not writable after reset");
        end

        write_byte(8'h11);
        read_expect(8'h11);

        write_byte(8'h20);
        write_byte(8'h21);
        write_byte(8'h22);
        write_byte(8'h23);

        repeat (4) @(posedge clk_wr);
        if (!full || wr_ready) begin
            fail("FIFO did not report full after DEPTH writes");
        end

        wr_valid <= 1'b1;
        wr_data  <= 8'haa;
        repeat (3) @(posedge clk_wr);
        if (wr_ready) begin
            fail("FIFO accepted a write while full");
        end
        wr_valid <= 1'b0;

        read_expect(8'h20);
        read_expect(8'h21);
        read_expect(8'h22);
        read_expect(8'h23);

        repeat (4) @(posedge clk_rd);
        if (!empty || rd_valid) begin
            fail("FIFO did not report empty after all reads");
        end

        write_byte(8'h30);
        write_byte(8'h31);
        write_byte(8'h32);
        repeat (5) @(posedge clk_rd);
        if (!rd_valid || rd_data !== 8'h30) begin
            fail("read-side backpressure did not hold first data");
        end
        read_expect(8'h30);
        read_expect(8'h31);
        read_expect(8'h32);

        write_byte(8'h41);
        write_byte(8'h42);
        @(negedge clk_wr);
        clear_wr_i = 1'b1;
        @(negedge clk_rd);
        clear_rd_i = 1'b1;
        @(posedge clk_wr);
        clear_wr_i = 1'b0;
        @(posedge clk_rd);
        clear_rd_i = 1'b0;
        repeat (3) @(posedge clk_wr);
        repeat (3) @(posedge clk_rd);
        if (!empty || rd_valid || !wr_ready || full) begin
            fail("FIFO clear did not return FIFO to empty state");
        end

        $display("[%0t] PASS: tb_async_fifo", $time);
        $finish;
    end

endmodule
