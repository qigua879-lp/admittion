`timescale 1ns/1ps

module rgb888_unpack (
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

    logic [1:0] byte_idx;
    logic [7:0] byte0_reg;
    logic [7:0] byte1_reg;
    logic       sof_reg;
    logic       sol_reg;
    logic       output_stall;

    assign output_stall    = pixel_valid_o && !pixel_ready_i;
    assign payload_ready_o = !output_stall;

    always_ff @(posedge clk_sys) begin
        if (!rst_n || clear_i) begin
            byte_idx      <= 2'd0;
            byte0_reg     <= 8'd0;
            byte1_reg     <= 8'd0;
            sof_reg       <= 1'b0;
            sol_reg       <= 1'b0;
            pixel_valid_o <= 1'b0;
            pixel_data_o  <= 24'd0;
            pixel_sof_o   <= 1'b0;
            pixel_sol_o   <= 1'b0;
        end else begin
            if (pixel_valid_o && pixel_ready_i && !(payload_valid_i && payload_ready_o && byte_idx == 2'd2)) begin
                pixel_valid_o <= 1'b0;
                pixel_sof_o   <= 1'b0;
                pixel_sol_o   <= 1'b0;
            end

            if (payload_valid_i && payload_ready_o) begin
                case (byte_idx)
                    2'd0: begin
                        byte0_reg <= payload_data_i;
                        sof_reg   <= payload_sof_i;
                        sol_reg   <= payload_sol_i;
                        byte_idx  <= 2'd1;
                    end

                    2'd1: begin
                        byte1_reg <= payload_data_i;
                        byte_idx  <= 2'd2;
                    end

                    default: begin
                        pixel_valid_o <= 1'b1;
                        pixel_data_o  <= {byte0_reg, byte1_reg, payload_data_i};
                        pixel_sof_o   <= sof_reg;
                        pixel_sol_o   <= sol_reg;
                        byte_idx      <= 2'd0;
                    end
                endcase
            end
        end
    end

endmodule
