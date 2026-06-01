`timescale 1ns/1ps

module tb_fpga_wrapper_lane_skew_scan;

    parameter int LANE_NUM             = 2;
    parameter int DESKEW_DEPTH         = 4;
    parameter int BYTE_FIFO_ADDR_WIDTH = 4;
    parameter int AXI_FIFO_ADDR_WIDTH  = 6;
    localparam int MAX_LEAD_BYTES       = DESKEW_DEPTH + 1;
    localparam logic [5:0] DATA_TYPE    = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID        = 2'd0;
    localparam int PIXEL_COUNT          = csi2_reference_helpers_pkg::csi2_expected_pixel_count(DATA_TYPE);
    localparam int STREAM_GROUPS        = 13;

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

    logic [7:0] lane0_stream [0:STREAM_GROUPS-1];
    logic [7:0] lane1_stream [0:STREAM_GROUPS-1];

    logic case_active;
    logic sensor_done_seen;
    logic frame_start_seen;
    logic frame_end_seen;
    logic line_start_seen;
    logic line_end_seen;
    logic pixel_sof_seen;
    logic pixel_sol_seen;
    logic overflow_seen;
    logic lane0_backpressure_seen;
    logic err_ecc_seen;
    logic err_crc_seen;
    logic err_sync_seen;
    int   act_pixel_cnt;
    int   mismatch_cnt;

    logic [0:MAX_LEAD_BYTES] result_pass;
    logic [0:MAX_LEAD_BYTES] result_overflow;
    logic [0:MAX_LEAD_BYTES] result_backpressure;
    int   result_pixels [0:MAX_LEAD_BYTES];
    int   result_mismatch [0:MAX_LEAD_BYTES];

    integer group_write_idx;

    mipi_csi2_capture_fpga_wrapper #(
        .LANE_NUM(LANE_NUM),
        .DESKEW_DEPTH(DESKEW_DEPTH),
        .BYTE_FIFO_ADDR_WIDTH(BYTE_FIFO_ADDR_WIDTH),
        .AXI_FIFO_ADDR_WIDTH(AXI_FIFO_ADDR_WIDTH)
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

    assign sensor_lane_ready = dut.u_mipi_csi2_capture_top.phy_lane_ready[LANE_NUM-1:0];

    task automatic fail(input string msg);
        begin
            $display("FAIL: %s", msg);
            $fatal(1);
        end
    endtask

    task automatic clear_lane_drive;
        begin
            sensor_lane_valid = '0;
            sensor_lane_data  = '0;
        end
    endtask

    task automatic append_group(
        input logic [7:0] byte0,
        input logic [7:0] byte1
    );
        begin
            if (group_write_idx >= STREAM_GROUPS) begin
                fail("stream group overflow while building lane scan stimulus");
            end
            lane0_stream[group_write_idx] = byte0;
            lane1_stream[group_write_idx] = byte1;
            group_write_idx = group_write_idx + 1;
        end
    endtask

    task automatic append_short_packet_to_stream(input logic [5:0] dt);
        logic [31:0] header;
        begin
            header = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, dt, 16'd0, 1'b0);
            append_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 0),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 1)
            );
            append_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 2),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 3)
            );
        end
    endtask

    task automatic append_long_packet_to_stream;
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

            append_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 0),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 1)
            );
            append_group(
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 2),
                csi2_reference_helpers_pkg::csi2_packet_byte(header, 3)
            );
            append_group(
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 0),
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 1)
            );
            append_group(
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 2),
                csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE, 3)
            );
            append_group(payload_crc[7:0], payload_crc[15:8]);
        end
    endtask

    task automatic build_frame_streams;
        begin
            group_write_idx = 0;
            append_short_packet_to_stream(csi2_reference_helpers_pkg::CSI2_DT_FS);
            append_short_packet_to_stream(csi2_reference_helpers_pkg::CSI2_DT_LS);
            append_long_packet_to_stream();
            append_short_packet_to_stream(csi2_reference_helpers_pkg::CSI2_DT_LE);
            append_short_packet_to_stream(csi2_reference_helpers_pkg::CSI2_DT_FE);

            if (group_write_idx != STREAM_GROUPS) begin
                fail("unexpected stream group count for lane skew scan");
            end
        end
    endtask

    task automatic drive_lane_group(
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

    task automatic drive_lane0_byte_force(input logic [7:0] byte0);
        begin
            @(negedge clk_byte);
            sensor_lane_valid[0] = 1'b1;
            sensor_lane_valid[1] = 1'b0;
            sensor_lane_data[0]  = byte0;
            sensor_lane_data[1]  = 8'h00;

            @(posedge clk_byte);
            @(negedge clk_byte);
            clear_lane_drive();
        end
    endtask

    task automatic drive_lane1_byte(input logic [7:0] byte1);
        begin
            while (!sensor_lane_ready[1]) begin
                @(posedge clk_byte);
            end

            @(negedge clk_byte);
            sensor_lane_valid[0] = 1'b0;
            sensor_lane_valid[1] = 1'b1;
            sensor_lane_data[0]  = 8'h00;
            sensor_lane_data[1]  = byte1;

            @(posedge clk_byte);
            @(negedge clk_byte);
            clear_lane_drive();
        end
    endtask

    task automatic pulse_sensor_done;
        begin
            sensor_done = 1'b1;
            @(posedge clk_byte);
            sensor_done = 1'b0;
        end
    endtask

    task automatic drive_frame_with_lead(input int lead_bytes);
        int idx;
        begin
            if (lead_bytes == 0) begin
                for (idx = 0; idx < STREAM_GROUPS; idx = idx + 1) begin
                    drive_lane_group(lane0_stream[idx], lane1_stream[idx]);
                end
                pulse_sensor_done();
            end else begin
                for (idx = 0; (idx < lead_bytes) && !overflow_seen; idx = idx + 1) begin
                    drive_lane0_byte_force(lane0_stream[idx]);
                end

                for (idx = 0; (idx < STREAM_GROUPS) && !overflow_seen; idx = idx + 1) begin
                    drive_lane1_byte(lane1_stream[idx]);
                    if (((idx + lead_bytes) < STREAM_GROUPS) && !overflow_seen) begin
                        drive_lane0_byte_force(lane0_stream[idx + lead_bytes]);
                    end
                end

                if (!overflow_seen) begin
                    pulse_sensor_done();
                end
            end
        end
    endtask

    task automatic apply_case_reset;
        begin
            rst_n        = 1'b0;
            case_active  = 1'b0;
            sensor_done  = 1'b0;
            clear_lane_drive();
            repeat (6) @(posedge clk_sys);
            rst_n = 1'b1;
            wait (cfg_init_done_o);
            repeat (4) @(posedge clk_byte);
            case_active = 1'b1;
        end
    endtask

    task automatic run_case(input int lead_bytes);
        int wait_cycles;
        begin
            apply_case_reset();
            drive_frame_with_lead(lead_bytes);

            if (lead_bytes <= DESKEW_DEPTH) begin
                wait_cycles = 0;
                while (!(frame_end_seen && (act_pixel_cnt == PIXEL_COUNT)) && (wait_cycles < 5000)) begin
                    @(posedge clk_sys);
                    wait_cycles = wait_cycles + 1;
                end
                if (!(frame_end_seen && (act_pixel_cnt == PIXEL_COUNT))) begin
                    $display("FAIL: lane skew scan timeout lead=%0d fs=%0b fe=%0b ls=%0b le=%0b pixels=%0d mismatch=%0d overflow=%0b ready_low=%0b",
                             lead_bytes, frame_start_seen, frame_end_seen, line_start_seen, line_end_seen,
                             act_pixel_cnt, mismatch_cnt, overflow_seen, lane0_backpressure_seen);
                    $fatal(1);
                end

                repeat (16) @(posedge clk_sys);

                if (overflow_seen) begin
                    $display("FAIL: unexpected overflow in tolerant lead=%0d", lead_bytes);
                    $fatal(1);
                end
                if (mismatch_cnt != 0 || act_pixel_cnt != PIXEL_COUNT) begin
                    $display("FAIL: tolerant lead=%0d pixel mismatch act=%0d mismatch=%0d",
                             lead_bytes, act_pixel_cnt, mismatch_cnt);
                    $fatal(1);
                end
                if (!frame_start_seen || !frame_end_seen || !line_start_seen || !line_end_seen) begin
                    $display("FAIL: tolerant lead=%0d missing markers fs=%0b fe=%0b ls=%0b le=%0b",
                             lead_bytes, frame_start_seen, frame_end_seen, line_start_seen, line_end_seen);
                    $fatal(1);
                end
                if (!pixel_sof_seen || !pixel_sol_seen) begin
                    $display("FAIL: tolerant lead=%0d missing pixel markers sof=%0b sol=%0b",
                             lead_bytes, pixel_sof_seen, pixel_sol_seen);
                    $fatal(1);
                end
                if (err_ecc_seen || err_crc_seen || err_sync_seen) begin
                    $display("FAIL: tolerant lead=%0d unexpected protocol errors ecc=%0b crc=%0b sync=%0b",
                             lead_bytes, err_ecc_seen, err_crc_seen, err_sync_seen);
                    $fatal(1);
                end
            end else begin
                wait_cycles = 0;
                while (!overflow_seen && (wait_cycles < 5000)) begin
                    @(posedge clk_sys);
                    wait_cycles = wait_cycles + 1;
                end
                if (!overflow_seen) begin
                    $display("FAIL: lane skew scan timeout lead=%0d fs=%0b fe=%0b ls=%0b le=%0b pixels=%0d mismatch=%0d overflow=%0b ready_low=%0b",
                             lead_bytes, frame_start_seen, frame_end_seen, line_start_seen, line_end_seen,
                             act_pixel_cnt, mismatch_cnt, overflow_seen, lane0_backpressure_seen);
                    $fatal(1);
                end

                repeat (4) @(posedge clk_byte);

                if (!lane0_backpressure_seen) begin
                    $display("FAIL: overflow lead=%0d did not observe lane0 backpressure", lead_bytes);
                    $fatal(1);
                end
                if (err_ecc_seen || err_crc_seen) begin
                    $display("FAIL: overflow lead=%0d unexpected protocol checker errors ecc=%0b crc=%0b",
                             lead_bytes, err_ecc_seen, err_crc_seen);
                    $fatal(1);
                end
            end

            result_pass[lead_bytes]         = (lead_bytes <= DESKEW_DEPTH);
            result_overflow[lead_bytes]     = overflow_seen;
            result_backpressure[lead_bytes] = lane0_backpressure_seen;
            result_pixels[lead_bytes]       = act_pixel_cnt;
            result_mismatch[lead_bytes]     = mismatch_cnt;

            $display("RESULT: deskew_depth=%0d byte_fifo_aw=%0d axi_fifo_aw=%0d lead_bytes=%0d tolerant=%0b overflow=%0b ready_low=%0b act_pixels=%0d mismatch=%0d",
                     DESKEW_DEPTH, BYTE_FIFO_ADDR_WIDTH, AXI_FIFO_ADDR_WIDTH,
                     lead_bytes, (lead_bytes <= DESKEW_DEPTH), overflow_seen,
                     lane0_backpressure_seen, act_pixel_cnt, mismatch_cnt);

            case_active = 1'b0;
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
            err_ecc_seen     <= 1'b0;
            err_crc_seen     <= 1'b0;
            err_sync_seen    <= 1'b0;
            act_pixel_cnt    <= 0;
            mismatch_cnt     <= 0;
        end else if (case_active) begin
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
            if (err_ecc_o) begin
                err_ecc_seen <= 1'b1;
            end
            if (err_crc_o) begin
                err_crc_seen <= 1'b1;
            end
            if (err_sync_o) begin
                err_sync_seen <= 1'b1;
            end
            if (pixel_valid_o) begin
                if (act_pixel_cnt >= PIXEL_COUNT) begin
                    mismatch_cnt <= mismatch_cnt + 1;
                end else if ((pixel_data_o != csi2_reference_helpers_pkg::csi2_expected_pixel(DATA_TYPE, act_pixel_cnt)) ||
                             (pixel_sof_o  != (act_pixel_cnt == 0)) ||
                             (pixel_sol_o  != (act_pixel_cnt == 0))) begin
                    mismatch_cnt <= mismatch_cnt + 1;
                end
                act_pixel_cnt <= act_pixel_cnt + 1;
            end
        end
    end

    always_ff @(posedge clk_byte) begin
        if (!rst_n) begin
            overflow_seen           <= 1'b0;
            lane0_backpressure_seen <= 1'b0;
        end else if (case_active) begin
            if (!sensor_lane_ready[0]) begin
                lane0_backpressure_seen <= 1'b1;
            end
            if (dut.u_mipi_csi2_capture_top.u_lane_deskew_buffer.err_overflow_o) begin
                overflow_seen <= 1'b1;
            end
        end
    end

    integer lead_idx;

    initial begin
        hs_mode     = 1'b1;
        lp_mode     = 1'b0;
        rst_n       = 1'b0;
        case_active = 1'b0;
        sensor_done = 1'b0;
        clear_lane_drive();
        build_frame_streams();

        for (lead_idx = 0; lead_idx <= MAX_LEAD_BYTES; lead_idx = lead_idx + 1) begin
            result_pass[lead_idx]         = 1'b0;
            result_overflow[lead_idx]     = 1'b0;
            result_backpressure[lead_idx] = 1'b0;
            result_pixels[lead_idx]       = 0;
            result_mismatch[lead_idx]     = 0;
        end

        for (lead_idx = 0; lead_idx <= MAX_LEAD_BYTES; lead_idx = lead_idx + 1) begin
            run_case(lead_idx);
        end

        for (lead_idx = 0; lead_idx <= DESKEW_DEPTH; lead_idx = lead_idx + 1) begin
            if (!result_pass[lead_idx] || result_overflow[lead_idx]) begin
                fail("tolerant scan window result mismatch");
            end
        end

        if (result_pass[DESKEW_DEPTH + 1]) begin
            fail("overflow boundary case unexpectedly passed");
        end
        if (!result_overflow[DESKEW_DEPTH + 1]) begin
            fail("overflow boundary case did not report overflow");
        end

        $display("PASS: tb_fpga_wrapper_lane_skew_scan deskew_depth=%0d byte_fifo_aw=%0d axi_fifo_aw=%0d tolerant_window=0..%0d overflow_at=%0d",
                 DESKEW_DEPTH, BYTE_FIFO_ADDR_WIDTH, AXI_FIFO_ADDR_WIDTH,
                 DESKEW_DEPTH, DESKEW_DEPTH + 1);
        $finish;
    end

endmodule
