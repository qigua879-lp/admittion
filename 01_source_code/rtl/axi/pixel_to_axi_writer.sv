`timescale 1ns/1ps

module pixel_to_axi_writer #(
    parameter int ADDR_WIDTH       = 32,
    parameter int DATA_WIDTH       = 32,
    parameter int MAX_BURST_LEN    = 16,
    parameter int FIFO_ADDR_WIDTH  = 6
) (
    input  logic                         clk_sys,
    input  logic                         clk_axi,
    input  logic                         rst_n,

    input  logic                         enable_i,
    input  logic                         clear_i,
    output logic                         clear_busy_o,
    input  logic [ADDR_WIDTH-1:0]        frame_base_addr_i,
    input  logic [ADDR_WIDTH-1:0]        line_stride_i,
    input  logic [15:0]                  frame_height_i,
    input  logic [8:0]                   max_burst_len_i,

    input  logic                         frame_start_i,
    input  logic                         line_end_i,
    input  logic                         discard_line_i,
    // Line-level recapture write-back: when a controllable source re-sends a
    // line in response to a retry request, recap_active_i is held high for that
    // line and recap_line_id_i selects the target slot. The line is then
    // addressed by recap_line_id_i (overwriting the corrupted/dropped line)
    // without advancing the normal line counter or hitting the height drop.
    // Both default to 0 -> behaviour identical to the non-recapture datapath.
    input  logic                         recap_active_i,
    input  logic [15:0]                  recap_line_id_i,
    input  logic                         pixel_valid_i,
    output logic                         pixel_ready_o,
    input  logic [23:0]                  pixel_data_i,

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

    localparam int DATA_BYTES      = DATA_WIDTH / 8;
    localparam int DATA_FIFO_WIDTH = DATA_WIDTH + (DATA_WIDTH / 8);
    localparam int CMD_FIFO_WIDTH  = 33;
    localparam int PIXELS_PER_BEAT = (DATA_WIDTH < 32) ? 1 : (DATA_WIDTH / 32);

    logic [15:0] sys_line_id_q;
    logic [15:0] sys_line_byte_cnt_q;
    logic        sys_cmd_pending_q;
    logic [15:0] sys_cmd_line_id_q;
    logic [15:0] sys_cmd_byte_len_q;
    logic        sys_cmd_drop_q;
    logic [DATA_WIDTH-1:0]     sys_pack_data_q;
    logic [(DATA_WIDTH/8)-1:0] sys_pack_strb_q;
    logic [$clog2(PIXELS_PER_BEAT+1)-1:0] sys_pack_count_q;
    logic        sys_line_end_pending_q;
    logic        sys_line_drop_pending_q;
    logic        sys_line_recap_pending_q;
    logic [15:0] sys_recap_line_id_q;
    logic        sys_data_fifo_wr_valid;
    logic [DATA_FIFO_WIDTH-1:0] sys_data_fifo_wr_data;
    logic        pixel_fire_sys;
    logic        clear_req_toggle_sys;
    logic        clear_commit_sync1_sys;
    logic        clear_commit_sync2_sys;
    logic        clear_commit_sync2_d_sys;
    logic        clear_busy_sys_q;
    logic        data_fifo_clear_wr_sys;
    logic        cmd_fifo_clear_wr_sys;
    logic        sys_force_flush;
    logic        sys_accept_pixel;
    logic        sys_can_accept_line_end;
    logic [DATA_WIDTH-1:0]     sys_pack_data_next;
    logic [(DATA_WIDTH/8)-1:0] sys_pack_strb_next;
    logic [$clog2(PIXELS_PER_BEAT+1)-1:0] sys_pack_count_next;

    logic                      data_fifo_wr_ready;
    logic                      data_fifo_rd_valid;
    logic                      data_fifo_rd_ready;
    logic [DATA_FIFO_WIDTH-1:0] data_fifo_rd_data;
    logic                      data_fifo_full_unused;
    logic                      data_fifo_empty_unused;
    logic [FIFO_ADDR_WIDTH:0]  data_fifo_wr_level_unused;
    logic [FIFO_ADDR_WIDTH:0]  data_fifo_rd_level_unused;

    logic                      cmd_fifo_wr_valid;
    logic                      cmd_fifo_wr_ready;
    logic [CMD_FIFO_WIDTH-1:0] cmd_fifo_wr_data;
    logic                      cmd_fifo_rd_valid;
    logic                      cmd_fifo_rd_ready;
    logic [CMD_FIFO_WIDTH-1:0] cmd_fifo_rd_data;
    logic                      cmd_fifo_full_unused;
    logic                      cmd_fifo_empty_unused;
    logic [3:0]                cmd_fifo_wr_level_unused;
    logic [3:0]                cmd_fifo_rd_level_unused;

    logic [ADDR_WIDTH-1:0] cfg_frame_base_meta_q;
    logic [ADDR_WIDTH-1:0] cfg_frame_base_axi_q;
    logic [ADDR_WIDTH-1:0] cfg_line_stride_meta_q;
    logic [ADDR_WIDTH-1:0] cfg_line_stride_axi_q;
    logic [8:0]            cfg_max_burst_meta_q;
    logic [8:0]            cfg_max_burst_axi_q;
    logic                  cfg_enable_meta_q;
    logic                  cfg_enable_axi_q;

    logic                  addr_req_valid;
    logic                  addr_req_ready;
    logic                  cmd_fifo_pop;
    logic [15:0]           addr_req_line_id;
    logic [ADDR_WIDTH-1:0] addr_req_byte_offset;
    logic                  addr_valid;
    logic                  addr_ready;
    logic [ADDR_WIDTH-1:0] addr_value;

    logic                  cmd_pending_q;
    logic [15:0]           cmd_byte_len_q;
    logic [15:0]           cmd_line_id_q;
    logic                  cmd_drop_q;
    logic                  discard_active_q;
    logic [15:0]           discard_bytes_left_q;
    logic                  discard_done;
    logic                  data_consume_axi;

    logic                  axi_cmd_valid;
    logic                  axi_cmd_ready;
    logic                  axi_wr_ready;
    logic                  axi_busy;
    logic                  axi_done;

    logic                  clear_req_sync1_axi;
    logic                  clear_req_sync2_axi;
    logic                  clear_req_sync2_d_axi;
    logic                  clear_commit_toggle_axi;
    logic                  clear_pending_axi_q;
    logic                  data_fifo_clear_rd_axi;
    logic                  cmd_fifo_clear_rd_axi;

    always_comb begin
        sys_pack_data_next  = sys_pack_data_q;
        sys_pack_strb_next  = sys_pack_strb_q;
        sys_pack_count_next = sys_pack_count_q;

        if (PIXELS_PER_BEAT == 1) begin
            sys_pack_data_next[31:0] = {8'd0, pixel_data_i};
            sys_pack_strb_next[3:0]  = 4'hf;
            sys_pack_count_next      = 1;
        end else begin
            sys_pack_data_next[(sys_pack_count_q * 32) +: 32] = {8'd0, pixel_data_i};
            sys_pack_strb_next[(sys_pack_count_q * 4) +: 4]   = 4'hf;
            sys_pack_count_next = sys_pack_count_q + 1'b1;
        end
    end

    assign sys_force_flush       = (sys_pack_count_q != '0) &&
                                   (sys_line_end_pending_q || (sys_pack_count_q == PIXELS_PER_BEAT));
    assign sys_accept_pixel      = enable_i && !clear_busy_sys_q && !sys_cmd_pending_q &&
                                   !sys_line_end_pending_q &&
                                   ((sys_pack_count_q != PIXELS_PER_BEAT) || data_fifo_wr_ready);
    assign sys_can_accept_line_end = enable_i && !clear_busy_sys_q && !sys_cmd_pending_q &&
                                     (!sys_force_flush || data_fifo_wr_ready);

    assign pixel_ready_o = !enable_i || sys_accept_pixel;
    assign pixel_fire_sys = pixel_valid_i && pixel_ready_o && enable_i;

    assign sys_data_fifo_wr_valid = !clear_busy_sys_q && data_fifo_wr_ready && sys_force_flush;
    assign sys_data_fifo_wr_data  = {sys_pack_strb_q, sys_pack_data_q};

    assign cmd_fifo_wr_valid = sys_cmd_pending_q;
    assign cmd_fifo_wr_data  = {sys_cmd_drop_q, sys_cmd_line_id_q, sys_cmd_byte_len_q};

    async_fifo #(
        .DATA_WIDTH(DATA_FIFO_WIDTH),
        .ADDR_WIDTH(FIFO_ADDR_WIDTH)
    ) u_pixel_data_fifo (
        .clk_wr(clk_sys),
        .clk_rd(clk_axi),
        .rst_n(rst_n),
        .clear_wr_i(data_fifo_clear_wr_sys),
        .clear_rd_i(data_fifo_clear_rd_axi),
        .wr_valid(sys_data_fifo_wr_valid),
        .wr_ready(data_fifo_wr_ready),
        .wr_data(sys_data_fifo_wr_data),
        .rd_valid(data_fifo_rd_valid),
        .rd_ready(data_fifo_rd_ready),
        .rd_data(data_fifo_rd_data),
        .full(data_fifo_full_unused),
        .empty(data_fifo_empty_unused),
        .wr_level(data_fifo_wr_level_unused),
        .rd_level(data_fifo_rd_level_unused)
    );

    async_fifo #(
        .DATA_WIDTH(CMD_FIFO_WIDTH),
        .ADDR_WIDTH(3)
    ) u_line_cmd_fifo (
        .clk_wr(clk_sys),
        .clk_rd(clk_axi),
        .rst_n(rst_n),
        .clear_wr_i(cmd_fifo_clear_wr_sys),
        .clear_rd_i(cmd_fifo_clear_rd_axi),
        .wr_valid(cmd_fifo_wr_valid),
        .wr_ready(cmd_fifo_wr_ready),
        .wr_data(cmd_fifo_wr_data),
        .rd_valid(cmd_fifo_rd_valid),
        .rd_ready(cmd_fifo_rd_ready),
        .rd_data(cmd_fifo_rd_data),
        .full(cmd_fifo_full_unused),
        .empty(cmd_fifo_empty_unused),
        .wr_level(cmd_fifo_wr_level_unused),
        .rd_level(cmd_fifo_rd_level_unused)
    );

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            sys_line_id_q          <= 16'd0;
            sys_line_byte_cnt_q    <= 16'd0;
            sys_cmd_pending_q      <= 1'b0;
            sys_cmd_line_id_q      <= 16'd0;
            sys_cmd_byte_len_q     <= 16'd0;
            sys_cmd_drop_q         <= 1'b0;
            sys_pack_data_q        <= '0;
            sys_pack_strb_q        <= '0;
            sys_pack_count_q       <= '0;
            sys_line_end_pending_q <= 1'b0;
            sys_line_drop_pending_q <= 1'b0;
            sys_line_recap_pending_q <= 1'b0;
            sys_recap_line_id_q     <= 16'd0;
            clear_req_toggle_sys   <= 1'b0;
            clear_commit_sync1_sys <= 1'b0;
            clear_commit_sync2_sys <= 1'b0;
            clear_commit_sync2_d_sys <= 1'b0;
            clear_busy_sys_q       <= 1'b0;
            data_fifo_clear_wr_sys <= 1'b0;
            cmd_fifo_clear_wr_sys  <= 1'b0;
        end else begin
            data_fifo_clear_wr_sys    <= 1'b0;
            cmd_fifo_clear_wr_sys     <= 1'b0;
            clear_commit_sync1_sys    <= clear_commit_toggle_axi;
            clear_commit_sync2_sys    <= clear_commit_sync1_sys;
            clear_commit_sync2_d_sys  <= clear_commit_sync2_sys;

            if (clear_i && !clear_busy_sys_q) begin
                clear_busy_sys_q        <= 1'b1;
                clear_req_toggle_sys    <= ~clear_req_toggle_sys;
                sys_line_id_q           <= 16'd0;
                sys_line_byte_cnt_q     <= 16'd0;
                sys_cmd_pending_q       <= 1'b0;
                sys_cmd_line_id_q       <= 16'd0;
                sys_cmd_byte_len_q      <= 16'd0;
                sys_cmd_drop_q          <= 1'b0;
                sys_pack_data_q         <= '0;
                sys_pack_strb_q         <= '0;
                sys_pack_count_q        <= '0;
                sys_line_end_pending_q  <= 1'b0;
                sys_line_drop_pending_q <= 1'b0;
            sys_line_recap_pending_q <= 1'b0;
            sys_recap_line_id_q     <= 16'd0;
            end else if (clear_busy_sys_q &&
                         (clear_commit_sync2_sys ^ clear_commit_sync2_d_sys)) begin
                clear_busy_sys_q        <= 1'b0;
                data_fifo_clear_wr_sys  <= 1'b1;
                cmd_fifo_clear_wr_sys   <= 1'b1;
                sys_line_id_q           <= 16'd0;
                sys_line_byte_cnt_q     <= 16'd0;
                sys_cmd_pending_q       <= 1'b0;
                sys_cmd_line_id_q       <= 16'd0;
                sys_cmd_byte_len_q      <= 16'd0;
                sys_cmd_drop_q          <= 1'b0;
                sys_pack_data_q         <= '0;
                sys_pack_strb_q         <= '0;
                sys_pack_count_q        <= '0;
                sys_line_end_pending_q  <= 1'b0;
                sys_line_drop_pending_q <= 1'b0;
            sys_line_recap_pending_q <= 1'b0;
            sys_recap_line_id_q     <= 16'd0;
            end else if (!enable_i) begin
                sys_line_id_q           <= 16'd0;
                sys_line_byte_cnt_q     <= 16'd0;
                sys_cmd_pending_q       <= 1'b0;
                sys_cmd_line_id_q       <= 16'd0;
                sys_cmd_byte_len_q      <= 16'd0;
                sys_cmd_drop_q          <= 1'b0;
                sys_pack_data_q         <= '0;
                sys_pack_strb_q         <= '0;
                sys_pack_count_q        <= '0;
                sys_line_end_pending_q  <= 1'b0;
                sys_line_drop_pending_q <= 1'b0;
            sys_line_recap_pending_q <= 1'b0;
            sys_recap_line_id_q     <= 16'd0;
            end else begin
                if (cmd_fifo_wr_valid && cmd_fifo_wr_ready) begin
                    sys_cmd_pending_q <= 1'b0;
                end

                if (frame_start_i) begin
                    sys_line_id_q <= 16'd0;
                end

                if (pixel_fire_sys) begin
                    sys_pack_data_q     <= sys_pack_data_next;
                    sys_pack_strb_q     <= sys_pack_strb_next;
                    sys_pack_count_q    <= sys_pack_count_next;
                    sys_line_byte_cnt_q <= sys_line_byte_cnt_q + 16'd4;
                end

                if (sys_data_fifo_wr_valid) begin
                    sys_pack_data_q  <= '0;
                    sys_pack_strb_q  <= '0;
                    sys_pack_count_q <= '0;
                end

                if (line_end_i && sys_can_accept_line_end) begin
                    sys_line_end_pending_q   <= 1'b1;
                    // A recapture line is never height-dropped or discard-dropped:
                    // it carries the corrected data for an already-located slot.
                    sys_line_drop_pending_q  <= recap_active_i ? 1'b0 :
                                                (discard_line_i || (sys_line_id_q >= frame_height_i));
                    sys_line_recap_pending_q <= recap_active_i;
                    sys_recap_line_id_q      <= recap_line_id_i;
                end

                if (sys_line_end_pending_q && !sys_force_flush && !sys_cmd_pending_q) begin
                    if (sys_line_byte_cnt_q != 16'd0) begin
                        sys_cmd_pending_q  <= 1'b1;
                        // Recapture line: address by the located slot id and do NOT
                        // advance the running line counter (normal lines keep their
                        // slots). Otherwise behave exactly as before.
                        sys_cmd_line_id_q  <= sys_line_recap_pending_q ? sys_recap_line_id_q
                                                                       : sys_line_id_q;
                        sys_cmd_byte_len_q <= sys_line_byte_cnt_q;
                        sys_cmd_drop_q     <= sys_line_drop_pending_q;
                        if (!sys_line_recap_pending_q) begin
                            sys_line_id_q  <= sys_line_id_q + 16'd1;
                        end
                    end
                    sys_line_byte_cnt_q      <= 16'd0;
                    sys_line_end_pending_q   <= 1'b0;
                    sys_line_drop_pending_q  <= 1'b0;
                    sys_line_recap_pending_q <= 1'b0;
                end
            end
        end
    end

    assign clear_busy_o = clear_busy_sys_q;

    always_ff @(posedge clk_axi) begin
        if (!rst_n) begin
            cfg_frame_base_meta_q    <= '0;
            cfg_frame_base_axi_q     <= '0;
            cfg_line_stride_meta_q   <= '0;
            cfg_line_stride_axi_q    <= '0;
            cfg_max_burst_meta_q     <= MAX_BURST_LEN[8:0];
            cfg_max_burst_axi_q      <= MAX_BURST_LEN[8:0];
            cfg_enable_meta_q        <= 1'b0;
            cfg_enable_axi_q         <= 1'b0;
            clear_req_sync1_axi      <= 1'b0;
            clear_req_sync2_axi      <= 1'b0;
            clear_req_sync2_d_axi    <= 1'b0;
            clear_commit_toggle_axi  <= 1'b0;
            clear_pending_axi_q      <= 1'b0;
            data_fifo_clear_rd_axi   <= 1'b0;
            cmd_fifo_clear_rd_axi    <= 1'b0;
        end else begin
            cfg_frame_base_meta_q  <= frame_base_addr_i;
            cfg_frame_base_axi_q   <= cfg_frame_base_meta_q;
            cfg_line_stride_meta_q <= line_stride_i;
            cfg_line_stride_axi_q  <= cfg_line_stride_meta_q;
            cfg_max_burst_meta_q   <= max_burst_len_i;
            cfg_max_burst_axi_q    <= cfg_max_burst_meta_q;
            cfg_enable_meta_q      <= enable_i;
            cfg_enable_axi_q       <= cfg_enable_meta_q;

            clear_req_sync1_axi    <= clear_req_toggle_sys;
            clear_req_sync2_axi    <= clear_req_sync1_axi;
            clear_req_sync2_d_axi  <= clear_req_sync2_axi;
            data_fifo_clear_rd_axi <= 1'b0;
            cmd_fifo_clear_rd_axi  <= 1'b0;

            if (clear_req_sync2_axi ^ clear_req_sync2_d_axi) begin
                clear_pending_axi_q <= 1'b1;
            end

            if (clear_pending_axi_q && !axi_busy && !cmd_pending_q && !discard_active_q) begin
                clear_pending_axi_q     <= 1'b0;
                data_fifo_clear_rd_axi  <= 1'b1;
                cmd_fifo_clear_rd_axi   <= 1'b1;
                clear_commit_toggle_axi <= ~clear_commit_toggle_axi;
            end
        end
    end

    assign addr_req_valid       = cmd_fifo_rd_valid && !cmd_pending_q && cfg_enable_axi_q &&
                                  !discard_active_q && !axi_busy && !clear_pending_axi_q &&
                                  !cmd_fifo_rd_data[CMD_FIFO_WIDTH-1];
    assign cmd_fifo_pop         = cmd_fifo_rd_valid && !cmd_pending_q && cfg_enable_axi_q &&
                                  !discard_active_q && !axi_busy && !clear_pending_axi_q &&
                                  (cmd_fifo_rd_data[CMD_FIFO_WIDTH-1] || addr_req_ready);
    assign cmd_fifo_rd_ready    = cmd_fifo_pop;
    assign addr_req_line_id     = cmd_fifo_rd_data[31:16];
    assign addr_req_byte_offset = '0;

    addr_gen_frame_based #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_addr_gen_frame_based (
        .clk_axi(clk_axi),
        .rst_n(rst_n),
        .addr_req_valid_i(addr_req_valid),
        .addr_req_ready_o(addr_req_ready),
        .frame_base_addr_i(cfg_frame_base_axi_q),
        .line_stride_i(cfg_line_stride_axi_q),
        .line_id_i(addr_req_line_id),
        .byte_offset_i(addr_req_byte_offset),
        .addr_valid_o(addr_valid),
        .addr_ready_i(addr_ready),
        .addr_o(addr_value)
    );

    always_ff @(posedge clk_axi) begin
        if (!rst_n) begin
            cmd_pending_q        <= 1'b0;
            cmd_byte_len_q       <= 16'd0;
            cmd_line_id_q        <= 16'd0;
            cmd_drop_q           <= 1'b0;
            discard_active_q     <= 1'b0;
            discard_bytes_left_q <= 16'd0;
        end else if (data_fifo_clear_rd_axi || cmd_fifo_clear_rd_axi) begin
            cmd_pending_q        <= 1'b0;
            cmd_byte_len_q       <= 16'd0;
            cmd_line_id_q        <= 16'd0;
            cmd_drop_q           <= 1'b0;
            discard_active_q     <= 1'b0;
            discard_bytes_left_q <= 16'd0;
        end else begin
            if (cmd_fifo_rd_ready && cmd_fifo_rd_valid) begin
                cmd_pending_q  <= 1'b1;
                cmd_line_id_q  <= cmd_fifo_rd_data[31:16];
                cmd_byte_len_q <= cmd_fifo_rd_data[15:0];
                cmd_drop_q     <= cmd_fifo_rd_data[32];
            end

            if (axi_cmd_valid && axi_cmd_ready) begin
                cmd_pending_q  <= 1'b0;
                cmd_byte_len_q <= 16'd0;
                cmd_drop_q     <= 1'b0;
            end

            if (cmd_pending_q && cmd_drop_q && !discard_active_q) begin
                discard_active_q     <= 1'b1;
                discard_bytes_left_q <= cmd_byte_len_q;
                cmd_pending_q        <= 1'b0;
                cmd_byte_len_q       <= 16'd0;
                cmd_drop_q           <= 1'b0;
            end

            if (discard_done) begin
                discard_active_q     <= 1'b0;
                discard_bytes_left_q <= 16'd0;
            end else if (discard_active_q && data_fifo_rd_valid) begin
                if (discard_bytes_left_q > DATA_BYTES) begin
                    discard_bytes_left_q <= discard_bytes_left_q - DATA_BYTES;
                end else begin
                    discard_bytes_left_q <= 16'd0;
                end
            end
        end
    end

    assign axi_cmd_valid   = addr_valid && cmd_pending_q && !cmd_drop_q && !clear_pending_axi_q;
    assign addr_ready      = axi_cmd_ready && cmd_pending_q && !cmd_drop_q && !clear_pending_axi_q;
    assign discard_done    = discard_active_q && data_fifo_rd_valid &&
                             (discard_bytes_left_q <= DATA_BYTES);
    assign data_consume_axi = discard_active_q ? 1'b1 : axi_wr_ready;

    axi_write_master #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MAX_BURST_LEN(MAX_BURST_LEN)
    ) u_axi_write_master (
        .clk_axi(clk_axi),
        .rst_n(rst_n),
        .cmd_valid_i(axi_cmd_valid),
        .cmd_ready_o(axi_cmd_ready),
        .cmd_addr_i(addr_value),
        .cmd_byte_len_i(cmd_byte_len_q),
        .cfg_max_burst_len_i(cfg_max_burst_axi_q),
        .wr_valid_i(data_fifo_rd_valid),
        .wr_ready_o(axi_wr_ready),
        .wr_data_i(data_fifo_rd_data[DATA_WIDTH-1:0]),
        .wr_strb_i(data_fifo_rd_data[DATA_FIFO_WIDTH-1:DATA_WIDTH]),
        .m_axi_awaddr_o(m_axi_awaddr_o),
        .m_axi_awlen_o(m_axi_awlen_o),
        .m_axi_awsize_o(m_axi_awsize_o),
        .m_axi_awburst_o(m_axi_awburst_o),
        .m_axi_awvalid_o(m_axi_awvalid_o),
        .m_axi_awready_i(m_axi_awready_i),
        .m_axi_wdata_o(m_axi_wdata_o),
        .m_axi_wstrb_o(m_axi_wstrb_o),
        .m_axi_wlast_o(m_axi_wlast_o),
        .m_axi_wvalid_o(m_axi_wvalid_o),
        .m_axi_wready_i(m_axi_wready_i),
        .m_axi_bresp_i(m_axi_bresp_i),
        .m_axi_bvalid_i(m_axi_bvalid_i),
        .m_axi_bready_o(m_axi_bready_o),
        .busy_o(axi_busy),
        .done_o(axi_done),
        .err_axi_o(err_axi_o)
    );

    assign data_fifo_rd_ready = !clear_pending_axi_q && data_consume_axi;
    assign done_o             = axi_done;
    assign busy_o             = axi_busy || cmd_pending_q || cmd_fifo_rd_valid ||
                                data_fifo_rd_valid || discard_active_q ||
                                clear_pending_axi_q || clear_busy_sys_q ||
                                sys_cmd_pending_q || (sys_pack_count_q != '0) ||
                                sys_line_end_pending_q;

endmodule
