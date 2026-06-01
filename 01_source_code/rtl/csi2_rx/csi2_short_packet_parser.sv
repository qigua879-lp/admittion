`timescale 1ns/1ps

module csi2_short_packet_parser (
    input  logic        clk_sys,
    input  logic        rst_n,

    input  logic        sp_valid,
    output logic        sp_ready,
    input  logic [31:0] sp_header,

    output logic        pkt_valid,
    input  logic        pkt_ready,
    output logic [1:0]  vc,
    output logic [5:0]  dt,
    output logic [15:0] word_count,
    output logic        ecc_ok,
    output logic        ecc_correctable,
    output logic [5:0]  ecc_syndrome
);

    localparam logic [1:0] ST_IDLE     = 2'd0;
    localparam logic [1:0] ST_ECC_REQ  = 2'd1;
    localparam logic [1:0] ST_WAIT_ECC = 2'd2;
    localparam logic [1:0] ST_HOLD     = 2'd3;

    logic [1:0]  state;
    logic [31:0] header_reg;

    logic        ecc_hdr_valid;
    logic        ecc_hdr_ready;
    logic        ecc_valid;
    logic        ecc_ready;
    logic [5:0]  ecc_calc_unused;
    logic        ecc_error;

    csi2_header_ecc_checker u_header_ecc_checker (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .hdr_valid(ecc_hdr_valid),
        .hdr_ready(ecc_hdr_ready),
        .hdr_data(header_reg[23:0]),
        .hdr_ecc(header_reg[29:24]),
        .ecc_valid(ecc_valid),
        .ecc_ready(ecc_ready),
        .ecc_calc(ecc_calc_unused),
        .ecc_syndrome(ecc_syndrome),
        .ecc_error(ecc_error),
        .ecc_correctable(ecc_correctable)
    );

    assign sp_ready      = (state == ST_IDLE);
    assign ecc_hdr_valid = (state == ST_ECC_REQ);
    assign ecc_ready     = (state == ST_WAIT_ECC);

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            state       <= ST_IDLE;
            header_reg  <= 32'd0;
            pkt_valid   <= 1'b0;
            vc          <= 2'd0;
            dt          <= 6'd0;
            word_count  <= 16'd0;
            ecc_ok      <= 1'b0;
        end else begin
            case (state)
                ST_IDLE: begin
                    pkt_valid <= 1'b0;
                    if (sp_valid && sp_ready) begin
                        header_reg <= sp_header;
                        state      <= ST_ECC_REQ;
                    end
                end

                ST_ECC_REQ: begin
                    if (ecc_hdr_ready) begin
                        state <= ST_WAIT_ECC;
                    end
                end

                ST_WAIT_ECC: begin
                    if (ecc_valid) begin
                        vc         <= header_reg[7:6];
                        dt         <= header_reg[5:0];
                        word_count <= header_reg[23:8];
                        ecc_ok     <= !ecc_error;
                        pkt_valid  <= 1'b1;
                        state      <= ST_HOLD;
                    end
                end

                ST_HOLD: begin
                    if (pkt_ready) begin
                        pkt_valid <= 1'b0;
                        state     <= ST_IDLE;
                    end
                end

                default: begin
                    state     <= ST_IDLE;
                    pkt_valid <= 1'b0;
                end
            endcase
        end
    end

endmodule
