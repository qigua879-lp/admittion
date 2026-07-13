`timescale 1ns/1ps

// System closure against a DDR-like AXI write slave (axi_ddr_latency_model):
// address-acceptance latency + pseudo-random per-beat wready stalls + delayed
// write responses. Proves the capture pipeline (async FIFOs + AXI writer)
// delivers every line intact under realistic memory-controller behavior, not
// just against the ideal always-ready null sink.
//
// Scenario: one clean RAW8 frame (4 lines x 4 px, 2 lanes) written through the
// model. Checks:
//   * every line slot holds the expected clean payload (byte-accurate readback)
//   * the imposed stress actually happened (aw/w/b stall counters all > 0)
//   * no ECC/CRC/sync errors, no lane-drop events
// APB configuration is written through the real APB interface (TB as master).
module tb_axi_ddr_latency_closure;

    localparam int LANE_NUM = 2;
    localparam logic [5:0] DATA_TYPE = csi2_reference_helpers_pkg::CSI2_DT_RAW8;
    localparam logic [1:0] VC_ID = 2'd0;

    localparam int H = 4;
    localparam int WORDS_PER_LINE = 4;

    logic clk_sys, clk_byte, clk_axi, clk_ddr, rst_n;

    logic [31:0] lane_data_0, lane_data_1, lane_data_2, lane_data_3;
    logic        lane_valid_0, lane_valid_1, lane_valid_2, lane_valid_3;
    logic        hs_mode, lp_mode;

    // APB master driven by the TB.
    logic        psel, penable, pwrite;
    logic [15:0] paddr;
    logic [31:0] pwdata;
    logic [31:0] prdata;
    logic        pready, pslverr;

    // AXI between top and the DDR model.
    logic [31:0]  m_axi_awaddr;
    logic [7:0]   m_axi_awlen;
    logic [2:0]   m_axi_awsize;
    logic [1:0]   m_axi_awburst;
    logic         m_axi_awvalid, m_axi_awready;
    logic [127:0] m_axi_wdata;
    logic [15:0]  m_axi_wstrb;
    logic         m_axi_wlast, m_axi_wvalid, m_axi_wready;
    logic [1:0]   m_axi_bresp;
    logic         m_axi_bvalid, m_axi_bready;

    logic        frame_start_o, frame_end_o, line_start_o, line_end_o;
    logic        err_ecc_o, err_crc_o, err_sync_o;
    logic [31:0] frame_cnt_o, line_cnt_o, err_cnt_ecc_o, err_cnt_crc_o;
    logic        retry_req_o, retry_pending_o, retry_mode_o;
    logic [31:0] retry_frame_id_o, retry_line_id_o;
    logic        no_bp_drop_event, no_bp_drop_active;
    logic [23:0] pixel_data_o;
    logic        pixel_valid_o, pixel_sof_o, pixel_sol_o;

    logic [31:0] aw_stall_cycles, w_stall_cycles, b_delay_cycles;

    logic [LANE_NUM-1:0]      sensor_lane_valid;
    logic [LANE_NUM-1:0][7:0] sensor_lane_data;
    logic [LANE_NUM-1:0]      sensor_lane_ready;

    mipi_csi2_capture_top #(
        .LANE_NUM(LANE_NUM),
        .AXI_ADDR_WIDTH(32),
        .AXI_DATA_WIDTH(128),
        .AXI_MAX_BURST_LEN(16)
    ) dut (
        .clk_sys(clk_sys), .clk_byte(clk_byte), .clk_axi(clk_axi), .clk_ddr(clk_ddr),
        .rst_n(rst_n),
        .lane_data_0(lane_data_0), .lane_data_1(lane_data_1),
        .lane_data_2(lane_data_2), .lane_data_3(lane_data_3),
        .lane_valid_0(lane_valid_0), .lane_valid_1(lane_valid_1),
        .lane_valid_2(lane_valid_2), .lane_valid_3(lane_valid_3),
        .hs_mode(hs_mode), .lp_mode(lp_mode),
        .psel(psel), .penable(penable), .pwrite(pwrite),
        .paddr(paddr), .pwdata(pwdata),
        .prdata(prdata), .pready(pready), .pslverr(pslverr),
        .m_axi_awaddr_o(m_axi_awaddr), .m_axi_awlen_o(m_axi_awlen),
        .m_axi_awsize_o(m_axi_awsize), .m_axi_awburst_o(m_axi_awburst),
        .m_axi_awvalid_o(m_axi_awvalid), .m_axi_awready_i(m_axi_awready),
        .m_axi_wdata_o(m_axi_wdata), .m_axi_wstrb_o(m_axi_wstrb),
        .m_axi_wlast_o(m_axi_wlast), .m_axi_wvalid_o(m_axi_wvalid),
        .m_axi_wready_i(m_axi_wready),
        .m_axi_bresp_i(m_axi_bresp), .m_axi_bvalid_i(m_axi_bvalid),
        .m_axi_bready_o(m_axi_bready),
        .frame_start_o(frame_start_o), .frame_end_o(frame_end_o),
        .line_start_o(line_start_o), .line_end_o(line_end_o),
        .err_ecc_o(err_ecc_o), .err_crc_o(err_crc_o), .err_sync_o(err_sync_o),
        .frame_cnt_o(frame_cnt_o), .line_cnt_o(line_cnt_o),
        .err_cnt_ecc_o(err_cnt_ecc_o), .err_cnt_crc_o(err_cnt_crc_o),
        .retry_req_o(retry_req_o), .retry_pending_o(retry_pending_o),
        .retry_mode_o(retry_mode_o),
        .retry_frame_id_o(retry_frame_id_o), .retry_line_id_o(retry_line_id_o),
        .src_recap_line_valid_i(1'b0),
        .no_backpressure_drop_event_o(no_bp_drop_event),
        .no_backpressure_drop_active_o(no_bp_drop_active),
        .pixel_data_o(pixel_data_o), .pixel_valid_o(pixel_valid_o),
        .pixel_sof_o(pixel_sof_o), .pixel_sol_o(pixel_sol_o)
    );

    axi_ddr_latency_model #(
        .ADDR_WIDTH(32),
        .DATA_WIDTH(128),
        .MEM_ADDR_WIDTH(12),
        .AW_DELAY_CYCLES(8),
        .B_DELAY_CYCLES(12)
    ) u_ddr_model (
        .clk_axi(clk_axi), .rst_n(rst_n),
        .s_axi_awaddr_i(m_axi_awaddr), .s_axi_awlen_i(m_axi_awlen),
        .s_axi_awsize_i(m_axi_awsize), .s_axi_awburst_i(m_axi_awburst),
        .s_axi_awvalid_i(m_axi_awvalid), .s_axi_awready_o(m_axi_awready),
        .s_axi_wdata_i(m_axi_wdata), .s_axi_wstrb_i(m_axi_wstrb),
        .s_axi_wlast_i(m_axi_wlast), .s_axi_wvalid_i(m_axi_wvalid),
        .s_axi_wready_o(m_axi_wready),
        .s_axi_bresp_o(m_axi_bresp), .s_axi_bvalid_o(m_axi_bvalid),
        .s_axi_bready_i(m_axi_bready),
        .aw_stall_cycles_o(aw_stall_cycles),
        .w_stall_cycles_o(w_stall_cycles),
        .b_delay_cycles_o(b_delay_cycles)
    );

    assign sensor_lane_ready = dut.phy_lane_ready[LANE_NUM-1:0];

    always_comb begin
        lane_data_0  = {24'd0, sensor_lane_data[0]};
        lane_data_1  = {24'd0, sensor_lane_data[1]};
        lane_data_2  = 32'd0; lane_data_3 = 32'd0;
        lane_valid_0 = sensor_lane_valid[0];
        lane_valid_1 = sensor_lane_valid[1];
        lane_valid_2 = 1'b0; lane_valid_3 = 1'b0;
    end

    // ---- APB master ----
    task automatic apb_write(input logic [15:0] addr, input logic [31:0] data);
        begin
            @(negedge clk_sys);
            psel = 1'b1; penable = 1'b0; pwrite = 1'b1;
            paddr = addr; pwdata = data;
            @(negedge clk_sys);
            penable = 1'b1;
            @(negedge clk_sys);
            while (!pready) @(negedge clk_sys);
            psel = 1'b0; penable = 1'b0;
        end
    endtask

    // ---- lane driving (same pattern as wrapper TBs) ----
    task automatic clear_lane_drive; begin sensor_lane_valid='0; sensor_lane_data='0; end endtask
    task automatic push_lane_group(input logic [7:0] b0, input logic [7:0] b1);
        begin
            while (!(sensor_lane_ready[0] && sensor_lane_ready[1])) @(posedge clk_byte);
            @(negedge clk_byte);
            sensor_lane_valid[0]=1'b1; sensor_lane_valid[1]=1'b1;
            sensor_lane_data[0]=b0;    sensor_lane_data[1]=b1;
            @(posedge clk_byte); @(negedge clk_byte);
            clear_lane_drive();
        end
    endtask
    task automatic send_short_packet(input logic [5:0] dt);
        logic [31:0] h;
        begin
            h = csi2_reference_helpers_pkg::csi2_pack_header(VC_ID, dt, 16'd0, 1'b0);
            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(h,0),
                            csi2_reference_helpers_pkg::csi2_packet_byte(h,1));
            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(h,2),
                            csi2_reference_helpers_pkg::csi2_packet_byte(h,3));
        end
    endtask
    task automatic send_long_packet;
        logic [31:0] hd; logic [15:0] cr;
        begin
            hd = csi2_reference_helpers_pkg::csi2_pack_header(
                VC_ID, DATA_TYPE,
                csi2_reference_helpers_pkg::csi2_payload_byte_count(DATA_TYPE), 1'b0);
            cr = csi2_reference_helpers_pkg::csi2_payload_crc(DATA_TYPE);
            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(hd,0),
                            csi2_reference_helpers_pkg::csi2_packet_byte(hd,1));
            push_lane_group(csi2_reference_helpers_pkg::csi2_packet_byte(hd,2),
                            csi2_reference_helpers_pkg::csi2_packet_byte(hd,3));
            push_lane_group(csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE,0),
                            csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE,1));
            push_lane_group(csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE,2),
                            csi2_reference_helpers_pkg::csi2_payload_byte(DATA_TYPE,3));
            push_lane_group(cr[7:0], cr[15:8]);
        end
    endtask
    task automatic send_line;
        begin
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LS);
            send_long_packet();
            send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_LE);
        end
    endtask

    function automatic bit slot_clean(input int word_base);
        begin
            slot_clean = (u_ddr_model.mem[word_base+0] === 32'h00000011) &&
                         (u_ddr_model.mem[word_base+1] === 32'h00000022) &&
                         (u_ddr_model.mem[word_base+2] === 32'h00000033) &&
                         (u_ddr_model.mem[word_base+3] === 32'h00000044);
        end
    endfunction

    initial begin clk_sys=0; forever #5 clk_sys=~clk_sys; end
    initial begin clk_byte=0; forever #4 clk_byte=~clk_byte; end
    initial begin clk_axi=0; forever #5 clk_axi=~clk_axi; end
    initial begin clk_ddr=0; forever #5 clk_ddr=~clk_ddr; end

    int i;
    int bad;
    initial begin
        rst_n=1'b0; hs_mode=1'b1; lp_mode=1'b0;
        psel=1'b0; penable=1'b0; pwrite=1'b0; paddr='0; pwdata='0;
        clear_lane_drive();
        repeat (6) @(posedge clk_sys);
        rst_n=1'b1;
        repeat (4) @(posedge clk_sys);

        // Configure through the real APB interface.
        apb_write(16'h0008, 32'd4);          // IMG_WIDTH
        apb_write(16'h000C, H);              // IMG_HEIGHT
        apb_write(16'h0010, 32'h0000_0031);  // LANE_CFG: mask=0011, lanes-1=1
        apb_write(16'h0014, 32'h0000_002A);  // DT_CFG: RAW8, VC0
        apb_write(16'h0018, 32'd0);          // FRAME_BASE
        apb_write(16'h001C, 32'd64);         // LINE_STRIDE
        apb_write(16'h0040, 32'd16);         // AXI max burst
        apb_write(16'h0000, 32'h0000_0001);  // CTRL.enable
        repeat (8) @(posedge clk_byte);

        // One clean frame through the DDR-like slave.
        send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FS);
        for (i = 0; i < H; i = i + 1) send_line();
        send_short_packet(csi2_reference_helpers_pkg::CSI2_DT_FE);

        // Drain generously: latency + stalls slow the write side down.
        repeat (2000) @(posedge clk_axi);

        bad = 0;
        for (i = 0; i < H; i = i + 1) begin
            if (!slot_clean(16*i)) begin
                $display("FAIL: line slot %0d not clean under DDR latency: %08h %08h %08h %08h",
                         i, u_ddr_model.mem[16*i+0], u_ddr_model.mem[16*i+1],
                            u_ddr_model.mem[16*i+2], u_ddr_model.mem[16*i+3]);
                bad = bad + 1;
            end
        end
        if ((aw_stall_cycles == 32'd0) || (w_stall_cycles == 32'd0) || (b_delay_cycles == 32'd0)) begin
            $display("FAIL: stress not exercised aw=%0d w=%0d b=%0d",
                     aw_stall_cycles, w_stall_cycles, b_delay_cycles);
            bad = bad + 1;
        end
        if (err_ecc_o || err_crc_o || err_sync_o || (err_cnt_crc_o != 0) || (err_cnt_ecc_o != 0)) begin
            $display("FAIL: unexpected protocol errors under DDR latency");
            bad = bad + 1;
        end
        if (no_bp_drop_event || no_bp_drop_active) begin
            $display("FAIL: unexpected drop events under DDR latency");
            bad = bad + 1;
        end

        if (bad != 0) begin
            $display("FAIL: tb_axi_ddr_latency_closure bad_checks=%0d", bad);
            $fatal(1);
        end

        $display("PASS: tb_axi_ddr_latency_closure lines=%0d aw_stall=%0d w_stall=%0d b_delay=%0d",
                 H, aw_stall_cycles, w_stall_cycles, b_delay_cycles);
        $finish;
    end

    initial begin
        repeat (80000) @(posedge clk_sys);
        $display("FAIL: tb_axi_ddr_latency_closure timeout aw=%0d w=%0d b=%0d frame_cnt=%0d",
                 aw_stall_cycles, w_stall_cycles, b_delay_cycles, frame_cnt_o);
        $fatal(1);
    end

endmodule
