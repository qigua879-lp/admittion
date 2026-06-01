`timescale 1ns/1ps

module csi2_payload_crc_checker #(
    parameter logic [15:0] CRC_INIT = 16'hffff
) (
    input  logic        clk_sys,
    input  logic        rst_n,

    input  logic        crc_start,
    input  logic        crc_clear,
    input  logic        crc_finish,

    input  logic        payload_valid,
    output logic        payload_ready,
    input  logic [7:0]  payload_data,
    input  logic        payload_last,

    input  logic        expected_crc_valid,
    output logic        expected_crc_ready,
    input  logic [15:0] expected_crc,

    output logic        crc_valid,
    input  logic        crc_ready,
    output logic [15:0] crc_calc,
    output logic        crc_error
);

    logic        active;
    logic        payload_done;
    logic        expected_seen;
    logic [15:0] crc_reg;
    logic [15:0] expected_crc_reg;

    logic        payload_fire;
    logic        expected_fire;
    logic        finish_fire;
    logic [15:0] crc_next;
    logic [15:0] finish_crc;
    logic [15:0] compare_crc;

    function automatic logic [15:0] crc16_next_byte(
        input logic [15:0] crc_in,
        input logic [7:0]  data_in
    );
        logic [15:0] crc_tmp;
        logic        feedback;
        int          i;
        begin
            crc_tmp = crc_in;
            for (i = 0; i < 8; i = i + 1) begin
                feedback = crc_tmp[0] ^ data_in[i];
                crc_tmp  = {1'b0, crc_tmp[15:1]};
                if (feedback) begin
                    crc_tmp = crc_tmp ^ 16'h8408;
                end
            end
            crc16_next_byte = crc_tmp;
        end
    endfunction

    assign payload_ready     = active && !payload_done && !crc_valid;
    assign expected_crc_ready = !expected_seen && !crc_valid;

    assign payload_fire  = payload_valid && payload_ready;
    assign expected_fire = expected_crc_valid && expected_crc_ready;
    assign finish_fire   = crc_finish || (payload_fire && payload_last);
    assign crc_next      = crc16_next_byte(crc_reg, payload_data);
    assign finish_crc    = (payload_fire && payload_last) ? crc_next : crc_reg;
    assign compare_crc   = expected_fire ? expected_crc : expected_crc_reg;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            active           <= 1'b0;
            payload_done     <= 1'b0;
            expected_seen    <= 1'b0;
            crc_reg          <= CRC_INIT;
            expected_crc_reg <= 16'd0;
            crc_valid        <= 1'b0;
            crc_calc         <= CRC_INIT;
            crc_error        <= 1'b0;
        end else if (crc_clear) begin
            active           <= 1'b0;
            payload_done     <= 1'b0;
            expected_seen    <= 1'b0;
            crc_reg          <= CRC_INIT;
            expected_crc_reg <= 16'd0;
            crc_valid        <= 1'b0;
            crc_calc         <= CRC_INIT;
            crc_error        <= 1'b0;
        end else if (crc_start) begin
            active           <= 1'b1;
            payload_done     <= 1'b0;
            expected_seen    <= 1'b0;
            crc_reg          <= CRC_INIT;
            expected_crc_reg <= 16'd0;
            crc_valid        <= 1'b0;
            crc_calc         <= CRC_INIT;
            crc_error        <= 1'b0;
        end else begin
            if (crc_valid && crc_ready) begin
                crc_valid    <= 1'b0;
                payload_done <= 1'b0;
                expected_seen <= 1'b0;
            end

            if (expected_fire) begin
                expected_crc_reg <= expected_crc;
                expected_seen    <= 1'b1;
            end

            if (payload_fire) begin
                crc_reg <= crc_next;
            end

            if (finish_fire && active) begin
                active       <= 1'b0;
                payload_done <= 1'b1;
                crc_calc     <= finish_crc;
            end

            if (finish_fire && active && (expected_seen || expected_fire)) begin
                crc_valid     <= 1'b1;
                payload_done  <= 1'b0;
                crc_calc      <= finish_crc;
                crc_error     <= (finish_crc != compare_crc);
            end else if (payload_done && expected_fire) begin
                crc_valid     <= 1'b1;
                payload_done  <= 1'b0;
                crc_error     <= (crc_calc != expected_crc);
            end
        end
    end

endmodule
