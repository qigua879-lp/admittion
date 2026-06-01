`timescale 1ns/1ps

module tb_fpga_wrapper_raw8_smoke;

    localparam int LANE_NUM = 2;
    localparam logic [5:0] DATA_TYPE = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID = 2'd0;
    localparam int PIXEL_COUNT = csi2_reference_helpers_pkg::csi2_expected_pixel_count(DATA_TYPE);

    logic clk_sys;
    logic clk_byte;
    logic clk_axi;
    logic clk_ddr;
    logic rst_n;

    logic [31:0] lane_data_0;
    logic [31:0] lane_data_1;
    logic [31:0] lane_data_2;
    logic [31:0] lane_data_3;
    logic        lane_valid_0;
    logic        lane_valid_1;
    logic        lane_valid_2;
    logic        lane_valid_3;
    logic        hs_mode;
    logic        lp_mode;

    logic        frame_start_o;
    logic        frame_end_o;
    logic        line_start_o;
    logic        line_end_o;
    logic        err_ecc_o;
    logic        err_crc_o;
    logic        err_sync_o;
    logic [23:0] pixel_data_o;
    logic        pixel_valid_o;
    logic        pixel_sof_o;
    logic        pixel_sol_o;
    logic        cfg_init_done_o;

    logic                     sensor_done;
    logic [LANE_NUM-1:0]      sensor_lane_valid;
    logic [LANE_NUM-1:0]      sensor_lane_ready;
    logic [LANE_NUM-1:0][7:0] sensor_lane_data;
    logic                     exp_valid;
    logic                     exp_ready;
    logic [23:0]              exp_pixel_data;
    logic                     exp_pixel_sof;
    logic                     exp_pixel_sol;

    logic                     finish_scoreboard;
    logic                     pass;
    logic                     fail;
    logic [31:0]              sb_frame_cnt;
    logic [31:0]              exp_pixel_cnt;
    logic [31:0]              act_pixel_cnt;
    logic [31:0]              mismatch_cnt;

    logic sensor_done_seen;
    logic frame_start_seen;
    logic frame_end_seen;
    logic line_start_seen;
    logic line_end_seen;
    logic pixel_sof_seen;
    logic pixel_sol_seen;

    mipi_csi2_capture_fpga_wrapper #(
        .LANE_NUM(LANE_NUM)
    ) dut (
        .clk_sys(clk_sys),
        .clk_byte(clk_byte),
        .clk_axi(clk_axi),
        .clk_ddr(clk_ddr),
        .rst_n(rst_n),
        .lane_data_0(lane_data_0),
        .lane_data_1(lane_data_1),
        .lane_data_2(lane_data_2),
        .lane_data_3(lane_data_3),
        .lane_valid_0(lane_valid_0),
        .lane_valid_1(lane_valid_1),
        .lane_valid_2(lane_valid_2),
        .lane_valid_3(lane_valid_3),
        .hs_mode(hs_mode),
        .lp_mode(lp_mode),
        .frame_start_o(frame_start_o),
        .frame_end_o(frame_end_o),
        .line_start_o(line_start_o),
        .line_end_o(line_end_o),
        .err_ecc_o(err_ecc_o),
        .err_crc_o(err_crc_o),
        .err_sync_o(err_sync_o),
        .pixel_data_o(pixel_data_o),
        .pixel_valid_o(pixel_valid_o),
        .pixel_sof_o(pixel_sof_o),
        .pixel_sol_o(pixel_sol_o),
        .cfg_init_done_o(cfg_init_done_o)
    );

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
        .act_valid_i(pixel_valid_o),
        .act_ready_o(),
        .act_data_i(pixel_data_o),
        .act_sof_i(pixel_sof_o),
        .act_sol_i(pixel_sol_o),
        .finish_i(finish_scoreboard),
        .pass_o(pass),
        .fail_o(fail),
        .frame_cnt_o(sb_frame_cnt),
        .exp_pixel_cnt_o(exp_pixel_cnt),
        .act_pixel_cnt_o(act_pixel_cnt),
        .mismatch_cnt_o(mismatch_cnt)
    );

    assign sensor_lane_ready = dut.u_mipi_csi2_capture_top.phy_lane_ready[LANE_NUM-1:0];

    task automatic clear_lane_drive;
        begin
            sensor_lane_valid = '0;
            sensor_lane_data  = '0;
        end
    endtask

    task automatic push_lane_group(
        input logic [7:0] byte0,
        input logic [7:0] byte1
    );
        begin
            while (!(sensor_lane_ready[0] && sensor_lane_ready[1])) begin
                @(posedge clk_byte);
            end

            @(negedge clk_byte);
            sensor_lane_valid[0] = 1'b1;
            sensor_lane_valid[1] = 1'b1;
            sensor_lane_data[0]  = byte0;
            sensor_lane_data[1]  = byte1;

            @(posedge clk_byte);
            @(negedge clk_byte);
            clear_lane_drive();
        end
    endtask

    task automatic send_short_packet(input logic [5:0] dt);
        logic [31:0] header;
        begin
            header = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, dt, 16'd0, 1'b0);
            push_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 0),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 1)
            );
            push_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 2),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 3)
            );
        end
    endtask

    task automatic send_long_packet;
        logic [31:0] header;
        logic [15:0] payload_crc;
        begin
            header      = csi2_reference_helpers_pkg::csi2_pack_header(
                VC_ID,
                DATA_TYPE,
                csi2_reference_helpers_pkg::csi2_payload_byte_count(DATA_TYPE),
                1'b0
            );
            payload_crc = csi2_reference_helpers_pkg::csi2_payload_crc(DATA_TYPE);

            push_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 0),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 1)
            );
            push_lane_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 2),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 3)
            );
            push_lane_group(
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 0),
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 1)
            );
            push_lane_group(
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 2),
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 3)
            );
            push_lane_group(payload_crc[7:0], payload_crc[15:8]);
        end
    endtask

    task automatic feed_expected_pixels;
        int idx;
        begin
            for (idx = 0; idx < PIXEL_COUNT; idx = idx + 1) begin
                @(negedge clk_sys);
                exp_valid      = 1'b1;
                exp_pixel_data = csi2_reference_helpers_pkg::csi2_expected_pixel(DATA_TYPE, idx);
                exp_pixel_sof  = (idx == 0);
                exp_pixel_sol  = (idx == 0);
                do begin
                    @(posedge clk_sys);
                end while (!exp_ready);
            end

            @(negedge clk_sys);
            exp_valid      = 1'b0;
            exp_pixel_data = 24'd0;
            exp_pixel_sof  = 1'b0;
            exp_pixel_sol  = 1'b0;
        end
    endtask

    task automatic drive_raw8_frame;
        begin
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
            send_long_packet();
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LE);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);
            sensor_done = 1'b1;
            @(posedge clk_byte);
            sensor_done = 1'b0;
        end
    endtask

    always_comb begin
        lane_data_0  = {24'd0, sensor_lane_data[0]};
        lane_data_1  = {24'd0, sensor_lane_data[1]};
        lane_data_2  = 32'd0;
        lane_data_3  = 32'd0;
        lane_valid_0 = sensor_lane_valid[0];
        lane_valid_1 = sensor_lane_valid[1];
        lane_valid_2 = 1'b0;
        lane_valid_3 = 1'b0;
    end

    initial begin
        clk_sys = 1'b0;
        forever #5 clk_sys = ~clk_sys;
    end

    initial begin
        clk_byte = 1'b0;
        forever #4 clk_byte = ~clk_byte;
    end

    initial begin
        clk_axi = 1'b0;
        forever #5 clk_axi = ~clk_axi;
    end

    initial begin
        clk_ddr = 1'b0;
        forever #5 clk_ddr = ~clk_ddr;
    end

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            sensor_done_seen <= 1'b0;
            frame_start_seen <= 1'b0;
            frame_end_seen   <= 1'b0;
            line_start_seen  <= 1'b0;
            line_end_seen    <= 1'b0;
            pixel_sof_seen   <= 1'b0;
            pixel_sol_seen   <= 1'b0;
        end else begin
            if (sensor_done) begin
                sensor_done_seen <= 1'b1;
            end
            if (frame_start_o) begin
                frame_start_seen <= 1'b1;
            end
            if (frame_end_o) begin
                frame_end_seen <= 1'b1;
            end
            if (line_start_o) begin
                line_start_seen <= 1'b1;
            end
            if (line_end_o) begin
                line_end_seen <= 1'b1;
            end
            if (pixel_sof_o) begin
                pixel_sof_seen <= 1'b1;
            end
            if (pixel_sol_o) begin
                pixel_sol_seen <= 1'b1;
            end
        end
    end

    initial begin
        rst_n             = 1'b0;
        hs_mode           = 1'b1;
        lp_mode           = 1'b0;
        sensor_done       = 1'b0;
        exp_valid         = 1'b0;
        exp_pixel_data    = 24'd0;
        exp_pixel_sof     = 1'b0;
        exp_pixel_sol     = 1'b0;
        finish_scoreboard = 1'b0;
        clear_lane_drive();

        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        wait (cfg_init_done_o);
        repeat (4) @(posedge clk_byte);

        fork
            feed_expected_pixels();
            drive_raw8_frame();
        join

        fork
            begin : timeout_block
                repeat (4000) @(posedge clk_sys);
                $display("FAIL: raw8 smoke timeout cfg_done=%0b sensor_done=%0b frame=%0b/%0b line=%0b/%0b exp=%0d act=%0d mismatch=%0d crc=%0b sync=%0b",
                         cfg_init_done_o, sensor_done_seen, frame_start_seen, frame_end_seen,
                         line_start_seen, line_end_seen, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt,
                         err_crc_o, err_sync_o);
                $fatal(1);
            end

            begin : main_check_block
                wait (sensor_done_seen);
                wait (act_pixel_cnt == PIXEL_COUNT);
                repeat (16) @(posedge clk_sys);

                @(negedge clk_sys);
                finish_scoreboard = 1'b1;
                @(negedge clk_sys);
                finish_scoreboard = 1'b0;
                @(posedge clk_sys);

                if (!pass || fail) begin
                    $display("FAIL: raw8 scoreboard pass=%0b fail=%0b exp=%0d act=%0d mismatch=%0d frames=%0d",
                             pass, fail, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt, sb_frame_cnt);
                    $fatal(1);
                end

                if (!frame_start_seen || !frame_end_seen || !line_start_seen || !line_end_seen) begin
                    $display("FAIL: missing markers fs=%0b fe=%0b ls=%0b le=%0b",
                             frame_start_seen, frame_end_seen, line_start_seen, line_end_seen);
                    $fatal(1);
                end

                if (!pixel_sof_seen || !pixel_sol_seen) begin
                    $display("FAIL: missing pixel markers sof=%0b sol=%0b",
                             pixel_sof_seen, pixel_sol_seen);
                    $fatal(1);
                end

                if (err_ecc_o || err_crc_o || err_sync_o) begin
                    $display("FAIL: unexpected errors ecc=%0b crc=%0b sync=%0b",
                             err_ecc_o, err_crc_o, err_sync_o);
                    $fatal(1);
                end

                $display("PASS: tb_fpga_wrapper_raw8_smoke exp=%0d act=%0d frames=%0d",
                         exp_pixel_cnt, act_pixel_cnt, sb_frame_cnt);
            end
        join_any

        disable timeout_block;
        disable main_check_block;
        $finish;
    end

endmodule
