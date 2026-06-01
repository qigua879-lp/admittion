`timescale 1ns/1ps

module tb_fpga_wrapper_raw10_metrics;

    localparam int LANE_NUM = 2;
    localparam logic [5:0] DATA_TYPE = 6'h2b;
    localparam logic [1:0] VC_ID = 2'd0;
    localparam int PIXEL_COUNT = 4;

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

    integer sys_cycle_cnt;
    integer init_done_cycle;
    integer frame_start_cycle;
    integer frame_end_cycle;
    integer first_pixel_cycle;
    integer last_pixel_cycle;
    integer pixel_valid_cycles;

    logic init_done_seen;
    logic frame_start_seen;
    logic frame_end_seen;
    logic first_pixel_seen;
    int unsigned tx_lane_phase;

    function automatic logic [7:0] raw10_payload_byte(input int unsigned idx);
        begin
            case (idx)
                0: raw10_payload_byte = 8'h12;
                1: raw10_payload_byte = 8'h23;
                2: raw10_payload_byte = 8'h34;
                3: raw10_payload_byte = 8'h45;
                4: raw10_payload_byte = 8'he4;
                default: raw10_payload_byte = 8'h00;
            endcase
        end
    endfunction

    function automatic logic [23:0] raw10_expected_pixel(input int unsigned idx);
        begin
            case (idx)
                0: raw10_expected_pixel = 24'h000048;
                1: raw10_expected_pixel = 24'h00008d;
                2: raw10_expected_pixel = 24'h0000d2;
                3: raw10_expected_pixel = 24'h000117;
                default: raw10_expected_pixel = 24'h000000;
            endcase
        end
    endfunction

    function automatic logic [15:0] raw10_payload_crc;
        logic [15:0] crc;
        int unsigned idx;
        begin
            crc = 16'hffff;
            for (idx = 0; idx < 5; idx = idx + 1) begin
                crc = csi2_reference_helpers_pkg::csi2_crc16_next_byte(crc, raw10_payload_byte(idx));
            end
            raw10_payload_crc = crc;
        end
    endfunction

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

    task automatic push_serial_byte(input logic [7:0] byte0);
        int wait_cycles;
        begin
            wait_cycles = 0;
            while (!sensor_lane_ready[tx_lane_phase]) begin
                wait_cycles = wait_cycles + 1;
                if (wait_cycles > 256) begin
                    $display("FAIL: raw10 metrics lane ready timeout phase=%0d ready0=%0b ready1=%0b byte0=0x%02h",
                             tx_lane_phase, sensor_lane_ready[0], sensor_lane_ready[1], byte0);
                    $fatal(1);
                end
                @(posedge clk_byte);
            end

            @(negedge clk_byte);
            sensor_lane_valid[0] = (tx_lane_phase == 0);
            sensor_lane_valid[1] = (tx_lane_phase == 1);
            sensor_lane_data[0]  = (tx_lane_phase == 0) ? byte0 : 8'h00;
            sensor_lane_data[1]  = (tx_lane_phase == 1) ? byte0 : 8'h00;

            @(posedge clk_byte);
            @(negedge clk_byte);
            clear_lane_drive();
            tx_lane_phase = tx_lane_phase ^ 1'b1;
        end
    endtask

    task automatic send_short_packet(input logic [5:0] dt);
        logic [31:0] header;
        begin
            header = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, dt, 16'd0, 1'b0);
            push_serial_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 0));
            push_serial_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 1));
            push_serial_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 2));
            push_serial_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 3));
        end
    endtask

    task automatic send_long_packet;
        logic [31:0] header;
        logic [15:0] payload_crc;
        begin
            header      = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, DATA_TYPE, 16'd5, 1'b0);
            payload_crc = raw10_payload_crc();
            push_serial_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 0));
            push_serial_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 1));
            push_serial_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 2));
            push_serial_byte(csi2_reference_helpers_pkg::csi2_packet_byte(header, 3));
            push_serial_byte(raw10_payload_byte(0));
            push_serial_byte(raw10_payload_byte(1));
            push_serial_byte(raw10_payload_byte(2));
            push_serial_byte(raw10_payload_byte(3));
            push_serial_byte(raw10_payload_byte(4));
            push_serial_byte(payload_crc[7:0]);
            push_serial_byte(payload_crc[15:8]);
        end
    endtask

    task automatic feed_expected_pixels;
        int idx;
        begin
            for (idx = 0; idx < PIXEL_COUNT; idx = idx + 1) begin
                @(negedge clk_sys);
                exp_valid      = 1'b1;
                exp_pixel_data = raw10_expected_pixel(idx);
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

    task automatic drive_raw10_frame;
        begin
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
            send_long_packet();
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LE);
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);
            push_serial_byte(8'h00);
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
            sys_cycle_cnt      <= 0;
            init_done_cycle    <= -1;
            frame_start_cycle  <= -1;
            frame_end_cycle    <= -1;
            first_pixel_cycle  <= -1;
            last_pixel_cycle   <= -1;
            pixel_valid_cycles <= 0;
            init_done_seen     <= 1'b0;
            frame_start_seen   <= 1'b0;
            frame_end_seen     <= 1'b0;
            first_pixel_seen   <= 1'b0;
        end else begin
            sys_cycle_cnt <= sys_cycle_cnt + 1;

            if (cfg_init_done_o && !init_done_seen) begin
                init_done_seen  <= 1'b1;
                init_done_cycle <= sys_cycle_cnt;
            end
            if (frame_start_o && !frame_start_seen) begin
                frame_start_seen  <= 1'b1;
                frame_start_cycle <= sys_cycle_cnt;
            end
            if (frame_end_o && !frame_end_seen) begin
                frame_end_seen  <= 1'b1;
                frame_end_cycle <= sys_cycle_cnt;
            end
            if (pixel_valid_o) begin
                pixel_valid_cycles <= pixel_valid_cycles + 1;
                last_pixel_cycle   <= sys_cycle_cnt;
                if (!first_pixel_seen) begin
                    first_pixel_seen  <= 1'b1;
                    first_pixel_cycle <= sys_cycle_cnt;
                end
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
        tx_lane_phase     = 0;
        clear_lane_drive();

        repeat (6) @(posedge clk_sys);
        rst_n = 1'b1;

        fork
            begin : cfg_timeout_block
                repeat (80) @(posedge clk_sys);
                if (!cfg_init_done_o) begin
                    $display("FAIL: raw10 metrics boot timeout cfg_done=%0b", cfg_init_done_o);
                    $fatal(1);
                end
            end

            begin : cfg_wait_block
                wait (cfg_init_done_o);
            end
        join_any

        disable cfg_timeout_block;
        disable cfg_wait_block;

        force dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_dt_code_o = 8'h2b;
        repeat (4) @(posedge clk_byte);

        fork
            feed_expected_pixels();
            drive_raw10_frame();
        join

        fork
            begin : timeout_block
                repeat (6000) @(posedge clk_sys);
                $display("FAIL: raw10 metrics timeout init=%0b frame=%0b first_pixel=%0b frame_end=%0b exp=%0d act=%0d mismatch=%0d",
                         init_done_seen, frame_start_seen, first_pixel_seen, frame_end_seen,
                         exp_pixel_cnt, act_pixel_cnt, mismatch_cnt);
                $fatal(1);
            end

            begin : main_check_block
                wait (act_pixel_cnt == PIXEL_COUNT);
                wait (frame_end_seen);
                repeat (16) @(posedge clk_sys);

                @(negedge clk_sys);
                finish_scoreboard = 1'b1;
                @(negedge clk_sys);
                finish_scoreboard = 1'b0;
                @(posedge clk_sys);

                if (!pass || fail) begin
                    $display("FAIL: raw10 metrics scoreboard pass=%0b fail=%0b exp=%0d act=%0d mismatch=%0d",
                             pass, fail, exp_pixel_cnt, act_pixel_cnt, mismatch_cnt);
                    $fatal(1);
                end

                if (!init_done_seen || !frame_start_seen || !first_pixel_seen || !frame_end_seen) begin
                    $display("FAIL: raw10 metrics missing markers init=%0b frame=%0b first_pixel=%0b frame_end=%0b",
                             init_done_seen, frame_start_seen, first_pixel_seen, frame_end_seen);
                    $fatal(1);
                end

                if (err_ecc_o || err_crc_o || err_sync_o) begin
                    $display("FAIL: unexpected raw10 protocol errors");
                    $fatal(1);
                end

                $display("PASS: tb_fpga_wrapper_raw10_metrics init_to_frame=%0d frame_to_first_pixel=%0d frame_to_end=%0d first_to_last_pixel=%0d pixel_valid_cycles=%0d exp=%0d act=%0d",
                         frame_start_cycle - init_done_cycle,
                         first_pixel_cycle - frame_start_cycle,
                         frame_end_cycle - frame_start_cycle,
                         last_pixel_cycle - first_pixel_cycle,
                         pixel_valid_cycles,
                         exp_pixel_cnt,
                         act_pixel_cnt);
            end
        join_any

        disable timeout_block;
        disable main_check_block;
        release dut.u_mipi_csi2_capture_top.u_cfg_reg_if_apb.cfg_dt_code_o;
        $finish;
    end

endmodule
