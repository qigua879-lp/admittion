`timescale 1ns/1ps

module yuv422_unpack (
    input  logic        clk_sys,
    input  logic        rst_n,
    input  logic        clear_i,

    input  logic        payload_valid_i,
    output logic        payload_ready_o,
    input  logic [7:0]  payload_data_i,
    input  logic        payload_sof_i,
    input  logic        payload_sol_i,

    output logic        pixel_valid_o,
    input  logic        pixel_ready_i,
    output logic [23:0] pixel_data_o,
    output logic        pixel_sof_o,
    output logic        pixel_sol_o
);

    localparam logic STATE_COLLECT = 1'b0;
    localparam logic STATE_OUTPUT  = 1'b1;

    logic       state;
    logic [1:0] byte_idx;
    logic       out_idx;
    logic [7:0] u_reg;
    logic [7:0] y0_reg;
    logic [7:0] v_reg;
    logic [7:0] y1_reg;
    logic       sof_reg;
    logic       sol_reg;

    assign payload_ready_o = (state == STATE_COLLECT);

    always_ff @(posedge clk_sys) begin
        if (!rst_n || clear_i) begin
            state         <= STATE_COLLECT;
            byte_idx      <= 2'd0;
            out_idx       <= 1'b0;
            u_reg         <= 8'd0;
            y0_reg        <= 8'd0;
            v_reg         <= 8'd0;
            y1_reg        <= 8'd0;
            sof_reg       <= 1'b0;
            sol_reg       <= 1'b0;
            pixel_valid_o <= 1'b0;
            pixel_data_o  <= 24'd0;
            pixel_sof_o   <= 1'b0;
            pixel_sol_o   <= 1'b0;
        end else begin
            case (state)
                STATE_COLLECT: begin
                    if (payload_valid_i && payload_ready_o) begin
                        case (byte_idx)
                            2'd0: begin
                                u_reg    <= payload_data_i;
                                sof_reg  <= payload_sof_i;
                                sol_reg  <= payload_sol_i;
                                byte_idx <= 2'd1;
                            end

                            2'd1: begin
                                y0_reg   <= payload_data_i;
                                byte_idx <= 2'd2;
                            end

                            2'd2: begin
                                v_reg    <= payload_data_i;
                                byte_idx <= 2'd3;
                            end

                            default: begin
                                y1_reg        <= payload_data_i;
                                pixel_valid_o <= 1'b1;
                                pixel_data_o  <= {y0_reg, u_reg, v_reg};
                                pixel_sof_o   <= sof_reg;
                                pixel_sol_o   <= sol_reg;
                                out_idx       <= 1'b0;
                                byte_idx      <= 2'd0;
                                state         <= STATE_OUTPUT;
                            end
                        endcase
                    end
                end

                STATE_OUTPUT: begin
                    if (pixel_valid_o && pixel_ready_i) begin
                        if (!out_idx) begin
                            pixel_data_o <= {y1_reg, u_reg, v_reg};
                            pixel_sof_o  <= 1'b0;
                            pixel_sol_o  <= 1'b0;
                            out_idx      <= 1'b1;
                        end else begin
                            pixel_valid_o <= 1'b0;
                            pixel_data_o  <= 24'd0;
                            pixel_sof_o   <= 1'b0;
                            pixel_sol_o   <= 1'b0;
                            out_idx       <= 1'b0;
                            state         <= STATE_COLLECT;
                        end
                    end
                end

                default: begin
                    state <= STATE_COLLECT;
                end
            endcase
        end
    end

endmodule
