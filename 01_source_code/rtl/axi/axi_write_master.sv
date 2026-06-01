`timescale 1ns/1ps

module axi_write_master #(
    parameter int ADDR_WIDTH    = 32,
    parameter int DATA_WIDTH    = 32,
    parameter int MAX_BURST_LEN = 16
) (
    input  logic                         clk_axi,
    input  logic                         rst_n,

    input  logic                         cmd_valid_i,
    output logic                         cmd_ready_o,
    input  logic [ADDR_WIDTH-1:0]        cmd_addr_i,
    input  logic [15:0]                  cmd_byte_len_i,
    input  logic [8:0]                   cfg_max_burst_len_i,

    input  logic                         wr_valid_i,
    output logic                         wr_ready_o,
    input  logic [DATA_WIDTH-1:0]        wr_data_i,
    input  logic [(DATA_WIDTH/8)-1:0]    wr_strb_i,

    output logic [ADDR_WIDTH-1:0]        m_axi_awaddr_o,
    output logic [7:0]                   m_axi_awlen_o,
    output logic [2:0]                   m_axi_awsize_o,
    output logic [1:0]                   m_axi_awburst_o,
    output logic                         m_axi_awvalid_o,
    input  logic                         m_axi_awready_i,

    output logic [DATA_WIDTH-1:0]        m_axi_wdata_o,
    output logic [(DATA_WIDTH/8)-1:0]    m_axi_wstrb_o,
    output logic                         m_axi_wlast_o,
    output logic                         m_axi_wvalid_o,
    input  logic                         m_axi_wready_i,

    input  logic [1:0]                   m_axi_bresp_i,
    input  logic                         m_axi_bvalid_i,
    output logic                         m_axi_bready_o,

    output logic                         busy_o,
    output logic                         done_o,
    output logic                         err_axi_o
);

    localparam int DATA_BYTES = DATA_WIDTH / 8;
    localparam logic [2:0] AXI_SIZE =
        (DATA_BYTES == 1)  ? 3'd0 :
        (DATA_BYTES == 2)  ? 3'd1 :
        (DATA_BYTES == 4)  ? 3'd2 :
        (DATA_BYTES == 8)  ? 3'd3 :
        (DATA_BYTES == 16) ? 3'd4 :
        (DATA_BYTES == 32) ? 3'd5 : 3'd2;

    localparam logic [1:0] AXI_BURST_INCR = 2'b01;

    localparam logic [1:0] ST_IDLE = 2'd0;
    localparam logic [1:0] ST_AW   = 2'd1;
    localparam logic [1:0] ST_W    = 2'd2;
    localparam logic [1:0] ST_B    = 2'd3;

    logic [1:0] state;

    logic [15:0] cmd_beat_cnt;
    logic        zero_cmd_fire;
    logic        burst_req_valid;
    logic        burst_req_ready;
    logic        burst_valid;
    logic        burst_ready;
    logic [ADDR_WIDTH-1:0] burst_addr;
    logic [7:0]            burst_len;
    logic [8:0]            burst_beat_cnt;
    logic                  burst_last;
    logic                  burst_busy;

    logic [ADDR_WIDTH-1:0] cur_addr;
    logic [7:0]            cur_len;
    logic [8:0]            cur_beat_cnt;
    logic                  cur_burst_last;
    logic [8:0]            beat_cnt;
    logic                  last_beat;
    logic                  aw_fire;
    logic                  w_fire;
    logic                  b_fire;

    assign cmd_beat_cnt = (cmd_byte_len_i == 16'd0) ? 16'd0 :
                          ((cmd_byte_len_i + DATA_BYTES - 1) / DATA_BYTES);

    assign cmd_ready_o     = (cmd_beat_cnt == 16'd0) ? !busy_o : burst_req_ready;
    assign zero_cmd_fire   = cmd_valid_i && cmd_ready_o && (cmd_beat_cnt == 16'd0);
    assign burst_req_valid = cmd_valid_i && (cmd_beat_cnt != 16'd0);

    axi_burst_gen #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_BURST_LEN(MAX_BURST_LEN)
    ) u_axi_burst_gen (
        .clk_axi(clk_axi),
        .rst_n(rst_n),
        .req_valid_i(burst_req_valid),
        .req_ready_o(burst_req_ready),
        .req_addr_i(cmd_addr_i),
        .req_beat_cnt_i(cmd_beat_cnt),
        .cfg_max_burst_len_i(cfg_max_burst_len_i),
        .burst_valid_o(burst_valid),
        .burst_ready_i(burst_ready),
        .burst_addr_o(burst_addr),
        .burst_len_o(burst_len),
        .burst_beat_cnt_o(burst_beat_cnt),
        .burst_last_o(burst_last),
        .busy_o(burst_busy)
    );

    assign burst_ready = (state == ST_IDLE) && burst_valid;
    assign busy_o      = (state != ST_IDLE) || burst_busy || burst_valid;

    assign m_axi_awaddr_o  = cur_addr;
    assign m_axi_awlen_o   = cur_len;
    assign m_axi_awsize_o  = AXI_SIZE;
    assign m_axi_awburst_o = AXI_BURST_INCR;
    assign m_axi_awvalid_o = (state == ST_AW);

    assign m_axi_wdata_o   = wr_data_i;
    assign m_axi_wstrb_o   = wr_strb_i;
    assign m_axi_wvalid_o  = (state == ST_W) && wr_valid_i;
    assign m_axi_wlast_o   = (state == ST_W) && last_beat;
    assign wr_ready_o      = (state == ST_W) && m_axi_wready_i;

    assign m_axi_bready_o  = (state == ST_B);

    assign last_beat = (beat_cnt == (cur_beat_cnt - 9'd1));
    assign aw_fire   = m_axi_awvalid_o && m_axi_awready_i;
    assign w_fire    = m_axi_wvalid_o && m_axi_wready_i;
    assign b_fire    = m_axi_bvalid_i && m_axi_bready_o;

    always_ff @(posedge clk_axi) begin
        if (!rst_n) begin
            state          <= ST_IDLE;
            cur_addr       <= '0;
            cur_len        <= 8'd0;
            cur_beat_cnt   <= 9'd0;
            cur_burst_last <= 1'b0;
            beat_cnt       <= 9'd0;
            done_o         <= 1'b0;
            err_axi_o      <= 1'b0;
        end else begin
            done_o <= 1'b0;

            if (cmd_valid_i && cmd_ready_o) begin
                err_axi_o <= 1'b0;
            end

            if (zero_cmd_fire) begin
                done_o <= 1'b1;
            end

            case (state)
                ST_IDLE: begin
                    beat_cnt <= 9'd0;
                    if (burst_valid) begin
                        cur_addr       <= burst_addr;
                        cur_len        <= burst_len;
                        cur_beat_cnt   <= burst_beat_cnt;
                        cur_burst_last <= burst_last;
                        state          <= ST_AW;
                    end
                end

                ST_AW: begin
                    if (aw_fire) begin
                        beat_cnt <= 9'd0;
                        state    <= ST_W;
                    end
                end

                ST_W: begin
                    if (w_fire) begin
                        if (last_beat) begin
                            state <= ST_B;
                        end else begin
                            beat_cnt <= beat_cnt + 9'd1;
                        end
                    end
                end

                ST_B: begin
                    if (b_fire) begin
                        if (m_axi_bresp_i != 2'b00) begin
                            err_axi_o <= 1'b1;
                        end

                        if (cur_burst_last) begin
                            done_o <= 1'b1;
                        end
                        state <= ST_IDLE;
                    end
                end

                default: begin
                    state <= ST_IDLE;
                end
            endcase
        end
    end

endmodule
