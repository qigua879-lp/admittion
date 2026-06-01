`timescale 1ns/1ps

module tb_mipi_csi2_capture_top #(
    parameter int         LANE_NUM     = 2,
    parameter int         DESKEW_DEPTH = 16,
    parameter logic [5:0] DATA_TYPE    = csi2_reference_helpers_pkg::CSI2_DT_RAW8,
    parameter logic [1:0] VC_ID        = 2'd0
);

    localparam int         PIXEL_COUNT = csi2_reference_helpers_pkg::csi2_expected_pixel_count(DATA_TYPE);

    logic clk_sys;
    logic rst_n;
    logic start;

    logic sensor_done;
    logic sensor_done_seen;

    logic                     sp_valid;
    logic                     sp_ready;
    logic [31:0]              sp_header;
    logic [LANE_NUM-1:0]      sensor_lane_valid;
    logic [LANE_NUM-1:0]      sensor_lane_ready;
    logic [LANE_NUM-1:0][7:0] sensor_lane_data;
    logic                     exp_valid;
    logic                     exp_ready;
    logic [23:0]              exp_pixel_data;
    logic                     exp_pixel_sof;
    logic                     exp_pixel_sol;

    logic        short_pkt_valid;
    logic        short_pkt_ready;
    logic [1:0]  short_vc;
    logic [5:0]  short_dt;
    logic [15:0] short_word_count;
    logic        short_ecc_ok;
    logic        short_ecc_correctable;
    logic [5:0]  short_ecc_syndrome;

    logic        frame_active;
    logic        line_active;
    logic        frame_start;
    logic        frame_end;
    logic        line_start;
    logic        line_end;
    logic [31:0] frame_cnt;
    logic [31:0] line_cnt;
    logic [1:0]  active_vc;
    logic        sync_error;
    logic        sync_error_seen;

    logic                     deskew_valid;
    logic                     deskew_ready;
    logic [LANE_NUM-1:0][7:0] deskew_data;
    logic                     deskew_overflow;
    logic                     deskew_overflow_seen;

    logic       byte_valid;
    logic       byte_ready;
    logic [7:0] byte_data;
    logic       merge_group_done;

    logic        long_hdr_valid;
    logic        long_hdr_ready;
    logic [1:0]  long_vc;
    logic [5:0]  long_dt;
    logic [15:0] long_word_count;
    logic        long_ecc_ok;
    logic        long_ecc_correctable;
    logic [5:0]  long_ecc_syndrome;
    logic        payload_valid;
    logic        payload_ready;
    logic [7:0]  payload_data;
    logic        payload_start;
    logic        payload_end;
    logic        expected_crc_valid_unused;
    logic [15:0] expected_crc_unused;
    logic        long_parser_busy;
    logic        long_packet_done;
    logic        long_packet_done_seen;
    logic        long_ecc_error_seen;

    logic pending_sof;
    logic pending_sol;
    logic payload_fire;

    logic        pixel_valid;
    logic        pixel_ready;
    logic [23:0] pixel_data;
    logic        pixel_sof;
    logic        pixel_sol;

    logic        finish_scoreboard;
    logic        pass;
    logic        fail;
    logic [31:0] sb_frame_cnt;
    logic [31:0] exp_pixel_cnt;
    logic [31:0] act_pixel_cnt;
    logic [31:0] mismatch_cnt;

    initial begin
        clk_sys = 1'b0;
        forever #5 clk_sys = ~clk_sys;
    end

    sensor_model #(
        .LANE_NUM(LANE_NUM),
        .DATA_TYPE(DATA_TYPE),
        .VC_ID(VC_ID)
    ) u_sensor_model (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .start_i(start),
        .inject_header_ecc_error_i(1'b0),
        .inject_payload_error_i(1'b0),
        .sp_valid_o(sp_valid),
        .sp_ready_i(sp_ready),
        .sp_header_o(sp_header),
        .lane_valid_o(sensor_lane_valid),
        .lane_ready_i(sensor_lane_ready),
        .lane_data_o(sensor_lane_data),
        .exp_valid_o(exp_valid),
        .exp_ready_i(exp_ready),
        .exp_pixel_data_o(exp_pixel_data),
        .exp_pixel_sof_o(exp_pixel_sof),
        .exp_pixel_sol_o(exp_pixel_sol),
        .done_o(sensor_done)
    );

    csi2_short_packet_parser u_short_packet_parser (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .sp_valid(sp_valid),
        .sp_ready(sp_ready),
        .sp_header(sp_header),
        .pkt_valid(short_pkt_valid),
        .pkt_ready(short_pkt_ready),
        .vc(short_vc),
        .dt(short_dt),
        .word_count(short_word_count),
        .ecc_ok(short_ecc_ok),
        .ecc_correctable(short_ecc_correctable),
        .ecc_syndrome(short_ecc_syndrome)
    );

    frame_line_sync_fsm u_frame_line_sync_fsm (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .event_valid(short_pkt_valid),
        .event_ready(short_pkt_ready),
        .event_dt(short_dt),
        .event_vc(short_vc),
        .frame_active(frame_active),
        .line_active(line_active),
        .frame_start(frame_start),
        .frame_end(frame_end),
        .line_start(line_start),
        .line_end(line_end),
        .frame_cnt(frame_cnt),
        .line_cnt(line_cnt),
        .active_vc(active_vc),
        .sync_error(sync_error)
    );

    lane_deskew_buffer #(
        .LANE_NUM(LANE_NUM),
        .DESKEW_DEPTH(DESKEW_DEPTH)
    ) u_lane_deskew_buffer (
        .clk_byte(clk_sys),
        .rst_n(rst_n),
        .clear_i(1'b0),
        .lane_valid_i(sensor_lane_valid),
        .lane_ready_o(sensor_lane_ready),
        .lane_data_i(sensor_lane_data),
        .deskew_valid_o(deskew_valid),
        .deskew_ready_i(deskew_ready),
        .deskew_data_o(deskew_data),
        .err_overflow_o(deskew_overflow)
    );

    lane_reorder_merge #(
        .LANE_NUM(LANE_NUM)
    ) u_lane_reorder_merge (
        .clk_byte(clk_sys),
        .rst_n(rst_n),
        .clear_i(1'b0),
        .lane_group_valid_i(deskew_valid),
        .lane_group_ready_o(deskew_ready),
        .lane_group_data_i(deskew_data),
        .byte_valid_o(byte_valid),
        .byte_ready_i(byte_ready),
        .byte_data_o(byte_data),
        .group_done_o(merge_group_done)
    );

    csi2_long_packet_parser u_long_packet_parser (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .byte_valid(byte_valid),
        .byte_ready(byte_ready),
        .byte_data(byte_data),
        .hdr_valid(long_hdr_valid),
        .hdr_ready(long_hdr_ready),
        .vc(long_vc),
        .dt(long_dt),
        .word_count(long_word_count),
        .ecc_ok(long_ecc_ok),
        .ecc_correctable(long_ecc_correctable),
        .ecc_syndrome(long_ecc_syndrome),
        .payload_valid(payload_valid),
        .payload_ready(payload_ready),
        .payload_data(payload_data),
        .payload_start(payload_start),
        .payload_end(payload_end),
        .expected_crc_valid(expected_crc_valid_unused),
        .expected_crc_ready(1'b1),
        .expected_crc(expected_crc_unused),
        .parser_busy(long_parser_busy),
        .packet_done(long_packet_done)
    );

    assign long_hdr_ready = 1'b1;
    assign payload_fire   = payload_valid && payload_ready;

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            pending_sof <= 1'b0;
            pending_sol <= 1'b0;
        end else begin
            if (frame_start) begin
                pending_sof <= 1'b1;
            end
            if (line_start) begin
                pending_sol <= 1'b1;
            end
            if (payload_fire && payload_start) begin
                pending_sof <= 1'b0;
                pending_sol <= 1'b0;
            end
        end
    end

    generate
        if (DATA_TYPE == csi2_reference_helpers_pkg::CSI2_DT_RGB888) begin : gen_rgb888_path
            rgb888_unpack u_rgb888_unpack (
                .clk_sys(clk_sys),
                .rst_n(rst_n),
                .payload_valid_i(payload_valid),
                .payload_ready_o(payload_ready),
                .payload_data_i(payload_data),
                .payload_sof_i(payload_start && pending_sof),
                .payload_sol_i(payload_start && pending_sol),
                .pixel_valid_o(pixel_valid),
                .pixel_ready_i(pixel_ready),
                .pixel_data_o(pixel_data),
                .pixel_sof_o(pixel_sof),
                .pixel_sol_o(pixel_sol)
            );
        end else begin : gen_raw8_path
            raw8_unpack u_raw8_unpack (
                .clk_sys(clk_sys),
                .rst_n(rst_n),
                .payload_valid_i(payload_valid),
                .payload_ready_o(payload_ready),
                .payload_data_i(payload_data),
                .payload_sof_i(payload_start && pending_sof),
                .payload_sol_i(payload_start && pending_sol),
                .pixel_valid_o(pixel_valid),
                .pixel_ready_i(pixel_ready),
                .pixel_data_o(pixel_data),
                .pixel_sof_o(pixel_sof),
                .pixel_sol_o(pixel_sol)
            );
        end
    endgenerate

    scoreboard #(
        .MAX_PIXELS(64)
    ) u_scoreboard (
        .clk_sys(clk_sys),
        .rst_n(rst_n),
        .clear_i(1'b0),
        .exp_valid_i(exp_valid),
        .exp_ready_o(exp_ready),
        .exp_data_i(exp_pixel_data),
        .exp_sof_i(exp_pixel_sof),
        .exp_sol_i(exp_pixel_sol),
        .act_valid_i(pixel_valid),
        .act_ready_o(pixel_ready),
        .act_data_i(pixel_data),
        .act_sof_i(pixel_sof),
        .act_sol_i(pixel_sol),
        .finish_i(finish_scoreboard),
        .pass_o(pass),
        .fail_o(fail),
        .frame_cnt_o(sb_frame_cnt),
        .exp_pixel_cnt_o(exp_pixel_cnt),
        .act_pixel_cnt_o(act_pixel_cnt),
        .mismatch_cnt_o(mismatch_cnt)
    );

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            sensor_done_seen      <= 1'b0;
            long_packet_done_seen <= 1'b0;
            sync_error_seen       <= 1'b0;
            deskew_overflow_seen  <= 1'b0;
            long_ecc_error_seen   <= 1'b0;
        end else begin
            if (sensor_done) begin
                sensor_done_seen <= 1'b1;
            end
            if (long_packet_done) begin
                long_packet_done_seen <= 1'b1;
            end
            if (sync_error) begin
                sync_error_seen <= 1'b1;
            end
            if (deskew_overflow) begin
                deskew_overflow_seen <= 1'b1;
            end
            if (long_hdr_valid && long_hdr_ready && !long_ecc_ok) begin
                long_ecc_error_seen <= 1'b1;
            end
        end
    end

    initial begin
        rst_n             = 1'b0;
        start             = 1'b0;
        finish_scoreboard = 1'b0;

        repeat (5) @(posedge clk_sys);
        @(negedge clk_sys);
        rst_n = 1'b1;
        repeat (3) @(posedge clk_sys);

        @(negedge clk_sys);
        start = 1'b1;
        @(negedge clk_sys);
        start = 1'b0;

        fork
            begin : timeout_block
                repeat (1000) @(posedge clk_sys);
                $display("FAIL: system tb timeout sensor_done=%0b packet_done=%0b exp=%0d act=%0d mismatch=%0d sync=%0b overflow=%0b",
                         sensor_done_seen, long_packet_done_seen, exp_pixel_cnt, act_pixel_cnt,
                         mismatch_cnt, sync_error_seen, deskew_overflow_seen);
                $fatal(1);
            end

            begin : main_check_block
                wait (sensor_done_seen);
                wait (long_packet_done_seen);
                wait ((exp_pixel_cnt == PIXEL_COUNT) && (act_pixel_cnt == PIXEL_COUNT));
                repeat (4) @(posedge clk_sys);

                @(negedge clk_sys);
                finish_scoreboard = 1'b1;
                @(negedge clk_sys);
                finish_scoreboard = 1'b0;
                @(posedge clk_sys);

                if (!pass || fail) begin
                    $display("FAIL: scoreboard pass=%0b fail=%0b exp=%0d act=%0d mismatch=%0d frames=%0d",
                             pass, fail, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt, sb_frame_cnt);
                    $fatal(1);
                end

                if (sync_error_seen || deskew_overflow_seen || long_ecc_error_seen) begin
                    $display("FAIL: error flags sync=%0b overflow=%0b long_ecc=%0b",
                             sync_error_seen, deskew_overflow_seen, long_ecc_error_seen);
                    $fatal(1);
                end

                if ((frame_cnt != 32'd1) || (line_cnt != 32'd1) || frame_active || line_active) begin
                    $display("FAIL: sync counters frame_cnt=%0d line_cnt=%0d frame_active=%0b line_active=%0b",
                             frame_cnt, line_cnt, frame_active, line_active);
                    $fatal(1);
                end

                if ((long_dt != DATA_TYPE) || (long_vc != VC_ID)) begin
                    $display("FAIL: long header dt=%02h vc=%0d", long_dt, long_vc);
                    $fatal(1);
                end

                $display("PASS: tb_mipi_csi2_capture_top lanes=%0d dt=%02h exp=%0d act=%0d frames=%0d",
                         LANE_NUM, DATA_TYPE, exp_pixel_cnt, act_pixel_cnt, sb_frame_cnt);
            end
        join_any

        disable timeout_block;
        disable main_check_block;
        $finish;
    end

endmodule
