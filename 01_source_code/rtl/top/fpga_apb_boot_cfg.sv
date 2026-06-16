`timescale 1ns/1ps

// Internal APB boot sequencer for the FPGA wrapper. It writes a fixed startup
// register set into cfg_reg_if_apb so the board-level wrapper does not need to
// expose the APB bus as package pins.
module fpga_apb_boot_cfg #(
    parameter int ADDR_WIDTH = 16,
    parameter int DATA_WIDTH = 32,
    parameter int AXI_ADDR_WIDTH = 32,
    parameter int AXI_MAX_BURST_LEN = 16,
    parameter logic [15:0] IMG_WIDTH = 16'd1920,
    parameter logic [15:0] IMG_HEIGHT = 16'd1080,
    parameter logic [1:0] LANE_NUM_MINUS1 = 2'd1,
    parameter logic [3:0] LANE_ENABLE_MASK = 4'b0011,
    parameter logic [7:0] DT_CODE = 8'h2a,
    parameter logic [7:0] VC_ID = 8'd0,
    parameter logic [AXI_ADDR_WIDTH-1:0] FRAME_BASE_ADDR = '0,
    parameter logic [AXI_ADDR_WIDTH-1:0] LINE_STRIDE = 32'd4096,
    // ERR_POLICY register value written at boot. Default 0x39 = err_log +
    // resync + degrade + retry(frame mode). Override e.g. to 0x7D to add
    // CRC-drop (bit2) + line-mode retry (bit6) for line-level recapture.
    parameter logic [31:0] ERR_POLICY_VALUE = 32'h0000_0039,
    parameter logic [8:0] AXI_MAX_BURST_LEN_CFG = AXI_MAX_BURST_LEN[8:0]
) (
    input  logic                  clk_sys,
    input  logic                  rst_n,

    output logic                  psel_o,
    output logic                  penable_o,
    output logic                  pwrite_o,
    output logic [ADDR_WIDTH-1:0] paddr_o,
    output logic [DATA_WIDTH-1:0] pwdata_o,
    input  logic [DATA_WIDTH-1:0] prdata_i,
    input  logic                  pready_i,
    input  logic                  pslverr_i,

    output logic                  init_done_o
);

    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_CTRL        = 16'h0000;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_IMG_WIDTH   = 16'h0008;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_IMG_HEIGHT  = 16'h000c;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_LANE_CFG    = 16'h0010;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_DT_CFG      = 16'h0014;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_FRAME_BASE  = 16'h0018;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_LINE_STRIDE = 16'h001c;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_ERR_POLICY  = 16'h0034;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_PREPROC_CFG = 16'h0038;
    localparam logic [ADDR_WIDTH-1:0] APB_ADDR_AXI_CFG     = 16'h0040;

    localparam int CFG_ENTRY_NUM = 8;

    localparam logic [1:0] ST_SETUP  = 2'd0;
    localparam logic [1:0] ST_ENABLE = 2'd1;
    localparam logic [1:0] ST_DONE   = 2'd2;

    logic [1:0] state_q;
    logic [$clog2(CFG_ENTRY_NUM+1)-1:0] cfg_idx_q;
    logic ctrl_written_q;
    logic [ADDR_WIDTH-1:0] cfg_addr_next;
    logic [DATA_WIDTH-1:0] cfg_data_next;

    always_comb begin
        cfg_addr_next = APB_ADDR_IMG_WIDTH;
        cfg_data_next = {16'd0, IMG_WIDTH};

        case (cfg_idx_q)
            0: begin
                cfg_addr_next = APB_ADDR_IMG_WIDTH;
                cfg_data_next = {16'd0, IMG_WIDTH};
            end
            1: begin
                cfg_addr_next = APB_ADDR_IMG_HEIGHT;
                cfg_data_next = {16'd0, IMG_HEIGHT};
            end
            2: begin
                cfg_addr_next = APB_ADDR_LANE_CFG;
                cfg_data_next = {24'd0, LANE_ENABLE_MASK, 2'd0, LANE_NUM_MINUS1};
            end
            3: begin
                cfg_addr_next = APB_ADDR_DT_CFG;
                cfg_data_next = {16'd0, VC_ID, DT_CODE};
            end
            4: begin
                cfg_addr_next = APB_ADDR_FRAME_BASE;
                cfg_data_next = FRAME_BASE_ADDR;
            end
            5: begin
                cfg_addr_next = APB_ADDR_LINE_STRIDE;
                cfg_data_next = LINE_STRIDE;
            end
            6: begin
                cfg_addr_next = APB_ADDR_ERR_POLICY;
                cfg_data_next = ERR_POLICY_VALUE;
            end
            default: begin
                cfg_addr_next = APB_ADDR_AXI_CFG;
                cfg_data_next = {23'd0, AXI_MAX_BURST_LEN_CFG};
            end
        endcase
    end

    always_ff @(posedge clk_sys) begin
        if (!rst_n) begin
            state_q        <= ST_SETUP;
            cfg_idx_q      <= '0;
            ctrl_written_q <= 1'b0;
            psel_o         <= 1'b0;
            penable_o      <= 1'b0;
            pwrite_o       <= 1'b1;
            paddr_o        <= '0;
            pwdata_o       <= '0;
            init_done_o    <= 1'b0;
        end else begin
            pwrite_o <= 1'b1;

            case (state_q)
                ST_SETUP: begin
                    psel_o    <= 1'b1;
                    penable_o <= 1'b0;

                    if (!ctrl_written_q) begin
                        paddr_o  <= cfg_addr_next;
                        pwdata_o <= cfg_data_next;
                    end else begin
                        paddr_o  <= APB_ADDR_CTRL;
                        pwdata_o <= 32'h0000_0001;
                    end

                    state_q <= ST_ENABLE;
                end

                ST_ENABLE: begin
                    // ACCESS phase: hold psel/penable asserted on the bus. The
                    // registered penable_o only reaches the slave one cycle after
                    // we leave ST_SETUP, so sampling pready_i must wait until
                    // penable_o is actually high on the bus (penable_o == 1).
                    // Otherwise penable would be cleared the same cycle it is set
                    // and apb_write_fire (psel & penable & pwrite) never asserts.
                    psel_o    <= 1'b1;
                    penable_o <= 1'b1;

                    if (penable_o && pready_i) begin
                        psel_o    <= 1'b0;
                        penable_o <= 1'b0;

                        if (!ctrl_written_q) begin
                            if (cfg_idx_q == CFG_ENTRY_NUM-1) begin
                                ctrl_written_q <= 1'b1;
                            end else begin
                                cfg_idx_q <= cfg_idx_q + 1'b1;
                            end
                            state_q <= ST_SETUP;
                        end else begin
                            init_done_o <= 1'b1;
                            state_q     <= ST_DONE;
                        end
                    end
                end

                default: begin
                    psel_o     <= 1'b0;
                    penable_o  <= 1'b0;
                    init_done_o <= 1'b1;
                    state_q    <= ST_DONE;
                end
            endcase
        end
    end

endmodule
