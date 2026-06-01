// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.3 (win64) Build 2018833 Wed Oct  4 19:58:22 MDT 2017
// Date        : Wed May 20 16:08:32 2026
// Host        : Icer running 64-bit major release  (build 9200)
// Command     : write_verilog -force {C:/Users/qigua/OneDrive/Desktop/MIPI
//               ALL/fpga/vivado/reports/mipi_csi2_capture_fpga_timing_cdc_v2/mipi_csi2_capture_fpga_timing_cdc_v2_synth_netlist.v}
// Design      : mipi_csi2_capture_fpga_wrapper
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu9eg-ffvb1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module async_fifo
   (\wr_ptr_bin_reg[3]_0 ,
    crc_error_reg,
    rd_data,
    crc_error_reg_0,
    D,
    crc_error_reg_1,
    \crc_calc_reg[15] ,
    \rd_ptr_bin_reg[3]_0 ,
    merge_byte_valid,
    Q,
    \crc_calc_reg[15]_0 ,
    clk_wr,
    wr_data,
    resync_toggle_byte_d_reg,
    resync_req_o_reg,
    clk_sys_IBUF_BUFG,
    \FSM_onehot_state_reg[3] );
  output \wr_ptr_bin_reg[3]_0 ;
  output crc_error_reg;
  output [7:0]rd_data;
  output crc_error_reg_0;
  output [3:0]D;
  output crc_error_reg_1;
  output [2:0]\crc_calc_reg[15] ;
  output \rd_ptr_bin_reg[3]_0 ;
  input merge_byte_valid;
  input [7:0]Q;
  input [0:0]\crc_calc_reg[15]_0 ;
  input clk_wr;
  input [7:0]wr_data;
  input resync_toggle_byte_d_reg;
  input resync_req_o_reg;
  input clk_sys_IBUF_BUFG;
  input \FSM_onehot_state_reg[3] ;

  wire \<const0> ;
  wire \<const1> ;
  wire [3:0]D;
  wire \FSM_onehot_state_reg[3] ;
  wire [7:0]Q;
  wire [3:1]bin_to_gray0_return;
  wire [3:1]bin_to_gray_return;
  wire [4:0]bin_value;
  wire [4:4]bin_value0_in;
  wire [3:0]bin_value0_in__0;
  wire clk_sys_IBUF_BUFG;
  wire clk_wr;
  wire [2:0]\crc_calc_reg[15] ;
  wire [0:0]\crc_calc_reg[15]_0 ;
  wire crc_error_reg;
  wire crc_error_reg_0;
  wire crc_error_reg_1;
  wire merge_byte_valid;
  wire p_1_in;
  wire [7:0]rd_data;
  wire [3:0]rd_ptr_bin_reg;
  wire \rd_ptr_bin_reg[3]_0 ;
  wire [4:0]rd_ptr_gray;
  wire \rd_ptr_gray[0]_i_1__0_n_0 ;
  wire \rd_ptr_gray[3]_i_6_n_0 ;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [4:0]rd_ptr_gray_wrclk_ff1;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [4:0]rd_ptr_gray_wrclk_ff2;
  wire resync_req_o_reg;
  wire resync_toggle_byte_d_reg;
  wire [7:0]wr_data;
  wire \wr_ptr_bin_reg[3]_0 ;
  wire [3:0]wr_ptr_bin_reg__0;
  wire [4:0]wr_ptr_gray;
  wire \wr_ptr_gray[0]_i_1_n_0 ;
  wire \wr_ptr_gray[3]_i_3_n_0 ;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [4:0]wr_ptr_gray_rdclk_ff1;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [4:0]wr_ptr_gray_rdclk_ff2;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT2 #(
    .INIT(4'h6)) 
    \crc_calc[11]_i_1 
       (.I0(rd_data[3]),
        .I1(Q[3]),
        .O(\crc_calc_reg[15] [0]));
  LUT4 #(
    .INIT(16'h6996)) 
    \crc_calc[12]_i_1 
       (.I0(rd_data[4]),
        .I1(Q[4]),
        .I2(rd_data[0]),
        .I3(Q[0]),
        .O(\crc_calc_reg[15] [1]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \crc_calc[15]_i_2 
       (.I0(rd_data[7]),
        .I1(Q[7]),
        .I2(rd_data[3]),
        .I3(Q[3]),
        .O(\crc_calc_reg[15] [2]));
  LUT2 #(
    .INIT(4'h6)) 
    crc_error_i_19
       (.I0(rd_data[7]),
        .I1(\crc_calc_reg[15]_0 ),
        .O(crc_error_reg_1));
  LUT6 #(
    .INIT(64'h9669699669969669)) 
    crc_error_i_36
       (.I0(rd_data[6]),
        .I1(Q[6]),
        .I2(rd_data[2]),
        .I3(Q[2]),
        .I4(Q[1]),
        .I5(rd_data[1]),
        .O(crc_error_reg_0));
  LUT6 #(
    .INIT(64'h9669699669969669)) 
    crc_error_i_51
       (.I0(rd_data[7]),
        .I1(Q[7]),
        .I2(rd_data[3]),
        .I3(Q[3]),
        .I4(Q[2]),
        .I5(rd_data[2]),
        .O(crc_error_reg));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \crc_reg[10]_i_1 
       (.I0(rd_data[2]),
        .I1(Q[2]),
        .I2(Q[3]),
        .I3(rd_data[3]),
        .I4(Q[7]),
        .I5(rd_data[7]),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \crc_reg[11]_i_1 
       (.I0(rd_data[3]),
        .I1(Q[3]),
        .O(D[3]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \crc_reg[8]_i_1 
       (.I0(rd_data[5]),
        .I1(rd_data[1]),
        .I2(Q[1]),
        .I3(Q[5]),
        .I4(rd_data[0]),
        .I5(Q[0]),
        .O(D[0]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \crc_reg[9]_i_1 
       (.I0(rd_data[1]),
        .I1(Q[1]),
        .I2(Q[2]),
        .I3(rd_data[2]),
        .I4(Q[6]),
        .I5(rd_data[6]),
        .O(D[1]));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  RAM32M16 #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000),
    .INIT_E(64'h0000000000000000),
    .INIT_F(64'h0000000000000000),
    .INIT_G(64'h0000000000000000),
    .INIT_H(64'h0000000000000000)) 
    mem_reg_0_15_0_5
       (.ADDRA({\<const0> ,rd_ptr_bin_reg}),
        .ADDRB({\<const0> ,rd_ptr_bin_reg}),
        .ADDRC({\<const0> ,rd_ptr_bin_reg}),
        .ADDRD({\<const0> ,rd_ptr_bin_reg}),
        .ADDRE({\<const0> ,rd_ptr_bin_reg}),
        .ADDRF({\<const0> ,rd_ptr_bin_reg}),
        .ADDRG({\<const0> ,rd_ptr_bin_reg}),
        .ADDRH({\<const0> ,wr_ptr_bin_reg__0}),
        .DIA(wr_data[1:0]),
        .DIB(wr_data[3:2]),
        .DIC(wr_data[5:4]),
        .DID(wr_data[7:6]),
        .DIE({\<const0> ,\<const0> }),
        .DIF({\<const0> ,\<const0> }),
        .DIG({\<const0> ,\<const0> }),
        .DIH({\<const0> ,\<const0> }),
        .DOA(rd_data[1:0]),
        .DOB(rd_data[3:2]),
        .DOC(rd_data[5:4]),
        .DOD(rd_data[7:6]),
        .WCLK(clk_wr),
        .WE(p_1_in));
  LUT2 #(
    .INIT(4'h2)) 
    mem_reg_0_15_0_5_i_1
       (.I0(\wr_ptr_bin_reg[3]_0 ),
        .I1(resync_toggle_byte_d_reg),
        .O(p_1_in));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \rd_ptr_bin[0]_i_1 
       (.I0(rd_ptr_bin_reg[0]),
        .O(bin_value[0]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_ptr_bin[1]_i_1 
       (.I0(rd_ptr_bin_reg[0]),
        .I1(rd_ptr_bin_reg[1]),
        .O(bin_value[1]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rd_ptr_bin[2]_i_1 
       (.I0(rd_ptr_bin_reg[0]),
        .I1(rd_ptr_bin_reg[1]),
        .I2(rd_ptr_bin_reg[2]),
        .O(bin_value[2]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \rd_ptr_bin[3]_i_1 
       (.I0(rd_ptr_bin_reg[1]),
        .I1(rd_ptr_bin_reg[0]),
        .I2(rd_ptr_bin_reg[2]),
        .I3(rd_ptr_bin_reg[3]),
        .O(bin_value[3]));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_bin_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_onehot_state_reg[3] ),
        .D(bin_value[0]),
        .Q(rd_ptr_bin_reg[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_bin_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_onehot_state_reg[3] ),
        .D(bin_value[1]),
        .Q(rd_ptr_bin_reg[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_bin_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_onehot_state_reg[3] ),
        .D(bin_value[2]),
        .Q(rd_ptr_bin_reg[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_bin_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_onehot_state_reg[3] ),
        .D(bin_value[3]),
        .Q(rd_ptr_bin_reg[3]),
        .R(resync_req_o_reg));
  LUT1 #(
    .INIT(2'h1)) 
    \rd_ptr_gray[0]_i_1__0 
       (.I0(rd_ptr_bin_reg[1]),
        .O(\rd_ptr_gray[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h56)) 
    \rd_ptr_gray[1]_i_1 
       (.I0(rd_ptr_bin_reg[2]),
        .I1(rd_ptr_bin_reg[1]),
        .I2(rd_ptr_bin_reg[0]),
        .O(bin_to_gray0_return[1]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h5666)) 
    \rd_ptr_gray[2]_i_1 
       (.I0(rd_ptr_bin_reg[3]),
        .I1(rd_ptr_bin_reg[2]),
        .I2(rd_ptr_bin_reg[1]),
        .I3(rd_ptr_bin_reg[0]),
        .O(bin_to_gray0_return[2]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h56666666)) 
    \rd_ptr_gray[3]_i_2 
       (.I0(rd_ptr_gray[4]),
        .I1(rd_ptr_bin_reg[3]),
        .I2(rd_ptr_bin_reg[2]),
        .I3(rd_ptr_bin_reg[0]),
        .I4(rd_ptr_bin_reg[1]),
        .O(bin_to_gray0_return[3]));
  LUT5 #(
    .INIT(32'h90000090)) 
    \rd_ptr_gray[3]_i_4 
       (.I0(rd_ptr_gray[3]),
        .I1(wr_ptr_gray_rdclk_ff2[3]),
        .I2(\rd_ptr_gray[3]_i_6_n_0 ),
        .I3(wr_ptr_gray_rdclk_ff2[4]),
        .I4(rd_ptr_gray[4]),
        .O(\rd_ptr_bin_reg[3]_0 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \rd_ptr_gray[3]_i_6 
       (.I0(rd_ptr_gray[0]),
        .I1(wr_ptr_gray_rdclk_ff2[0]),
        .I2(wr_ptr_gray_rdclk_ff2[2]),
        .I3(rd_ptr_gray[2]),
        .I4(wr_ptr_gray_rdclk_ff2[1]),
        .I5(rd_ptr_gray[1]),
        .O(\rd_ptr_gray[3]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \rd_ptr_gray[4]_i_1 
       (.I0(rd_ptr_bin_reg[2]),
        .I1(rd_ptr_bin_reg[0]),
        .I2(rd_ptr_bin_reg[1]),
        .I3(rd_ptr_bin_reg[3]),
        .I4(rd_ptr_gray[4]),
        .O(bin_value[4]));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_onehot_state_reg[3] ),
        .D(\rd_ptr_gray[0]_i_1__0_n_0 ),
        .Q(rd_ptr_gray[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_onehot_state_reg[3] ),
        .D(bin_to_gray0_return[1]),
        .Q(rd_ptr_gray[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_onehot_state_reg[3] ),
        .D(bin_to_gray0_return[2]),
        .Q(rd_ptr_gray[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_onehot_state_reg[3] ),
        .D(bin_to_gray0_return[3]),
        .Q(rd_ptr_gray[3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_onehot_state_reg[3] ),
        .D(bin_value[4]),
        .Q(rd_ptr_gray[4]),
        .R(resync_req_o_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[0] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(rd_ptr_gray[0]),
        .Q(rd_ptr_gray_wrclk_ff1[0]),
        .R(resync_toggle_byte_d_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[1] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(rd_ptr_gray[1]),
        .Q(rd_ptr_gray_wrclk_ff1[1]),
        .R(resync_toggle_byte_d_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[2] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(rd_ptr_gray[2]),
        .Q(rd_ptr_gray_wrclk_ff1[2]),
        .R(resync_toggle_byte_d_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[3] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(rd_ptr_gray[3]),
        .Q(rd_ptr_gray_wrclk_ff1[3]),
        .R(resync_toggle_byte_d_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[4] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(rd_ptr_gray[4]),
        .Q(rd_ptr_gray_wrclk_ff1[4]),
        .R(resync_toggle_byte_d_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[0] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[0]),
        .Q(rd_ptr_gray_wrclk_ff2[0]),
        .R(resync_toggle_byte_d_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[1] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[1]),
        .Q(rd_ptr_gray_wrclk_ff2[1]),
        .R(resync_toggle_byte_d_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[2] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[2]),
        .Q(rd_ptr_gray_wrclk_ff2[2]),
        .R(resync_toggle_byte_d_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[3] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[3]),
        .Q(rd_ptr_gray_wrclk_ff2[3]),
        .R(resync_toggle_byte_d_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[4] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[4]),
        .Q(rd_ptr_gray_wrclk_ff2[4]),
        .R(resync_toggle_byte_d_reg));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \wr_ptr_bin[0]_i_1 
       (.I0(wr_ptr_bin_reg__0[0]),
        .O(bin_value0_in__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_ptr_bin[1]_i_1 
       (.I0(wr_ptr_bin_reg__0[0]),
        .I1(wr_ptr_bin_reg__0[1]),
        .O(bin_value0_in__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \wr_ptr_bin[2]_i_1 
       (.I0(wr_ptr_bin_reg__0[0]),
        .I1(wr_ptr_bin_reg__0[1]),
        .I2(wr_ptr_bin_reg__0[2]),
        .O(bin_value0_in__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \wr_ptr_bin[3]_i_1 
       (.I0(wr_ptr_bin_reg__0[1]),
        .I1(wr_ptr_bin_reg__0[0]),
        .I2(wr_ptr_bin_reg__0[2]),
        .I3(wr_ptr_bin_reg__0[3]),
        .O(bin_value0_in__0[3]));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_bin_reg[0] 
       (.C(clk_wr),
        .CE(\wr_ptr_bin_reg[3]_0 ),
        .D(bin_value0_in__0[0]),
        .Q(wr_ptr_bin_reg__0[0]),
        .R(resync_toggle_byte_d_reg));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_bin_reg[1] 
       (.C(clk_wr),
        .CE(\wr_ptr_bin_reg[3]_0 ),
        .D(bin_value0_in__0[1]),
        .Q(wr_ptr_bin_reg__0[1]),
        .R(resync_toggle_byte_d_reg));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_bin_reg[2] 
       (.C(clk_wr),
        .CE(\wr_ptr_bin_reg[3]_0 ),
        .D(bin_value0_in__0[2]),
        .Q(wr_ptr_bin_reg__0[2]),
        .R(resync_toggle_byte_d_reg));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_bin_reg[3] 
       (.C(clk_wr),
        .CE(\wr_ptr_bin_reg[3]_0 ),
        .D(bin_value0_in__0[3]),
        .Q(wr_ptr_bin_reg__0[3]),
        .R(resync_toggle_byte_d_reg));
  LUT1 #(
    .INIT(2'h1)) 
    \wr_ptr_gray[0]_i_1 
       (.I0(wr_ptr_bin_reg__0[1]),
        .O(\wr_ptr_gray[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h56)) 
    \wr_ptr_gray[1]_i_1 
       (.I0(wr_ptr_bin_reg__0[2]),
        .I1(wr_ptr_bin_reg__0[1]),
        .I2(wr_ptr_bin_reg__0[0]),
        .O(bin_to_gray_return[1]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'h5666)) 
    \wr_ptr_gray[2]_i_1 
       (.I0(wr_ptr_bin_reg__0[3]),
        .I1(wr_ptr_bin_reg__0[2]),
        .I2(wr_ptr_bin_reg__0[1]),
        .I3(wr_ptr_bin_reg__0[0]),
        .O(bin_to_gray_return[2]));
  LUT6 #(
    .INIT(64'hAAAA82AA82AAAAAA)) 
    \wr_ptr_gray[3]_i_1 
       (.I0(merge_byte_valid),
        .I1(wr_ptr_gray[4]),
        .I2(rd_ptr_gray_wrclk_ff2[4]),
        .I3(\wr_ptr_gray[3]_i_3_n_0 ),
        .I4(rd_ptr_gray_wrclk_ff2[3]),
        .I5(wr_ptr_gray[3]),
        .O(\wr_ptr_bin_reg[3]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'h56666666)) 
    \wr_ptr_gray[3]_i_2 
       (.I0(wr_ptr_gray[4]),
        .I1(wr_ptr_bin_reg__0[3]),
        .I2(wr_ptr_bin_reg__0[2]),
        .I3(wr_ptr_bin_reg__0[0]),
        .I4(wr_ptr_bin_reg__0[1]),
        .O(bin_to_gray_return[3]));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \wr_ptr_gray[3]_i_3 
       (.I0(wr_ptr_gray[0]),
        .I1(rd_ptr_gray_wrclk_ff2[0]),
        .I2(rd_ptr_gray_wrclk_ff2[2]),
        .I3(wr_ptr_gray[2]),
        .I4(rd_ptr_gray_wrclk_ff2[1]),
        .I5(wr_ptr_gray[1]),
        .O(\wr_ptr_gray[3]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \wr_ptr_gray[4]_i_1 
       (.I0(wr_ptr_bin_reg__0[2]),
        .I1(wr_ptr_bin_reg__0[0]),
        .I2(wr_ptr_bin_reg__0[1]),
        .I3(wr_ptr_bin_reg__0[3]),
        .I4(wr_ptr_gray[4]),
        .O(bin_value0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray[0]),
        .Q(wr_ptr_gray_rdclk_ff1[0]),
        .R(resync_req_o_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray[1]),
        .Q(wr_ptr_gray_rdclk_ff1[1]),
        .R(resync_req_o_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray[2]),
        .Q(wr_ptr_gray_rdclk_ff1[2]),
        .R(resync_req_o_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray[3]),
        .Q(wr_ptr_gray_rdclk_ff1[3]),
        .R(resync_req_o_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray[4]),
        .Q(wr_ptr_gray_rdclk_ff1[4]),
        .R(resync_req_o_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[0]),
        .Q(wr_ptr_gray_rdclk_ff2[0]),
        .R(resync_req_o_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[1]),
        .Q(wr_ptr_gray_rdclk_ff2[1]),
        .R(resync_req_o_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[2]),
        .Q(wr_ptr_gray_rdclk_ff2[2]),
        .R(resync_req_o_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[3]),
        .Q(wr_ptr_gray_rdclk_ff2[3]),
        .R(resync_req_o_reg));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[4]),
        .Q(wr_ptr_gray_rdclk_ff2[4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_reg[0] 
       (.C(clk_wr),
        .CE(\wr_ptr_bin_reg[3]_0 ),
        .D(\wr_ptr_gray[0]_i_1_n_0 ),
        .Q(wr_ptr_gray[0]),
        .R(resync_toggle_byte_d_reg));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_reg[1] 
       (.C(clk_wr),
        .CE(\wr_ptr_bin_reg[3]_0 ),
        .D(bin_to_gray_return[1]),
        .Q(wr_ptr_gray[1]),
        .R(resync_toggle_byte_d_reg));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_reg[2] 
       (.C(clk_wr),
        .CE(\wr_ptr_bin_reg[3]_0 ),
        .D(bin_to_gray_return[2]),
        .Q(wr_ptr_gray[2]),
        .R(resync_toggle_byte_d_reg));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_reg[3] 
       (.C(clk_wr),
        .CE(\wr_ptr_bin_reg[3]_0 ),
        .D(bin_to_gray_return[3]),
        .Q(wr_ptr_gray[3]),
        .R(resync_toggle_byte_d_reg));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_reg[4] 
       (.C(clk_wr),
        .CE(\wr_ptr_bin_reg[3]_0 ),
        .D(bin_value0_in),
        .Q(wr_ptr_gray[4]),
        .R(resync_toggle_byte_d_reg));
endmodule

(* ORIG_REF_NAME = "async_fifo" *) 
module async_fifo__parameterized0
   (SR,
    data_fifo_rd_valid,
    E,
    clk_axi_IBUF_BUFG,
    data_fifo_clear_wr_sys,
    rst_n_IBUF,
    data_fifo_clear_rd_axi,
    clk_sys_IBUF_BUFG);
  output [0:0]SR;
  output data_fifo_rd_valid;
  input [0:0]E;
  input clk_axi_IBUF_BUFG;
  input data_fifo_clear_wr_sys;
  input rst_n_IBUF;
  input data_fifo_clear_rd_axi;
  input clk_sys_IBUF_BUFG;

  wire \<const0> ;
  wire \<const1> ;
  wire [0:0]E;
  wire [0:0]SR;
  wire [5:0]bin_to_gray1_return;
  wire [6:6]bin_value;
  wire [5:0]bin_value__0;
  wire clk_axi_IBUF_BUFG;
  wire clk_sys_IBUF_BUFG;
  wire data_fifo_clear_rd_axi;
  wire data_fifo_clear_wr_sys;
  wire data_fifo_rd_valid;
  wire [5:0]rd_ptr_bin_reg;
  wire [6:0]rd_ptr_gray;
  wire \rd_ptr_gray[5]_i_5_n_0 ;
  wire \rd_ptr_gray[5]_i_6_n_0 ;
  wire \rd_ptr_gray[5]_i_7_n_0 ;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [6:0]rd_ptr_gray_wrclk_ff1;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [6:0]rd_ptr_gray_wrclk_ff2;
  wire rst_n_IBUF;
  wire wr_ptr_bin0;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [6:0]wr_ptr_gray_rdclk_ff1;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [6:0]wr_ptr_gray_rdclk_ff2;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT1 #(
    .INIT(2'h1)) 
    \rd_ptr_bin[0]_i_1__0 
       (.I0(rd_ptr_bin_reg[0]),
        .O(bin_value__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_ptr_bin[1]_i_1__0 
       (.I0(rd_ptr_bin_reg[0]),
        .I1(rd_ptr_bin_reg[1]),
        .O(bin_value__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rd_ptr_bin[2]_i_1__0 
       (.I0(rd_ptr_bin_reg[0]),
        .I1(rd_ptr_bin_reg[1]),
        .I2(rd_ptr_bin_reg[2]),
        .O(bin_value__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \rd_ptr_bin[3]_i_1__0 
       (.I0(rd_ptr_bin_reg[1]),
        .I1(rd_ptr_bin_reg[0]),
        .I2(rd_ptr_bin_reg[2]),
        .I3(rd_ptr_bin_reg[3]),
        .O(bin_value__0[3]));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT5 #(
    .INIT(32'h7FFF8000)) 
    \rd_ptr_bin[4]_i_1 
       (.I0(rd_ptr_bin_reg[2]),
        .I1(rd_ptr_bin_reg[0]),
        .I2(rd_ptr_bin_reg[1]),
        .I3(rd_ptr_bin_reg[3]),
        .I4(rd_ptr_bin_reg[4]),
        .O(bin_value__0[4]));
  LUT6 #(
    .INIT(64'h7FFFFFFF80000000)) 
    \rd_ptr_bin[5]_i_1 
       (.I0(rd_ptr_bin_reg[3]),
        .I1(rd_ptr_bin_reg[1]),
        .I2(rd_ptr_bin_reg[0]),
        .I3(rd_ptr_bin_reg[2]),
        .I4(rd_ptr_bin_reg[4]),
        .I5(rd_ptr_bin_reg[5]),
        .O(bin_value__0[5]));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_bin_reg[0] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(E),
        .D(bin_value__0[0]),
        .Q(rd_ptr_bin_reg[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_bin_reg[1] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(E),
        .D(bin_value__0[1]),
        .Q(rd_ptr_bin_reg[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_bin_reg[2] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(E),
        .D(bin_value__0[2]),
        .Q(rd_ptr_bin_reg[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_bin_reg[3] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(E),
        .D(bin_value__0[3]),
        .Q(rd_ptr_bin_reg[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_bin_reg[4] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(E),
        .D(bin_value__0[4]),
        .Q(rd_ptr_bin_reg[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_bin_reg[5] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(E),
        .D(bin_value__0[5]),
        .Q(rd_ptr_bin_reg[5]),
        .R(SR));
  LUT1 #(
    .INIT(2'h1)) 
    \rd_ptr_gray[0]_i_1 
       (.I0(rd_ptr_bin_reg[1]),
        .O(bin_to_gray1_return[0]));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT3 #(
    .INIT(8'h56)) 
    \rd_ptr_gray[1]_i_1__0 
       (.I0(rd_ptr_bin_reg[2]),
        .I1(rd_ptr_bin_reg[1]),
        .I2(rd_ptr_bin_reg[0]),
        .O(bin_to_gray1_return[1]));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT4 #(
    .INIT(16'h5666)) 
    \rd_ptr_gray[2]_i_1__0 
       (.I0(rd_ptr_bin_reg[3]),
        .I1(rd_ptr_bin_reg[2]),
        .I2(rd_ptr_bin_reg[1]),
        .I3(rd_ptr_bin_reg[0]),
        .O(bin_to_gray1_return[2]));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT5 #(
    .INIT(32'h56666666)) 
    \rd_ptr_gray[3]_i_1 
       (.I0(rd_ptr_bin_reg[4]),
        .I1(rd_ptr_bin_reg[3]),
        .I2(rd_ptr_bin_reg[2]),
        .I3(rd_ptr_bin_reg[0]),
        .I4(rd_ptr_bin_reg[1]),
        .O(bin_to_gray1_return[3]));
  LUT6 #(
    .INIT(64'h5666666666666666)) 
    \rd_ptr_gray[4]_i_1__0 
       (.I0(rd_ptr_bin_reg[5]),
        .I1(rd_ptr_bin_reg[4]),
        .I2(rd_ptr_bin_reg[3]),
        .I3(rd_ptr_bin_reg[1]),
        .I4(rd_ptr_bin_reg[0]),
        .I5(rd_ptr_bin_reg[2]),
        .O(bin_to_gray1_return[4]));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT3 #(
    .INIT(8'h56)) 
    \rd_ptr_gray[5]_i_2 
       (.I0(rd_ptr_gray[6]),
        .I1(rd_ptr_bin_reg[5]),
        .I2(\rd_ptr_gray[5]_i_5_n_0 ),
        .O(bin_to_gray1_return[5]));
  LUT6 #(
    .INIT(64'hFFFFFFFFBEFFFFBE)) 
    \rd_ptr_gray[5]_i_4 
       (.I0(\rd_ptr_gray[5]_i_6_n_0 ),
        .I1(rd_ptr_gray[4]),
        .I2(wr_ptr_gray_rdclk_ff2[4]),
        .I3(rd_ptr_gray[3]),
        .I4(wr_ptr_gray_rdclk_ff2[3]),
        .I5(\rd_ptr_gray[5]_i_7_n_0 ),
        .O(data_fifo_rd_valid));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \rd_ptr_gray[5]_i_5 
       (.I0(rd_ptr_bin_reg[4]),
        .I1(rd_ptr_bin_reg[2]),
        .I2(rd_ptr_bin_reg[0]),
        .I3(rd_ptr_bin_reg[1]),
        .I4(rd_ptr_bin_reg[3]),
        .O(\rd_ptr_gray[5]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h6FF6)) 
    \rd_ptr_gray[5]_i_6 
       (.I0(rd_ptr_gray[2]),
        .I1(wr_ptr_gray_rdclk_ff2[2]),
        .I2(rd_ptr_gray[6]),
        .I3(wr_ptr_gray_rdclk_ff2[6]),
        .O(\rd_ptr_gray[5]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    \rd_ptr_gray[5]_i_7 
       (.I0(wr_ptr_gray_rdclk_ff2[0]),
        .I1(rd_ptr_gray[0]),
        .I2(wr_ptr_gray_rdclk_ff2[1]),
        .I3(rd_ptr_gray[1]),
        .I4(rd_ptr_gray[5]),
        .I5(wr_ptr_gray_rdclk_ff2[5]),
        .O(\rd_ptr_gray[5]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rd_ptr_gray[6]_i_1 
       (.I0(\rd_ptr_gray[5]_i_5_n_0 ),
        .I1(rd_ptr_bin_reg[5]),
        .I2(rd_ptr_gray[6]),
        .O(bin_value));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_reg[0] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(E),
        .D(bin_to_gray1_return[0]),
        .Q(rd_ptr_gray[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_reg[1] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(E),
        .D(bin_to_gray1_return[1]),
        .Q(rd_ptr_gray[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_reg[2] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(E),
        .D(bin_to_gray1_return[2]),
        .Q(rd_ptr_gray[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_reg[3] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(E),
        .D(bin_to_gray1_return[3]),
        .Q(rd_ptr_gray[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_reg[4] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(E),
        .D(bin_to_gray1_return[4]),
        .Q(rd_ptr_gray[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_reg[5] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(E),
        .D(bin_to_gray1_return[5]),
        .Q(rd_ptr_gray[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_reg[6] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(E),
        .D(bin_value),
        .Q(rd_ptr_gray[6]),
        .R(SR));
  LUT2 #(
    .INIT(4'hB)) 
    \rd_ptr_gray_wrclk_ff1[6]_i_1 
       (.I0(data_fifo_clear_wr_sys),
        .I1(rst_n_IBUF),
        .O(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray[0]),
        .Q(rd_ptr_gray_wrclk_ff1[0]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray[1]),
        .Q(rd_ptr_gray_wrclk_ff1[1]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray[2]),
        .Q(rd_ptr_gray_wrclk_ff1[2]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray[3]),
        .Q(rd_ptr_gray_wrclk_ff1[3]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray[4]),
        .Q(rd_ptr_gray_wrclk_ff1[4]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray[5]),
        .Q(rd_ptr_gray_wrclk_ff1[5]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray[6]),
        .Q(rd_ptr_gray_wrclk_ff1[6]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[0]),
        .Q(rd_ptr_gray_wrclk_ff2[0]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[1]),
        .Q(rd_ptr_gray_wrclk_ff2[1]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[2]),
        .Q(rd_ptr_gray_wrclk_ff2[2]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[3]),
        .Q(rd_ptr_gray_wrclk_ff2[3]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[4]),
        .Q(rd_ptr_gray_wrclk_ff2[4]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[5]),
        .Q(rd_ptr_gray_wrclk_ff2[5]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[6]),
        .Q(rd_ptr_gray_wrclk_ff2[6]),
        .R(wr_ptr_bin0));
  LUT2 #(
    .INIT(4'hB)) 
    \wr_ptr_gray_rdclk_ff1[6]_i_1 
       (.I0(data_fifo_clear_rd_axi),
        .I1(rst_n_IBUF),
        .O(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[0] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(wr_ptr_gray_rdclk_ff1[0]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[1] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(wr_ptr_gray_rdclk_ff1[1]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[2] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(wr_ptr_gray_rdclk_ff1[2]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[3] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(wr_ptr_gray_rdclk_ff1[3]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[4] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(wr_ptr_gray_rdclk_ff1[4]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[5] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(wr_ptr_gray_rdclk_ff1[5]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[6] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(wr_ptr_gray_rdclk_ff1[6]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[0] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[0]),
        .Q(wr_ptr_gray_rdclk_ff2[0]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[1] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[1]),
        .Q(wr_ptr_gray_rdclk_ff2[1]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[2] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[2]),
        .Q(wr_ptr_gray_rdclk_ff2[2]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[3] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[3]),
        .Q(wr_ptr_gray_rdclk_ff2[3]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[4] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[4]),
        .Q(wr_ptr_gray_rdclk_ff2[4]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[5] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[5]),
        .Q(wr_ptr_gray_rdclk_ff2[5]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[6] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[6]),
        .Q(wr_ptr_gray_rdclk_ff2[6]),
        .R(SR));
endmodule

(* ORIG_REF_NAME = "async_fifo" *) 
module async_fifo__parameterized1
   (data_fifo_clear_wr_sys,
    rst_n_IBUF,
    SR,
    clk_axi_IBUF_BUFG,
    clk_sys_IBUF_BUFG);
  input data_fifo_clear_wr_sys;
  input rst_n_IBUF;
  input [0:0]SR;
  input clk_axi_IBUF_BUFG;
  input clk_sys_IBUF_BUFG;

  wire \<const0> ;
  wire \<const1> ;
  wire [0:0]SR;
  wire clk_axi_IBUF_BUFG;
  wire clk_sys_IBUF_BUFG;
  wire data_fifo_clear_wr_sys;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [3:0]rd_ptr_gray_wrclk_ff1;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [3:0]rd_ptr_gray_wrclk_ff2;
  wire rst_n_IBUF;
  wire wr_ptr_bin0;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [3:0]wr_ptr_gray_rdclk_ff1;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [3:0]wr_ptr_gray_rdclk_ff2;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT2 #(
    .INIT(4'hB)) 
    \rd_ptr_gray_wrclk_ff1[3]_i_1 
       (.I0(data_fifo_clear_wr_sys),
        .I1(rst_n_IBUF),
        .O(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(rd_ptr_gray_wrclk_ff1[0]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(rd_ptr_gray_wrclk_ff1[1]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(rd_ptr_gray_wrclk_ff1[2]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff1_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(rd_ptr_gray_wrclk_ff1[3]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[0]),
        .Q(rd_ptr_gray_wrclk_ff2[0]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[1]),
        .Q(rd_ptr_gray_wrclk_ff2[1]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[2]),
        .Q(rd_ptr_gray_wrclk_ff2[2]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_gray_wrclk_ff2_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(rd_ptr_gray_wrclk_ff1[3]),
        .Q(rd_ptr_gray_wrclk_ff2[3]),
        .R(wr_ptr_bin0));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[0] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(wr_ptr_gray_rdclk_ff1[0]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[1] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(wr_ptr_gray_rdclk_ff1[1]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[2] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(wr_ptr_gray_rdclk_ff1[2]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff1_reg[3] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(wr_ptr_gray_rdclk_ff1[3]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[0] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[0]),
        .Q(wr_ptr_gray_rdclk_ff2[0]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[1] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[1]),
        .Q(wr_ptr_gray_rdclk_ff2[1]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[2] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[2]),
        .Q(wr_ptr_gray_rdclk_ff2[2]),
        .R(SR));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_gray_rdclk_ff2_reg[3] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(wr_ptr_gray_rdclk_ff1[3]),
        .Q(wr_ptr_gray_rdclk_ff2[3]),
        .R(SR));
endmodule

module axi_write_master
   (clear_pending_axi_q_reg,
    Q,
    E,
    m_axi_wlast,
    clear_commit_toggle_axi0,
    D,
    \beats_remaining_q_reg[0] ,
    aw_seen_q_reg,
    s_axi_bvalid_o_reg,
    clear_commit_toggle_axi_reg,
    rst_n_IBUF,
    clear_req_sync2_d_axi,
    clear_req_sync2_axi,
    clear_pending_axi_q,
    s_axi_bvalid_o_reg_0,
    m_axi_wready,
    data_fifo_rd_valid,
    \beats_remaining_q_reg[0]_0 ,
    aw_seen_q_reg_0,
    aw_seen_q,
    m_axi_bvalid,
    clear_commit_toggle_axi,
    SR,
    clk_axi_IBUF_BUFG);
  output clear_pending_axi_q_reg;
  output [1:0]Q;
  output [0:0]E;
  output m_axi_wlast;
  output clear_commit_toggle_axi0;
  output [0:0]D;
  output \beats_remaining_q_reg[0] ;
  output aw_seen_q_reg;
  output s_axi_bvalid_o_reg;
  output clear_commit_toggle_axi_reg;
  input rst_n_IBUF;
  input clear_req_sync2_d_axi;
  input clear_req_sync2_axi;
  input clear_pending_axi_q;
  input s_axi_bvalid_o_reg_0;
  input m_axi_wready;
  input data_fifo_rd_valid;
  input [0:0]\beats_remaining_q_reg[0]_0 ;
  input aw_seen_q_reg_0;
  input aw_seen_q;
  input m_axi_bvalid;
  input clear_commit_toggle_axi;
  input [0:0]SR;
  input clk_axi_IBUF_BUFG;

  wire [0:0]D;
  wire [0:0]E;
  wire [1:0]Q;
  wire [0:0]SR;
  wire aw_seen_q;
  wire aw_seen_q_reg;
  wire aw_seen_q_reg_0;
  wire [8:0]beat_cnt;
  wire \beat_cnt[5]_i_2_n_0 ;
  wire \beat_cnt[8]_i_1_n_0 ;
  wire \beat_cnt[8]_i_3_n_0 ;
  wire \beat_cnt[8]_i_4_n_0 ;
  wire \beats_remaining_q_reg[0] ;
  wire [0:0]\beats_remaining_q_reg[0]_0 ;
  wire clear_commit_toggle_axi;
  wire clear_commit_toggle_axi0;
  wire clear_commit_toggle_axi_reg;
  wire clear_pending_axi_q;
  wire clear_pending_axi_q_reg;
  wire clear_req_sync2_axi;
  wire clear_req_sync2_d_axi;
  wire clk_axi_IBUF_BUFG;
  wire data_fifo_rd_valid;
  wire m_axi_bvalid;
  wire m_axi_wlast;
  wire m_axi_wready;
  wire p_0_in5_in;
  wire [8:0]p_2_in;
  wire rst_n_IBUF;
  wire s_axi_bvalid_o_reg;
  wire s_axi_bvalid_o_reg_0;
  wire [1:0]state;
  wire \state[1]_i_1_n_0 ;
  wire \state[1]_i_5_n_0 ;

  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT5 #(
    .INIT(32'h0000AA08)) 
    aw_seen_q_i_1
       (.I0(rst_n_IBUF),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(aw_seen_q_reg_0),
        .I4(aw_seen_q),
        .O(aw_seen_q_reg));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \beat_cnt[0]_i_1 
       (.I0(Q[1]),
        .I1(beat_cnt[0]),
        .O(p_2_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT3 #(
    .INIT(8'h48)) 
    \beat_cnt[1]_i_1 
       (.I0(beat_cnt[0]),
        .I1(Q[1]),
        .I2(beat_cnt[1]),
        .O(p_2_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT4 #(
    .INIT(16'h7080)) 
    \beat_cnt[2]_i_1 
       (.I0(beat_cnt[0]),
        .I1(beat_cnt[1]),
        .I2(Q[1]),
        .I3(beat_cnt[2]),
        .O(p_2_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT5 #(
    .INIT(32'h7F008000)) 
    \beat_cnt[3]_i_1 
       (.I0(beat_cnt[2]),
        .I1(beat_cnt[1]),
        .I2(beat_cnt[0]),
        .I3(Q[1]),
        .I4(beat_cnt[3]),
        .O(p_2_in[3]));
  LUT6 #(
    .INIT(64'h7FFF000080000000)) 
    \beat_cnt[4]_i_1 
       (.I0(beat_cnt[0]),
        .I1(beat_cnt[1]),
        .I2(beat_cnt[2]),
        .I3(beat_cnt[3]),
        .I4(Q[1]),
        .I5(beat_cnt[4]),
        .O(p_2_in[4]));
  LUT6 #(
    .INIT(64'hFF7F000000800000)) 
    \beat_cnt[5]_i_1 
       (.I0(beat_cnt[4]),
        .I1(beat_cnt[3]),
        .I2(beat_cnt[2]),
        .I3(\beat_cnt[5]_i_2_n_0 ),
        .I4(Q[1]),
        .I5(beat_cnt[5]),
        .O(p_2_in[5]));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \beat_cnt[5]_i_2 
       (.I0(beat_cnt[0]),
        .I1(beat_cnt[1]),
        .O(\beat_cnt[5]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT3 #(
    .INIT(8'h84)) 
    \beat_cnt[6]_i_1 
       (.I0(\beat_cnt[8]_i_4_n_0 ),
        .I1(Q[1]),
        .I2(beat_cnt[6]),
        .O(p_2_in[6]));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT4 #(
    .INIT(16'hD020)) 
    \beat_cnt[7]_i_1 
       (.I0(beat_cnt[6]),
        .I1(\beat_cnt[8]_i_4_n_0 ),
        .I2(Q[1]),
        .I3(beat_cnt[7]),
        .O(p_2_in[7]));
  LUT6 #(
    .INIT(64'hCCDFCCDDCCDDCCDD)) 
    \beat_cnt[8]_i_1 
       (.I0(Q[1]),
        .I1(\beat_cnt[8]_i_3_n_0 ),
        .I2(p_0_in5_in),
        .I3(Q[0]),
        .I4(m_axi_wready),
        .I5(data_fifo_rd_valid),
        .O(\beat_cnt[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT5 #(
    .INIT(32'hBF004000)) 
    \beat_cnt[8]_i_2 
       (.I0(\beat_cnt[8]_i_4_n_0 ),
        .I1(beat_cnt[6]),
        .I2(beat_cnt[7]),
        .I3(Q[1]),
        .I4(beat_cnt[8]),
        .O(p_2_in[8]));
  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT3 #(
    .INIT(8'h04)) 
    \beat_cnt[8]_i_3 
       (.I0(Q[1]),
        .I1(rst_n_IBUF),
        .I2(aw_seen_q_reg_0),
        .O(\beat_cnt[8]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \beat_cnt[8]_i_4 
       (.I0(beat_cnt[0]),
        .I1(beat_cnt[1]),
        .I2(beat_cnt[2]),
        .I3(beat_cnt[3]),
        .I4(beat_cnt[4]),
        .I5(beat_cnt[5]),
        .O(\beat_cnt[8]_i_4_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \beat_cnt_reg[0] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beat_cnt[8]_i_1_n_0 ),
        .D(p_2_in[0]),
        .Q(beat_cnt[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \beat_cnt_reg[1] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beat_cnt[8]_i_1_n_0 ),
        .D(p_2_in[1]),
        .Q(beat_cnt[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \beat_cnt_reg[2] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beat_cnt[8]_i_1_n_0 ),
        .D(p_2_in[2]),
        .Q(beat_cnt[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \beat_cnt_reg[3] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beat_cnt[8]_i_1_n_0 ),
        .D(p_2_in[3]),
        .Q(beat_cnt[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \beat_cnt_reg[4] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beat_cnt[8]_i_1_n_0 ),
        .D(p_2_in[4]),
        .Q(beat_cnt[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \beat_cnt_reg[5] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beat_cnt[8]_i_1_n_0 ),
        .D(p_2_in[5]),
        .Q(beat_cnt[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \beat_cnt_reg[6] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beat_cnt[8]_i_1_n_0 ),
        .D(p_2_in[6]),
        .Q(beat_cnt[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \beat_cnt_reg[7] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beat_cnt[8]_i_1_n_0 ),
        .D(p_2_in[7]),
        .Q(beat_cnt[7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \beat_cnt_reg[8] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beat_cnt[8]_i_1_n_0 ),
        .D(p_2_in[8]),
        .Q(beat_cnt[8]),
        .R(SR));
  LUT2 #(
    .INIT(4'hB)) 
    \beats_remaining_q[0]_i_1 
       (.I0(\beats_remaining_q_reg[0] ),
        .I1(\beats_remaining_q_reg[0]_0 ),
        .O(D));
  LUT6 #(
    .INIT(64'hFFFFFFFFF7FFFFFF)) 
    \beats_remaining_q[0]_i_2 
       (.I0(data_fifo_rd_valid),
        .I1(Q[1]),
        .I2(Q[0]),
        .I3(rst_n_IBUF),
        .I4(aw_seen_q_reg_0),
        .I5(m_axi_bvalid),
        .O(\beats_remaining_q_reg[0] ));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT4 #(
    .INIT(16'hFD02)) 
    clear_commit_toggle_axi_i_1
       (.I0(clear_pending_axi_q),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(clear_commit_toggle_axi),
        .O(clear_commit_toggle_axi_reg));
  LUT6 #(
    .INIT(64'hAA28AA28AA280028)) 
    clear_pending_axi_q_i_1
       (.I0(rst_n_IBUF),
        .I1(clear_req_sync2_d_axi),
        .I2(clear_req_sync2_axi),
        .I3(clear_pending_axi_q),
        .I4(Q[0]),
        .I5(Q[1]),
        .O(clear_pending_axi_q_reg));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT3 #(
    .INIT(8'h02)) 
    data_fifo_clear_rd_axi_i_1
       (.I0(clear_pending_axi_q),
        .I1(Q[0]),
        .I2(Q[1]),
        .O(clear_commit_toggle_axi0));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT5 #(
    .INIT(32'h00200000)) 
    \rd_ptr_gray[5]_i_1 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(m_axi_wready),
        .I3(clear_pending_axi_q),
        .I4(data_fifo_rd_valid),
        .O(E));
  LUT5 #(
    .INIT(32'h77F00000)) 
    s_axi_bvalid_o_i_1
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(aw_seen_q),
        .I3(m_axi_bvalid),
        .I4(rst_n_IBUF),
        .O(s_axi_bvalid_o_reg));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT3 #(
    .INIT(8'h40)) 
    s_axi_bvalid_o_i_4
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(p_0_in5_in),
        .O(m_axi_wlast));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT3 #(
    .INIT(8'h0B)) 
    \state[0]_i_1 
       (.I0(p_0_in5_in),
        .I1(Q[1]),
        .I2(Q[0]),
        .O(state[0]));
  LUT6 #(
    .INIT(64'hAAAAEAAAAAAAAAAA)) 
    \state[1]_i_1 
       (.I0(s_axi_bvalid_o_reg_0),
        .I1(p_0_in5_in),
        .I2(m_axi_wready),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(data_fifo_rd_valid),
        .O(\state[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT3 #(
    .INIT(8'h38)) 
    \state[1]_i_2 
       (.I0(p_0_in5_in),
        .I1(Q[1]),
        .I2(Q[0]),
        .O(state[1]));
  LUT4 #(
    .INIT(16'h8000)) 
    \state[1]_i_4 
       (.I0(\state[1]_i_5_n_0 ),
        .I1(beat_cnt[2]),
        .I2(beat_cnt[3]),
        .I3(beat_cnt[4]),
        .O(p_0_in5_in));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \state[1]_i_5 
       (.I0(beat_cnt[5]),
        .I1(beat_cnt[6]),
        .I2(beat_cnt[7]),
        .I3(beat_cnt[8]),
        .I4(beat_cnt[1]),
        .I5(beat_cnt[0]),
        .O(\state[1]_i_5_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \state_reg[0] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\state[1]_i_1_n_0 ),
        .D(state[0]),
        .Q(Q[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \state_reg[1] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\state[1]_i_1_n_0 ),
        .D(state[1]),
        .Q(Q[1]),
        .R(SR));
endmodule

module axi_write_null_slave
   (m_axi_bvalid,
    \beats_remaining_q_reg[0]_0 ,
    \state_reg[0] ,
    \beats_remaining_q_reg[1]_0 ,
    aw_seen_q,
    m_axi_wready,
    \state_reg[1] ,
    clk_axi_IBUF_BUFG,
    \state_reg[0]_0 ,
    Q,
    rst_n_IBUF,
    \state_reg[1]_0 ,
    m_axi_wlast,
    p_0_in,
    D);
  output m_axi_bvalid;
  output \beats_remaining_q_reg[0]_0 ;
  output \state_reg[0] ;
  output [0:0]\beats_remaining_q_reg[1]_0 ;
  output aw_seen_q;
  output m_axi_wready;
  input \state_reg[1] ;
  input clk_axi_IBUF_BUFG;
  input \state_reg[0]_0 ;
  input [1:0]Q;
  input rst_n_IBUF;
  input \state_reg[1]_0 ;
  input m_axi_wlast;
  input p_0_in;
  input [0:0]D;

  wire \<const0> ;
  wire \<const1> ;
  wire [0:0]D;
  wire [1:0]Q;
  wire aw_seen_q;
  wire [6:1]beats_remaining_q;
  wire \beats_remaining_q[1]_i_1_n_0 ;
  wire \beats_remaining_q[2]_i_1_n_0 ;
  wire \beats_remaining_q[3]_i_1_n_0 ;
  wire \beats_remaining_q[4]_i_1_n_0 ;
  wire \beats_remaining_q[5]_i_1_n_0 ;
  wire \beats_remaining_q[6]_i_1_n_0 ;
  wire \beats_remaining_q[6]_i_2_n_0 ;
  wire \beats_remaining_q[6]_i_3_n_0 ;
  wire \beats_remaining_q[6]_i_4_n_0 ;
  wire \beats_remaining_q_reg[0]_0 ;
  wire [0:0]\beats_remaining_q_reg[1]_0 ;
  wire clk_axi_IBUF_BUFG;
  wire m_axi_bvalid;
  wire m_axi_wlast;
  wire m_axi_wready;
  wire p_0_in;
  wire rst_n_IBUF;
  wire s_axi_bvalid_o_i_3_n_0;
  wire \state_reg[0] ;
  wire \state_reg[0]_0 ;
  wire \state_reg[1] ;
  wire \state_reg[1]_0 ;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  FDRE #(
    .INIT(1'b0)) 
    aw_seen_q_reg
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\state_reg[0]_0 ),
        .Q(\beats_remaining_q_reg[0]_0 ),
        .R(\<const0> ));
  LUT3 #(
    .INIT(8'h82)) 
    \beats_remaining_q[1]_i_1 
       (.I0(\beats_remaining_q[6]_i_3_n_0 ),
        .I1(beats_remaining_q[1]),
        .I2(\beats_remaining_q_reg[1]_0 ),
        .O(\beats_remaining_q[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hA802)) 
    \beats_remaining_q[2]_i_1 
       (.I0(\beats_remaining_q[6]_i_3_n_0 ),
        .I1(\beats_remaining_q_reg[1]_0 ),
        .I2(beats_remaining_q[1]),
        .I3(beats_remaining_q[2]),
        .O(\beats_remaining_q[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hAAA80002)) 
    \beats_remaining_q[3]_i_1 
       (.I0(\beats_remaining_q[6]_i_3_n_0 ),
        .I1(beats_remaining_q[2]),
        .I2(beats_remaining_q[1]),
        .I3(\beats_remaining_q_reg[1]_0 ),
        .I4(beats_remaining_q[3]),
        .O(\beats_remaining_q[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAA800000002)) 
    \beats_remaining_q[4]_i_1 
       (.I0(\beats_remaining_q[6]_i_3_n_0 ),
        .I1(beats_remaining_q[3]),
        .I2(beats_remaining_q[2]),
        .I3(beats_remaining_q[1]),
        .I4(\beats_remaining_q_reg[1]_0 ),
        .I5(beats_remaining_q[4]),
        .O(\beats_remaining_q[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hA802)) 
    \beats_remaining_q[5]_i_1 
       (.I0(\beats_remaining_q[6]_i_3_n_0 ),
        .I1(beats_remaining_q[4]),
        .I2(\beats_remaining_q[6]_i_4_n_0 ),
        .I3(beats_remaining_q[5]),
        .O(\beats_remaining_q[5]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFF04)) 
    \beats_remaining_q[6]_i_1 
       (.I0(\beats_remaining_q_reg[0]_0 ),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(\beats_remaining_q[6]_i_3_n_0 ),
        .O(\beats_remaining_q[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hAAA80002)) 
    \beats_remaining_q[6]_i_2 
       (.I0(\beats_remaining_q[6]_i_3_n_0 ),
        .I1(beats_remaining_q[5]),
        .I2(beats_remaining_q[4]),
        .I3(\beats_remaining_q[6]_i_4_n_0 ),
        .I4(beats_remaining_q[6]),
        .O(\beats_remaining_q[6]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h55555554)) 
    \beats_remaining_q[6]_i_3 
       (.I0(\state_reg[1]_0 ),
        .I1(\beats_remaining_q[6]_i_4_n_0 ),
        .I2(beats_remaining_q[6]),
        .I3(beats_remaining_q[5]),
        .I4(beats_remaining_q[4]),
        .O(\beats_remaining_q[6]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \beats_remaining_q[6]_i_4 
       (.I0(beats_remaining_q[3]),
        .I1(beats_remaining_q[2]),
        .I2(beats_remaining_q[1]),
        .I3(\beats_remaining_q_reg[1]_0 ),
        .O(\beats_remaining_q[6]_i_4_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \beats_remaining_q_reg[0] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beats_remaining_q[6]_i_1_n_0 ),
        .D(D),
        .Q(\beats_remaining_q_reg[1]_0 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \beats_remaining_q_reg[1] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beats_remaining_q[6]_i_1_n_0 ),
        .D(\beats_remaining_q[1]_i_1_n_0 ),
        .Q(beats_remaining_q[1]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \beats_remaining_q_reg[2] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beats_remaining_q[6]_i_1_n_0 ),
        .D(\beats_remaining_q[2]_i_1_n_0 ),
        .Q(beats_remaining_q[2]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \beats_remaining_q_reg[3] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beats_remaining_q[6]_i_1_n_0 ),
        .D(\beats_remaining_q[3]_i_1_n_0 ),
        .Q(beats_remaining_q[3]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \beats_remaining_q_reg[4] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beats_remaining_q[6]_i_1_n_0 ),
        .D(\beats_remaining_q[4]_i_1_n_0 ),
        .Q(beats_remaining_q[4]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \beats_remaining_q_reg[5] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beats_remaining_q[6]_i_1_n_0 ),
        .D(\beats_remaining_q[5]_i_1_n_0 ),
        .Q(beats_remaining_q[5]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \beats_remaining_q_reg[6] 
       (.C(clk_axi_IBUF_BUFG),
        .CE(\beats_remaining_q[6]_i_1_n_0 ),
        .D(\beats_remaining_q[6]_i_2_n_0 ),
        .Q(beats_remaining_q[6]),
        .R(p_0_in));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h40)) 
    \rd_ptr_gray[5]_i_3 
       (.I0(m_axi_bvalid),
        .I1(\beats_remaining_q_reg[0]_0 ),
        .I2(rst_n_IBUF),
        .O(m_axi_wready));
  LUT6 #(
    .INIT(64'h00000000FFFF0001)) 
    s_axi_bvalid_o_i_2
       (.I0(beats_remaining_q[4]),
        .I1(beats_remaining_q[5]),
        .I2(beats_remaining_q[6]),
        .I3(s_axi_bvalid_o_i_3_n_0),
        .I4(m_axi_wlast),
        .I5(\state_reg[1]_0 ),
        .O(aw_seen_q));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hFFEF)) 
    s_axi_bvalid_o_i_3
       (.I0(beats_remaining_q[3]),
        .I1(beats_remaining_q[2]),
        .I2(\beats_remaining_q_reg[1]_0 ),
        .I3(beats_remaining_q[1]),
        .O(s_axi_bvalid_o_i_3_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axi_bvalid_o_reg
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\state_reg[1] ),
        .Q(m_axi_bvalid),
        .R(\<const0> ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h80808C80)) 
    \state[1]_i_3 
       (.I0(m_axi_bvalid),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(rst_n_IBUF),
        .I4(\beats_remaining_q_reg[0]_0 ),
        .O(\state_reg[0] ));
endmodule

module csi2_header_ecc_checker
   (E,
    ecc_ok_reg,
    ecc_ok_reg_0,
    rst_n,
    clk_sys_IBUF_BUFG,
    \FSM_onehot_state_reg[7] ,
    out,
    \FSM_onehot_state_reg[3] ,
    Q,
    \header_ecc_reg_reg[5] );
  output [0:0]E;
  output [0:0]ecc_ok_reg;
  output ecc_ok_reg_0;
  input rst_n;
  input clk_sys_IBUF_BUFG;
  input \FSM_onehot_state_reg[7] ;
  input [4:0]out;
  input \FSM_onehot_state_reg[3] ;
  input [23:0]Q;
  input [5:0]\header_ecc_reg_reg[5] ;

  wire \<const1> ;
  wire [0:0]E;
  wire \FSM_onehot_state[9]_i_4_n_0 ;
  wire \FSM_onehot_state[9]_i_5_n_0 ;
  wire \FSM_onehot_state_reg[3] ;
  wire \FSM_onehot_state_reg[7] ;
  wire [23:0]Q;
  wire clk_sys_IBUF_BUFG;
  wire ecc_error;
  wire ecc_error_i_10_n_0;
  wire ecc_error_i_11_n_0;
  wire ecc_error_i_12_n_0;
  wire ecc_error_i_13_n_0;
  wire ecc_error_i_14_n_0;
  wire ecc_error_i_15_n_0;
  wire ecc_error_i_16_n_0;
  wire ecc_error_i_17_n_0;
  wire ecc_error_i_18_n_0;
  wire ecc_error_i_19_n_0;
  wire ecc_error_i_1_n_0;
  wire ecc_error_i_2_n_0;
  wire ecc_error_i_3_n_0;
  wire ecc_error_i_4_n_0;
  wire ecc_error_i_5_n_0;
  wire ecc_error_i_6_n_0;
  wire ecc_error_i_7_n_0;
  wire ecc_error_i_8_n_0;
  wire [0:0]ecc_ok_reg;
  wire ecc_ok_reg_0;
  wire ecc_valid;
  wire ecc_valid_i_2_n_0;
  wire [5:0]\header_ecc_reg_reg[5] ;
  wire [4:0]out;
  wire rst_n;
  wire [3:3]syndrome;

  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFAEA)) 
    \FSM_onehot_state[9]_i_1 
       (.I0(\FSM_onehot_state_reg[7] ),
        .I1(out[3]),
        .I2(\FSM_onehot_state_reg[3] ),
        .I3(out[4]),
        .I4(\FSM_onehot_state[9]_i_4_n_0 ),
        .I5(\FSM_onehot_state[9]_i_5_n_0 ),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hD0)) 
    \FSM_onehot_state[9]_i_4 
       (.I0(ecc_valid),
        .I1(out[1]),
        .I2(out[0]),
        .O(\FSM_onehot_state[9]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hF8)) 
    \FSM_onehot_state[9]_i_5 
       (.I0(out[1]),
        .I1(ecc_valid),
        .I2(out[2]),
        .O(\FSM_onehot_state[9]_i_5_n_0 ));
  VCC VCC
       (.P(\<const1> ));
  LUT6 #(
    .INIT(64'h7F7FFF7F70700070)) 
    ecc_error_i_1
       (.I0(ecc_error_i_2_n_0),
        .I1(ecc_error_i_3_n_0),
        .I2(out[0]),
        .I3(ecc_valid),
        .I4(out[1]),
        .I5(ecc_error),
        .O(ecc_error_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    ecc_error_i_10
       (.I0(Q[23]),
        .I1(Q[19]),
        .O(ecc_error_i_10_n_0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    ecc_error_i_11
       (.I0(Q[17]),
        .I1(Q[5]),
        .I2(Q[9]),
        .I3(\header_ecc_reg_reg[5] [4]),
        .I4(Q[20]),
        .I5(Q[4]),
        .O(ecc_error_i_11_n_0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    ecc_error_i_12
       (.I0(Q[22]),
        .I1(Q[18]),
        .I2(Q[16]),
        .I3(Q[7]),
        .I4(Q[8]),
        .I5(Q[6]),
        .O(ecc_error_i_12_n_0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    ecc_error_i_13
       (.I0(Q[10]),
        .I1(Q[4]),
        .I2(Q[1]),
        .I3(Q[13]),
        .I4(Q[23]),
        .I5(Q[0]),
        .O(ecc_error_i_13_n_0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    ecc_error_i_14
       (.I0(Q[16]),
        .I1(Q[2]),
        .I2(Q[11]),
        .I3(\header_ecc_reg_reg[5] [0]),
        .I4(Q[7]),
        .I5(Q[5]),
        .O(ecc_error_i_14_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    ecc_error_i_15
       (.I0(Q[21]),
        .I1(Q[22]),
        .O(ecc_error_i_15_n_0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    ecc_error_i_16
       (.I0(Q[10]),
        .I1(Q[4]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(Q[23]),
        .I5(Q[3]),
        .O(ecc_error_i_16_n_0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    ecc_error_i_17
       (.I0(Q[8]),
        .I1(Q[12]),
        .I2(Q[17]),
        .I3(\header_ecc_reg_reg[5] [1]),
        .I4(Q[6]),
        .I5(Q[14]),
        .O(ecc_error_i_17_n_0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    ecc_error_i_18
       (.I0(Q[14]),
        .I1(Q[8]),
        .I2(Q[7]),
        .I3(Q[21]),
        .I4(Q[13]),
        .I5(Q[2]),
        .O(ecc_error_i_18_n_0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    ecc_error_i_19
       (.I0(Q[15]),
        .I1(Q[20]),
        .I2(Q[23]),
        .I3(\header_ecc_reg_reg[5] [3]),
        .I4(Q[9]),
        .I5(Q[19]),
        .O(ecc_error_i_19_n_0));
  LUT5 #(
    .INIT(32'h82282882)) 
    ecc_error_i_2
       (.I0(ecc_error_i_4_n_0),
        .I1(Q[22]),
        .I2(Q[18]),
        .I3(ecc_error_i_5_n_0),
        .I4(ecc_error_i_6_n_0),
        .O(ecc_error_i_2_n_0));
  LUT6 #(
    .INIT(64'h0009060006000009)) 
    ecc_error_i_3
       (.I0(ecc_error_i_7_n_0),
        .I1(ecc_error_i_8_n_0),
        .I2(syndrome),
        .I3(ecc_error_i_10_n_0),
        .I4(ecc_error_i_11_n_0),
        .I5(ecc_error_i_12_n_0),
        .O(ecc_error_i_3_n_0));
  LUT6 #(
    .INIT(64'h9009066006609009)) 
    ecc_error_i_4
       (.I0(ecc_error_i_13_n_0),
        .I1(ecc_error_i_14_n_0),
        .I2(ecc_error_i_15_n_0),
        .I3(Q[20]),
        .I4(ecc_error_i_16_n_0),
        .I5(ecc_error_i_17_n_0),
        .O(ecc_error_i_4_n_0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    ecc_error_i_5
       (.I0(Q[21]),
        .I1(Q[11]),
        .I2(Q[9]),
        .I3(\header_ecc_reg_reg[5] [2]),
        .I4(Q[20]),
        .I5(Q[15]),
        .O(ecc_error_i_5_n_0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    ecc_error_i_6
       (.I0(Q[3]),
        .I1(Q[0]),
        .I2(Q[2]),
        .I3(Q[5]),
        .I4(Q[12]),
        .I5(Q[6]),
        .O(ecc_error_i_6_n_0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    ecc_error_i_7
       (.I0(Q[22]),
        .I1(Q[18]),
        .I2(Q[13]),
        .I3(Q[16]),
        .I4(Q[12]),
        .I5(Q[14]),
        .O(ecc_error_i_7_n_0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    ecc_error_i_8
       (.I0(Q[17]),
        .I1(Q[11]),
        .I2(Q[15]),
        .I3(\header_ecc_reg_reg[5] [5]),
        .I4(Q[21]),
        .I5(Q[10]),
        .O(ecc_error_i_8_n_0));
  LUT4 #(
    .INIT(16'h6996)) 
    ecc_error_i_9
       (.I0(ecc_error_i_18_n_0),
        .I1(ecc_error_i_19_n_0),
        .I2(Q[3]),
        .I3(Q[1]),
        .O(syndrome));
  FDRE #(
    .INIT(1'b0)) 
    ecc_error_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(ecc_error_i_1_n_0),
        .Q(ecc_error),
        .R(rst_n));
  LUT1 #(
    .INIT(2'h1)) 
    ecc_ok_i_1
       (.I0(ecc_error),
        .O(ecc_ok_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hCE)) 
    ecc_valid_i_2
       (.I0(ecc_valid),
        .I1(out[0]),
        .I2(out[1]),
        .O(ecc_valid_i_2_n_0));
  FDRE #(
    .INIT(1'b0)) 
    ecc_valid_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(ecc_valid_i_2_n_0),
        .Q(ecc_valid),
        .R(rst_n));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[15]_i_1 
       (.I0(out[1]),
        .I1(ecc_valid),
        .O(ecc_ok_reg));
endmodule

module csi2_long_packet_parser
   (Q,
    err_valid_o_reg,
    \rd_ptr_bin_reg[3] ,
    in1,
    \FSM_onehot_byte_idx_reg[0] ,
    \FSM_onehot_byte_idx_reg[0]_0 ,
    \FSM_onehot_byte_idx_reg[0]_1 ,
    pending_sol_reg,
    frame_start_reg,
    sync_error_reg,
    line_start_reg,
    frame_end_reg,
    line_end_reg,
    sync_error_reg_0,
    pixel_sof_o3_out,
    sof_reg,
    I138,
    E,
    pixel_sol_o1_out,
    I137,
    \pixel_data_o_reg[0] ,
    \byte_idx_reg[1] ,
    pixel_sof_o_reg,
    pixel_sol_o_reg,
    \expected_crc_reg_reg[0] ,
    active_reg,
    \crc_calc_reg[15] ,
    frame_active_reg,
    line_active_reg,
    pending_sol,
    pending_sol_reg_0,
    payload_sof_i,
    payload_sol_i,
    pending_sol_reg_1,
    err_ecc_o_OBUF,
    \payload_dt_reg_reg[0] ,
    crc_error_reg,
    \crc_calc_reg[15]_0 ,
    crc_error_reg_0,
    \crc_calc_reg[15]_1 ,
    crc_error_reg_1,
    \expected_crc_reg_reg[7] ,
    crc_error_reg_2,
    out11,
    \payload_dt_reg_reg[0]_0 ,
    resync_drop_packet,
    out,
    lane_err_sync_d,
    sync_error_reg_1,
    \rd_ptr_gray_reg[3] ,
    state_reg,
    raw10_pixel_valid,
    line_active_reg_0,
    frame_active_reg_0,
    resync_req_d,
    rst_n_IBUF,
    \payload_dt_reg_reg[3] ,
    O59,
    \byte_idx_reg[1]_0 ,
    sol_reg,
    pixel_valid_o,
    \payload_dt_reg_reg[2] ,
    \payload_dt_reg_reg[2]_0 ,
    \payload_dt_reg_reg[5] ,
    pending_sof,
    pending_sol_reg_2,
    active,
    SR,
    payload_done_reg,
    \payload_dt_reg_reg[5]_0 ,
    \payload_dt_reg_reg[5]_1 ,
    crc_valid,
    crc_error,
    \crc_reg_reg[10] ,
    crc_valid_reg,
    \crc_reg_reg[7] ,
    \crc_calc_reg[5] ,
    resync_req_o_reg,
    clk_sys_IBUF_BUFG,
    crc_valid_reg_0,
    D,
    rst_n);
  output [5:0]Q;
  output err_valid_o_reg;
  output \rd_ptr_bin_reg[3] ;
  output in1;
  output \FSM_onehot_byte_idx_reg[0] ;
  output \FSM_onehot_byte_idx_reg[0]_0 ;
  output \FSM_onehot_byte_idx_reg[0]_1 ;
  output pending_sol_reg;
  output frame_start_reg;
  output sync_error_reg;
  output line_start_reg;
  output frame_end_reg;
  output line_end_reg;
  output sync_error_reg_0;
  output pixel_sof_o3_out;
  output sof_reg;
  output I138;
  output [0:0]E;
  output pixel_sol_o1_out;
  output I137;
  output [0:0]\pixel_data_o_reg[0] ;
  output [0:0]\byte_idx_reg[1] ;
  output pixel_sof_o_reg;
  output pixel_sol_o_reg;
  output \expected_crc_reg_reg[0] ;
  output active_reg;
  output \crc_calc_reg[15] ;
  output frame_active_reg;
  output line_active_reg;
  output pending_sol;
  output pending_sol_reg_0;
  output payload_sof_i;
  output payload_sol_i;
  output pending_sol_reg_1;
  output err_ecc_o_OBUF;
  output [0:0]\payload_dt_reg_reg[0] ;
  output crc_error_reg;
  output \crc_calc_reg[15]_0 ;
  output crc_error_reg_0;
  output [0:0]\crc_calc_reg[15]_1 ;
  output crc_error_reg_1;
  output [7:0]\expected_crc_reg_reg[7] ;
  output crc_error_reg_2;
  output [0:0]out11;
  input \payload_dt_reg_reg[0]_0 ;
  input resync_drop_packet;
  input out;
  input lane_err_sync_d;
  input sync_error_reg_1;
  input \rd_ptr_gray_reg[3] ;
  input state_reg;
  input raw10_pixel_valid;
  input line_active_reg_0;
  input frame_active_reg_0;
  input resync_req_d;
  input rst_n_IBUF;
  input \payload_dt_reg_reg[3] ;
  input O59;
  input [1:0]\byte_idx_reg[1]_0 ;
  input sol_reg;
  input pixel_valid_o;
  input \payload_dt_reg_reg[2] ;
  input \payload_dt_reg_reg[2]_0 ;
  input \payload_dt_reg_reg[5] ;
  input pending_sof;
  input pending_sol_reg_2;
  input active;
  input [0:0]SR;
  input payload_done_reg;
  input [5:0]\payload_dt_reg_reg[5]_0 ;
  input \payload_dt_reg_reg[5]_1 ;
  input crc_valid;
  input crc_error;
  input [0:0]\crc_reg_reg[10] ;
  input crc_valid_reg;
  input \crc_reg_reg[7] ;
  input [5:0]\crc_calc_reg[5] ;
  input resync_req_o_reg;
  input clk_sys_IBUF_BUFG;
  input crc_valid_reg_0;
  input [7:0]D;
  input rst_n;

  wire [7:0]D;
  wire [0:0]E;
  wire \FSM_onehot_byte_idx_reg[0] ;
  wire \FSM_onehot_byte_idx_reg[0]_0 ;
  wire \FSM_onehot_byte_idx_reg[0]_1 ;
  wire \FSM_onehot_state[0]_i_1_n_0 ;
  wire \FSM_onehot_state[2]_i_1_n_0 ;
  wire \FSM_onehot_state[3]_i_1_n_0 ;
  wire \FSM_onehot_state[4]_i_1_n_0 ;
  wire \FSM_onehot_state[5]_i_1_n_0 ;
  wire \FSM_onehot_state[6]_i_1_n_0 ;
  wire \FSM_onehot_state[7]_i_1_n_0 ;
  wire \FSM_onehot_state[7]_i_2_n_0 ;
  wire \FSM_onehot_state[7]_i_3_n_0 ;
  wire \FSM_onehot_state[7]_i_4_n_0 ;
  wire \FSM_onehot_state[7]_i_5_n_0 ;
  wire \FSM_onehot_state[8]_i_1_n_0 ;
  wire \FSM_onehot_state[9]_i_2_n_0 ;
  wire \FSM_onehot_state[9]_i_3_n_0 ;
  wire \FSM_onehot_state[9]_i_6_n_0 ;
  wire \FSM_onehot_state[9]_i_7_n_0 ;
  (* RTL_KEEP = "yes" *) wire \FSM_onehot_state_reg_n_0_[0] ;
  (* RTL_KEEP = "yes" *) wire \FSM_onehot_state_reg_n_0_[1] ;
  (* RTL_KEEP = "yes" *) wire \FSM_onehot_state_reg_n_0_[3] ;
  (* RTL_KEEP = "yes" *) wire \FSM_onehot_state_reg_n_0_[8] ;
  wire I137;
  wire I138;
  wire O59;
  wire [5:0]Q;
  wire [0:0]SR;
  wire active;
  wire active_reg;
  wire \byte_idx[1]_i_6_n_0 ;
  wire \byte_idx[1]_i_7_n_0 ;
  wire [0:0]\byte_idx_reg[1] ;
  wire [1:0]\byte_idx_reg[1]_0 ;
  wire clk_sys_IBUF_BUFG;
  wire \crc_calc[15]_i_5_n_0 ;
  wire \crc_calc_reg[15] ;
  wire \crc_calc_reg[15]_0 ;
  wire [0:0]\crc_calc_reg[15]_1 ;
  wire [5:0]\crc_calc_reg[5] ;
  wire crc_error;
  wire crc_error_i_55_n_0;
  wire crc_error_i_57_n_0;
  wire crc_error_reg;
  wire crc_error_reg_0;
  wire crc_error_reg_1;
  wire crc_error_reg_2;
  wire crc_lsb_reg;
  wire [0:0]\crc_reg_reg[10] ;
  wire \crc_reg_reg[7] ;
  wire crc_valid;
  wire crc_valid_reg;
  wire crc_valid_reg_0;
  (* RTL_KEEP = "yes" *) wire ecc_hdr_valid;
  (* RTL_KEEP = "yes" *) wire ecc_ready;
  wire err_ecc_o_OBUF;
  wire err_valid_o_i_2_n_0;
  wire err_valid_o_reg;
  wire \expected_crc_reg_reg[0] ;
  wire [7:0]\expected_crc_reg_reg[7] ;
  wire fifo_rd_ready;
  wire frame_active_reg;
  wire frame_active_reg_0;
  wire frame_end_i_2_n_0;
  wire frame_end_reg;
  wire frame_start_i_4_n_0;
  wire frame_start_reg;
  (* RTL_KEEP = "yes" *) wire hdr_valid;
  wire \header_data_reg[15]_i_1_n_0 ;
  wire \header_data_reg[23]_i_1_n_0 ;
  wire \header_data_reg[7]_i_1_n_0 ;
  wire \header_data_reg_reg_n_0_[0] ;
  wire \header_data_reg_reg_n_0_[10] ;
  wire \header_data_reg_reg_n_0_[11] ;
  wire \header_data_reg_reg_n_0_[12] ;
  wire \header_data_reg_reg_n_0_[13] ;
  wire \header_data_reg_reg_n_0_[14] ;
  wire \header_data_reg_reg_n_0_[15] ;
  wire \header_data_reg_reg_n_0_[16] ;
  wire \header_data_reg_reg_n_0_[17] ;
  wire \header_data_reg_reg_n_0_[18] ;
  wire \header_data_reg_reg_n_0_[19] ;
  wire \header_data_reg_reg_n_0_[1] ;
  wire \header_data_reg_reg_n_0_[20] ;
  wire \header_data_reg_reg_n_0_[21] ;
  wire \header_data_reg_reg_n_0_[22] ;
  wire \header_data_reg_reg_n_0_[23] ;
  wire \header_data_reg_reg_n_0_[2] ;
  wire \header_data_reg_reg_n_0_[3] ;
  wire \header_data_reg_reg_n_0_[4] ;
  wire \header_data_reg_reg_n_0_[5] ;
  wire \header_data_reg_reg_n_0_[6] ;
  wire \header_data_reg_reg_n_0_[7] ;
  wire \header_data_reg_reg_n_0_[8] ;
  wire \header_data_reg_reg_n_0_[9] ;
  wire header_ecc_reg;
  wire \header_ecc_reg_reg_n_0_[0] ;
  wire \header_ecc_reg_reg_n_0_[1] ;
  wire \header_ecc_reg_reg_n_0_[2] ;
  wire \header_ecc_reg_reg_n_0_[3] ;
  wire \header_ecc_reg_reg_n_0_[4] ;
  wire \header_ecc_reg_reg_n_0_[5] ;
  wire in1;
  wire lane_err_sync_d;
  wire line_active_reg;
  wire line_active_reg_0;
  wire line_end_reg;
  wire line_start_reg;
  wire out;
  (* RTL_KEEP = "yes" *) wire [0:0]out11;
  (* RTL_KEEP = "yes" *) wire p_0_in;
  (* RTL_KEEP = "yes" *) wire p_0_in1_in;
  wire [15:0]payload_cnt;
  wire \payload_cnt[10]_i_2_n_0 ;
  wire \payload_cnt[13]_i_2_n_0 ;
  wire \payload_cnt[15]_i_10_n_0 ;
  wire \payload_cnt[15]_i_11_n_0 ;
  wire \payload_cnt[15]_i_12_n_0 ;
  wire \payload_cnt[15]_i_13_n_0 ;
  wire \payload_cnt[15]_i_14_n_0 ;
  wire \payload_cnt[15]_i_15_n_0 ;
  wire \payload_cnt[15]_i_16_n_0 ;
  wire \payload_cnt[15]_i_17_n_0 ;
  wire \payload_cnt[15]_i_18_n_0 ;
  wire \payload_cnt[15]_i_19_n_0 ;
  wire \payload_cnt[15]_i_1_n_0 ;
  wire \payload_cnt[15]_i_20_n_0 ;
  wire \payload_cnt[15]_i_21_n_0 ;
  wire \payload_cnt[15]_i_22_n_0 ;
  wire \payload_cnt[15]_i_4_n_0 ;
  wire \payload_cnt[15]_i_6_n_0 ;
  wire \payload_cnt[15]_i_7_n_0 ;
  wire \payload_cnt[15]_i_8_n_0 ;
  wire \payload_cnt[15]_i_9_n_0 ;
  wire \payload_cnt[4]_i_2_n_0 ;
  wire \payload_cnt[5]_i_2_n_0 ;
  wire \payload_cnt[8]_i_2_n_0 ;
  wire \payload_cnt[9]_i_2_n_0 ;
  wire \payload_cnt_reg_n_0_[0] ;
  wire \payload_cnt_reg_n_0_[10] ;
  wire \payload_cnt_reg_n_0_[11] ;
  wire \payload_cnt_reg_n_0_[12] ;
  wire \payload_cnt_reg_n_0_[13] ;
  wire \payload_cnt_reg_n_0_[14] ;
  wire \payload_cnt_reg_n_0_[15] ;
  wire \payload_cnt_reg_n_0_[1] ;
  wire \payload_cnt_reg_n_0_[2] ;
  wire \payload_cnt_reg_n_0_[3] ;
  wire \payload_cnt_reg_n_0_[4] ;
  wire \payload_cnt_reg_n_0_[5] ;
  wire \payload_cnt_reg_n_0_[6] ;
  wire \payload_cnt_reg_n_0_[7] ;
  wire \payload_cnt_reg_n_0_[8] ;
  wire \payload_cnt_reg_n_0_[9] ;
  wire payload_done_reg;
  wire payload_drop;
  wire [0:0]\payload_dt_reg_reg[0] ;
  wire \payload_dt_reg_reg[0]_0 ;
  wire \payload_dt_reg_reg[2] ;
  wire \payload_dt_reg_reg[2]_0 ;
  wire \payload_dt_reg_reg[3] ;
  wire \payload_dt_reg_reg[5] ;
  wire [5:0]\payload_dt_reg_reg[5]_0 ;
  wire \payload_dt_reg_reg[5]_1 ;
  wire payload_last_byte;
  wire [15:15]payload_last_byte0;
  wire payload_sof_i;
  wire payload_sol_i;
  wire payload_start;
  wire pending_sof;
  wire pending_sol;
  wire pending_sol_reg;
  wire pending_sol_reg_0;
  wire pending_sol_reg_1;
  wire pending_sol_reg_2;
  wire [0:0]\pixel_data_o_reg[0] ;
  wire pixel_sof_o3_out;
  wire pixel_sof_o_reg;
  wire pixel_sol_o1_out;
  wire pixel_sol_o_reg;
  wire pixel_valid_o;
  wire pkt_ecc_ok;
  wire [1:0]pkt_vc;
  wire [15:0]pkt_word_count;
  wire raw10_pixel_valid;
  wire \rd_ptr_bin_reg[3] ;
  wire \rd_ptr_gray[3]_i_5_n_0 ;
  wire \rd_ptr_gray_reg[3] ;
  wire resync_drop_packet;
  wire resync_req_d;
  wire resync_req_o_reg;
  wire rst_n;
  wire rst_n_IBUF;
  wire short_event_valid;
  wire sof_reg;
  wire sof_reg_i_3_n_0;
  wire sof_reg_i_4_n_0;
  wire sof_reg_i_5_n_0;
  wire sol_reg;
  wire state_reg;
  wire sync_error_reg;
  wire sync_error_reg_0;
  wire sync_error_reg_1;
  wire u_header_ecc_checker_n_0;
  wire u_header_ecc_checker_n_1;
  wire u_header_ecc_checker_n_2;

  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \FSM_onehot_byte_idx[3]_i_1 
       (.I0(\FSM_onehot_byte_idx_reg[0] ),
        .I1(state_reg),
        .O(in1));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT4 #(
    .INIT(16'h0020)) 
    \FSM_onehot_byte_idx[3]_i_2 
       (.I0(pending_sol_reg),
        .I1(payload_drop),
        .I2(\payload_dt_reg_reg[5] ),
        .I3(state_reg),
        .O(\FSM_onehot_byte_idx_reg[0] ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \FSM_onehot_byte_idx[4]_i_1 
       (.I0(\FSM_onehot_byte_idx_reg[0]_1 ),
        .I1(raw10_pixel_valid),
        .O(\FSM_onehot_byte_idx_reg[0]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT4 #(
    .INIT(16'h0020)) 
    \FSM_onehot_byte_idx[4]_i_2 
       (.I0(pending_sol_reg),
        .I1(payload_drop),
        .I2(\payload_dt_reg_reg[2]_0 ),
        .I3(raw10_pixel_valid),
        .O(\FSM_onehot_byte_idx_reg[0]_1 ));
  LUT5 #(
    .INIT(32'h4444000C)) 
    \FSM_onehot_state[0]_i_1 
       (.I0(\FSM_onehot_state[7]_i_2_n_0 ),
        .I1(\FSM_onehot_state[9]_i_6_n_0 ),
        .I2(\FSM_onehot_state_reg_n_0_[8] ),
        .I3(p_0_in),
        .I4(hdr_valid),
        .O(\FSM_onehot_state[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \FSM_onehot_state[2]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .O(\FSM_onehot_state[2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h02)) 
    \FSM_onehot_state[3]_i_1 
       (.I0(p_0_in1_in),
        .I1(\FSM_onehot_state_reg_n_0_[1] ),
        .I2(\FSM_onehot_state_reg_n_0_[0] ),
        .O(\FSM_onehot_state[3]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0002)) 
    \FSM_onehot_state[4]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(p_0_in1_in),
        .I2(\FSM_onehot_state_reg_n_0_[0] ),
        .I3(\FSM_onehot_state_reg_n_0_[1] ),
        .O(\FSM_onehot_state[4]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00000002)) 
    \FSM_onehot_state[5]_i_1 
       (.I0(ecc_hdr_valid),
        .I1(\FSM_onehot_state_reg_n_0_[3] ),
        .I2(\FSM_onehot_state_reg_n_0_[1] ),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .I4(p_0_in1_in),
        .O(\FSM_onehot_state[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \FSM_onehot_state[6]_i_1 
       (.I0(ecc_hdr_valid),
        .I1(p_0_in1_in),
        .I2(\FSM_onehot_state_reg_n_0_[0] ),
        .I3(\FSM_onehot_state_reg_n_0_[1] ),
        .I4(\FSM_onehot_state_reg_n_0_[3] ),
        .I5(ecc_ready),
        .O(\FSM_onehot_state[6]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h80)) 
    \FSM_onehot_state[7]_i_1 
       (.I0(\FSM_onehot_state[7]_i_2_n_0 ),
        .I1(hdr_valid),
        .I2(\FSM_onehot_state[9]_i_6_n_0 ),
        .O(\FSM_onehot_state[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \FSM_onehot_state[7]_i_2 
       (.I0(\FSM_onehot_state[7]_i_3_n_0 ),
        .I1(pkt_word_count[1]),
        .I2(pkt_word_count[0]),
        .I3(pkt_word_count[3]),
        .I4(pkt_word_count[2]),
        .I5(\FSM_onehot_state[7]_i_4_n_0 ),
        .O(\FSM_onehot_state[7]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_onehot_state[7]_i_3 
       (.I0(pkt_word_count[5]),
        .I1(pkt_word_count[4]),
        .I2(pkt_word_count[7]),
        .I3(pkt_word_count[6]),
        .O(\FSM_onehot_state[7]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \FSM_onehot_state[7]_i_4 
       (.I0(pkt_word_count[10]),
        .I1(pkt_word_count[11]),
        .I2(pkt_word_count[8]),
        .I3(pkt_word_count[9]),
        .I4(\FSM_onehot_state[7]_i_5_n_0 ),
        .O(\FSM_onehot_state[7]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_onehot_state[7]_i_5 
       (.I0(pkt_word_count[13]),
        .I1(pkt_word_count[12]),
        .I2(pkt_word_count[15]),
        .I3(pkt_word_count[14]),
        .O(\FSM_onehot_state[7]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h40)) 
    \FSM_onehot_state[8]_i_1 
       (.I0(hdr_valid),
        .I1(p_0_in),
        .I2(\FSM_onehot_state[9]_i_6_n_0 ),
        .O(\FSM_onehot_state[8]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0400)) 
    \FSM_onehot_state[9]_i_2 
       (.I0(hdr_valid),
        .I1(\FSM_onehot_state_reg_n_0_[8] ),
        .I2(p_0_in),
        .I3(\FSM_onehot_state[9]_i_6_n_0 ),
        .O(\FSM_onehot_state[9]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h00F00080)) 
    \FSM_onehot_state[9]_i_3 
       (.I0(p_0_in),
        .I1(payload_last_byte),
        .I2(fifo_rd_ready),
        .I3(\rd_ptr_gray_reg[3] ),
        .I4(\FSM_onehot_state[9]_i_7_n_0 ),
        .O(\FSM_onehot_state[9]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \FSM_onehot_state[9]_i_6 
       (.I0(ecc_hdr_valid),
        .I1(p_0_in1_in),
        .I2(\FSM_onehot_state_reg_n_0_[0] ),
        .I3(\FSM_onehot_state_reg_n_0_[1] ),
        .I4(\FSM_onehot_state_reg_n_0_[3] ),
        .I5(ecc_ready),
        .O(\FSM_onehot_state[9]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_onehot_state[9]_i_7 
       (.I0(p_0_in1_in),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .I2(\FSM_onehot_state_reg_n_0_[1] ),
        .I3(\FSM_onehot_state_reg_n_0_[3] ),
        .O(\FSM_onehot_state[9]_i_7_n_0 ));
  (* FSM_ENCODED_STATES = "ST_HDR0:0000000001,ST_HDR1:0000000010,ST_HDR2:0000000100,ST_HDR3:0000001000,ST_ECC_REQ:0000010000,ST_WAIT_ECC:0000100000,ST_HDR_OUT:0001000000,ST_PAYLOAD:0010000000,ST_CRC0:0100000000,ST_CRC1:1000000000" *) 
  (* KEEP = "yes" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_0),
        .D(\FSM_onehot_state[0]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[0] ),
        .S(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "ST_HDR0:0000000001,ST_HDR1:0000000010,ST_HDR2:0000000100,ST_HDR3:0000001000,ST_ECC_REQ:0000010000,ST_WAIT_ECC:0000100000,ST_HDR_OUT:0001000000,ST_PAYLOAD:0010000000,ST_CRC0:0100000000,ST_CRC1:1000000000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_0),
        .D(\FSM_onehot_state_reg_n_0_[0] ),
        .Q(\FSM_onehot_state_reg_n_0_[1] ),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "ST_HDR0:0000000001,ST_HDR1:0000000010,ST_HDR2:0000000100,ST_HDR3:0000001000,ST_ECC_REQ:0000010000,ST_WAIT_ECC:0000100000,ST_HDR_OUT:0001000000,ST_PAYLOAD:0010000000,ST_CRC0:0100000000,ST_CRC1:1000000000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_0),
        .D(\FSM_onehot_state[2]_i_1_n_0 ),
        .Q(p_0_in1_in),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "ST_HDR0:0000000001,ST_HDR1:0000000010,ST_HDR2:0000000100,ST_HDR3:0000001000,ST_ECC_REQ:0000010000,ST_WAIT_ECC:0000100000,ST_HDR_OUT:0001000000,ST_PAYLOAD:0010000000,ST_CRC0:0100000000,ST_CRC1:1000000000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_0),
        .D(\FSM_onehot_state[3]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[3] ),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "ST_HDR0:0000000001,ST_HDR1:0000000010,ST_HDR2:0000000100,ST_HDR3:0000001000,ST_ECC_REQ:0000010000,ST_WAIT_ECC:0000100000,ST_HDR_OUT:0001000000,ST_PAYLOAD:0010000000,ST_CRC0:0100000000,ST_CRC1:1000000000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_0),
        .D(\FSM_onehot_state[4]_i_1_n_0 ),
        .Q(ecc_hdr_valid),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "ST_HDR0:0000000001,ST_HDR1:0000000010,ST_HDR2:0000000100,ST_HDR3:0000001000,ST_ECC_REQ:0000010000,ST_WAIT_ECC:0000100000,ST_HDR_OUT:0001000000,ST_PAYLOAD:0010000000,ST_CRC0:0100000000,ST_CRC1:1000000000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_0),
        .D(\FSM_onehot_state[5]_i_1_n_0 ),
        .Q(ecc_ready),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "ST_HDR0:0000000001,ST_HDR1:0000000010,ST_HDR2:0000000100,ST_HDR3:0000001000,ST_ECC_REQ:0000010000,ST_WAIT_ECC:0000100000,ST_HDR_OUT:0001000000,ST_PAYLOAD:0010000000,ST_CRC0:0100000000,ST_CRC1:1000000000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_0),
        .D(\FSM_onehot_state[6]_i_1_n_0 ),
        .Q(hdr_valid),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "ST_HDR0:0000000001,ST_HDR1:0000000010,ST_HDR2:0000000100,ST_HDR3:0000001000,ST_ECC_REQ:0000010000,ST_WAIT_ECC:0000100000,ST_HDR_OUT:0001000000,ST_PAYLOAD:0010000000,ST_CRC0:0100000000,ST_CRC1:1000000000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_0),
        .D(\FSM_onehot_state[7]_i_1_n_0 ),
        .Q(p_0_in),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "ST_HDR0:0000000001,ST_HDR1:0000000010,ST_HDR2:0000000100,ST_HDR3:0000001000,ST_ECC_REQ:0000010000,ST_WAIT_ECC:0000100000,ST_HDR_OUT:0001000000,ST_PAYLOAD:0010000000,ST_CRC0:0100000000,ST_CRC1:1000000000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_0),
        .D(\FSM_onehot_state[8]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[8] ),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "ST_HDR0:0000000001,ST_HDR1:0000000010,ST_HDR2:0000000100,ST_HDR3:0000001000,ST_ECC_REQ:0000010000,ST_WAIT_ECC:0000100000,ST_HDR_OUT:0001000000,ST_PAYLOAD:0010000000,ST_CRC0:0100000000,ST_CRC1:1000000000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_0),
        .D(\FSM_onehot_state[9]_i_2_n_0 ),
        .Q(out11),
        .R(resync_req_o_reg));
  LUT6 #(
    .INIT(64'h00000000F8880000)) 
    active_i_1__0
       (.I0(\FSM_onehot_state[7]_i_2_n_0 ),
        .I1(hdr_valid),
        .I2(active),
        .I3(\crc_calc_reg[15] ),
        .I4(rst_n_IBUF),
        .I5(resync_drop_packet),
        .O(active_reg));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    \byte0_reg[7]_i_1__0 
       (.I0(pending_sol_reg),
        .I1(payload_drop),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(\byte_idx_reg[1]_0 [0]),
        .I4(\byte_idx_reg[1]_0 [1]),
        .O(sof_reg));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'h00200000)) 
    \byte1_reg[7]_i_1__0 
       (.I0(pending_sol_reg),
        .I1(payload_drop),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(\byte_idx_reg[1]_0 [1]),
        .I4(\byte_idx_reg[1]_0 [0]),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'h20)) 
    \byte_idx[1]_i_1 
       (.I0(pending_sol_reg),
        .I1(payload_drop),
        .I2(\payload_dt_reg_reg[3] ),
        .O(\byte_idx_reg[1] ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \byte_idx[1]_i_3 
       (.I0(\payload_dt_reg_reg[0]_0 ),
        .I1(Q[0]),
        .I2(\byte_idx[1]_i_6_n_0 ),
        .I3(\byte_idx[1]_i_7_n_0 ),
        .I4(resync_drop_packet),
        .O(payload_drop));
  LUT6 #(
    .INIT(64'hFFFFFFFFFBFFFFFF)) 
    \byte_idx[1]_i_6 
       (.I0(pkt_vc[0]),
        .I1(Q[5]),
        .I2(Q[4]),
        .I3(Q[3]),
        .I4(Q[1]),
        .I5(Q[2]),
        .O(\byte_idx[1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hEFEFAFEFFFFBFFFF)) 
    \byte_idx[1]_i_7 
       (.I0(pkt_vc[1]),
        .I1(\payload_dt_reg_reg[5]_0 [2]),
        .I2(\payload_dt_reg_reg[5]_0 [3]),
        .I3(\payload_dt_reg_reg[5]_0 [4]),
        .I4(\payload_dt_reg_reg[5]_0 [5]),
        .I5(\payload_dt_reg_reg[5]_0 [1]),
        .O(\byte_idx[1]_i_7_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \crc_calc[15]_i_1 
       (.I0(\crc_calc_reg[15] ),
        .O(\crc_calc_reg[15]_1 ));
  LUT6 #(
    .INIT(64'hDFFFFFFFFFFFFFFF)) 
    \crc_calc[15]_i_3 
       (.I0(pending_sol_reg_0),
        .I1(payload_done_reg),
        .I2(\crc_calc_reg[15]_0 ),
        .I3(\payload_cnt[15]_i_8_n_0 ),
        .I4(\payload_cnt[15]_i_9_n_0 ),
        .I5(pending_sol_reg),
        .O(\crc_calc_reg[15] ));
  LUT6 #(
    .INIT(64'h8442211800000000)) 
    \crc_calc[15]_i_4 
       (.I0(\payload_cnt_reg_n_0_[12] ),
        .I1(\payload_cnt_reg_n_0_[13] ),
        .I2(pkt_word_count[12]),
        .I3(\payload_cnt[15]_i_11_n_0 ),
        .I4(pkt_word_count[13]),
        .I5(\crc_calc[15]_i_5_n_0 ),
        .O(\crc_calc_reg[15]_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAA955555556)) 
    \crc_calc[15]_i_5 
       (.I0(pkt_word_count[14]),
        .I1(pkt_word_count[12]),
        .I2(\payload_cnt[15]_i_10_n_0 ),
        .I3(pkt_word_count[11]),
        .I4(pkt_word_count[13]),
        .I5(\payload_cnt_reg_n_0_[14] ),
        .O(\crc_calc[15]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    crc_error_i_17
       (.I0(\expected_crc_reg_reg[7] [0]),
        .I1(\crc_calc_reg[5] [0]),
        .I2(\crc_calc_reg[5] [1]),
        .I3(\expected_crc_reg_reg[7] [1]),
        .I4(\crc_calc_reg[5] [2]),
        .I5(\expected_crc_reg_reg[7] [2]),
        .O(crc_error_reg_1));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    crc_error_i_18
       (.I0(\expected_crc_reg_reg[7] [3]),
        .I1(\crc_calc_reg[5] [3]),
        .I2(\crc_calc_reg[5] [4]),
        .I3(\expected_crc_reg_reg[7] [4]),
        .I4(\crc_calc_reg[5] [5]),
        .I5(\expected_crc_reg_reg[7] [5]),
        .O(crc_error_reg_2));
  LUT6 #(
    .INIT(64'h7555555545555555)) 
    crc_error_i_35
       (.I0(\crc_reg_reg[10] ),
        .I1(crc_valid_reg),
        .I2(\crc_calc_reg[15]_0 ),
        .I3(crc_error_reg_0),
        .I4(pending_sol_reg),
        .I5(\crc_reg_reg[7] ),
        .O(crc_error_reg));
  LUT5 #(
    .INIT(32'h01000001)) 
    crc_error_i_44
       (.I0(\payload_cnt[15]_i_14_n_0 ),
        .I1(\payload_cnt[15]_i_13_n_0 ),
        .I2(crc_error_i_55_n_0),
        .I3(\payload_cnt_reg_n_0_[15] ),
        .I4(payload_last_byte0),
        .O(crc_error_reg_0));
  LUT6 #(
    .INIT(64'h69FFFF69FF6969FF)) 
    crc_error_i_55
       (.I0(\payload_cnt_reg_n_0_[8] ),
        .I1(crc_error_i_57_n_0),
        .I2(pkt_word_count[8]),
        .I3(\payload_cnt_reg_n_0_[11] ),
        .I4(\payload_cnt[15]_i_10_n_0 ),
        .I5(pkt_word_count[11]),
        .O(crc_error_i_55_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFE00000001)) 
    crc_error_i_56
       (.I0(pkt_word_count[14]),
        .I1(pkt_word_count[12]),
        .I2(\payload_cnt[15]_i_10_n_0 ),
        .I3(pkt_word_count[11]),
        .I4(pkt_word_count[13]),
        .I5(pkt_word_count[15]),
        .O(payload_last_byte0));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    crc_error_i_57
       (.I0(pkt_word_count[6]),
        .I1(\payload_cnt[15]_i_15_n_0 ),
        .I2(pkt_word_count[7]),
        .O(crc_error_i_57_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    \crc_lsb_reg[7]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[8] ),
        .I1(\rd_ptr_bin_reg[3] ),
        .O(crc_lsb_reg));
  FDRE #(
    .INIT(1'b0)) 
    \crc_lsb_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_lsb_reg),
        .D(D[0]),
        .Q(\expected_crc_reg_reg[7] [0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \crc_lsb_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_lsb_reg),
        .D(D[1]),
        .Q(\expected_crc_reg_reg[7] [1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \crc_lsb_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_lsb_reg),
        .D(D[2]),
        .Q(\expected_crc_reg_reg[7] [2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \crc_lsb_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_lsb_reg),
        .D(D[3]),
        .Q(\expected_crc_reg_reg[7] [3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \crc_lsb_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_lsb_reg),
        .D(D[4]),
        .Q(\expected_crc_reg_reg[7] [4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \crc_lsb_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_lsb_reg),
        .D(D[5]),
        .Q(\expected_crc_reg_reg[7] [5]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \crc_lsb_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_lsb_reg),
        .D(D[6]),
        .Q(\expected_crc_reg_reg[7] [6]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \crc_lsb_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_lsb_reg),
        .D(D[7]),
        .Q(\expected_crc_reg_reg[7] [7]),
        .R(resync_req_o_reg));
  LUT4 #(
    .INIT(16'hFF8F)) 
    \crc_reg[15]_i_1 
       (.I0(\FSM_onehot_state[7]_i_2_n_0 ),
        .I1(hdr_valid),
        .I2(rst_n_IBUF),
        .I3(resync_drop_packet),
        .O(\expected_crc_reg_reg[0] ));
  LUT6 #(
    .INIT(64'hEFEBEFEFFFFBFFFF)) 
    \crc_reg[15]_i_4 
       (.I0(pending_sol_reg_1),
        .I1(\payload_dt_reg_reg[5]_0 [0]),
        .I2(\payload_dt_reg_reg[5]_0 [2]),
        .I3(\payload_dt_reg_reg[5]_0 [4]),
        .I4(\payload_dt_reg_reg[5]_0 [5]),
        .I5(state_reg),
        .O(pending_sol_reg_0));
  LUT6 #(
    .INIT(64'hFFFFBFFFBFBFBFFF)) 
    \crc_reg[15]_i_5 
       (.I0(payload_drop),
        .I1(\payload_dt_reg_reg[5]_0 [1]),
        .I2(\payload_dt_reg_reg[5]_0 [3]),
        .I3(raw10_pixel_valid),
        .I4(\payload_dt_reg_reg[5]_0 [2]),
        .I5(\payload_dt_reg_reg[5]_1 ),
        .O(pending_sol_reg_1));
  FDRE #(
    .INIT(1'b0)) 
    \dt_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[0] ),
        .Q(Q[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \dt_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[1] ),
        .Q(Q[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \dt_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[2] ),
        .Q(Q[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \dt_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[3] ),
        .Q(Q[3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \dt_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[4] ),
        .Q(Q[4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \dt_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[5] ),
        .Q(Q[5]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    ecc_ok_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(u_header_ecc_checker_n_2),
        .Q(pkt_ecc_ok),
        .R(resync_req_o_reg));
  LUT2 #(
    .INIT(4'h2)) 
    err_ecc_o_OBUF_inst_i_1
       (.I0(hdr_valid),
        .I1(pkt_ecc_ok),
        .O(err_ecc_o_OBUF));
  LUT4 #(
    .INIT(16'hFFBE)) 
    err_valid_o_i_1
       (.I0(err_valid_o_i_2_n_0),
        .I1(out),
        .I2(lane_err_sync_d),
        .I3(sync_error_reg_1),
        .O(err_valid_o_reg));
  LUT4 #(
    .INIT(16'hF444)) 
    err_valid_o_i_2
       (.I0(pkt_ecc_ok),
        .I1(hdr_valid),
        .I2(crc_valid),
        .I3(crc_error),
        .O(err_valid_o_i_2_n_0));
  LUT5 #(
    .INIT(32'hFFF70004)) 
    frame_active_i_1
       (.I0(Q[0]),
        .I1(short_event_valid),
        .I2(Q[1]),
        .I3(frame_end_i_2_n_0),
        .I4(frame_active_reg_0),
        .O(frame_active_reg));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT4 #(
    .INIT(16'h0008)) 
    frame_end_i_1
       (.I0(frame_active_reg_0),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(frame_end_i_2_n_0),
        .O(frame_end_reg));
  LUT4 #(
    .INIT(16'hFFFE)) 
    frame_end_i_2
       (.I0(Q[4]),
        .I1(Q[5]),
        .I2(Q[3]),
        .I3(Q[2]),
        .O(frame_end_i_2_n_0));
  LUT4 #(
    .INIT(16'h75FF)) 
    frame_start_i_1
       (.I0(short_event_valid),
        .I1(resync_req_d),
        .I2(resync_drop_packet),
        .I3(rst_n_IBUF),
        .O(sync_error_reg_0));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    frame_start_i_2
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[2]),
        .I3(Q[3]),
        .I4(Q[5]),
        .I5(Q[4]),
        .O(frame_start_reg));
  LUT3 #(
    .INIT(8'h08)) 
    frame_start_i_3
       (.I0(hdr_valid),
        .I1(frame_start_i_4_n_0),
        .I2(\FSM_onehot_state[7]_i_2_n_0 ),
        .O(short_event_valid));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    frame_start_i_4
       (.I0(Q[4]),
        .I1(Q[5]),
        .I2(Q[2]),
        .I3(Q[3]),
        .I4(pkt_vc[1]),
        .I5(pkt_vc[0]),
        .O(frame_start_i_4_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    \header_data_reg[15]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[1] ),
        .I1(\rd_ptr_bin_reg[3] ),
        .O(\header_data_reg[15]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \header_data_reg[23]_i_1 
       (.I0(p_0_in1_in),
        .I1(\rd_ptr_bin_reg[3] ),
        .O(\header_data_reg[23]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \header_data_reg[7]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(\rd_ptr_bin_reg[3] ),
        .O(\header_data_reg[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[7]_i_1_n_0 ),
        .D(D[0]),
        .Q(\header_data_reg_reg_n_0_[0] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[10] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[15]_i_1_n_0 ),
        .D(D[2]),
        .Q(\header_data_reg_reg_n_0_[10] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[11] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[15]_i_1_n_0 ),
        .D(D[3]),
        .Q(\header_data_reg_reg_n_0_[11] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[12] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[15]_i_1_n_0 ),
        .D(D[4]),
        .Q(\header_data_reg_reg_n_0_[12] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[13] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[15]_i_1_n_0 ),
        .D(D[5]),
        .Q(\header_data_reg_reg_n_0_[13] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[14] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[15]_i_1_n_0 ),
        .D(D[6]),
        .Q(\header_data_reg_reg_n_0_[14] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[15] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[15]_i_1_n_0 ),
        .D(D[7]),
        .Q(\header_data_reg_reg_n_0_[15] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[16] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[23]_i_1_n_0 ),
        .D(D[0]),
        .Q(\header_data_reg_reg_n_0_[16] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[17] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[23]_i_1_n_0 ),
        .D(D[1]),
        .Q(\header_data_reg_reg_n_0_[17] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[18] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[23]_i_1_n_0 ),
        .D(D[2]),
        .Q(\header_data_reg_reg_n_0_[18] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[19] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[23]_i_1_n_0 ),
        .D(D[3]),
        .Q(\header_data_reg_reg_n_0_[19] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[7]_i_1_n_0 ),
        .D(D[1]),
        .Q(\header_data_reg_reg_n_0_[1] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[20] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[23]_i_1_n_0 ),
        .D(D[4]),
        .Q(\header_data_reg_reg_n_0_[20] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[21] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[23]_i_1_n_0 ),
        .D(D[5]),
        .Q(\header_data_reg_reg_n_0_[21] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[22] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[23]_i_1_n_0 ),
        .D(D[6]),
        .Q(\header_data_reg_reg_n_0_[22] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[23] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[23]_i_1_n_0 ),
        .D(D[7]),
        .Q(\header_data_reg_reg_n_0_[23] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[7]_i_1_n_0 ),
        .D(D[2]),
        .Q(\header_data_reg_reg_n_0_[2] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[7]_i_1_n_0 ),
        .D(D[3]),
        .Q(\header_data_reg_reg_n_0_[3] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[7]_i_1_n_0 ),
        .D(D[4]),
        .Q(\header_data_reg_reg_n_0_[4] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[7]_i_1_n_0 ),
        .D(D[5]),
        .Q(\header_data_reg_reg_n_0_[5] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[7]_i_1_n_0 ),
        .D(D[6]),
        .Q(\header_data_reg_reg_n_0_[6] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[7]_i_1_n_0 ),
        .D(D[7]),
        .Q(\header_data_reg_reg_n_0_[7] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[15]_i_1_n_0 ),
        .D(D[0]),
        .Q(\header_data_reg_reg_n_0_[8] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_data_reg_reg[9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\header_data_reg[15]_i_1_n_0 ),
        .D(D[1]),
        .Q(\header_data_reg_reg_n_0_[9] ),
        .R(resync_req_o_reg));
  LUT2 #(
    .INIT(4'h8)) 
    \header_ecc_reg[5]_i_1 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(\rd_ptr_bin_reg[3] ),
        .O(header_ecc_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_ecc_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(header_ecc_reg),
        .D(D[0]),
        .Q(\header_ecc_reg_reg_n_0_[0] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_ecc_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(header_ecc_reg),
        .D(D[1]),
        .Q(\header_ecc_reg_reg_n_0_[1] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_ecc_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(header_ecc_reg),
        .D(D[2]),
        .Q(\header_ecc_reg_reg_n_0_[2] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_ecc_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(header_ecc_reg),
        .D(D[3]),
        .Q(\header_ecc_reg_reg_n_0_[3] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_ecc_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(header_ecc_reg),
        .D(D[4]),
        .Q(\header_ecc_reg_reg_n_0_[4] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \header_ecc_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(header_ecc_reg),
        .D(D[5]),
        .Q(\header_ecc_reg_reg_n_0_[5] ),
        .R(resync_req_o_reg));
  LUT6 #(
    .INIT(64'hD0F0F2F0D0D0D0D0)) 
    line_active_i_1
       (.I0(short_event_valid),
        .I1(frame_end_i_2_n_0),
        .I2(line_active_reg_0),
        .I3(frame_active_reg_0),
        .I4(Q[0]),
        .I5(Q[1]),
        .O(line_active_reg));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'h00008000)) 
    line_end_i_1
       (.I0(Q[0]),
        .I1(frame_active_reg_0),
        .I2(line_active_reg_0),
        .I3(Q[1]),
        .I4(frame_end_i_2_n_0),
        .O(line_end_reg));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'h00000020)) 
    line_start_i_1
       (.I0(frame_active_reg_0),
        .I1(line_active_reg_0),
        .I2(Q[1]),
        .I3(Q[0]),
        .I4(frame_end_i_2_n_0),
        .O(line_start_reg));
  LUT3 #(
    .INIT(8'h02)) 
    \payload_cnt[0]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[0] ),
        .I2(payload_last_byte),
        .O(payload_cnt[0]));
  LUT4 #(
    .INIT(16'h0028)) 
    \payload_cnt[10]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[10] ),
        .I2(\payload_cnt[10]_i_2_n_0 ),
        .I3(payload_last_byte),
        .O(payload_cnt[10]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \payload_cnt[10]_i_2 
       (.I0(\payload_cnt_reg_n_0_[9] ),
        .I1(\payload_cnt_reg_n_0_[7] ),
        .I2(\payload_cnt[8]_i_2_n_0 ),
        .I3(\payload_cnt_reg_n_0_[6] ),
        .I4(\payload_cnt_reg_n_0_[8] ),
        .O(\payload_cnt[10]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h0028)) 
    \payload_cnt[11]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[11] ),
        .I2(\payload_cnt[13]_i_2_n_0 ),
        .I3(payload_last_byte),
        .O(payload_cnt[11]));
  LUT5 #(
    .INIT(32'h00002888)) 
    \payload_cnt[12]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[12] ),
        .I2(\payload_cnt_reg_n_0_[11] ),
        .I3(\payload_cnt[13]_i_2_n_0 ),
        .I4(payload_last_byte),
        .O(payload_cnt[12]));
  LUT6 #(
    .INIT(64'h0000000028888888)) 
    \payload_cnt[13]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[13] ),
        .I2(\payload_cnt_reg_n_0_[12] ),
        .I3(\payload_cnt[13]_i_2_n_0 ),
        .I4(\payload_cnt_reg_n_0_[11] ),
        .I5(payload_last_byte),
        .O(payload_cnt[13]));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \payload_cnt[13]_i_2 
       (.I0(\payload_cnt_reg_n_0_[10] ),
        .I1(\payload_cnt_reg_n_0_[8] ),
        .I2(\payload_cnt_reg_n_0_[6] ),
        .I3(\payload_cnt[8]_i_2_n_0 ),
        .I4(\payload_cnt_reg_n_0_[7] ),
        .I5(\payload_cnt_reg_n_0_[9] ),
        .O(\payload_cnt[13]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h0028)) 
    \payload_cnt[14]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[14] ),
        .I2(\payload_cnt[15]_i_4_n_0 ),
        .I3(payload_last_byte),
        .O(payload_cnt[14]));
  LUT5 #(
    .INIT(32'hFFF8FFF0)) 
    \payload_cnt[15]_i_1 
       (.I0(pending_sol_reg),
        .I1(fifo_rd_ready),
        .I2(hdr_valid),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .I4(p_0_in),
        .O(\payload_cnt[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \payload_cnt[15]_i_10 
       (.I0(pkt_word_count[9]),
        .I1(pkt_word_count[7]),
        .I2(\payload_cnt[15]_i_15_n_0 ),
        .I3(pkt_word_count[6]),
        .I4(pkt_word_count[8]),
        .I5(pkt_word_count[10]),
        .O(\payload_cnt[15]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \payload_cnt[15]_i_11 
       (.I0(pkt_word_count[10]),
        .I1(pkt_word_count[8]),
        .I2(\payload_cnt[15]_i_16_n_0 ),
        .I3(pkt_word_count[7]),
        .I4(pkt_word_count[9]),
        .I5(pkt_word_count[11]),
        .O(\payload_cnt[15]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'h5556AAA9)) 
    \payload_cnt[15]_i_12 
       (.I0(pkt_word_count[8]),
        .I1(pkt_word_count[6]),
        .I2(\payload_cnt[15]_i_15_n_0 ),
        .I3(pkt_word_count[7]),
        .I4(\payload_cnt_reg_n_0_[8] ),
        .O(\payload_cnt[15]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF7EBDD7EB)) 
    \payload_cnt[15]_i_13 
       (.I0(pkt_word_count[10]),
        .I1(\payload_cnt[15]_i_17_n_0 ),
        .I2(pkt_word_count[9]),
        .I3(\payload_cnt_reg_n_0_[10] ),
        .I4(\payload_cnt_reg_n_0_[9] ),
        .I5(\payload_cnt[15]_i_18_n_0 ),
        .O(\payload_cnt[15]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFBDE7)) 
    \payload_cnt[15]_i_14 
       (.I0(\payload_cnt_reg_n_0_[0] ),
        .I1(\payload_cnt_reg_n_0_[1] ),
        .I2(pkt_word_count[0]),
        .I3(pkt_word_count[1]),
        .I4(\payload_cnt[15]_i_19_n_0 ),
        .I5(\payload_cnt[15]_i_20_n_0 ),
        .O(\payload_cnt[15]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \payload_cnt[15]_i_15 
       (.I0(pkt_word_count[4]),
        .I1(pkt_word_count[2]),
        .I2(pkt_word_count[0]),
        .I3(pkt_word_count[1]),
        .I4(pkt_word_count[3]),
        .I5(pkt_word_count[5]),
        .O(\payload_cnt[15]_i_15_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \payload_cnt[15]_i_16 
       (.I0(pkt_word_count[5]),
        .I1(pkt_word_count[3]),
        .I2(\payload_cnt[15]_i_21_n_0 ),
        .I3(pkt_word_count[2]),
        .I4(pkt_word_count[4]),
        .I5(pkt_word_count[6]),
        .O(\payload_cnt[15]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \payload_cnt[15]_i_17 
       (.I0(pkt_word_count[7]),
        .I1(\payload_cnt[15]_i_15_n_0 ),
        .I2(pkt_word_count[6]),
        .I3(pkt_word_count[8]),
        .O(\payload_cnt[15]_i_17_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'h7BBDDEE7)) 
    \payload_cnt[15]_i_18 
       (.I0(\payload_cnt_reg_n_0_[6] ),
        .I1(\payload_cnt_reg_n_0_[7] ),
        .I2(pkt_word_count[6]),
        .I3(\payload_cnt[15]_i_15_n_0 ),
        .I4(pkt_word_count[7]),
        .O(\payload_cnt[15]_i_18_n_0 ));
  LUT6 #(
    .INIT(64'h7B7B7BBDDEDEDEE7)) 
    \payload_cnt[15]_i_19 
       (.I0(\payload_cnt_reg_n_0_[3] ),
        .I1(\payload_cnt_reg_n_0_[4] ),
        .I2(pkt_word_count[3]),
        .I3(\payload_cnt[15]_i_21_n_0 ),
        .I4(pkt_word_count[2]),
        .I5(pkt_word_count[4]),
        .O(\payload_cnt[15]_i_19_n_0 ));
  LUT5 #(
    .INIT(32'h00002888)) 
    \payload_cnt[15]_i_2 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[15] ),
        .I2(\payload_cnt_reg_n_0_[14] ),
        .I3(\payload_cnt[15]_i_4_n_0 ),
        .I4(payload_last_byte),
        .O(payload_cnt[15]));
  LUT6 #(
    .INIT(64'h69FFFF69FF6969FF)) 
    \payload_cnt[15]_i_20 
       (.I0(\payload_cnt_reg_n_0_[2] ),
        .I1(\payload_cnt[15]_i_21_n_0 ),
        .I2(pkt_word_count[2]),
        .I3(\payload_cnt_reg_n_0_[5] ),
        .I4(\payload_cnt[15]_i_22_n_0 ),
        .I5(pkt_word_count[5]),
        .O(\payload_cnt[15]_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \payload_cnt[15]_i_21 
       (.I0(pkt_word_count[0]),
        .I1(pkt_word_count[1]),
        .O(\payload_cnt[15]_i_21_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \payload_cnt[15]_i_22 
       (.I0(pkt_word_count[3]),
        .I1(pkt_word_count[1]),
        .I2(pkt_word_count[0]),
        .I3(pkt_word_count[2]),
        .I4(pkt_word_count[4]),
        .O(\payload_cnt[15]_i_22_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \payload_cnt[15]_i_3 
       (.I0(p_0_in),
        .I1(\rd_ptr_gray_reg[3] ),
        .O(pending_sol_reg));
  LUT4 #(
    .INIT(16'h8000)) 
    \payload_cnt[15]_i_4 
       (.I0(\payload_cnt_reg_n_0_[13] ),
        .I1(\payload_cnt_reg_n_0_[11] ),
        .I2(\payload_cnt[13]_i_2_n_0 ),
        .I3(\payload_cnt_reg_n_0_[12] ),
        .O(\payload_cnt[15]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h9600000000000000)) 
    \payload_cnt[15]_i_5 
       (.I0(pkt_word_count[14]),
        .I1(\payload_cnt[15]_i_6_n_0 ),
        .I2(\payload_cnt_reg_n_0_[14] ),
        .I3(\payload_cnt[15]_i_7_n_0 ),
        .I4(\payload_cnt[15]_i_8_n_0 ),
        .I5(\payload_cnt[15]_i_9_n_0 ),
        .O(payload_last_byte));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \payload_cnt[15]_i_6 
       (.I0(pkt_word_count[12]),
        .I1(\payload_cnt[15]_i_10_n_0 ),
        .I2(pkt_word_count[11]),
        .I3(pkt_word_count[13]),
        .O(\payload_cnt[15]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hA801540202A80154)) 
    \payload_cnt[15]_i_7 
       (.I0(pkt_word_count[13]),
        .I1(pkt_word_count[11]),
        .I2(\payload_cnt[15]_i_10_n_0 ),
        .I3(pkt_word_count[12]),
        .I4(\payload_cnt_reg_n_0_[13] ),
        .I5(\payload_cnt_reg_n_0_[12] ),
        .O(\payload_cnt[15]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAA955555556)) 
    \payload_cnt[15]_i_8 
       (.I0(pkt_word_count[15]),
        .I1(pkt_word_count[13]),
        .I2(\payload_cnt[15]_i_11_n_0 ),
        .I3(pkt_word_count[12]),
        .I4(pkt_word_count[14]),
        .I5(\payload_cnt_reg_n_0_[15] ),
        .O(\payload_cnt[15]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000004114)) 
    \payload_cnt[15]_i_9 
       (.I0(\payload_cnt[15]_i_12_n_0 ),
        .I1(\payload_cnt_reg_n_0_[11] ),
        .I2(\payload_cnt[15]_i_10_n_0 ),
        .I3(pkt_word_count[11]),
        .I4(\payload_cnt[15]_i_13_n_0 ),
        .I5(\payload_cnt[15]_i_14_n_0 ),
        .O(\payload_cnt[15]_i_9_n_0 ));
  LUT4 #(
    .INIT(16'h0028)) 
    \payload_cnt[1]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[1] ),
        .I2(\payload_cnt_reg_n_0_[0] ),
        .I3(payload_last_byte),
        .O(payload_cnt[1]));
  LUT5 #(
    .INIT(32'h00002888)) 
    \payload_cnt[2]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[2] ),
        .I2(\payload_cnt_reg_n_0_[1] ),
        .I3(\payload_cnt_reg_n_0_[0] ),
        .I4(payload_last_byte),
        .O(payload_cnt[2]));
  LUT6 #(
    .INIT(64'h0000000028888888)) 
    \payload_cnt[3]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[3] ),
        .I2(\payload_cnt_reg_n_0_[2] ),
        .I3(\payload_cnt_reg_n_0_[0] ),
        .I4(\payload_cnt_reg_n_0_[1] ),
        .I5(payload_last_byte),
        .O(payload_cnt[3]));
  LUT4 #(
    .INIT(16'h0028)) 
    \payload_cnt[4]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[4] ),
        .I2(\payload_cnt[4]_i_2_n_0 ),
        .I3(payload_last_byte),
        .O(payload_cnt[4]));
  LUT4 #(
    .INIT(16'h8000)) 
    \payload_cnt[4]_i_2 
       (.I0(\payload_cnt_reg_n_0_[3] ),
        .I1(\payload_cnt_reg_n_0_[1] ),
        .I2(\payload_cnt_reg_n_0_[0] ),
        .I3(\payload_cnt_reg_n_0_[2] ),
        .O(\payload_cnt[4]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h0028)) 
    \payload_cnt[5]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[5] ),
        .I2(\payload_cnt[5]_i_2_n_0 ),
        .I3(payload_last_byte),
        .O(payload_cnt[5]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \payload_cnt[5]_i_2 
       (.I0(\payload_cnt_reg_n_0_[4] ),
        .I1(\payload_cnt_reg_n_0_[2] ),
        .I2(\payload_cnt_reg_n_0_[0] ),
        .I3(\payload_cnt_reg_n_0_[1] ),
        .I4(\payload_cnt_reg_n_0_[3] ),
        .O(\payload_cnt[5]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h0028)) 
    \payload_cnt[6]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[6] ),
        .I2(\payload_cnt[8]_i_2_n_0 ),
        .I3(payload_last_byte),
        .O(payload_cnt[6]));
  LUT5 #(
    .INIT(32'h00002888)) 
    \payload_cnt[7]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[7] ),
        .I2(\payload_cnt_reg_n_0_[6] ),
        .I3(\payload_cnt[8]_i_2_n_0 ),
        .I4(payload_last_byte),
        .O(payload_cnt[7]));
  LUT6 #(
    .INIT(64'h0000000028888888)) 
    \payload_cnt[8]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[8] ),
        .I2(\payload_cnt_reg_n_0_[7] ),
        .I3(\payload_cnt[8]_i_2_n_0 ),
        .I4(\payload_cnt_reg_n_0_[6] ),
        .I5(payload_last_byte),
        .O(payload_cnt[8]));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \payload_cnt[8]_i_2 
       (.I0(\payload_cnt_reg_n_0_[5] ),
        .I1(\payload_cnt_reg_n_0_[3] ),
        .I2(\payload_cnt_reg_n_0_[1] ),
        .I3(\payload_cnt_reg_n_0_[0] ),
        .I4(\payload_cnt_reg_n_0_[2] ),
        .I5(\payload_cnt_reg_n_0_[4] ),
        .O(\payload_cnt[8]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h0028)) 
    \payload_cnt[9]_i_1 
       (.I0(p_0_in),
        .I1(\payload_cnt_reg_n_0_[9] ),
        .I2(\payload_cnt[9]_i_2_n_0 ),
        .I3(payload_last_byte),
        .O(payload_cnt[9]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    \payload_cnt[9]_i_2 
       (.I0(\payload_cnt_reg_n_0_[8] ),
        .I1(\payload_cnt_reg_n_0_[6] ),
        .I2(\payload_cnt[8]_i_2_n_0 ),
        .I3(\payload_cnt_reg_n_0_[7] ),
        .O(\payload_cnt[9]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[0]),
        .Q(\payload_cnt_reg_n_0_[0] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[10] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[10]),
        .Q(\payload_cnt_reg_n_0_[10] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[11] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[11]),
        .Q(\payload_cnt_reg_n_0_[11] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[12] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[12]),
        .Q(\payload_cnt_reg_n_0_[12] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[13] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[13]),
        .Q(\payload_cnt_reg_n_0_[13] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[14] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[14]),
        .Q(\payload_cnt_reg_n_0_[14] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[15] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[15]),
        .Q(\payload_cnt_reg_n_0_[15] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[1]),
        .Q(\payload_cnt_reg_n_0_[1] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[2]),
        .Q(\payload_cnt_reg_n_0_[2] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[3]),
        .Q(\payload_cnt_reg_n_0_[3] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[4]),
        .Q(\payload_cnt_reg_n_0_[4] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[5]),
        .Q(\payload_cnt_reg_n_0_[5] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[6]),
        .Q(\payload_cnt_reg_n_0_[6] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[7]),
        .Q(\payload_cnt_reg_n_0_[7] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[8]),
        .Q(\payload_cnt_reg_n_0_[8] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \payload_cnt_reg[9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\payload_cnt[15]_i_1_n_0 ),
        .D(payload_cnt[9]),
        .Q(\payload_cnt_reg_n_0_[9] ),
        .R(resync_req_o_reg));
  LUT2 #(
    .INIT(4'h8)) 
    \payload_dt_reg[5]_i_2 
       (.I0(\FSM_onehot_state[7]_i_2_n_0 ),
        .I1(hdr_valid),
        .O(\payload_dt_reg_reg[0] ));
  LUT5 #(
    .INIT(32'hAEAAAAAA)) 
    pending_sof_i_1
       (.I0(SR),
        .I1(pending_sol_reg_0),
        .I2(payload_done_reg),
        .I3(pending_sol_reg),
        .I4(payload_start),
        .O(pending_sol));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'h20)) 
    \pixel_data_o[7]_i_1__1 
       (.I0(pending_sol_reg),
        .I1(payload_drop),
        .I2(\payload_dt_reg_reg[2] ),
        .O(\pixel_data_o_reg[0] ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'h20000000)) 
    pixel_sof_o_i_1__1
       (.I0(pending_sol_reg),
        .I1(payload_drop),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(O59),
        .I4(\byte_idx_reg[1]_0 [1]),
        .O(pixel_sof_o3_out));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'h00800000)) 
    pixel_sof_o_i_1__2
       (.I0(pending_sof),
        .I1(payload_start),
        .I2(pending_sol_reg),
        .I3(payload_drop),
        .I4(\payload_dt_reg_reg[2] ),
        .O(pixel_sof_o_reg));
  LUT5 #(
    .INIT(32'h20000000)) 
    pixel_sol_o_i_1__0
       (.I0(pending_sol_reg),
        .I1(payload_drop),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(sol_reg),
        .I4(\byte_idx_reg[1]_0 [1]),
        .O(pixel_sol_o1_out));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h00800000)) 
    pixel_sol_o_i_1__1
       (.I0(pending_sol_reg_2),
        .I1(payload_start),
        .I2(pending_sol_reg),
        .I3(payload_drop),
        .I4(\payload_dt_reg_reg[2] ),
        .O(pixel_sol_o_reg));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'hFF20FF00)) 
    pixel_valid_o_i_1__0
       (.I0(pending_sol_reg),
        .I1(payload_drop),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_valid_o),
        .I4(\byte_idx_reg[1]_0 [1]),
        .O(I137));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT4 #(
    .INIT(16'h2000)) 
    pixel_valid_o_i_2
       (.I0(pending_sol_reg),
        .I1(payload_drop),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(\byte_idx_reg[1]_0 [1]),
        .O(I138));
  LUT2 #(
    .INIT(4'h2)) 
    \rd_ptr_gray[3]_i_1__0 
       (.I0(fifo_rd_ready),
        .I1(\rd_ptr_gray_reg[3] ),
        .O(\rd_ptr_bin_reg[3] ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \rd_ptr_gray[3]_i_3 
       (.I0(\FSM_onehot_state_reg_n_0_[3] ),
        .I1(p_0_in1_in),
        .I2(\FSM_onehot_state_reg_n_0_[1] ),
        .I3(\rd_ptr_gray[3]_i_5_n_0 ),
        .I4(\FSM_onehot_state_reg_n_0_[0] ),
        .O(fifo_rd_ready));
  LUT6 #(
    .INIT(64'h30AA30AA30FF30AA)) 
    \rd_ptr_gray[3]_i_5 
       (.I0(\FSM_onehot_state_reg_n_0_[8] ),
        .I1(payload_done_reg),
        .I2(pending_sol_reg_0),
        .I3(p_0_in),
        .I4(out11),
        .I5(crc_valid_reg_0),
        .O(\rd_ptr_gray[3]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    sof_reg_i_1
       (.I0(pending_sof),
        .I1(payload_start),
        .O(payload_sof_i));
  LUT6 #(
    .INIT(64'h0000000000000008)) 
    sof_reg_i_2
       (.I0(sof_reg_i_3_n_0),
        .I1(pending_sol_reg),
        .I2(\payload_cnt_reg_n_0_[15] ),
        .I3(\payload_cnt_reg_n_0_[14] ),
        .I4(\payload_cnt_reg_n_0_[13] ),
        .I5(\payload_cnt_reg_n_0_[12] ),
        .O(payload_start));
  LUT6 #(
    .INIT(64'h0000000200000000)) 
    sof_reg_i_3
       (.I0(sof_reg_i_4_n_0),
        .I1(\payload_cnt_reg_n_0_[7] ),
        .I2(\payload_cnt_reg_n_0_[6] ),
        .I3(\payload_cnt_reg_n_0_[5] ),
        .I4(\payload_cnt_reg_n_0_[4] ),
        .I5(sof_reg_i_5_n_0),
        .O(sof_reg_i_3_n_0));
  LUT4 #(
    .INIT(16'h0001)) 
    sof_reg_i_4
       (.I0(\payload_cnt_reg_n_0_[11] ),
        .I1(\payload_cnt_reg_n_0_[10] ),
        .I2(\payload_cnt_reg_n_0_[9] ),
        .I3(\payload_cnt_reg_n_0_[8] ),
        .O(sof_reg_i_4_n_0));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    sof_reg_i_5
       (.I0(\payload_cnt_reg_n_0_[1] ),
        .I1(\payload_cnt_reg_n_0_[0] ),
        .I2(\payload_cnt_reg_n_0_[3] ),
        .I3(\payload_cnt_reg_n_0_[2] ),
        .O(sof_reg_i_5_n_0));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT2 #(
    .INIT(4'h8)) 
    sol_reg_i_1
       (.I0(pending_sol_reg_2),
        .I1(payload_start),
        .O(payload_sol_i));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'h000079EE)) 
    sync_error_i_1
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(line_active_reg_0),
        .I3(frame_active_reg_0),
        .I4(frame_end_i_2_n_0),
        .O(sync_error_reg));
  csi2_header_ecc_checker u_header_ecc_checker
       (.E(u_header_ecc_checker_n_0),
        .\FSM_onehot_state_reg[3] (\rd_ptr_bin_reg[3] ),
        .\FSM_onehot_state_reg[7] (\FSM_onehot_state[9]_i_3_n_0 ),
        .Q({\header_data_reg_reg_n_0_[23] ,\header_data_reg_reg_n_0_[22] ,\header_data_reg_reg_n_0_[21] ,\header_data_reg_reg_n_0_[20] ,\header_data_reg_reg_n_0_[19] ,\header_data_reg_reg_n_0_[18] ,\header_data_reg_reg_n_0_[17] ,\header_data_reg_reg_n_0_[16] ,\header_data_reg_reg_n_0_[15] ,\header_data_reg_reg_n_0_[14] ,\header_data_reg_reg_n_0_[13] ,\header_data_reg_reg_n_0_[12] ,\header_data_reg_reg_n_0_[11] ,\header_data_reg_reg_n_0_[10] ,\header_data_reg_reg_n_0_[9] ,\header_data_reg_reg_n_0_[8] ,\header_data_reg_reg_n_0_[7] ,\header_data_reg_reg_n_0_[6] ,\header_data_reg_reg_n_0_[5] ,\header_data_reg_reg_n_0_[4] ,\header_data_reg_reg_n_0_[3] ,\header_data_reg_reg_n_0_[2] ,\header_data_reg_reg_n_0_[1] ,\header_data_reg_reg_n_0_[0] }),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .ecc_ok_reg(u_header_ecc_checker_n_1),
        .ecc_ok_reg_0(u_header_ecc_checker_n_2),
        .\header_ecc_reg_reg[5] ({\header_ecc_reg_reg_n_0_[5] ,\header_ecc_reg_reg_n_0_[4] ,\header_ecc_reg_reg_n_0_[3] ,\header_ecc_reg_reg_n_0_[2] ,\header_ecc_reg_reg_n_0_[1] ,\header_ecc_reg_reg_n_0_[0] }),
        .out({out11,\FSM_onehot_state_reg_n_0_[8] ,hdr_valid,ecc_ready,ecc_hdr_valid}),
        .rst_n(rst_n));
  FDRE #(
    .INIT(1'b0)) 
    \vc_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[6] ),
        .Q(pkt_vc[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \vc_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[7] ),
        .Q(pkt_vc[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[8] ),
        .Q(pkt_word_count[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[10] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[18] ),
        .Q(pkt_word_count[10]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[11] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[19] ),
        .Q(pkt_word_count[11]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[12] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[20] ),
        .Q(pkt_word_count[12]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[13] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[21] ),
        .Q(pkt_word_count[13]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[14] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[22] ),
        .Q(pkt_word_count[14]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[15] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[23] ),
        .Q(pkt_word_count[15]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[9] ),
        .Q(pkt_word_count[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[10] ),
        .Q(pkt_word_count[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[11] ),
        .Q(pkt_word_count[3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[12] ),
        .Q(pkt_word_count[4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[13] ),
        .Q(pkt_word_count[5]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[14] ),
        .Q(pkt_word_count[6]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[15] ),
        .Q(pkt_word_count[7]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[16] ),
        .Q(pkt_word_count[8]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \word_count_reg[9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(u_header_ecc_checker_n_1),
        .D(\header_data_reg_reg_n_0_[17] ),
        .Q(pkt_word_count[9]),
        .R(resync_req_o_reg));
endmodule

module csi2_payload_crc_checker
   (crc_valid,
    active,
    crc_error,
    Q,
    err_crc_o_OBUF,
    pending_sol_reg,
    crc_error_reg_0,
    \payload_cnt_reg[0] ,
    pending_sol_reg_0,
    crc_error_reg_1,
    \FSM_onehot_state_reg[6] ,
    clk_sys_IBUF_BUFG,
    \FSM_onehot_state_reg[6]_0 ,
    \payload_dt_reg_reg[0] ,
    rd_data,
    D,
    \crc_reg_reg[3]_0 ,
    \payload_dt_reg_reg[5] ,
    \crc_lsb_reg_reg[7] ,
    \crc_reg_reg[10]_0 ,
    \crc_reg_reg[6]_0 ,
    \rd_ptr_gray_reg[3] ,
    out11,
    \payload_cnt_reg[12] ,
    \payload_cnt_reg[15] ,
    \FSM_onehot_state_reg[7] ,
    \payload_dt_reg_reg[0]_0 ,
    \payload_dt_reg_reg[1] ,
    state_reg,
    \crc_lsb_reg_reg[0] ,
    \crc_lsb_reg_reg[3] ,
    \crc_calc_reg[15]_0 ,
    E);
  output crc_valid;
  output active;
  output crc_error;
  output [8:0]Q;
  output err_crc_o_OBUF;
  output pending_sol_reg;
  output crc_error_reg_0;
  output \payload_cnt_reg[0] ;
  output pending_sol_reg_0;
  output [6:0]crc_error_reg_1;
  input \FSM_onehot_state_reg[6] ;
  input clk_sys_IBUF_BUFG;
  input \FSM_onehot_state_reg[6]_0 ;
  input \payload_dt_reg_reg[0] ;
  input [7:0]rd_data;
  input [2:0]D;
  input [3:0]\crc_reg_reg[3]_0 ;
  input [1:0]\payload_dt_reg_reg[5] ;
  input [7:0]\crc_lsb_reg_reg[7] ;
  input \crc_reg_reg[10]_0 ;
  input \crc_reg_reg[6]_0 ;
  input \rd_ptr_gray_reg[3] ;
  input [0:0]out11;
  input \payload_cnt_reg[12] ;
  input \payload_cnt_reg[15] ;
  input \FSM_onehot_state_reg[7] ;
  input \payload_dt_reg_reg[0]_0 ;
  input \payload_dt_reg_reg[1] ;
  input state_reg;
  input \crc_lsb_reg_reg[0] ;
  input \crc_lsb_reg_reg[3] ;
  input \crc_calc_reg[15]_0 ;
  input [0:0]E;

  wire \<const0> ;
  wire \<const1> ;
  wire [2:0]D;
  wire [0:0]E;
  wire \FSM_onehot_state_reg[6] ;
  wire \FSM_onehot_state_reg[6]_0 ;
  wire \FSM_onehot_state_reg[7] ;
  wire [8:0]Q;
  wire active;
  wire clk_sys_IBUF_BUFG;
  wire [15:0]compare_crc;
  wire [14:0]crc16_next_byte_return;
  wire \crc_calc[8]_i_2_n_0 ;
  wire \crc_calc_reg[15]_0 ;
  wire \crc_calc_reg_n_0_[10] ;
  wire \crc_calc_reg_n_0_[11] ;
  wire \crc_calc_reg_n_0_[12] ;
  wire \crc_calc_reg_n_0_[13] ;
  wire \crc_calc_reg_n_0_[14] ;
  wire \crc_calc_reg_n_0_[6] ;
  wire \crc_calc_reg_n_0_[7] ;
  wire \crc_calc_reg_n_0_[8] ;
  wire \crc_calc_reg_n_0_[9] ;
  wire crc_error;
  wire crc_error_i_10_n_0;
  wire crc_error_i_11_n_0;
  wire crc_error_i_12_n_0;
  wire crc_error_i_13_n_0;
  wire crc_error_i_14_n_0;
  wire crc_error_i_15_n_0;
  wire crc_error_i_16_n_0;
  wire crc_error_i_1_n_0;
  wire crc_error_i_20_n_0;
  wire crc_error_i_21_n_0;
  wire crc_error_i_22_n_0;
  wire crc_error_i_23_n_0;
  wire crc_error_i_24_n_0;
  wire crc_error_i_25_n_0;
  wire crc_error_i_26_n_0;
  wire crc_error_i_27_n_0;
  wire crc_error_i_28_n_0;
  wire crc_error_i_29_n_0;
  wire crc_error_i_2_n_0;
  wire crc_error_i_30_n_0;
  wire crc_error_i_31_n_0;
  wire crc_error_i_32_n_0;
  wire crc_error_i_33_n_0;
  wire crc_error_i_34_n_0;
  wire crc_error_i_37_n_0;
  wire crc_error_i_38_n_0;
  wire crc_error_i_39_n_0;
  wire crc_error_i_3_n_0;
  wire crc_error_i_40_n_0;
  wire crc_error_i_41_n_0;
  wire crc_error_i_42_n_0;
  wire crc_error_i_45_n_0;
  wire crc_error_i_46_n_0;
  wire crc_error_i_47_n_0;
  wire crc_error_i_48_n_0;
  wire crc_error_i_49_n_0;
  wire crc_error_i_4_n_0;
  wire crc_error_i_50_n_0;
  wire crc_error_i_52_n_0;
  wire crc_error_i_53_n_0;
  wire crc_error_i_5_n_0;
  wire crc_error_i_6_n_0;
  wire crc_error_i_7_n_0;
  wire crc_error_i_8_n_0;
  wire crc_error_i_9_n_0;
  wire crc_error_reg_0;
  wire [6:0]crc_error_reg_1;
  wire \crc_lsb_reg_reg[0] ;
  wire \crc_lsb_reg_reg[3] ;
  wire [7:0]\crc_lsb_reg_reg[7] ;
  wire \crc_reg_reg[10]_0 ;
  wire [3:0]\crc_reg_reg[3]_0 ;
  wire \crc_reg_reg[6]_0 ;
  wire crc_tmp118_out;
  wire crc_valid;
  wire crc_valid_i_1_n_0;
  wire crc_valid_i_2_n_0;
  wire err_crc_o_OBUF;
  wire [15:0]expected_crc_reg;
  wire expected_fire;
  wire expected_seen;
  wire expected_seen_i_1_n_0;
  wire [14:0]finish_crc;
  wire [0:0]out11;
  wire [14:7]p_0_in;
  wire p_5_in;
  wire \payload_cnt_reg[0] ;
  wire \payload_cnt_reg[12] ;
  wire \payload_cnt_reg[15] ;
  wire payload_done;
  wire payload_done_i_1_n_0;
  wire \payload_dt_reg_reg[0] ;
  wire \payload_dt_reg_reg[0]_0 ;
  wire \payload_dt_reg_reg[1] ;
  wire [1:0]\payload_dt_reg_reg[5] ;
  wire pending_sol_reg;
  wire pending_sol_reg_0;
  wire [7:0]rd_data;
  wire \rd_ptr_gray_reg[3] ;
  wire state_reg;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  FDRE #(
    .INIT(1'b0)) 
    active_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\FSM_onehot_state_reg[6]_0 ),
        .Q(active),
        .R(\<const0> ));
  LUT5 #(
    .INIT(32'h96696996)) 
    \crc_calc[0]_i_1 
       (.I0(Q[0]),
        .I1(rd_data[0]),
        .I2(Q[4]),
        .I3(rd_data[4]),
        .I4(p_0_in[7]),
        .O(finish_crc[0]));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \crc_calc[10]_i_1 
       (.I0(rd_data[2]),
        .I1(Q[2]),
        .I2(crc_tmp118_out),
        .O(finish_crc[10]));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \crc_calc[13]_i_1 
       (.I0(Q[5]),
        .I1(Q[1]),
        .I2(rd_data[1]),
        .I3(rd_data[5]),
        .O(finish_crc[13]));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \crc_calc[14]_i_1 
       (.I0(Q[2]),
        .I1(rd_data[2]),
        .I2(Q[6]),
        .I3(rd_data[6]),
        .O(finish_crc[14]));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \crc_calc[1]_i_1 
       (.I0(Q[1]),
        .I1(rd_data[1]),
        .I2(Q[5]),
        .I3(rd_data[5]),
        .I4(p_0_in[8]),
        .O(finish_crc[1]));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \crc_calc[2]_i_1 
       (.I0(Q[2]),
        .I1(rd_data[2]),
        .I2(Q[6]),
        .I3(rd_data[6]),
        .I4(Q[8]),
        .O(finish_crc[2]));
  LUT4 #(
    .INIT(16'h6996)) 
    \crc_calc[3]_i_1 
       (.I0(p_0_in[10]),
        .I1(Q[0]),
        .I2(rd_data[0]),
        .I3(crc_tmp118_out),
        .O(finish_crc[3]));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \crc_calc[4]_i_1 
       (.I0(rd_data[1]),
        .I1(Q[1]),
        .I2(p_0_in[11]),
        .O(finish_crc[4]));
  LUT3 #(
    .INIT(8'h96)) 
    \crc_calc[5]_i_1 
       (.I0(rd_data[2]),
        .I1(Q[2]),
        .I2(p_0_in[12]),
        .O(finish_crc[5]));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \crc_calc[6]_i_1 
       (.I0(rd_data[3]),
        .I1(Q[3]),
        .I2(p_0_in[13]),
        .O(finish_crc[6]));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \crc_calc[7]_i_1 
       (.I0(Q[0]),
        .I1(rd_data[0]),
        .I2(Q[4]),
        .I3(rd_data[4]),
        .I4(p_0_in[14]),
        .O(finish_crc[7]));
  LUT1 #(
    .INIT(2'h1)) 
    \crc_calc[8]_i_1 
       (.I0(\crc_calc[8]_i_2_n_0 ),
        .O(finish_crc[8]));
  LUT6 #(
    .INIT(64'h9669699669969669)) 
    \crc_calc[8]_i_2 
       (.I0(Q[0]),
        .I1(rd_data[0]),
        .I2(Q[5]),
        .I3(Q[1]),
        .I4(rd_data[1]),
        .I5(rd_data[5]),
        .O(\crc_calc[8]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hB88B8BB8)) 
    \crc_calc[9]_i_1 
       (.I0(p_0_in[8]),
        .I1(\payload_dt_reg_reg[0] ),
        .I2(crc16_next_byte_return[14]),
        .I3(Q[1]),
        .I4(rd_data[1]),
        .O(finish_crc[9]));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(finish_crc[0]),
        .Q(crc_error_reg_1[0]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[10] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(finish_crc[10]),
        .Q(\crc_calc_reg_n_0_[10] ),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[11] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(D[0]),
        .Q(\crc_calc_reg_n_0_[11] ),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[12] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(D[1]),
        .Q(\crc_calc_reg_n_0_[12] ),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[13] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(finish_crc[13]),
        .Q(\crc_calc_reg_n_0_[13] ),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[14] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(finish_crc[14]),
        .Q(\crc_calc_reg_n_0_[14] ),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[15] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(D[2]),
        .Q(crc_error_reg_1[6]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(finish_crc[1]),
        .Q(crc_error_reg_1[1]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(finish_crc[2]),
        .Q(crc_error_reg_1[2]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(finish_crc[3]),
        .Q(crc_error_reg_1[3]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(finish_crc[4]),
        .Q(crc_error_reg_1[4]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(finish_crc[5]),
        .Q(crc_error_reg_1[5]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(finish_crc[6]),
        .Q(\crc_calc_reg_n_0_[6] ),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(finish_crc[7]),
        .Q(\crc_calc_reg_n_0_[7] ),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(finish_crc[8]),
        .Q(\crc_calc_reg_n_0_[8] ),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_calc_reg[9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(finish_crc[9]),
        .Q(\crc_calc_reg_n_0_[9] ),
        .S(\FSM_onehot_state_reg[6] ));
  LUT6 #(
    .INIT(64'hBBB8BBBBBBB88888)) 
    crc_error_i_1
       (.I0(crc_error),
        .I1(crc_valid_i_2_n_0),
        .I2(crc_error_i_2_n_0),
        .I3(crc_error_i_3_n_0),
        .I4(crc_error_i_4_n_0),
        .I5(crc_error_i_5_n_0),
        .O(crc_error_i_1_n_0));
  LUT6 #(
    .INIT(64'h2E2E2ED1D1D12ED1)) 
    crc_error_i_10
       (.I0(\crc_reg_reg[6]_0 ),
        .I1(\payload_dt_reg_reg[0] ),
        .I2(p_0_in[8]),
        .I3(expected_crc_reg[9]),
        .I4(expected_fire),
        .I5(rd_data[1]),
        .O(crc_error_i_10_n_0));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    crc_error_i_11
       (.I0(crc_error_i_37_n_0),
        .I1(crc_error_i_38_n_0),
        .I2(crc_error_i_39_n_0),
        .I3(crc_error_i_40_n_0),
        .I4(crc_error_i_41_n_0),
        .I5(crc_error_i_42_n_0),
        .O(crc_error_i_11_n_0));
  LUT6 #(
    .INIT(64'h7447477447747447)) 
    crc_error_i_12
       (.I0(p_0_in[11]),
        .I1(\payload_dt_reg_reg[0] ),
        .I2(Q[0]),
        .I3(rd_data[0]),
        .I4(Q[4]),
        .I5(rd_data[4]),
        .O(crc_error_i_12_n_0));
  LUT6 #(
    .INIT(64'h7447477447747447)) 
    crc_error_i_13
       (.I0(p_0_in[12]),
        .I1(\payload_dt_reg_reg[0] ),
        .I2(rd_data[5]),
        .I3(rd_data[1]),
        .I4(Q[1]),
        .I5(Q[5]),
        .O(crc_error_i_13_n_0));
  LUT6 #(
    .INIT(64'h7447477447747447)) 
    crc_error_i_14
       (.I0(p_0_in[13]),
        .I1(\payload_dt_reg_reg[0] ),
        .I2(rd_data[6]),
        .I3(Q[6]),
        .I4(rd_data[2]),
        .I5(Q[2]),
        .O(crc_error_i_14_n_0));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    crc_error_i_15
       (.I0(\crc_lsb_reg_reg[7] [6]),
        .I1(\crc_calc_reg_n_0_[6] ),
        .I2(rd_data[0]),
        .I3(\crc_calc_reg_n_0_[8] ),
        .I4(\crc_calc_reg_n_0_[7] ),
        .I5(\crc_lsb_reg_reg[7] [7]),
        .O(crc_error_i_15_n_0));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    crc_error_i_16
       (.I0(\crc_calc_reg_n_0_[9] ),
        .I1(rd_data[1]),
        .I2(rd_data[3]),
        .I3(\crc_calc_reg_n_0_[11] ),
        .I4(rd_data[2]),
        .I5(\crc_calc_reg_n_0_[10] ),
        .O(crc_error_i_16_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    crc_error_i_2
       (.I0(crc_error_i_6_n_0),
        .I1(crc_error_i_7_n_0),
        .I2(crc_error_i_8_n_0),
        .I3(crc_error_i_9_n_0),
        .I4(crc_error_i_10_n_0),
        .I5(crc_error_i_11_n_0),
        .O(crc_error_i_2_n_0));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    crc_error_i_20
       (.I0(\crc_calc_reg_n_0_[12] ),
        .I1(rd_data[4]),
        .I2(rd_data[5]),
        .I3(\crc_calc_reg_n_0_[13] ),
        .I4(rd_data[6]),
        .I5(\crc_calc_reg_n_0_[14] ),
        .O(crc_error_i_20_n_0));
  LUT6 #(
    .INIT(64'h7555555545555555)) 
    crc_error_i_21
       (.I0(Q[4]),
        .I1(crc_error_reg_0),
        .I2(\payload_cnt_reg[12] ),
        .I3(\payload_cnt_reg[15] ),
        .I4(\FSM_onehot_state_reg[7] ),
        .I5(crc_error_i_45_n_0),
        .O(crc_error_i_21_n_0));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT3 #(
    .INIT(8'h47)) 
    crc_error_i_22
       (.I0(\crc_lsb_reg_reg[7] [4]),
        .I1(expected_fire),
        .I2(expected_crc_reg[4]),
        .O(crc_error_i_22_n_0));
  LUT6 #(
    .INIT(64'h7555555545555555)) 
    crc_error_i_23
       (.I0(Q[5]),
        .I1(crc_error_reg_0),
        .I2(\payload_cnt_reg[12] ),
        .I3(\payload_cnt_reg[15] ),
        .I4(\FSM_onehot_state_reg[7] ),
        .I5(crc_error_i_46_n_0),
        .O(crc_error_i_23_n_0));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT3 #(
    .INIT(8'h47)) 
    crc_error_i_24
       (.I0(\crc_lsb_reg_reg[7] [5]),
        .I1(expected_fire),
        .I2(expected_crc_reg[5]),
        .O(crc_error_i_24_n_0));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT3 #(
    .INIT(8'h47)) 
    crc_error_i_25
       (.I0(\crc_lsb_reg_reg[7] [3]),
        .I1(expected_fire),
        .I2(expected_crc_reg[3]),
        .O(crc_error_i_25_n_0));
  LUT6 #(
    .INIT(64'h7555555545555555)) 
    crc_error_i_26
       (.I0(Q[3]),
        .I1(crc_error_reg_0),
        .I2(\payload_cnt_reg[12] ),
        .I3(\payload_cnt_reg[15] ),
        .I4(\FSM_onehot_state_reg[7] ),
        .I5(crc_error_i_47_n_0),
        .O(crc_error_i_26_n_0));
  LUT6 #(
    .INIT(64'h7555555545555555)) 
    crc_error_i_27
       (.I0(Q[1]),
        .I1(crc_error_reg_0),
        .I2(\payload_cnt_reg[12] ),
        .I3(\payload_cnt_reg[15] ),
        .I4(\FSM_onehot_state_reg[7] ),
        .I5(crc_error_i_48_n_0),
        .O(crc_error_i_27_n_0));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT3 #(
    .INIT(8'h47)) 
    crc_error_i_28
       (.I0(\crc_lsb_reg_reg[7] [1]),
        .I1(expected_fire),
        .I2(expected_crc_reg[1]),
        .O(crc_error_i_28_n_0));
  LUT6 #(
    .INIT(64'h7555555545555555)) 
    crc_error_i_29
       (.I0(Q[2]),
        .I1(crc_error_reg_0),
        .I2(\payload_cnt_reg[12] ),
        .I3(\payload_cnt_reg[15] ),
        .I4(\FSM_onehot_state_reg[7] ),
        .I5(crc_error_i_49_n_0),
        .O(crc_error_i_29_n_0));
  LUT6 #(
    .INIT(64'hFFFFF99FF99FFFFF)) 
    crc_error_i_3
       (.I0(compare_crc[12]),
        .I1(crc_error_i_12_n_0),
        .I2(crc_error_i_13_n_0),
        .I3(compare_crc[13]),
        .I4(crc_error_i_14_n_0),
        .I5(compare_crc[14]),
        .O(crc_error_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT3 #(
    .INIT(8'h47)) 
    crc_error_i_30
       (.I0(\crc_lsb_reg_reg[7] [2]),
        .I1(expected_fire),
        .I2(expected_crc_reg[2]),
        .O(crc_error_i_30_n_0));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT3 #(
    .INIT(8'h47)) 
    crc_error_i_31
       (.I0(\crc_lsb_reg_reg[7] [0]),
        .I1(expected_fire),
        .I2(expected_crc_reg[0]),
        .O(crc_error_i_31_n_0));
  LUT6 #(
    .INIT(64'h5C55555555555555)) 
    crc_error_i_32
       (.I0(Q[0]),
        .I1(crc_error_i_50_n_0),
        .I2(crc_error_reg_0),
        .I3(\payload_cnt_reg[12] ),
        .I4(\payload_cnt_reg[15] ),
        .I5(\FSM_onehot_state_reg[7] ),
        .O(crc_error_i_32_n_0));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT3 #(
    .INIT(8'h47)) 
    crc_error_i_33
       (.I0(rd_data[3]),
        .I1(expected_fire),
        .I2(expected_crc_reg[11]),
        .O(crc_error_i_33_n_0));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT3 #(
    .INIT(8'h47)) 
    crc_error_i_34
       (.I0(rd_data[2]),
        .I1(expected_fire),
        .I2(expected_crc_reg[10]),
        .O(crc_error_i_34_n_0));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT3 #(
    .INIT(8'h47)) 
    crc_error_i_37
       (.I0(\crc_lsb_reg_reg[7] [6]),
        .I1(expected_fire),
        .I2(expected_crc_reg[6]),
        .O(crc_error_i_37_n_0));
  LUT6 #(
    .INIT(64'h7555555545555555)) 
    crc_error_i_38
       (.I0(Q[6]),
        .I1(crc_error_reg_0),
        .I2(\payload_cnt_reg[12] ),
        .I3(\payload_cnt_reg[15] ),
        .I4(\FSM_onehot_state_reg[7] ),
        .I5(crc_error_i_52_n_0),
        .O(crc_error_i_38_n_0));
  LUT6 #(
    .INIT(64'h7555555545555555)) 
    crc_error_i_39
       (.I0(p_0_in[7]),
        .I1(crc_error_reg_0),
        .I2(\payload_cnt_reg[12] ),
        .I3(\payload_cnt_reg[15] ),
        .I4(\FSM_onehot_state_reg[7] ),
        .I5(\crc_calc[8]_i_2_n_0 ),
        .O(crc_error_i_39_n_0));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT3 #(
    .INIT(8'h54)) 
    crc_error_i_4
       (.I0(\payload_dt_reg_reg[0] ),
        .I1(expected_fire),
        .I2(expected_seen),
        .O(crc_error_i_4_n_0));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT3 #(
    .INIT(8'h47)) 
    crc_error_i_40
       (.I0(rd_data[0]),
        .I1(expected_fire),
        .I2(expected_crc_reg[8]),
        .O(crc_error_i_40_n_0));
  LUT6 #(
    .INIT(64'h7555555545555555)) 
    crc_error_i_41
       (.I0(Q[7]),
        .I1(crc_error_reg_0),
        .I2(\payload_cnt_reg[12] ),
        .I3(\payload_cnt_reg[15] ),
        .I4(\FSM_onehot_state_reg[7] ),
        .I5(crc_error_i_53_n_0),
        .O(crc_error_i_41_n_0));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT3 #(
    .INIT(8'h47)) 
    crc_error_i_42
       (.I0(\crc_lsb_reg_reg[7] [7]),
        .I1(expected_fire),
        .I2(expected_crc_reg[7]),
        .O(crc_error_i_42_n_0));
  LUT6 #(
    .INIT(64'hFBFFFBFFFBFFFFFF)) 
    crc_error_i_43
       (.I0(crc_valid),
        .I1(active),
        .I2(payload_done),
        .I3(\FSM_onehot_state_reg[7] ),
        .I4(\payload_dt_reg_reg[1] ),
        .I5(state_reg),
        .O(crc_error_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT3 #(
    .INIT(8'h69)) 
    crc_error_i_45
       (.I0(p_0_in[11]),
        .I1(Q[1]),
        .I2(rd_data[1]),
        .O(crc_error_i_45_n_0));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT3 #(
    .INIT(8'h69)) 
    crc_error_i_46
       (.I0(p_0_in[12]),
        .I1(Q[2]),
        .I2(rd_data[2]),
        .O(crc_error_i_46_n_0));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT4 #(
    .INIT(16'h9669)) 
    crc_error_i_47
       (.I0(crc_tmp118_out),
        .I1(rd_data[0]),
        .I2(Q[0]),
        .I3(p_0_in[10]),
        .O(crc_error_i_47_n_0));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    crc_error_i_48
       (.I0(p_0_in[8]),
        .I1(rd_data[5]),
        .I2(Q[5]),
        .I3(rd_data[1]),
        .I4(Q[1]),
        .O(crc_error_i_48_n_0));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    crc_error_i_49
       (.I0(Q[8]),
        .I1(rd_data[6]),
        .I2(Q[6]),
        .I3(rd_data[2]),
        .I4(Q[2]),
        .O(crc_error_i_49_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    crc_error_i_5
       (.I0(crc_error_i_15_n_0),
        .I1(crc_error_i_16_n_0),
        .I2(\crc_lsb_reg_reg[0] ),
        .I3(\crc_lsb_reg_reg[3] ),
        .I4(\crc_calc_reg[15]_0 ),
        .I5(crc_error_i_20_n_0),
        .O(crc_error_i_5_n_0));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    crc_error_i_50
       (.I0(p_0_in[7]),
        .I1(rd_data[4]),
        .I2(Q[4]),
        .I3(rd_data[0]),
        .I4(Q[0]),
        .O(crc_error_i_50_n_0));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT3 #(
    .INIT(8'h69)) 
    crc_error_i_52
       (.I0(p_0_in[13]),
        .I1(Q[3]),
        .I2(rd_data[3]),
        .O(crc_error_i_52_n_0));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    crc_error_i_53
       (.I0(p_0_in[14]),
        .I1(rd_data[4]),
        .I2(Q[4]),
        .I3(rd_data[0]),
        .I4(Q[0]),
        .O(crc_error_i_53_n_0));
  LUT6 #(
    .INIT(64'h1D1D1DE2E2E21DE2)) 
    crc_error_i_6
       (.I0(crc_tmp118_out),
        .I1(\payload_dt_reg_reg[0] ),
        .I2(p_0_in[14]),
        .I3(expected_crc_reg[15]),
        .I4(expected_fire),
        .I5(rd_data[7]),
        .O(crc_error_i_6_n_0));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    crc_error_i_7
       (.I0(crc_error_i_21_n_0),
        .I1(crc_error_i_22_n_0),
        .I2(crc_error_i_23_n_0),
        .I3(crc_error_i_24_n_0),
        .I4(crc_error_i_25_n_0),
        .I5(crc_error_i_26_n_0),
        .O(crc_error_i_7_n_0));
  LUT6 #(
    .INIT(64'h6FF6FFFFFFFF6FF6)) 
    crc_error_i_8
       (.I0(crc_error_i_27_n_0),
        .I1(crc_error_i_28_n_0),
        .I2(crc_error_i_29_n_0),
        .I3(crc_error_i_30_n_0),
        .I4(crc_error_i_31_n_0),
        .I5(crc_error_i_32_n_0),
        .O(crc_error_i_8_n_0));
  LUT6 #(
    .INIT(64'h9A95FFFFFFFF9A95)) 
    crc_error_i_9
       (.I0(crc_error_i_33_n_0),
        .I1(p_0_in[10]),
        .I2(\payload_dt_reg_reg[0] ),
        .I3(\crc_reg_reg[3]_0 [3]),
        .I4(crc_error_i_34_n_0),
        .I5(\crc_reg_reg[10]_0 ),
        .O(crc_error_i_9_n_0));
  FDRE #(
    .INIT(1'b0)) 
    crc_error_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(crc_error_i_1_n_0),
        .Q(crc_error),
        .R(\FSM_onehot_state_reg[6] ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \crc_reg[0]_i_1 
       (.I0(Q[0]),
        .I1(rd_data[0]),
        .I2(Q[4]),
        .I3(rd_data[4]),
        .I4(p_0_in[7]),
        .O(crc16_next_byte_return[0]));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \crc_reg[12]_i_1 
       (.I0(Q[0]),
        .I1(rd_data[0]),
        .I2(Q[4]),
        .I3(rd_data[4]),
        .O(crc16_next_byte_return[12]));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \crc_reg[13]_i_1 
       (.I0(Q[1]),
        .I1(rd_data[1]),
        .I2(Q[5]),
        .I3(rd_data[5]),
        .O(crc16_next_byte_return[13]));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \crc_reg[14]_i_1 
       (.I0(Q[2]),
        .I1(rd_data[2]),
        .I2(Q[6]),
        .I3(rd_data[6]),
        .O(crc16_next_byte_return[14]));
  LUT5 #(
    .INIT(32'h00000800)) 
    \crc_reg[15]_i_2 
       (.I0(\payload_dt_reg_reg[0]_0 ),
        .I1(\FSM_onehot_state_reg[7] ),
        .I2(payload_done),
        .I3(active),
        .I4(crc_valid),
        .O(p_5_in));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \crc_reg[15]_i_3 
       (.I0(Q[3]),
        .I1(rd_data[3]),
        .I2(Q[7]),
        .I3(rd_data[7]),
        .O(crc_tmp118_out));
  LUT2 #(
    .INIT(4'hB)) 
    \crc_reg[15]_i_6 
       (.I0(\payload_dt_reg_reg[5] [1]),
        .I1(\payload_dt_reg_reg[5] [0]),
        .O(pending_sol_reg));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \crc_reg[1]_i_1 
       (.I0(Q[1]),
        .I1(rd_data[1]),
        .I2(Q[5]),
        .I3(rd_data[5]),
        .I4(p_0_in[8]),
        .O(crc16_next_byte_return[1]));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \crc_reg[2]_i_1 
       (.I0(Q[2]),
        .I1(rd_data[2]),
        .I2(Q[6]),
        .I3(rd_data[6]),
        .I4(Q[8]),
        .O(crc16_next_byte_return[2]));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \crc_reg[3]_i_1 
       (.I0(p_0_in[10]),
        .I1(Q[0]),
        .I2(rd_data[0]),
        .I3(crc_tmp118_out),
        .O(crc16_next_byte_return[3]));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \crc_reg[4]_i_1 
       (.I0(rd_data[1]),
        .I1(Q[1]),
        .I2(p_0_in[11]),
        .O(crc16_next_byte_return[4]));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \crc_reg[5]_i_1 
       (.I0(rd_data[2]),
        .I1(Q[2]),
        .I2(p_0_in[12]),
        .O(crc16_next_byte_return[5]));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \crc_reg[6]_i_1 
       (.I0(rd_data[3]),
        .I1(Q[3]),
        .I2(p_0_in[13]),
        .O(crc16_next_byte_return[6]));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \crc_reg[7]_i_1 
       (.I0(Q[0]),
        .I1(rd_data[0]),
        .I2(Q[4]),
        .I3(rd_data[4]),
        .I4(p_0_in[14]),
        .O(crc16_next_byte_return[7]));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(crc16_next_byte_return[0]),
        .Q(Q[0]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[10] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(\crc_reg_reg[3]_0 [2]),
        .Q(Q[8]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[11] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(\crc_reg_reg[3]_0 [3]),
        .Q(p_0_in[10]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[12] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(crc16_next_byte_return[12]),
        .Q(p_0_in[11]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[13] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(crc16_next_byte_return[13]),
        .Q(p_0_in[12]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[14] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(crc16_next_byte_return[14]),
        .Q(p_0_in[13]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[15] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(crc_tmp118_out),
        .Q(p_0_in[14]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(crc16_next_byte_return[1]),
        .Q(Q[1]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(crc16_next_byte_return[2]),
        .Q(Q[2]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(crc16_next_byte_return[3]),
        .Q(Q[3]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(crc16_next_byte_return[4]),
        .Q(Q[4]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(crc16_next_byte_return[5]),
        .Q(Q[5]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(crc16_next_byte_return[6]),
        .Q(Q[6]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(crc16_next_byte_return[7]),
        .Q(Q[7]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(\crc_reg_reg[3]_0 [0]),
        .Q(p_0_in[7]),
        .S(\FSM_onehot_state_reg[6] ));
  FDSE #(
    .INIT(1'b1)) 
    \crc_reg_reg[9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(p_5_in),
        .D(\crc_reg_reg[3]_0 [1]),
        .Q(p_0_in[8]),
        .S(\FSM_onehot_state_reg[6] ));
  LUT1 #(
    .INIT(2'h1)) 
    crc_valid_i_1
       (.I0(crc_valid_i_2_n_0),
        .O(crc_valid_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT4 #(
    .INIT(16'h5F03)) 
    crc_valid_i_2
       (.I0(payload_done),
        .I1(expected_seen),
        .I2(expected_fire),
        .I3(\payload_dt_reg_reg[0] ),
        .O(crc_valid_i_2_n_0));
  FDRE #(
    .INIT(1'b0)) 
    crc_valid_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(crc_valid_i_1_n_0),
        .Q(crc_valid),
        .R(\FSM_onehot_state_reg[6] ));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT2 #(
    .INIT(4'h8)) 
    err_crc_o_OBUF_inst_i_1
       (.I0(crc_error),
        .I1(crc_valid),
        .O(err_crc_o_OBUF));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT3 #(
    .INIT(8'hE2)) 
    \expected_crc_reg[0]_i_1 
       (.I0(expected_crc_reg[0]),
        .I1(expected_fire),
        .I2(\crc_lsb_reg_reg[7] [0]),
        .O(compare_crc[0]));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT3 #(
    .INIT(8'hE2)) 
    \expected_crc_reg[10]_i_1 
       (.I0(expected_crc_reg[10]),
        .I1(expected_fire),
        .I2(rd_data[2]),
        .O(compare_crc[10]));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT3 #(
    .INIT(8'hE2)) 
    \expected_crc_reg[11]_i_1 
       (.I0(expected_crc_reg[11]),
        .I1(expected_fire),
        .I2(rd_data[3]),
        .O(compare_crc[11]));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \expected_crc_reg[12]_i_1 
       (.I0(rd_data[4]),
        .I1(expected_fire),
        .I2(expected_crc_reg[12]),
        .O(compare_crc[12]));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \expected_crc_reg[13]_i_1 
       (.I0(rd_data[5]),
        .I1(expected_fire),
        .I2(expected_crc_reg[13]),
        .O(compare_crc[13]));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \expected_crc_reg[14]_i_1 
       (.I0(rd_data[6]),
        .I1(expected_fire),
        .I2(expected_crc_reg[14]),
        .O(compare_crc[14]));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \expected_crc_reg[15]_i_1 
       (.I0(rd_data[7]),
        .I1(expected_fire),
        .I2(expected_crc_reg[15]),
        .O(compare_crc[15]));
  LUT4 #(
    .INIT(16'h0004)) 
    \expected_crc_reg[15]_i_2 
       (.I0(\rd_ptr_gray_reg[3] ),
        .I1(out11),
        .I2(expected_seen),
        .I3(crc_valid),
        .O(expected_fire));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT3 #(
    .INIT(8'hE2)) 
    \expected_crc_reg[1]_i_1 
       (.I0(expected_crc_reg[1]),
        .I1(expected_fire),
        .I2(\crc_lsb_reg_reg[7] [1]),
        .O(compare_crc[1]));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT3 #(
    .INIT(8'hE2)) 
    \expected_crc_reg[2]_i_1 
       (.I0(expected_crc_reg[2]),
        .I1(expected_fire),
        .I2(\crc_lsb_reg_reg[7] [2]),
        .O(compare_crc[2]));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT3 #(
    .INIT(8'hE2)) 
    \expected_crc_reg[3]_i_1 
       (.I0(expected_crc_reg[3]),
        .I1(expected_fire),
        .I2(\crc_lsb_reg_reg[7] [3]),
        .O(compare_crc[3]));
  LUT3 #(
    .INIT(8'hE2)) 
    \expected_crc_reg[4]_i_1 
       (.I0(expected_crc_reg[4]),
        .I1(expected_fire),
        .I2(\crc_lsb_reg_reg[7] [4]),
        .O(compare_crc[4]));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT3 #(
    .INIT(8'hE2)) 
    \expected_crc_reg[5]_i_1 
       (.I0(expected_crc_reg[5]),
        .I1(expected_fire),
        .I2(\crc_lsb_reg_reg[7] [5]),
        .O(compare_crc[5]));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT3 #(
    .INIT(8'hE2)) 
    \expected_crc_reg[6]_i_1 
       (.I0(expected_crc_reg[6]),
        .I1(expected_fire),
        .I2(\crc_lsb_reg_reg[7] [6]),
        .O(compare_crc[6]));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT3 #(
    .INIT(8'hE2)) 
    \expected_crc_reg[7]_i_1 
       (.I0(expected_crc_reg[7]),
        .I1(expected_fire),
        .I2(\crc_lsb_reg_reg[7] [7]),
        .O(compare_crc[7]));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT3 #(
    .INIT(8'hE2)) 
    \expected_crc_reg[8]_i_1 
       (.I0(expected_crc_reg[8]),
        .I1(expected_fire),
        .I2(rd_data[0]),
        .O(compare_crc[8]));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT3 #(
    .INIT(8'hE2)) 
    \expected_crc_reg[9]_i_1 
       (.I0(expected_crc_reg[9]),
        .I1(expected_fire),
        .I2(rd_data[1]),
        .O(compare_crc[9]));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[0]),
        .Q(expected_crc_reg[0]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[10] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[10]),
        .Q(expected_crc_reg[10]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[11] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[11]),
        .Q(expected_crc_reg[11]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[12] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[12]),
        .Q(expected_crc_reg[12]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[13] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[13]),
        .Q(expected_crc_reg[13]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[14] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[14]),
        .Q(expected_crc_reg[14]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[15] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[15]),
        .Q(expected_crc_reg[15]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[1]),
        .Q(expected_crc_reg[1]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[2]),
        .Q(expected_crc_reg[2]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[3]),
        .Q(expected_crc_reg[3]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[4]),
        .Q(expected_crc_reg[4]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[5]),
        .Q(expected_crc_reg[5]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[6]),
        .Q(expected_crc_reg[6]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[7]),
        .Q(expected_crc_reg[7]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[8]),
        .Q(expected_crc_reg[8]),
        .R(\FSM_onehot_state_reg[6] ));
  FDRE #(
    .INIT(1'b0)) 
    \expected_crc_reg_reg[9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(compare_crc[9]),
        .Q(expected_crc_reg[9]),
        .R(\FSM_onehot_state_reg[6] ));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT3 #(
    .INIT(8'hDC)) 
    expected_seen_i_1
       (.I0(crc_valid),
        .I1(expected_fire),
        .I2(expected_seen),
        .O(expected_seen_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    expected_seen_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(expected_seen_i_1_n_0),
        .Q(expected_seen),
        .R(\FSM_onehot_state_reg[6] ));
  LUT6 #(
    .INIT(64'h0000000005110011)) 
    payload_done_i_1
       (.I0(expected_fire),
        .I1(expected_seen),
        .I2(crc_valid),
        .I3(\payload_dt_reg_reg[0] ),
        .I4(payload_done),
        .I5(\FSM_onehot_state_reg[6] ),
        .O(payload_done_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    payload_done_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(payload_done_i_1_n_0),
        .Q(payload_done),
        .R(\<const0> ));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT3 #(
    .INIT(8'hFB)) 
    pending_sof_i_3
       (.I0(payload_done),
        .I1(active),
        .I2(crc_valid),
        .O(pending_sol_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \rd_ptr_gray[3]_i_7 
       (.I0(crc_valid),
        .I1(expected_seen),
        .O(\payload_cnt_reg[0] ));
endmodule

module degrade_recover_fsm
   (Q,
    rst_n_IBUF,
    out,
    lane_err_sync_d,
    clk_sys_IBUF_BUFG,
    SR,
    err_valid,
    frame_end_reg);
  output [1:0]Q;
  input rst_n_IBUF;
  input out;
  input lane_err_sync_d;
  input clk_sys_IBUF_BUFG;
  input [0:0]SR;
  input err_valid;
  input frame_end_reg;

  wire \<const1> ;
  wire [1:0]Q;
  wire [0:0]SR;
  wire \active_lane_num_o[2]_i_1_n_0 ;
  wire \active_lane_num_o[2]_i_2_n_0 ;
  wire clk_sys_IBUF_BUFG;
  wire degraded_o1;
  wire [1:0]degraded_o1__0;
  wire degraded_o_i_1_n_0;
  wire degraded_o_reg_n_0;
  wire err_valid;
  wire frame_end_reg;
  wire [1:0]good_frame_cnt;
  wire \good_frame_cnt[1]_i_1_n_0 ;
  wire lane_err_sync_d;
  wire lane_error_event_sys;
  wire out;
  wire rst_n_IBUF;

  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \active_lane_num_o[1]_i_1 
       (.I0(out),
        .I1(lane_err_sync_d),
        .O(lane_error_event_sys));
  LUT6 #(
    .INIT(64'hAAAAAAAAAEAAAAAA)) 
    \active_lane_num_o[2]_i_1 
       (.I0(lane_error_event_sys),
        .I1(degraded_o_reg_n_0),
        .I2(err_valid),
        .I3(frame_end_reg),
        .I4(good_frame_cnt[1]),
        .I5(good_frame_cnt[0]),
        .O(\active_lane_num_o[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \active_lane_num_o[2]_i_2 
       (.I0(lane_err_sync_d),
        .I1(out),
        .O(\active_lane_num_o[2]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \active_lane_num_o_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\active_lane_num_o[2]_i_1_n_0 ),
        .D(lane_error_event_sys),
        .Q(Q[0]),
        .R(SR));
  FDSE #(
    .INIT(1'b1)) 
    \active_lane_num_o_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\active_lane_num_o[2]_i_1_n_0 ),
        .D(\active_lane_num_o[2]_i_2_n_0 ),
        .Q(Q[1]),
        .S(SR));
  LUT6 #(
    .INIT(64'hFFAAFBAAFFAAFFAA)) 
    degraded_o_i_1
       (.I0(lane_error_event_sys),
        .I1(good_frame_cnt[1]),
        .I2(good_frame_cnt[0]),
        .I3(degraded_o_reg_n_0),
        .I4(err_valid),
        .I5(frame_end_reg),
        .O(degraded_o_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    degraded_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(degraded_o_i_1_n_0),
        .Q(degraded_o_reg_n_0),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \good_frame_cnt[0]_i_1 
       (.I0(good_frame_cnt[0]),
        .O(degraded_o1__0[0]));
  LUT6 #(
    .INIT(64'hFFFF202FFFFFFFFF)) 
    \good_frame_cnt[1]_i_1 
       (.I0(good_frame_cnt[1]),
        .I1(good_frame_cnt[0]),
        .I2(degraded_o1),
        .I3(degraded_o_reg_n_0),
        .I4(lane_error_event_sys),
        .I5(rst_n_IBUF),
        .O(\good_frame_cnt[1]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h20)) 
    \good_frame_cnt[1]_i_2 
       (.I0(degraded_o_reg_n_0),
        .I1(err_valid),
        .I2(frame_end_reg),
        .O(degraded_o1));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \good_frame_cnt[1]_i_3 
       (.I0(good_frame_cnt[0]),
        .I1(good_frame_cnt[1]),
        .O(degraded_o1__0[1]));
  FDRE #(
    .INIT(1'b0)) 
    \good_frame_cnt_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(degraded_o1),
        .D(degraded_o1__0[0]),
        .Q(good_frame_cnt[0]),
        .R(\good_frame_cnt[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \good_frame_cnt_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(degraded_o1),
        .D(degraded_o1__0[1]),
        .Q(good_frame_cnt[1]),
        .R(\good_frame_cnt[1]_i_1_n_0 ));
endmodule

module err_classifier
   (err_valid,
    SR,
    lane_err_sync_reg,
    clk_sys_IBUF_BUFG);
  output err_valid;
  input [0:0]SR;
  input lane_err_sync_reg;
  input clk_sys_IBUF_BUFG;

  wire \<const1> ;
  wire [0:0]SR;
  wire clk_sys_IBUF_BUFG;
  wire err_valid;
  wire lane_err_sync_reg;

  VCC VCC
       (.P(\<const1> ));
  FDRE #(
    .INIT(1'b0)) 
    err_valid_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(lane_err_sync_reg),
        .Q(err_valid),
        .R(SR));
endmodule

module fpga_apb_boot_cfg
   (cfg_init_done_o_OBUF,
    p_0_in,
    clk_sys_IBUF_BUFG);
  output cfg_init_done_o_OBUF;
  input p_0_in;
  input clk_sys_IBUF_BUFG;

  wire \<const1> ;
  wire \cfg_idx_q[3]_i_1_n_0 ;
  wire \cfg_idx_q[3]_i_3_n_0 ;
  wire [3:0]cfg_idx_q_reg__0;
  wire cfg_init_done_o_OBUF;
  wire clk_sys_IBUF_BUFG;
  wire ctrl_written_q;
  wire ctrl_written_q_i_1_n_0;
  wire p_0_in;
  wire [3:0]p_0_in__0;
  wire [0:0]state_q;
  wire \state_q[1]_i_1_n_0 ;
  wire \state_q_reg_n_0_[0] ;
  wire \state_q_reg_n_0_[1] ;

  VCC VCC
       (.P(\<const1> ));
  LUT1 #(
    .INIT(2'h1)) 
    \cfg_idx_q[0]_i_1 
       (.I0(cfg_idx_q_reg__0[0]),
        .O(p_0_in__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \cfg_idx_q[1]_i_1 
       (.I0(cfg_idx_q_reg__0[0]),
        .I1(cfg_idx_q_reg__0[1]),
        .O(p_0_in__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h6A)) 
    \cfg_idx_q[2]_i_1 
       (.I0(cfg_idx_q_reg__0[2]),
        .I1(cfg_idx_q_reg__0[1]),
        .I2(cfg_idx_q_reg__0[0]),
        .O(p_0_in__0[2]));
  LUT4 #(
    .INIT(16'h0004)) 
    \cfg_idx_q[3]_i_1 
       (.I0(\cfg_idx_q[3]_i_3_n_0 ),
        .I1(\state_q_reg_n_0_[0] ),
        .I2(ctrl_written_q),
        .I3(\state_q_reg_n_0_[1] ),
        .O(\cfg_idx_q[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \cfg_idx_q[3]_i_2 
       (.I0(cfg_idx_q_reg__0[3]),
        .I1(cfg_idx_q_reg__0[0]),
        .I2(cfg_idx_q_reg__0[1]),
        .I3(cfg_idx_q_reg__0[2]),
        .O(p_0_in__0[3]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h0080)) 
    \cfg_idx_q[3]_i_3 
       (.I0(cfg_idx_q_reg__0[0]),
        .I1(cfg_idx_q_reg__0[1]),
        .I2(cfg_idx_q_reg__0[2]),
        .I3(cfg_idx_q_reg__0[3]),
        .O(\cfg_idx_q[3]_i_3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cfg_idx_q_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\cfg_idx_q[3]_i_1_n_0 ),
        .D(p_0_in__0[0]),
        .Q(cfg_idx_q_reg__0[0]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \cfg_idx_q_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\cfg_idx_q[3]_i_1_n_0 ),
        .D(p_0_in__0[1]),
        .Q(cfg_idx_q_reg__0[1]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \cfg_idx_q_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\cfg_idx_q[3]_i_1_n_0 ),
        .D(p_0_in__0[2]),
        .Q(cfg_idx_q_reg__0[2]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \cfg_idx_q_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\cfg_idx_q[3]_i_1_n_0 ),
        .D(p_0_in__0[3]),
        .Q(cfg_idx_q_reg__0[3]),
        .R(p_0_in));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hFF40)) 
    ctrl_written_q_i_1
       (.I0(\state_q_reg_n_0_[1] ),
        .I1(\state_q_reg_n_0_[0] ),
        .I2(\cfg_idx_q[3]_i_3_n_0 ),
        .I3(ctrl_written_q),
        .O(ctrl_written_q_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    ctrl_written_q_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(ctrl_written_q_i_1_n_0),
        .Q(ctrl_written_q),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    init_done_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\state_q[1]_i_1_n_0 ),
        .D(\<const1> ),
        .Q(cfg_init_done_o_OBUF),
        .R(p_0_in));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \state_q[0]_i_1 
       (.I0(\state_q_reg_n_0_[1] ),
        .I1(\state_q_reg_n_0_[0] ),
        .O(state_q));
  LUT3 #(
    .INIT(8'hF8)) 
    \state_q[1]_i_1 
       (.I0(ctrl_written_q),
        .I1(\state_q_reg_n_0_[0] ),
        .I2(\state_q_reg_n_0_[1] ),
        .O(\state_q[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \state_q_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(state_q),
        .Q(\state_q_reg_n_0_[0] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \state_q_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\state_q[1]_i_1_n_0 ),
        .Q(\state_q_reg_n_0_[1] ),
        .R(p_0_in));
endmodule

module frame_line_sync_fsm
   (frame_start,
    frame_end,
    line_start,
    line_end,
    state_reg,
    frame_active_reg_0,
    line_active_reg_0,
    pending_sof_reg,
    pending_sol_reg,
    resync_req_d_reg,
    \dt_reg[1] ,
    clk_sys_IBUF_BUFG,
    frame_active_reg_1,
    frame_active_reg_2,
    \dt_reg[0] ,
    \dt_reg[0]_0 ,
    resync_req_o_reg,
    \dt_reg[0]_1 ,
    line_active_reg_1,
    pending_sof,
    pending_sol_reg_0);
  output frame_start;
  output frame_end;
  output line_start;
  output line_end;
  output state_reg;
  output frame_active_reg_0;
  output line_active_reg_0;
  output pending_sof_reg;
  output pending_sol_reg;
  input resync_req_d_reg;
  input \dt_reg[1] ;
  input clk_sys_IBUF_BUFG;
  input frame_active_reg_1;
  input frame_active_reg_2;
  input \dt_reg[0] ;
  input \dt_reg[0]_0 ;
  input resync_req_o_reg;
  input \dt_reg[0]_1 ;
  input line_active_reg_1;
  input pending_sof;
  input pending_sol_reg_0;

  wire \<const1> ;
  wire clk_sys_IBUF_BUFG;
  wire \dt_reg[0] ;
  wire \dt_reg[0]_0 ;
  wire \dt_reg[0]_1 ;
  wire \dt_reg[1] ;
  wire frame_active_reg_0;
  wire frame_active_reg_1;
  wire frame_active_reg_2;
  wire frame_end;
  wire frame_start;
  wire line_active_reg_0;
  wire line_active_reg_1;
  wire line_end;
  wire line_start;
  wire pending_sof;
  wire pending_sof_reg;
  wire pending_sol_reg;
  wire pending_sol_reg_0;
  wire resync_req_d_reg;
  wire resync_req_o_reg;
  wire state_reg;

  VCC VCC
       (.P(\<const1> ));
  FDRE #(
    .INIT(1'b0)) 
    frame_active_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\dt_reg[0]_1 ),
        .Q(frame_active_reg_0),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    frame_end_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(frame_active_reg_1),
        .Q(frame_end),
        .R(resync_req_d_reg));
  FDRE #(
    .INIT(1'b0)) 
    frame_start_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\dt_reg[1] ),
        .Q(frame_start),
        .R(resync_req_d_reg));
  FDRE #(
    .INIT(1'b0)) 
    line_active_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(line_active_reg_1),
        .Q(line_active_reg_0),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    line_end_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\dt_reg[0] ),
        .Q(line_end),
        .R(resync_req_d_reg));
  FDRE #(
    .INIT(1'b0)) 
    line_start_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(frame_active_reg_2),
        .Q(line_start),
        .R(resync_req_d_reg));
  LUT2 #(
    .INIT(4'hE)) 
    pending_sof_i_2
       (.I0(frame_start),
        .I1(pending_sof),
        .O(pending_sof_reg));
  LUT2 #(
    .INIT(4'hE)) 
    pending_sol_i_1
       (.I0(line_start),
        .I1(pending_sol_reg_0),
        .O(pending_sol_reg));
  FDRE #(
    .INIT(1'b0)) 
    sync_error_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(\dt_reg[0]_0 ),
        .Q(state_reg),
        .R(resync_req_d_reg));
endmodule

module lane_deskew_buffer
   (lane_err_toggle_byte_reg,
    \rd_ptr_reg[3][3]_0 ,
    deskew_valid,
    \wr_ptr_reg[3][3]_0 ,
    \lane_group_data_i[3] ,
    \lane_group_data_i[2] ,
    \lane_group_data_i[1] ,
    \lane_group_data_i[0] ,
    clk_wr,
    lane_err_toggle_byte,
    merge_byte_valid,
    resync_toggle_byte_d,
    out,
    rst_n_IBUF,
    \cfg_lane_enable_mask_byte_reg[3] ,
    lp_mode_IBUF,
    hs_mode_IBUF,
    lane_valid_2_IBUF,
    \active_lane_num_byte_reg[2] ,
    \cfg_lane_num_byte_reg[1] ,
    lane_valid_0_IBUF,
    \lane_data_i[3] ,
    \lane_data_i[2] ,
    \lane_data_i[1] ,
    \lane_data_i[0] ,
    lane_valid_1_IBUF,
    lane_valid_3_IBUF);
  output lane_err_toggle_byte_reg;
  output \rd_ptr_reg[3][3]_0 ;
  output deskew_valid;
  output \wr_ptr_reg[3][3]_0 ;
  output [7:0]\lane_group_data_i[3] ;
  output [7:0]\lane_group_data_i[2] ;
  output [7:0]\lane_group_data_i[1] ;
  output [7:0]\lane_group_data_i[0] ;
  input clk_wr;
  input lane_err_toggle_byte;
  input merge_byte_valid;
  input resync_toggle_byte_d;
  input out;
  input rst_n_IBUF;
  input [3:0]\cfg_lane_enable_mask_byte_reg[3] ;
  input lp_mode_IBUF;
  input hs_mode_IBUF;
  input lane_valid_2_IBUF;
  input [2:0]\active_lane_num_byte_reg[2] ;
  input [1:0]\cfg_lane_num_byte_reg[1] ;
  input lane_valid_0_IBUF;
  input [7:0]\lane_data_i[3] ;
  input [7:0]\lane_data_i[2] ;
  input [7:0]\lane_data_i[1] ;
  input [7:0]\lane_data_i[0] ;
  input lane_valid_1_IBUF;
  input lane_valid_3_IBUF;

  wire \<const0> ;
  wire \<const1> ;
  wire [2:0]\active_lane_num_byte_reg[2] ;
  wire [3:0]\cfg_lane_enable_mask_byte_reg[3] ;
  wire [1:0]\cfg_lane_num_byte_reg[1] ;
  wire clk_wr;
  wire deskew_overflow;
  wire deskew_valid;
  wire err_overflow_o_i_1_n_0;
  wire err_overflow_o_i_2_n_0;
  wire err_overflow_o_i_3_n_0;
  wire fifo_mem;
  wire \fifo_mem[0][10][7]_i_1_n_0 ;
  wire \fifo_mem[0][11][7]_i_1_n_0 ;
  wire \fifo_mem[0][12][7]_i_1_n_0 ;
  wire \fifo_mem[0][13][7]_i_1_n_0 ;
  wire \fifo_mem[0][14][7]_i_1_n_0 ;
  wire \fifo_mem[0][15][7]_i_1_n_0 ;
  wire \fifo_mem[0][1][7]_i_1_n_0 ;
  wire \fifo_mem[0][2][7]_i_1_n_0 ;
  wire \fifo_mem[0][3][7]_i_1_n_0 ;
  wire \fifo_mem[0][4][7]_i_1_n_0 ;
  wire \fifo_mem[0][5][7]_i_1_n_0 ;
  wire \fifo_mem[0][6][7]_i_1_n_0 ;
  wire \fifo_mem[0][7][7]_i_1_n_0 ;
  wire \fifo_mem[0][8][7]_i_1_n_0 ;
  wire \fifo_mem[0][9][7]_i_1_n_0 ;
  wire \fifo_mem[1][0][7]_i_1_n_0 ;
  wire \fifo_mem[1][10][7]_i_1_n_0 ;
  wire \fifo_mem[1][11][7]_i_1_n_0 ;
  wire \fifo_mem[1][12][7]_i_1_n_0 ;
  wire \fifo_mem[1][13][7]_i_1_n_0 ;
  wire \fifo_mem[1][14][7]_i_1_n_0 ;
  wire \fifo_mem[1][15][7]_i_1_n_0 ;
  wire \fifo_mem[1][1][7]_i_1_n_0 ;
  wire \fifo_mem[1][2][7]_i_1_n_0 ;
  wire \fifo_mem[1][3][7]_i_1_n_0 ;
  wire \fifo_mem[1][4][7]_i_1_n_0 ;
  wire \fifo_mem[1][5][7]_i_1_n_0 ;
  wire \fifo_mem[1][6][7]_i_1_n_0 ;
  wire \fifo_mem[1][7][7]_i_1_n_0 ;
  wire \fifo_mem[1][8][7]_i_1_n_0 ;
  wire \fifo_mem[1][9][7]_i_1_n_0 ;
  wire \fifo_mem[2][0][7]_i_1_n_0 ;
  wire \fifo_mem[2][10][7]_i_1_n_0 ;
  wire \fifo_mem[2][11][7]_i_1_n_0 ;
  wire \fifo_mem[2][12][7]_i_1_n_0 ;
  wire \fifo_mem[2][13][7]_i_1_n_0 ;
  wire \fifo_mem[2][14][7]_i_1_n_0 ;
  wire \fifo_mem[2][15][7]_i_1_n_0 ;
  wire \fifo_mem[2][1][7]_i_1_n_0 ;
  wire \fifo_mem[2][2][7]_i_1_n_0 ;
  wire \fifo_mem[2][3][7]_i_1_n_0 ;
  wire \fifo_mem[2][4][7]_i_1_n_0 ;
  wire \fifo_mem[2][5][7]_i_1_n_0 ;
  wire \fifo_mem[2][6][7]_i_1_n_0 ;
  wire \fifo_mem[2][7][7]_i_1_n_0 ;
  wire \fifo_mem[2][8][7]_i_1_n_0 ;
  wire \fifo_mem[2][9][7]_i_1_n_0 ;
  wire \fifo_mem[3][0][7]_i_1_n_0 ;
  wire \fifo_mem[3][10][7]_i_1_n_0 ;
  wire \fifo_mem[3][11][7]_i_1_n_0 ;
  wire \fifo_mem[3][12][7]_i_1_n_0 ;
  wire \fifo_mem[3][13][7]_i_1_n_0 ;
  wire \fifo_mem[3][14][7]_i_1_n_0 ;
  wire \fifo_mem[3][15][7]_i_1_n_0 ;
  wire \fifo_mem[3][1][7]_i_1_n_0 ;
  wire \fifo_mem[3][2][7]_i_1_n_0 ;
  wire \fifo_mem[3][3][7]_i_1_n_0 ;
  wire \fifo_mem[3][4][7]_i_1_n_0 ;
  wire \fifo_mem[3][5][7]_i_1_n_0 ;
  wire \fifo_mem[3][6][7]_i_1_n_0 ;
  wire \fifo_mem[3][7][7]_i_1_n_0 ;
  wire \fifo_mem[3][8][7]_i_1_n_0 ;
  wire \fifo_mem[3][9][7]_i_1_n_0 ;
  wire [7:0]\fifo_mem_reg[0][0]_49 ;
  wire [7:0]\fifo_mem_reg[0][10]_59 ;
  wire [7:0]\fifo_mem_reg[0][11]_60 ;
  wire [7:0]\fifo_mem_reg[0][12]_61 ;
  wire [7:0]\fifo_mem_reg[0][13]_62 ;
  wire [7:0]\fifo_mem_reg[0][14]_63 ;
  wire [7:0]\fifo_mem_reg[0][15]_64 ;
  wire [7:0]\fifo_mem_reg[0][1]_50 ;
  wire [7:0]\fifo_mem_reg[0][2]_51 ;
  wire [7:0]\fifo_mem_reg[0][3]_52 ;
  wire [7:0]\fifo_mem_reg[0][4]_53 ;
  wire [7:0]\fifo_mem_reg[0][5]_54 ;
  wire [7:0]\fifo_mem_reg[0][6]_55 ;
  wire [7:0]\fifo_mem_reg[0][7]_56 ;
  wire [7:0]\fifo_mem_reg[0][8]_57 ;
  wire [7:0]\fifo_mem_reg[0][9]_58 ;
  wire [7:0]\fifo_mem_reg[1][0]_33 ;
  wire [7:0]\fifo_mem_reg[1][10]_43 ;
  wire [7:0]\fifo_mem_reg[1][11]_44 ;
  wire [7:0]\fifo_mem_reg[1][12]_45 ;
  wire [7:0]\fifo_mem_reg[1][13]_46 ;
  wire [7:0]\fifo_mem_reg[1][14]_47 ;
  wire [7:0]\fifo_mem_reg[1][15]_48 ;
  wire [7:0]\fifo_mem_reg[1][1]_34 ;
  wire [7:0]\fifo_mem_reg[1][2]_35 ;
  wire [7:0]\fifo_mem_reg[1][3]_36 ;
  wire [7:0]\fifo_mem_reg[1][4]_37 ;
  wire [7:0]\fifo_mem_reg[1][5]_38 ;
  wire [7:0]\fifo_mem_reg[1][6]_39 ;
  wire [7:0]\fifo_mem_reg[1][7]_40 ;
  wire [7:0]\fifo_mem_reg[1][8]_41 ;
  wire [7:0]\fifo_mem_reg[1][9]_42 ;
  wire [7:0]\fifo_mem_reg[2][0]_17 ;
  wire [7:0]\fifo_mem_reg[2][10]_27 ;
  wire [7:0]\fifo_mem_reg[2][11]_28 ;
  wire [7:0]\fifo_mem_reg[2][12]_29 ;
  wire [7:0]\fifo_mem_reg[2][13]_30 ;
  wire [7:0]\fifo_mem_reg[2][14]_31 ;
  wire [7:0]\fifo_mem_reg[2][15]_32 ;
  wire [7:0]\fifo_mem_reg[2][1]_18 ;
  wire [7:0]\fifo_mem_reg[2][2]_19 ;
  wire [7:0]\fifo_mem_reg[2][3]_20 ;
  wire [7:0]\fifo_mem_reg[2][4]_21 ;
  wire [7:0]\fifo_mem_reg[2][5]_22 ;
  wire [7:0]\fifo_mem_reg[2][6]_23 ;
  wire [7:0]\fifo_mem_reg[2][7]_24 ;
  wire [7:0]\fifo_mem_reg[2][8]_25 ;
  wire [7:0]\fifo_mem_reg[2][9]_26 ;
  wire [7:0]\fifo_mem_reg[3][0]_1 ;
  wire [7:0]\fifo_mem_reg[3][10]_11 ;
  wire [7:0]\fifo_mem_reg[3][11]_12 ;
  wire [7:0]\fifo_mem_reg[3][12]_13 ;
  wire [7:0]\fifo_mem_reg[3][13]_14 ;
  wire [7:0]\fifo_mem_reg[3][14]_15 ;
  wire [7:0]\fifo_mem_reg[3][15]_16 ;
  wire [7:0]\fifo_mem_reg[3][1]_2 ;
  wire [7:0]\fifo_mem_reg[3][2]_3 ;
  wire [7:0]\fifo_mem_reg[3][3]_4 ;
  wire [7:0]\fifo_mem_reg[3][4]_5 ;
  wire [7:0]\fifo_mem_reg[3][5]_6 ;
  wire [7:0]\fifo_mem_reg[3][6]_7 ;
  wire [7:0]\fifo_mem_reg[3][7]_8 ;
  wire [7:0]\fifo_mem_reg[3][8]_9 ;
  wire [7:0]\fifo_mem_reg[3][9]_10 ;
  wire \group_data_reg[0][0]_i_4_n_0 ;
  wire \group_data_reg[0][0]_i_5_n_0 ;
  wire \group_data_reg[0][0]_i_6_n_0 ;
  wire \group_data_reg[0][0]_i_7_n_0 ;
  wire \group_data_reg[0][1]_i_4_n_0 ;
  wire \group_data_reg[0][1]_i_5_n_0 ;
  wire \group_data_reg[0][1]_i_6_n_0 ;
  wire \group_data_reg[0][1]_i_7_n_0 ;
  wire \group_data_reg[0][2]_i_4_n_0 ;
  wire \group_data_reg[0][2]_i_5_n_0 ;
  wire \group_data_reg[0][2]_i_6_n_0 ;
  wire \group_data_reg[0][2]_i_7_n_0 ;
  wire \group_data_reg[0][3]_i_4_n_0 ;
  wire \group_data_reg[0][3]_i_5_n_0 ;
  wire \group_data_reg[0][3]_i_6_n_0 ;
  wire \group_data_reg[0][3]_i_7_n_0 ;
  wire \group_data_reg[0][4]_i_4_n_0 ;
  wire \group_data_reg[0][4]_i_5_n_0 ;
  wire \group_data_reg[0][4]_i_6_n_0 ;
  wire \group_data_reg[0][4]_i_7_n_0 ;
  wire \group_data_reg[0][5]_i_4_n_0 ;
  wire \group_data_reg[0][5]_i_5_n_0 ;
  wire \group_data_reg[0][5]_i_6_n_0 ;
  wire \group_data_reg[0][5]_i_7_n_0 ;
  wire \group_data_reg[0][6]_i_4_n_0 ;
  wire \group_data_reg[0][6]_i_5_n_0 ;
  wire \group_data_reg[0][6]_i_6_n_0 ;
  wire \group_data_reg[0][6]_i_7_n_0 ;
  wire \group_data_reg[0][7]_i_4_n_0 ;
  wire \group_data_reg[0][7]_i_5_n_0 ;
  wire \group_data_reg[0][7]_i_6_n_0 ;
  wire \group_data_reg[0][7]_i_7_n_0 ;
  wire \group_data_reg[1][0]_i_4_n_0 ;
  wire \group_data_reg[1][0]_i_5_n_0 ;
  wire \group_data_reg[1][0]_i_6_n_0 ;
  wire \group_data_reg[1][0]_i_7_n_0 ;
  wire \group_data_reg[1][1]_i_4_n_0 ;
  wire \group_data_reg[1][1]_i_5_n_0 ;
  wire \group_data_reg[1][1]_i_6_n_0 ;
  wire \group_data_reg[1][1]_i_7_n_0 ;
  wire \group_data_reg[1][2]_i_4_n_0 ;
  wire \group_data_reg[1][2]_i_5_n_0 ;
  wire \group_data_reg[1][2]_i_6_n_0 ;
  wire \group_data_reg[1][2]_i_7_n_0 ;
  wire \group_data_reg[1][3]_i_4_n_0 ;
  wire \group_data_reg[1][3]_i_5_n_0 ;
  wire \group_data_reg[1][3]_i_6_n_0 ;
  wire \group_data_reg[1][3]_i_7_n_0 ;
  wire \group_data_reg[1][4]_i_4_n_0 ;
  wire \group_data_reg[1][4]_i_5_n_0 ;
  wire \group_data_reg[1][4]_i_6_n_0 ;
  wire \group_data_reg[1][4]_i_7_n_0 ;
  wire \group_data_reg[1][5]_i_4_n_0 ;
  wire \group_data_reg[1][5]_i_5_n_0 ;
  wire \group_data_reg[1][5]_i_6_n_0 ;
  wire \group_data_reg[1][5]_i_7_n_0 ;
  wire \group_data_reg[1][6]_i_4_n_0 ;
  wire \group_data_reg[1][6]_i_5_n_0 ;
  wire \group_data_reg[1][6]_i_6_n_0 ;
  wire \group_data_reg[1][6]_i_7_n_0 ;
  wire \group_data_reg[1][7]_i_4_n_0 ;
  wire \group_data_reg[1][7]_i_5_n_0 ;
  wire \group_data_reg[1][7]_i_6_n_0 ;
  wire \group_data_reg[1][7]_i_7_n_0 ;
  wire \group_data_reg[2][0]_i_4_n_0 ;
  wire \group_data_reg[2][0]_i_5_n_0 ;
  wire \group_data_reg[2][0]_i_6_n_0 ;
  wire \group_data_reg[2][0]_i_7_n_0 ;
  wire \group_data_reg[2][1]_i_4_n_0 ;
  wire \group_data_reg[2][1]_i_5_n_0 ;
  wire \group_data_reg[2][1]_i_6_n_0 ;
  wire \group_data_reg[2][1]_i_7_n_0 ;
  wire \group_data_reg[2][2]_i_4_n_0 ;
  wire \group_data_reg[2][2]_i_5_n_0 ;
  wire \group_data_reg[2][2]_i_6_n_0 ;
  wire \group_data_reg[2][2]_i_7_n_0 ;
  wire \group_data_reg[2][3]_i_4_n_0 ;
  wire \group_data_reg[2][3]_i_5_n_0 ;
  wire \group_data_reg[2][3]_i_6_n_0 ;
  wire \group_data_reg[2][3]_i_7_n_0 ;
  wire \group_data_reg[2][4]_i_4_n_0 ;
  wire \group_data_reg[2][4]_i_5_n_0 ;
  wire \group_data_reg[2][4]_i_6_n_0 ;
  wire \group_data_reg[2][4]_i_7_n_0 ;
  wire \group_data_reg[2][5]_i_4_n_0 ;
  wire \group_data_reg[2][5]_i_5_n_0 ;
  wire \group_data_reg[2][5]_i_6_n_0 ;
  wire \group_data_reg[2][5]_i_7_n_0 ;
  wire \group_data_reg[2][6]_i_4_n_0 ;
  wire \group_data_reg[2][6]_i_5_n_0 ;
  wire \group_data_reg[2][6]_i_6_n_0 ;
  wire \group_data_reg[2][6]_i_7_n_0 ;
  wire \group_data_reg[2][7]_i_4_n_0 ;
  wire \group_data_reg[2][7]_i_5_n_0 ;
  wire \group_data_reg[2][7]_i_6_n_0 ;
  wire \group_data_reg[2][7]_i_7_n_0 ;
  wire \group_data_reg[3][0]_i_4_n_0 ;
  wire \group_data_reg[3][0]_i_5_n_0 ;
  wire \group_data_reg[3][0]_i_6_n_0 ;
  wire \group_data_reg[3][0]_i_7_n_0 ;
  wire \group_data_reg[3][1]_i_4_n_0 ;
  wire \group_data_reg[3][1]_i_5_n_0 ;
  wire \group_data_reg[3][1]_i_6_n_0 ;
  wire \group_data_reg[3][1]_i_7_n_0 ;
  wire \group_data_reg[3][2]_i_4_n_0 ;
  wire \group_data_reg[3][2]_i_5_n_0 ;
  wire \group_data_reg[3][2]_i_6_n_0 ;
  wire \group_data_reg[3][2]_i_7_n_0 ;
  wire \group_data_reg[3][3]_i_4_n_0 ;
  wire \group_data_reg[3][3]_i_5_n_0 ;
  wire \group_data_reg[3][3]_i_6_n_0 ;
  wire \group_data_reg[3][3]_i_7_n_0 ;
  wire \group_data_reg[3][4]_i_4_n_0 ;
  wire \group_data_reg[3][4]_i_5_n_0 ;
  wire \group_data_reg[3][4]_i_6_n_0 ;
  wire \group_data_reg[3][4]_i_7_n_0 ;
  wire \group_data_reg[3][5]_i_4_n_0 ;
  wire \group_data_reg[3][5]_i_5_n_0 ;
  wire \group_data_reg[3][5]_i_6_n_0 ;
  wire \group_data_reg[3][5]_i_7_n_0 ;
  wire \group_data_reg[3][6]_i_4_n_0 ;
  wire \group_data_reg[3][6]_i_5_n_0 ;
  wire \group_data_reg[3][6]_i_6_n_0 ;
  wire \group_data_reg[3][6]_i_7_n_0 ;
  wire \group_data_reg[3][7]_i_4_n_0 ;
  wire \group_data_reg[3][7]_i_5_n_0 ;
  wire \group_data_reg[3][7]_i_6_n_0 ;
  wire \group_data_reg[3][7]_i_7_n_0 ;
  wire \group_data_reg_reg[0][0]_i_2_n_0 ;
  wire \group_data_reg_reg[0][0]_i_3_n_0 ;
  wire \group_data_reg_reg[0][1]_i_2_n_0 ;
  wire \group_data_reg_reg[0][1]_i_3_n_0 ;
  wire \group_data_reg_reg[0][2]_i_2_n_0 ;
  wire \group_data_reg_reg[0][2]_i_3_n_0 ;
  wire \group_data_reg_reg[0][3]_i_2_n_0 ;
  wire \group_data_reg_reg[0][3]_i_3_n_0 ;
  wire \group_data_reg_reg[0][4]_i_2_n_0 ;
  wire \group_data_reg_reg[0][4]_i_3_n_0 ;
  wire \group_data_reg_reg[0][5]_i_2_n_0 ;
  wire \group_data_reg_reg[0][5]_i_3_n_0 ;
  wire \group_data_reg_reg[0][6]_i_2_n_0 ;
  wire \group_data_reg_reg[0][6]_i_3_n_0 ;
  wire \group_data_reg_reg[0][7]_i_2_n_0 ;
  wire \group_data_reg_reg[0][7]_i_3_n_0 ;
  wire \group_data_reg_reg[1][0]_i_2_n_0 ;
  wire \group_data_reg_reg[1][0]_i_3_n_0 ;
  wire \group_data_reg_reg[1][1]_i_2_n_0 ;
  wire \group_data_reg_reg[1][1]_i_3_n_0 ;
  wire \group_data_reg_reg[1][2]_i_2_n_0 ;
  wire \group_data_reg_reg[1][2]_i_3_n_0 ;
  wire \group_data_reg_reg[1][3]_i_2_n_0 ;
  wire \group_data_reg_reg[1][3]_i_3_n_0 ;
  wire \group_data_reg_reg[1][4]_i_2_n_0 ;
  wire \group_data_reg_reg[1][4]_i_3_n_0 ;
  wire \group_data_reg_reg[1][5]_i_2_n_0 ;
  wire \group_data_reg_reg[1][5]_i_3_n_0 ;
  wire \group_data_reg_reg[1][6]_i_2_n_0 ;
  wire \group_data_reg_reg[1][6]_i_3_n_0 ;
  wire \group_data_reg_reg[1][7]_i_2_n_0 ;
  wire \group_data_reg_reg[1][7]_i_3_n_0 ;
  wire \group_data_reg_reg[2][0]_i_2_n_0 ;
  wire \group_data_reg_reg[2][0]_i_3_n_0 ;
  wire \group_data_reg_reg[2][1]_i_2_n_0 ;
  wire \group_data_reg_reg[2][1]_i_3_n_0 ;
  wire \group_data_reg_reg[2][2]_i_2_n_0 ;
  wire \group_data_reg_reg[2][2]_i_3_n_0 ;
  wire \group_data_reg_reg[2][3]_i_2_n_0 ;
  wire \group_data_reg_reg[2][3]_i_3_n_0 ;
  wire \group_data_reg_reg[2][4]_i_2_n_0 ;
  wire \group_data_reg_reg[2][4]_i_3_n_0 ;
  wire \group_data_reg_reg[2][5]_i_2_n_0 ;
  wire \group_data_reg_reg[2][5]_i_3_n_0 ;
  wire \group_data_reg_reg[2][6]_i_2_n_0 ;
  wire \group_data_reg_reg[2][6]_i_3_n_0 ;
  wire \group_data_reg_reg[2][7]_i_2_n_0 ;
  wire \group_data_reg_reg[2][7]_i_3_n_0 ;
  wire \group_data_reg_reg[3][0]_i_2_n_0 ;
  wire \group_data_reg_reg[3][0]_i_3_n_0 ;
  wire \group_data_reg_reg[3][1]_i_2_n_0 ;
  wire \group_data_reg_reg[3][1]_i_3_n_0 ;
  wire \group_data_reg_reg[3][2]_i_2_n_0 ;
  wire \group_data_reg_reg[3][2]_i_3_n_0 ;
  wire \group_data_reg_reg[3][3]_i_2_n_0 ;
  wire \group_data_reg_reg[3][3]_i_3_n_0 ;
  wire \group_data_reg_reg[3][4]_i_2_n_0 ;
  wire \group_data_reg_reg[3][4]_i_3_n_0 ;
  wire \group_data_reg_reg[3][5]_i_2_n_0 ;
  wire \group_data_reg_reg[3][5]_i_3_n_0 ;
  wire \group_data_reg_reg[3][6]_i_2_n_0 ;
  wire \group_data_reg_reg[3][6]_i_3_n_0 ;
  wire \group_data_reg_reg[3][7]_i_2_n_0 ;
  wire \group_data_reg_reg[3][7]_i_3_n_0 ;
  wire hs_mode_IBUF;
  wire [4:0]lane_cnt;
  wire \lane_cnt[0][1]_i_1_n_0 ;
  wire \lane_cnt[0][4]_i_1_n_0 ;
  wire \lane_cnt[1][1]_i_1_n_0 ;
  wire \lane_cnt[1][4]_i_1_n_0 ;
  wire \lane_cnt[2][1]_i_1_n_0 ;
  wire \lane_cnt[2][4]_i_1_n_0 ;
  wire \lane_cnt[3][1]_i_1_n_0 ;
  wire \lane_cnt[3][4]_i_1_n_0 ;
  wire [4:0]lane_cnt__0;
  wire [4:0]lane_cnt__1;
  wire [4:0]lane_cnt__2;
  wire [4:0]\lane_cnt_reg[0]_65 ;
  wire [4:0]\lane_cnt_reg[1]_66 ;
  wire [4:0]\lane_cnt_reg[2]_67 ;
  wire [4:0]\lane_cnt_reg[3]_68 ;
  wire [7:0]\lane_data_i[0] ;
  wire [7:0]\lane_data_i[1] ;
  wire [7:0]\lane_data_i[2] ;
  wire [7:0]\lane_data_i[3] ;
  wire lane_err_toggle_byte;
  wire lane_err_toggle_byte_reg;
  wire [7:0]\lane_group_data_i[0] ;
  wire [7:0]\lane_group_data_i[1] ;
  wire [7:0]\lane_group_data_i[2] ;
  wire [7:0]\lane_group_data_i[3] ;
  wire lane_valid_0_IBUF;
  wire lane_valid_1_IBUF;
  wire lane_valid_2_IBUF;
  wire lane_valid_3_IBUF;
  wire lp_mode_IBUF;
  wire merge_byte_valid;
  wire out;
  wire [3:1]phy_lane_valid;
  wire \rd_ptr[0][0]_i_1_n_0 ;
  wire \rd_ptr[0][1]_i_1_n_0 ;
  wire \rd_ptr[0][2]_i_1_n_0 ;
  wire \rd_ptr[0][3]_i_1_n_0 ;
  wire \rd_ptr[1][0]_i_1_n_0 ;
  wire \rd_ptr[1][1]_i_1_n_0 ;
  wire \rd_ptr[1][2]_i_1_n_0 ;
  wire \rd_ptr[1][3]_i_1_n_0 ;
  wire \rd_ptr[2][0]_i_1_n_0 ;
  wire \rd_ptr[2][1]_i_1_n_0 ;
  wire \rd_ptr[2][2]_i_1_n_0 ;
  wire \rd_ptr[2][3]_i_1_n_0 ;
  wire \rd_ptr[3][0]_i_1_n_0 ;
  wire \rd_ptr[3][1]_i_1_n_0 ;
  wire \rd_ptr[3][2]_i_1_n_0 ;
  wire \rd_ptr[3][3]_i_2_n_0 ;
  wire \rd_ptr[3][3]_i_4_n_0 ;
  wire \rd_ptr[3][3]_i_5_n_0 ;
  wire \rd_ptr[3][3]_i_6_n_0 ;
  wire \rd_ptr[3][3]_i_7_n_0 ;
  wire \rd_ptr_reg[3][3]_0 ;
  wire \rd_ptr_reg_n_0_[0][0] ;
  wire \rd_ptr_reg_n_0_[0][1] ;
  wire \rd_ptr_reg_n_0_[0][2] ;
  wire \rd_ptr_reg_n_0_[0][3] ;
  wire \rd_ptr_reg_n_0_[1][0] ;
  wire \rd_ptr_reg_n_0_[1][1] ;
  wire \rd_ptr_reg_n_0_[1][2] ;
  wire \rd_ptr_reg_n_0_[1][3] ;
  wire \rd_ptr_reg_n_0_[2][0] ;
  wire \rd_ptr_reg_n_0_[2][1] ;
  wire \rd_ptr_reg_n_0_[2][2] ;
  wire \rd_ptr_reg_n_0_[2][3] ;
  wire \rd_ptr_reg_n_0_[3][0] ;
  wire \rd_ptr_reg_n_0_[3][1] ;
  wire \rd_ptr_reg_n_0_[3][2] ;
  wire \rd_ptr_reg_n_0_[3][3] ;
  wire resync_toggle_byte_d;
  wire rst_n_IBUF;
  wire \wr_ptr[0][0]_i_1_n_0 ;
  wire \wr_ptr[0][1]_i_1_n_0 ;
  wire \wr_ptr[0][2]_i_1_n_0 ;
  wire \wr_ptr[0][3]_i_1_n_0 ;
  wire \wr_ptr[0][3]_i_2_n_0 ;
  wire \wr_ptr[1][0]_i_1_n_0 ;
  wire \wr_ptr[1][1]_i_1_n_0 ;
  wire \wr_ptr[1][2]_i_1_n_0 ;
  wire \wr_ptr[1][3]_i_1_n_0 ;
  wire \wr_ptr[1][3]_i_2_n_0 ;
  wire \wr_ptr[2][0]_i_1_n_0 ;
  wire \wr_ptr[2][1]_i_1_n_0 ;
  wire \wr_ptr[2][2]_i_1_n_0 ;
  wire \wr_ptr[2][3]_i_1_n_0 ;
  wire \wr_ptr[2][3]_i_2_n_0 ;
  wire \wr_ptr[2][3]_i_3_n_0 ;
  wire \wr_ptr[3][0]_i_1_n_0 ;
  wire \wr_ptr[3][1]_i_1_n_0 ;
  wire \wr_ptr[3][2]_i_1_n_0 ;
  wire \wr_ptr[3][3]_i_2_n_0 ;
  wire \wr_ptr[3][3]_i_3_n_0 ;
  wire \wr_ptr[3][3]_i_5_n_0 ;
  wire \wr_ptr_reg[3][3]_0 ;
  wire \wr_ptr_reg_n_0_[0][0] ;
  wire \wr_ptr_reg_n_0_[0][1] ;
  wire \wr_ptr_reg_n_0_[0][2] ;
  wire \wr_ptr_reg_n_0_[0][3] ;
  wire \wr_ptr_reg_n_0_[1][0] ;
  wire \wr_ptr_reg_n_0_[1][1] ;
  wire \wr_ptr_reg_n_0_[1][2] ;
  wire \wr_ptr_reg_n_0_[1][3] ;
  wire \wr_ptr_reg_n_0_[2][0] ;
  wire \wr_ptr_reg_n_0_[2][1] ;
  wire \wr_ptr_reg_n_0_[2][2] ;
  wire \wr_ptr_reg_n_0_[2][3] ;
  wire \wr_ptr_reg_n_0_[3][0] ;
  wire \wr_ptr_reg_n_0_[3][1] ;
  wire \wr_ptr_reg_n_0_[3][2] ;
  wire \wr_ptr_reg_n_0_[3][3] ;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT6 #(
    .INIT(64'h00000000EAAAAAAA)) 
    err_overflow_o_i_1
       (.I0(err_overflow_o_i_2_n_0),
        .I1(\lane_cnt_reg[0]_65 [4]),
        .I2(\cfg_lane_enable_mask_byte_reg[3] [0]),
        .I3(err_overflow_o_i_3_n_0),
        .I4(lane_valid_0_IBUF),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(err_overflow_o_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    err_overflow_o_i_2
       (.I0(phy_lane_valid[3]),
        .I1(\lane_cnt_reg[3]_68 [4]),
        .I2(\lane_cnt_reg[1]_66 [4]),
        .I3(phy_lane_valid[1]),
        .I4(\lane_cnt_reg[2]_67 [4]),
        .I5(phy_lane_valid[2]),
        .O(err_overflow_o_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT2 #(
    .INIT(4'h2)) 
    err_overflow_o_i_3
       (.I0(hs_mode_IBUF),
        .I1(lp_mode_IBUF),
        .O(err_overflow_o_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT5 #(
    .INIT(32'h08000000)) 
    err_overflow_o_i_4
       (.I0(lane_valid_2_IBUF),
        .I1(hs_mode_IBUF),
        .I2(lp_mode_IBUF),
        .I3(\wr_ptr[2][3]_i_3_n_0 ),
        .I4(\cfg_lane_enable_mask_byte_reg[3] [2]),
        .O(phy_lane_valid[2]));
  FDRE #(
    .INIT(1'b0)) 
    err_overflow_o_reg
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(err_overflow_o_i_1_n_0),
        .Q(deskew_overflow),
        .R(\<const0> ));
  LUT6 #(
    .INIT(64'h0000000000010000)) 
    \fifo_mem[0][0][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][3] ),
        .I1(\wr_ptr_reg_n_0_[0][2] ),
        .I2(\wr_ptr_reg_n_0_[0][0] ),
        .I3(\wr_ptr_reg_n_0_[0][1] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(fifo_mem));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[0][10][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][0] ),
        .I1(\wr_ptr_reg_n_0_[0][2] ),
        .I2(\wr_ptr_reg_n_0_[0][1] ),
        .I3(\wr_ptr_reg_n_0_[0][3] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][10][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[0][11][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][3] ),
        .I1(\wr_ptr_reg_n_0_[0][2] ),
        .I2(\wr_ptr_reg_n_0_[0][0] ),
        .I3(\wr_ptr_reg_n_0_[0][1] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][11][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[0][12][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][0] ),
        .I1(\wr_ptr_reg_n_0_[0][1] ),
        .I2(\wr_ptr_reg_n_0_[0][3] ),
        .I3(\wr_ptr_reg_n_0_[0][2] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][12][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[0][13][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][2] ),
        .I1(\wr_ptr_reg_n_0_[0][1] ),
        .I2(\wr_ptr_reg_n_0_[0][0] ),
        .I3(\wr_ptr_reg_n_0_[0][3] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][13][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[0][14][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][2] ),
        .I1(\wr_ptr_reg_n_0_[0][0] ),
        .I2(\wr_ptr_reg_n_0_[0][3] ),
        .I3(\wr_ptr_reg_n_0_[0][1] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][14][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000080000000)) 
    \fifo_mem[0][15][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][3] ),
        .I1(\wr_ptr_reg_n_0_[0][2] ),
        .I2(\wr_ptr_reg_n_0_[0][0] ),
        .I3(\wr_ptr_reg_n_0_[0][1] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][15][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[0][1][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][3] ),
        .I1(\wr_ptr_reg_n_0_[0][2] ),
        .I2(\wr_ptr_reg_n_0_[0][0] ),
        .I3(\wr_ptr_reg_n_0_[0][1] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][1][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[0][2][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][3] ),
        .I1(\wr_ptr_reg_n_0_[0][2] ),
        .I2(\wr_ptr_reg_n_0_[0][1] ),
        .I3(\wr_ptr_reg_n_0_[0][0] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][2][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[0][3][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][3] ),
        .I1(\wr_ptr_reg_n_0_[0][2] ),
        .I2(\wr_ptr_reg_n_0_[0][0] ),
        .I3(\wr_ptr_reg_n_0_[0][1] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][3][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[0][4][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][3] ),
        .I1(\wr_ptr_reg_n_0_[0][0] ),
        .I2(\wr_ptr_reg_n_0_[0][2] ),
        .I3(\wr_ptr_reg_n_0_[0][1] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][4][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[0][5][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][3] ),
        .I1(\wr_ptr_reg_n_0_[0][1] ),
        .I2(\wr_ptr_reg_n_0_[0][0] ),
        .I3(\wr_ptr_reg_n_0_[0][2] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][5][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[0][6][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][3] ),
        .I1(\wr_ptr_reg_n_0_[0][0] ),
        .I2(\wr_ptr_reg_n_0_[0][1] ),
        .I3(\wr_ptr_reg_n_0_[0][2] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][6][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[0][7][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][2] ),
        .I1(\wr_ptr_reg_n_0_[0][3] ),
        .I2(\wr_ptr_reg_n_0_[0][0] ),
        .I3(\wr_ptr_reg_n_0_[0][1] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][7][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[0][8][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][0] ),
        .I1(\wr_ptr_reg_n_0_[0][2] ),
        .I2(\wr_ptr_reg_n_0_[0][3] ),
        .I3(\wr_ptr_reg_n_0_[0][1] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][8][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[0][9][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][1] ),
        .I1(\wr_ptr_reg_n_0_[0][2] ),
        .I2(\wr_ptr_reg_n_0_[0][0] ),
        .I3(\wr_ptr_reg_n_0_[0][3] ),
        .I4(\wr_ptr[0][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[0][9][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000010000)) 
    \fifo_mem[1][0][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][3] ),
        .I1(\wr_ptr_reg_n_0_[1][2] ),
        .I2(\wr_ptr_reg_n_0_[1][0] ),
        .I3(\wr_ptr_reg_n_0_[1][1] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][0][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[1][10][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][0] ),
        .I1(\wr_ptr_reg_n_0_[1][2] ),
        .I2(\wr_ptr_reg_n_0_[1][1] ),
        .I3(\wr_ptr_reg_n_0_[1][3] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][10][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[1][11][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][3] ),
        .I1(\wr_ptr_reg_n_0_[1][2] ),
        .I2(\wr_ptr_reg_n_0_[1][0] ),
        .I3(\wr_ptr_reg_n_0_[1][1] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][11][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[1][12][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][0] ),
        .I1(\wr_ptr_reg_n_0_[1][1] ),
        .I2(\wr_ptr_reg_n_0_[1][3] ),
        .I3(\wr_ptr_reg_n_0_[1][2] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][12][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[1][13][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][2] ),
        .I1(\wr_ptr_reg_n_0_[1][1] ),
        .I2(\wr_ptr_reg_n_0_[1][0] ),
        .I3(\wr_ptr_reg_n_0_[1][3] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][13][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[1][14][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][2] ),
        .I1(\wr_ptr_reg_n_0_[1][0] ),
        .I2(\wr_ptr_reg_n_0_[1][3] ),
        .I3(\wr_ptr_reg_n_0_[1][1] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][14][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000080000000)) 
    \fifo_mem[1][15][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][3] ),
        .I1(\wr_ptr_reg_n_0_[1][2] ),
        .I2(\wr_ptr_reg_n_0_[1][0] ),
        .I3(\wr_ptr_reg_n_0_[1][1] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][15][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[1][1][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][3] ),
        .I1(\wr_ptr_reg_n_0_[1][2] ),
        .I2(\wr_ptr_reg_n_0_[1][0] ),
        .I3(\wr_ptr_reg_n_0_[1][1] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][1][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[1][2][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][3] ),
        .I1(\wr_ptr_reg_n_0_[1][2] ),
        .I2(\wr_ptr_reg_n_0_[1][1] ),
        .I3(\wr_ptr_reg_n_0_[1][0] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][2][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[1][3][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][3] ),
        .I1(\wr_ptr_reg_n_0_[1][2] ),
        .I2(\wr_ptr_reg_n_0_[1][0] ),
        .I3(\wr_ptr_reg_n_0_[1][1] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][3][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[1][4][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][3] ),
        .I1(\wr_ptr_reg_n_0_[1][0] ),
        .I2(\wr_ptr_reg_n_0_[1][2] ),
        .I3(\wr_ptr_reg_n_0_[1][1] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][4][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[1][5][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][3] ),
        .I1(\wr_ptr_reg_n_0_[1][1] ),
        .I2(\wr_ptr_reg_n_0_[1][0] ),
        .I3(\wr_ptr_reg_n_0_[1][2] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][5][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[1][6][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][3] ),
        .I1(\wr_ptr_reg_n_0_[1][0] ),
        .I2(\wr_ptr_reg_n_0_[1][1] ),
        .I3(\wr_ptr_reg_n_0_[1][2] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][6][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[1][7][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][2] ),
        .I1(\wr_ptr_reg_n_0_[1][3] ),
        .I2(\wr_ptr_reg_n_0_[1][0] ),
        .I3(\wr_ptr_reg_n_0_[1][1] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][7][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[1][8][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][0] ),
        .I1(\wr_ptr_reg_n_0_[1][2] ),
        .I2(\wr_ptr_reg_n_0_[1][3] ),
        .I3(\wr_ptr_reg_n_0_[1][1] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][8][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[1][9][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][1] ),
        .I1(\wr_ptr_reg_n_0_[1][2] ),
        .I2(\wr_ptr_reg_n_0_[1][0] ),
        .I3(\wr_ptr_reg_n_0_[1][3] ),
        .I4(\wr_ptr[1][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[1][9][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000010000)) 
    \fifo_mem[2][0][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][3] ),
        .I1(\wr_ptr_reg_n_0_[2][2] ),
        .I2(\wr_ptr_reg_n_0_[2][0] ),
        .I3(\wr_ptr_reg_n_0_[2][1] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][0][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[2][10][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][0] ),
        .I1(\wr_ptr_reg_n_0_[2][2] ),
        .I2(\wr_ptr_reg_n_0_[2][1] ),
        .I3(\wr_ptr_reg_n_0_[2][3] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][10][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[2][11][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][3] ),
        .I1(\wr_ptr_reg_n_0_[2][2] ),
        .I2(\wr_ptr_reg_n_0_[2][0] ),
        .I3(\wr_ptr_reg_n_0_[2][1] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][11][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[2][12][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][0] ),
        .I1(\wr_ptr_reg_n_0_[2][1] ),
        .I2(\wr_ptr_reg_n_0_[2][3] ),
        .I3(\wr_ptr_reg_n_0_[2][2] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][12][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[2][13][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][2] ),
        .I1(\wr_ptr_reg_n_0_[2][1] ),
        .I2(\wr_ptr_reg_n_0_[2][0] ),
        .I3(\wr_ptr_reg_n_0_[2][3] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][13][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[2][14][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][2] ),
        .I1(\wr_ptr_reg_n_0_[2][0] ),
        .I2(\wr_ptr_reg_n_0_[2][3] ),
        .I3(\wr_ptr_reg_n_0_[2][1] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][14][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000080000000)) 
    \fifo_mem[2][15][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][3] ),
        .I1(\wr_ptr_reg_n_0_[2][2] ),
        .I2(\wr_ptr_reg_n_0_[2][0] ),
        .I3(\wr_ptr_reg_n_0_[2][1] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][15][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[2][1][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][3] ),
        .I1(\wr_ptr_reg_n_0_[2][2] ),
        .I2(\wr_ptr_reg_n_0_[2][0] ),
        .I3(\wr_ptr_reg_n_0_[2][1] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][1][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[2][2][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][3] ),
        .I1(\wr_ptr_reg_n_0_[2][2] ),
        .I2(\wr_ptr_reg_n_0_[2][1] ),
        .I3(\wr_ptr_reg_n_0_[2][0] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][2][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[2][3][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][3] ),
        .I1(\wr_ptr_reg_n_0_[2][2] ),
        .I2(\wr_ptr_reg_n_0_[2][0] ),
        .I3(\wr_ptr_reg_n_0_[2][1] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][3][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[2][4][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][3] ),
        .I1(\wr_ptr_reg_n_0_[2][0] ),
        .I2(\wr_ptr_reg_n_0_[2][2] ),
        .I3(\wr_ptr_reg_n_0_[2][1] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][4][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[2][5][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][3] ),
        .I1(\wr_ptr_reg_n_0_[2][1] ),
        .I2(\wr_ptr_reg_n_0_[2][0] ),
        .I3(\wr_ptr_reg_n_0_[2][2] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][5][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[2][6][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][3] ),
        .I1(\wr_ptr_reg_n_0_[2][0] ),
        .I2(\wr_ptr_reg_n_0_[2][1] ),
        .I3(\wr_ptr_reg_n_0_[2][2] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][6][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[2][7][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][2] ),
        .I1(\wr_ptr_reg_n_0_[2][3] ),
        .I2(\wr_ptr_reg_n_0_[2][0] ),
        .I3(\wr_ptr_reg_n_0_[2][1] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][7][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[2][8][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][0] ),
        .I1(\wr_ptr_reg_n_0_[2][2] ),
        .I2(\wr_ptr_reg_n_0_[2][3] ),
        .I3(\wr_ptr_reg_n_0_[2][1] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][8][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[2][9][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][1] ),
        .I1(\wr_ptr_reg_n_0_[2][2] ),
        .I2(\wr_ptr_reg_n_0_[2][0] ),
        .I3(\wr_ptr_reg_n_0_[2][3] ),
        .I4(\wr_ptr[2][3]_i_1_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[2][9][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000010000)) 
    \fifo_mem[3][0][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][3] ),
        .I1(\wr_ptr_reg_n_0_[3][2] ),
        .I2(\wr_ptr_reg_n_0_[3][0] ),
        .I3(\wr_ptr_reg_n_0_[3][1] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][0][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[3][10][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][0] ),
        .I1(\wr_ptr_reg_n_0_[3][2] ),
        .I2(\wr_ptr_reg_n_0_[3][1] ),
        .I3(\wr_ptr_reg_n_0_[3][3] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][10][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[3][11][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][3] ),
        .I1(\wr_ptr_reg_n_0_[3][2] ),
        .I2(\wr_ptr_reg_n_0_[3][0] ),
        .I3(\wr_ptr_reg_n_0_[3][1] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][11][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[3][12][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][0] ),
        .I1(\wr_ptr_reg_n_0_[3][1] ),
        .I2(\wr_ptr_reg_n_0_[3][3] ),
        .I3(\wr_ptr_reg_n_0_[3][2] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][12][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[3][13][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][2] ),
        .I1(\wr_ptr_reg_n_0_[3][1] ),
        .I2(\wr_ptr_reg_n_0_[3][0] ),
        .I3(\wr_ptr_reg_n_0_[3][3] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][13][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[3][14][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][2] ),
        .I1(\wr_ptr_reg_n_0_[3][0] ),
        .I2(\wr_ptr_reg_n_0_[3][3] ),
        .I3(\wr_ptr_reg_n_0_[3][1] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][14][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000080000000)) 
    \fifo_mem[3][15][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][3] ),
        .I1(\wr_ptr_reg_n_0_[3][2] ),
        .I2(\wr_ptr_reg_n_0_[3][0] ),
        .I3(\wr_ptr_reg_n_0_[3][1] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][15][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[3][1][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][3] ),
        .I1(\wr_ptr_reg_n_0_[3][2] ),
        .I2(\wr_ptr_reg_n_0_[3][0] ),
        .I3(\wr_ptr_reg_n_0_[3][1] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][1][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[3][2][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][3] ),
        .I1(\wr_ptr_reg_n_0_[3][2] ),
        .I2(\wr_ptr_reg_n_0_[3][1] ),
        .I3(\wr_ptr_reg_n_0_[3][0] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][2][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[3][3][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][3] ),
        .I1(\wr_ptr_reg_n_0_[3][2] ),
        .I2(\wr_ptr_reg_n_0_[3][0] ),
        .I3(\wr_ptr_reg_n_0_[3][1] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][3][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[3][4][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][3] ),
        .I1(\wr_ptr_reg_n_0_[3][0] ),
        .I2(\wr_ptr_reg_n_0_[3][2] ),
        .I3(\wr_ptr_reg_n_0_[3][1] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][4][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[3][5][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][3] ),
        .I1(\wr_ptr_reg_n_0_[3][1] ),
        .I2(\wr_ptr_reg_n_0_[3][0] ),
        .I3(\wr_ptr_reg_n_0_[3][2] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][5][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[3][6][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][3] ),
        .I1(\wr_ptr_reg_n_0_[3][0] ),
        .I2(\wr_ptr_reg_n_0_[3][1] ),
        .I3(\wr_ptr_reg_n_0_[3][2] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][6][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000020000000)) 
    \fifo_mem[3][7][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][2] ),
        .I1(\wr_ptr_reg_n_0_[3][3] ),
        .I2(\wr_ptr_reg_n_0_[3][0] ),
        .I3(\wr_ptr_reg_n_0_[3][1] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][7][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000100000)) 
    \fifo_mem[3][8][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][0] ),
        .I1(\wr_ptr_reg_n_0_[3][2] ),
        .I2(\wr_ptr_reg_n_0_[3][3] ),
        .I3(\wr_ptr_reg_n_0_[3][1] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][8][7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000010000000)) 
    \fifo_mem[3][9][7]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][1] ),
        .I1(\wr_ptr_reg_n_0_[3][2] ),
        .I2(\wr_ptr_reg_n_0_[3][0] ),
        .I3(\wr_ptr_reg_n_0_[3][3] ),
        .I4(\wr_ptr[3][3]_i_2_n_0 ),
        .I5(\wr_ptr_reg[3][3]_0 ),
        .O(\fifo_mem[3][9][7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][0][0] 
       (.C(clk_wr),
        .CE(fifo_mem),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][0]_49 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][0][1] 
       (.C(clk_wr),
        .CE(fifo_mem),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][0]_49 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][0][2] 
       (.C(clk_wr),
        .CE(fifo_mem),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][0]_49 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][0][3] 
       (.C(clk_wr),
        .CE(fifo_mem),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][0]_49 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][0][4] 
       (.C(clk_wr),
        .CE(fifo_mem),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][0]_49 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][0][5] 
       (.C(clk_wr),
        .CE(fifo_mem),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][0]_49 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][0][6] 
       (.C(clk_wr),
        .CE(fifo_mem),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][0]_49 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][0][7] 
       (.C(clk_wr),
        .CE(fifo_mem),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][0]_49 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][10][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][10][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][10]_59 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][10][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][10][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][10]_59 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][10][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][10][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][10]_59 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][10][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][10][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][10]_59 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][10][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][10][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][10]_59 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][10][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][10][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][10]_59 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][10][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][10][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][10]_59 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][10][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][10][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][10]_59 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][11][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][11][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][11]_60 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][11][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][11][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][11]_60 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][11][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][11][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][11]_60 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][11][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][11][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][11]_60 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][11][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][11][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][11]_60 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][11][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][11][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][11]_60 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][11][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][11][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][11]_60 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][11][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][11][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][11]_60 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][12][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][12][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][12]_61 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][12][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][12][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][12]_61 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][12][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][12][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][12]_61 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][12][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][12][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][12]_61 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][12][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][12][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][12]_61 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][12][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][12][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][12]_61 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][12][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][12][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][12]_61 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][12][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][12][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][12]_61 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][13][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][13][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][13]_62 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][13][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][13][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][13]_62 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][13][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][13][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][13]_62 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][13][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][13][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][13]_62 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][13][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][13][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][13]_62 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][13][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][13][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][13]_62 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][13][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][13][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][13]_62 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][13][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][13][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][13]_62 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][14][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][14][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][14]_63 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][14][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][14][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][14]_63 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][14][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][14][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][14]_63 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][14][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][14][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][14]_63 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][14][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][14][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][14]_63 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][14][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][14][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][14]_63 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][14][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][14][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][14]_63 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][14][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][14][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][14]_63 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][15][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][15][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][15]_64 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][15][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][15][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][15]_64 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][15][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][15][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][15]_64 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][15][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][15][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][15]_64 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][15][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][15][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][15]_64 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][15][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][15][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][15]_64 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][15][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][15][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][15]_64 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][15][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][15][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][15]_64 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][1][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][1][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][1]_50 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][1][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][1][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][1]_50 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][1][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][1][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][1]_50 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][1][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][1][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][1]_50 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][1][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][1][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][1]_50 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][1][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][1][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][1]_50 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][1][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][1][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][1]_50 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][1][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][1][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][1]_50 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][2][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][2][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][2]_51 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][2][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][2][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][2]_51 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][2][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][2][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][2]_51 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][2][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][2][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][2]_51 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][2][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][2][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][2]_51 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][2][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][2][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][2]_51 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][2][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][2][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][2]_51 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][2][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][2][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][2]_51 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][3][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][3][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][3]_52 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][3][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][3][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][3]_52 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][3][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][3][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][3]_52 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][3][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][3][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][3]_52 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][3][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][3][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][3]_52 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][3][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][3][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][3]_52 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][3][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][3][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][3]_52 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][3][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][3][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][3]_52 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][4][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][4][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][4]_53 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][4][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][4][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][4]_53 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][4][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][4][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][4]_53 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][4][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][4][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][4]_53 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][4][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][4][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][4]_53 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][4][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][4][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][4]_53 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][4][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][4][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][4]_53 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][4][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][4][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][4]_53 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][5][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][5][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][5]_54 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][5][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][5][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][5]_54 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][5][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][5][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][5]_54 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][5][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][5][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][5]_54 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][5][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][5][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][5]_54 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][5][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][5][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][5]_54 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][5][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][5][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][5]_54 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][5][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][5][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][5]_54 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][6][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][6][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][6]_55 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][6][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][6][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][6]_55 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][6][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][6][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][6]_55 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][6][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][6][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][6]_55 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][6][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][6][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][6]_55 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][6][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][6][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][6]_55 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][6][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][6][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][6]_55 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][6][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][6][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][6]_55 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][7][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][7][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][7]_56 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][7][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][7][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][7]_56 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][7][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][7][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][7]_56 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][7][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][7][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][7]_56 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][7][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][7][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][7]_56 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][7][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][7][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][7]_56 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][7][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][7][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][7]_56 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][7][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][7][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][7]_56 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][8][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][8][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][8]_57 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][8][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][8][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][8]_57 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][8][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][8][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][8]_57 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][8][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][8][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][8]_57 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][8][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][8][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][8]_57 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][8][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][8][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][8]_57 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][8][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][8][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][8]_57 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][8][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][8][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][8]_57 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][9][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][9][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [0]),
        .Q(\fifo_mem_reg[0][9]_58 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][9][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][9][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [1]),
        .Q(\fifo_mem_reg[0][9]_58 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][9][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][9][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [2]),
        .Q(\fifo_mem_reg[0][9]_58 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][9][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][9][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [3]),
        .Q(\fifo_mem_reg[0][9]_58 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][9][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][9][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [4]),
        .Q(\fifo_mem_reg[0][9]_58 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][9][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][9][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [5]),
        .Q(\fifo_mem_reg[0][9]_58 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][9][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][9][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [6]),
        .Q(\fifo_mem_reg[0][9]_58 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[0][9][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[0][9][7]_i_1_n_0 ),
        .D(\lane_data_i[0] [7]),
        .Q(\fifo_mem_reg[0][9]_58 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][0][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][0][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][0]_33 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][0][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][0][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][0]_33 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][0][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][0][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][0]_33 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][0][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][0][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][0]_33 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][0][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][0][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][0]_33 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][0][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][0][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][0]_33 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][0][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][0][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][0]_33 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][0][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][0][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][0]_33 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][10][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][10][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][10]_43 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][10][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][10][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][10]_43 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][10][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][10][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][10]_43 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][10][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][10][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][10]_43 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][10][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][10][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][10]_43 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][10][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][10][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][10]_43 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][10][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][10][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][10]_43 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][10][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][10][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][10]_43 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][11][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][11][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][11]_44 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][11][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][11][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][11]_44 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][11][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][11][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][11]_44 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][11][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][11][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][11]_44 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][11][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][11][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][11]_44 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][11][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][11][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][11]_44 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][11][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][11][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][11]_44 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][11][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][11][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][11]_44 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][12][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][12][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][12]_45 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][12][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][12][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][12]_45 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][12][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][12][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][12]_45 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][12][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][12][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][12]_45 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][12][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][12][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][12]_45 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][12][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][12][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][12]_45 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][12][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][12][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][12]_45 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][12][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][12][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][12]_45 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][13][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][13][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][13]_46 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][13][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][13][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][13]_46 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][13][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][13][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][13]_46 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][13][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][13][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][13]_46 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][13][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][13][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][13]_46 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][13][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][13][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][13]_46 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][13][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][13][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][13]_46 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][13][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][13][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][13]_46 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][14][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][14][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][14]_47 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][14][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][14][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][14]_47 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][14][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][14][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][14]_47 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][14][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][14][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][14]_47 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][14][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][14][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][14]_47 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][14][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][14][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][14]_47 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][14][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][14][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][14]_47 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][14][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][14][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][14]_47 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][15][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][15][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][15]_48 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][15][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][15][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][15]_48 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][15][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][15][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][15]_48 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][15][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][15][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][15]_48 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][15][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][15][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][15]_48 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][15][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][15][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][15]_48 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][15][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][15][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][15]_48 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][15][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][15][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][15]_48 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][1][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][1][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][1]_34 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][1][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][1][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][1]_34 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][1][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][1][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][1]_34 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][1][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][1][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][1]_34 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][1][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][1][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][1]_34 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][1][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][1][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][1]_34 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][1][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][1][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][1]_34 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][1][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][1][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][1]_34 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][2][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][2][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][2]_35 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][2][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][2][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][2]_35 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][2][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][2][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][2]_35 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][2][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][2][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][2]_35 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][2][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][2][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][2]_35 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][2][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][2][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][2]_35 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][2][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][2][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][2]_35 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][2][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][2][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][2]_35 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][3][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][3][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][3]_36 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][3][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][3][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][3]_36 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][3][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][3][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][3]_36 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][3][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][3][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][3]_36 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][3][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][3][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][3]_36 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][3][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][3][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][3]_36 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][3][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][3][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][3]_36 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][3][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][3][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][3]_36 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][4][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][4][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][4]_37 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][4][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][4][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][4]_37 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][4][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][4][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][4]_37 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][4][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][4][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][4]_37 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][4][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][4][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][4]_37 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][4][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][4][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][4]_37 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][4][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][4][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][4]_37 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][4][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][4][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][4]_37 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][5][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][5][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][5]_38 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][5][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][5][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][5]_38 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][5][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][5][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][5]_38 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][5][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][5][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][5]_38 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][5][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][5][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][5]_38 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][5][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][5][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][5]_38 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][5][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][5][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][5]_38 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][5][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][5][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][5]_38 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][6][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][6][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][6]_39 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][6][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][6][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][6]_39 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][6][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][6][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][6]_39 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][6][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][6][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][6]_39 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][6][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][6][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][6]_39 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][6][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][6][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][6]_39 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][6][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][6][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][6]_39 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][6][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][6][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][6]_39 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][7][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][7][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][7]_40 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][7][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][7][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][7]_40 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][7][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][7][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][7]_40 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][7][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][7][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][7]_40 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][7][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][7][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][7]_40 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][7][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][7][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][7]_40 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][7][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][7][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][7]_40 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][7][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][7][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][7]_40 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][8][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][8][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][8]_41 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][8][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][8][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][8]_41 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][8][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][8][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][8]_41 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][8][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][8][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][8]_41 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][8][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][8][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][8]_41 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][8][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][8][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][8]_41 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][8][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][8][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][8]_41 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][8][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][8][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][8]_41 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][9][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][9][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [0]),
        .Q(\fifo_mem_reg[1][9]_42 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][9][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][9][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [1]),
        .Q(\fifo_mem_reg[1][9]_42 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][9][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][9][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [2]),
        .Q(\fifo_mem_reg[1][9]_42 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][9][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][9][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [3]),
        .Q(\fifo_mem_reg[1][9]_42 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][9][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][9][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [4]),
        .Q(\fifo_mem_reg[1][9]_42 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][9][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][9][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [5]),
        .Q(\fifo_mem_reg[1][9]_42 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][9][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][9][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [6]),
        .Q(\fifo_mem_reg[1][9]_42 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[1][9][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[1][9][7]_i_1_n_0 ),
        .D(\lane_data_i[1] [7]),
        .Q(\fifo_mem_reg[1][9]_42 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][0][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][0][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][0]_17 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][0][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][0][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][0]_17 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][0][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][0][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][0]_17 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][0][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][0][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][0]_17 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][0][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][0][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][0]_17 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][0][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][0][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][0]_17 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][0][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][0][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][0]_17 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][0][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][0][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][0]_17 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][10][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][10][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][10]_27 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][10][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][10][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][10]_27 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][10][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][10][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][10]_27 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][10][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][10][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][10]_27 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][10][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][10][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][10]_27 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][10][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][10][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][10]_27 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][10][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][10][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][10]_27 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][10][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][10][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][10]_27 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][11][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][11][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][11]_28 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][11][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][11][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][11]_28 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][11][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][11][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][11]_28 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][11][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][11][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][11]_28 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][11][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][11][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][11]_28 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][11][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][11][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][11]_28 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][11][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][11][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][11]_28 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][11][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][11][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][11]_28 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][12][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][12][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][12]_29 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][12][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][12][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][12]_29 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][12][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][12][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][12]_29 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][12][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][12][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][12]_29 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][12][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][12][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][12]_29 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][12][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][12][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][12]_29 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][12][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][12][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][12]_29 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][12][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][12][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][12]_29 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][13][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][13][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][13]_30 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][13][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][13][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][13]_30 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][13][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][13][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][13]_30 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][13][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][13][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][13]_30 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][13][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][13][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][13]_30 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][13][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][13][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][13]_30 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][13][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][13][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][13]_30 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][13][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][13][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][13]_30 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][14][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][14][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][14]_31 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][14][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][14][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][14]_31 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][14][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][14][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][14]_31 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][14][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][14][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][14]_31 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][14][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][14][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][14]_31 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][14][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][14][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][14]_31 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][14][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][14][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][14]_31 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][14][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][14][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][14]_31 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][15][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][15][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][15]_32 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][15][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][15][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][15]_32 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][15][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][15][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][15]_32 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][15][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][15][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][15]_32 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][15][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][15][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][15]_32 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][15][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][15][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][15]_32 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][15][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][15][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][15]_32 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][15][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][15][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][15]_32 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][1][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][1][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][1]_18 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][1][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][1][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][1]_18 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][1][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][1][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][1]_18 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][1][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][1][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][1]_18 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][1][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][1][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][1]_18 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][1][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][1][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][1]_18 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][1][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][1][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][1]_18 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][1][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][1][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][1]_18 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][2][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][2][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][2]_19 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][2][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][2][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][2]_19 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][2][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][2][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][2]_19 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][2][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][2][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][2]_19 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][2][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][2][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][2]_19 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][2][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][2][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][2]_19 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][2][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][2][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][2]_19 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][2][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][2][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][2]_19 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][3][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][3][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][3]_20 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][3][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][3][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][3]_20 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][3][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][3][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][3]_20 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][3][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][3][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][3]_20 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][3][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][3][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][3]_20 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][3][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][3][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][3]_20 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][3][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][3][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][3]_20 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][3][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][3][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][3]_20 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][4][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][4][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][4]_21 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][4][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][4][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][4]_21 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][4][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][4][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][4]_21 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][4][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][4][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][4]_21 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][4][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][4][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][4]_21 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][4][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][4][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][4]_21 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][4][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][4][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][4]_21 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][4][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][4][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][4]_21 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][5][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][5][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][5]_22 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][5][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][5][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][5]_22 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][5][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][5][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][5]_22 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][5][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][5][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][5]_22 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][5][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][5][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][5]_22 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][5][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][5][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][5]_22 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][5][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][5][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][5]_22 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][5][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][5][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][5]_22 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][6][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][6][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][6]_23 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][6][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][6][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][6]_23 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][6][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][6][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][6]_23 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][6][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][6][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][6]_23 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][6][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][6][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][6]_23 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][6][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][6][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][6]_23 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][6][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][6][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][6]_23 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][6][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][6][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][6]_23 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][7][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][7][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][7]_24 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][7][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][7][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][7]_24 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][7][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][7][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][7]_24 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][7][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][7][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][7]_24 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][7][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][7][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][7]_24 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][7][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][7][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][7]_24 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][7][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][7][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][7]_24 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][7][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][7][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][7]_24 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][8][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][8][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][8]_25 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][8][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][8][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][8]_25 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][8][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][8][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][8]_25 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][8][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][8][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][8]_25 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][8][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][8][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][8]_25 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][8][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][8][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][8]_25 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][8][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][8][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][8]_25 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][8][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][8][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][8]_25 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][9][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][9][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [0]),
        .Q(\fifo_mem_reg[2][9]_26 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][9][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][9][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [1]),
        .Q(\fifo_mem_reg[2][9]_26 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][9][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][9][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [2]),
        .Q(\fifo_mem_reg[2][9]_26 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][9][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][9][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [3]),
        .Q(\fifo_mem_reg[2][9]_26 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][9][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][9][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [4]),
        .Q(\fifo_mem_reg[2][9]_26 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][9][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][9][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [5]),
        .Q(\fifo_mem_reg[2][9]_26 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][9][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][9][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [6]),
        .Q(\fifo_mem_reg[2][9]_26 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[2][9][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[2][9][7]_i_1_n_0 ),
        .D(\lane_data_i[2] [7]),
        .Q(\fifo_mem_reg[2][9]_26 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][0][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][0][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][0]_1 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][0][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][0][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][0]_1 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][0][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][0][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][0]_1 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][0][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][0][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][0]_1 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][0][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][0][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][0]_1 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][0][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][0][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][0]_1 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][0][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][0][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][0]_1 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][0][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][0][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][0]_1 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][10][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][10][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][10]_11 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][10][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][10][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][10]_11 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][10][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][10][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][10]_11 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][10][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][10][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][10]_11 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][10][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][10][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][10]_11 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][10][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][10][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][10]_11 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][10][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][10][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][10]_11 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][10][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][10][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][10]_11 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][11][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][11][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][11]_12 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][11][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][11][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][11]_12 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][11][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][11][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][11]_12 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][11][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][11][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][11]_12 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][11][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][11][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][11]_12 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][11][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][11][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][11]_12 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][11][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][11][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][11]_12 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][11][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][11][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][11]_12 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][12][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][12][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][12]_13 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][12][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][12][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][12]_13 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][12][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][12][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][12]_13 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][12][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][12][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][12]_13 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][12][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][12][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][12]_13 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][12][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][12][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][12]_13 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][12][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][12][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][12]_13 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][12][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][12][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][12]_13 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][13][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][13][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][13]_14 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][13][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][13][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][13]_14 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][13][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][13][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][13]_14 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][13][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][13][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][13]_14 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][13][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][13][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][13]_14 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][13][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][13][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][13]_14 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][13][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][13][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][13]_14 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][13][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][13][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][13]_14 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][14][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][14][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][14]_15 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][14][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][14][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][14]_15 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][14][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][14][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][14]_15 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][14][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][14][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][14]_15 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][14][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][14][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][14]_15 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][14][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][14][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][14]_15 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][14][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][14][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][14]_15 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][14][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][14][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][14]_15 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][15][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][15][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][15]_16 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][15][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][15][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][15]_16 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][15][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][15][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][15]_16 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][15][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][15][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][15]_16 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][15][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][15][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][15]_16 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][15][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][15][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][15]_16 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][15][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][15][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][15]_16 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][15][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][15][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][15]_16 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][1][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][1][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][1]_2 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][1][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][1][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][1]_2 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][1][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][1][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][1]_2 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][1][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][1][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][1]_2 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][1][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][1][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][1]_2 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][1][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][1][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][1]_2 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][1][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][1][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][1]_2 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][1][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][1][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][1]_2 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][2][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][2][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][2]_3 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][2][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][2][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][2]_3 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][2][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][2][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][2]_3 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][2][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][2][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][2]_3 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][2][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][2][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][2]_3 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][2][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][2][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][2]_3 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][2][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][2][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][2]_3 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][2][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][2][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][2]_3 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][3][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][3][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][3]_4 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][3][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][3][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][3]_4 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][3][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][3][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][3]_4 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][3][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][3][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][3]_4 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][3][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][3][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][3]_4 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][3][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][3][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][3]_4 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][3][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][3][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][3]_4 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][3][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][3][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][3]_4 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][4][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][4][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][4]_5 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][4][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][4][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][4]_5 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][4][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][4][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][4]_5 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][4][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][4][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][4]_5 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][4][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][4][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][4]_5 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][4][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][4][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][4]_5 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][4][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][4][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][4]_5 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][4][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][4][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][4]_5 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][5][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][5][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][5]_6 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][5][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][5][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][5]_6 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][5][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][5][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][5]_6 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][5][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][5][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][5]_6 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][5][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][5][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][5]_6 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][5][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][5][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][5]_6 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][5][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][5][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][5]_6 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][5][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][5][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][5]_6 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][6][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][6][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][6]_7 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][6][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][6][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][6]_7 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][6][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][6][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][6]_7 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][6][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][6][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][6]_7 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][6][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][6][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][6]_7 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][6][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][6][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][6]_7 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][6][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][6][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][6]_7 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][6][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][6][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][6]_7 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][7][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][7][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][7]_8 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][7][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][7][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][7]_8 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][7][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][7][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][7]_8 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][7][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][7][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][7]_8 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][7][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][7][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][7]_8 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][7][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][7][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][7]_8 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][7][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][7][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][7]_8 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][7][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][7][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][7]_8 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][8][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][8][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][8]_9 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][8][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][8][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][8]_9 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][8][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][8][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][8]_9 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][8][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][8][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][8]_9 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][8][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][8][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][8]_9 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][8][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][8][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][8]_9 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][8][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][8][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][8]_9 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][8][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][8][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][8]_9 [7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][9][0] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][9][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [0]),
        .Q(\fifo_mem_reg[3][9]_10 [0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][9][1] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][9][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [1]),
        .Q(\fifo_mem_reg[3][9]_10 [1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][9][2] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][9][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [2]),
        .Q(\fifo_mem_reg[3][9]_10 [2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][9][3] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][9][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [3]),
        .Q(\fifo_mem_reg[3][9]_10 [3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][9][4] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][9][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [4]),
        .Q(\fifo_mem_reg[3][9]_10 [4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][9][5] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][9][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [5]),
        .Q(\fifo_mem_reg[3][9]_10 [5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][9][6] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][9][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [6]),
        .Q(\fifo_mem_reg[3][9]_10 [6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \fifo_mem_reg[3][9][7] 
       (.C(clk_wr),
        .CE(\fifo_mem[3][9][7]_i_1_n_0 ),
        .D(\lane_data_i[3] [7]),
        .Q(\fifo_mem_reg[3][9]_10 [7]),
        .R(\<const0> ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][0]_i_4 
       (.I0(\fifo_mem_reg[0][3]_52 [0]),
        .I1(\fifo_mem_reg[0][2]_51 [0]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][1]_50 [0]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][0]_49 [0]),
        .O(\group_data_reg[0][0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][0]_i_5 
       (.I0(\fifo_mem_reg[0][7]_56 [0]),
        .I1(\fifo_mem_reg[0][6]_55 [0]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][5]_54 [0]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][4]_53 [0]),
        .O(\group_data_reg[0][0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][0]_i_6 
       (.I0(\fifo_mem_reg[0][11]_60 [0]),
        .I1(\fifo_mem_reg[0][10]_59 [0]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][9]_58 [0]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][8]_57 [0]),
        .O(\group_data_reg[0][0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][0]_i_7 
       (.I0(\fifo_mem_reg[0][15]_64 [0]),
        .I1(\fifo_mem_reg[0][14]_63 [0]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][13]_62 [0]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][12]_61 [0]),
        .O(\group_data_reg[0][0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][1]_i_4 
       (.I0(\fifo_mem_reg[0][3]_52 [1]),
        .I1(\fifo_mem_reg[0][2]_51 [1]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][1]_50 [1]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][0]_49 [1]),
        .O(\group_data_reg[0][1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][1]_i_5 
       (.I0(\fifo_mem_reg[0][7]_56 [1]),
        .I1(\fifo_mem_reg[0][6]_55 [1]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][5]_54 [1]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][4]_53 [1]),
        .O(\group_data_reg[0][1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][1]_i_6 
       (.I0(\fifo_mem_reg[0][11]_60 [1]),
        .I1(\fifo_mem_reg[0][10]_59 [1]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][9]_58 [1]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][8]_57 [1]),
        .O(\group_data_reg[0][1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][1]_i_7 
       (.I0(\fifo_mem_reg[0][15]_64 [1]),
        .I1(\fifo_mem_reg[0][14]_63 [1]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][13]_62 [1]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][12]_61 [1]),
        .O(\group_data_reg[0][1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][2]_i_4 
       (.I0(\fifo_mem_reg[0][3]_52 [2]),
        .I1(\fifo_mem_reg[0][2]_51 [2]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][1]_50 [2]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][0]_49 [2]),
        .O(\group_data_reg[0][2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][2]_i_5 
       (.I0(\fifo_mem_reg[0][7]_56 [2]),
        .I1(\fifo_mem_reg[0][6]_55 [2]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][5]_54 [2]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][4]_53 [2]),
        .O(\group_data_reg[0][2]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][2]_i_6 
       (.I0(\fifo_mem_reg[0][11]_60 [2]),
        .I1(\fifo_mem_reg[0][10]_59 [2]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][9]_58 [2]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][8]_57 [2]),
        .O(\group_data_reg[0][2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][2]_i_7 
       (.I0(\fifo_mem_reg[0][15]_64 [2]),
        .I1(\fifo_mem_reg[0][14]_63 [2]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][13]_62 [2]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][12]_61 [2]),
        .O(\group_data_reg[0][2]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][3]_i_4 
       (.I0(\fifo_mem_reg[0][3]_52 [3]),
        .I1(\fifo_mem_reg[0][2]_51 [3]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][1]_50 [3]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][0]_49 [3]),
        .O(\group_data_reg[0][3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][3]_i_5 
       (.I0(\fifo_mem_reg[0][7]_56 [3]),
        .I1(\fifo_mem_reg[0][6]_55 [3]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][5]_54 [3]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][4]_53 [3]),
        .O(\group_data_reg[0][3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][3]_i_6 
       (.I0(\fifo_mem_reg[0][11]_60 [3]),
        .I1(\fifo_mem_reg[0][10]_59 [3]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][9]_58 [3]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][8]_57 [3]),
        .O(\group_data_reg[0][3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][3]_i_7 
       (.I0(\fifo_mem_reg[0][15]_64 [3]),
        .I1(\fifo_mem_reg[0][14]_63 [3]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][13]_62 [3]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][12]_61 [3]),
        .O(\group_data_reg[0][3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][4]_i_4 
       (.I0(\fifo_mem_reg[0][3]_52 [4]),
        .I1(\fifo_mem_reg[0][2]_51 [4]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][1]_50 [4]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][0]_49 [4]),
        .O(\group_data_reg[0][4]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][4]_i_5 
       (.I0(\fifo_mem_reg[0][7]_56 [4]),
        .I1(\fifo_mem_reg[0][6]_55 [4]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][5]_54 [4]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][4]_53 [4]),
        .O(\group_data_reg[0][4]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][4]_i_6 
       (.I0(\fifo_mem_reg[0][11]_60 [4]),
        .I1(\fifo_mem_reg[0][10]_59 [4]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][9]_58 [4]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][8]_57 [4]),
        .O(\group_data_reg[0][4]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][4]_i_7 
       (.I0(\fifo_mem_reg[0][15]_64 [4]),
        .I1(\fifo_mem_reg[0][14]_63 [4]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][13]_62 [4]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][12]_61 [4]),
        .O(\group_data_reg[0][4]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][5]_i_4 
       (.I0(\fifo_mem_reg[0][3]_52 [5]),
        .I1(\fifo_mem_reg[0][2]_51 [5]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][1]_50 [5]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][0]_49 [5]),
        .O(\group_data_reg[0][5]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][5]_i_5 
       (.I0(\fifo_mem_reg[0][7]_56 [5]),
        .I1(\fifo_mem_reg[0][6]_55 [5]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][5]_54 [5]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][4]_53 [5]),
        .O(\group_data_reg[0][5]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][5]_i_6 
       (.I0(\fifo_mem_reg[0][11]_60 [5]),
        .I1(\fifo_mem_reg[0][10]_59 [5]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][9]_58 [5]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][8]_57 [5]),
        .O(\group_data_reg[0][5]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][5]_i_7 
       (.I0(\fifo_mem_reg[0][15]_64 [5]),
        .I1(\fifo_mem_reg[0][14]_63 [5]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][13]_62 [5]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][12]_61 [5]),
        .O(\group_data_reg[0][5]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][6]_i_4 
       (.I0(\fifo_mem_reg[0][3]_52 [6]),
        .I1(\fifo_mem_reg[0][2]_51 [6]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][1]_50 [6]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][0]_49 [6]),
        .O(\group_data_reg[0][6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][6]_i_5 
       (.I0(\fifo_mem_reg[0][7]_56 [6]),
        .I1(\fifo_mem_reg[0][6]_55 [6]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][5]_54 [6]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][4]_53 [6]),
        .O(\group_data_reg[0][6]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][6]_i_6 
       (.I0(\fifo_mem_reg[0][11]_60 [6]),
        .I1(\fifo_mem_reg[0][10]_59 [6]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][9]_58 [6]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][8]_57 [6]),
        .O(\group_data_reg[0][6]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][6]_i_7 
       (.I0(\fifo_mem_reg[0][15]_64 [6]),
        .I1(\fifo_mem_reg[0][14]_63 [6]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][13]_62 [6]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][12]_61 [6]),
        .O(\group_data_reg[0][6]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][7]_i_4 
       (.I0(\fifo_mem_reg[0][3]_52 [7]),
        .I1(\fifo_mem_reg[0][2]_51 [7]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][1]_50 [7]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][0]_49 [7]),
        .O(\group_data_reg[0][7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][7]_i_5 
       (.I0(\fifo_mem_reg[0][7]_56 [7]),
        .I1(\fifo_mem_reg[0][6]_55 [7]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][5]_54 [7]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][4]_53 [7]),
        .O(\group_data_reg[0][7]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][7]_i_6 
       (.I0(\fifo_mem_reg[0][11]_60 [7]),
        .I1(\fifo_mem_reg[0][10]_59 [7]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][9]_58 [7]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][8]_57 [7]),
        .O(\group_data_reg[0][7]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[0][7]_i_7 
       (.I0(\fifo_mem_reg[0][15]_64 [7]),
        .I1(\fifo_mem_reg[0][14]_63 [7]),
        .I2(\rd_ptr_reg_n_0_[0][1] ),
        .I3(\fifo_mem_reg[0][13]_62 [7]),
        .I4(\rd_ptr_reg_n_0_[0][0] ),
        .I5(\fifo_mem_reg[0][12]_61 [7]),
        .O(\group_data_reg[0][7]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][0]_i_4 
       (.I0(\fifo_mem_reg[1][3]_36 [0]),
        .I1(\fifo_mem_reg[1][2]_35 [0]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][1]_34 [0]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][0]_33 [0]),
        .O(\group_data_reg[1][0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][0]_i_5 
       (.I0(\fifo_mem_reg[1][7]_40 [0]),
        .I1(\fifo_mem_reg[1][6]_39 [0]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][5]_38 [0]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][4]_37 [0]),
        .O(\group_data_reg[1][0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][0]_i_6 
       (.I0(\fifo_mem_reg[1][11]_44 [0]),
        .I1(\fifo_mem_reg[1][10]_43 [0]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][9]_42 [0]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][8]_41 [0]),
        .O(\group_data_reg[1][0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][0]_i_7 
       (.I0(\fifo_mem_reg[1][15]_48 [0]),
        .I1(\fifo_mem_reg[1][14]_47 [0]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][13]_46 [0]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][12]_45 [0]),
        .O(\group_data_reg[1][0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][1]_i_4 
       (.I0(\fifo_mem_reg[1][3]_36 [1]),
        .I1(\fifo_mem_reg[1][2]_35 [1]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][1]_34 [1]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][0]_33 [1]),
        .O(\group_data_reg[1][1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][1]_i_5 
       (.I0(\fifo_mem_reg[1][7]_40 [1]),
        .I1(\fifo_mem_reg[1][6]_39 [1]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][5]_38 [1]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][4]_37 [1]),
        .O(\group_data_reg[1][1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][1]_i_6 
       (.I0(\fifo_mem_reg[1][11]_44 [1]),
        .I1(\fifo_mem_reg[1][10]_43 [1]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][9]_42 [1]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][8]_41 [1]),
        .O(\group_data_reg[1][1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][1]_i_7 
       (.I0(\fifo_mem_reg[1][15]_48 [1]),
        .I1(\fifo_mem_reg[1][14]_47 [1]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][13]_46 [1]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][12]_45 [1]),
        .O(\group_data_reg[1][1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][2]_i_4 
       (.I0(\fifo_mem_reg[1][3]_36 [2]),
        .I1(\fifo_mem_reg[1][2]_35 [2]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][1]_34 [2]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][0]_33 [2]),
        .O(\group_data_reg[1][2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][2]_i_5 
       (.I0(\fifo_mem_reg[1][7]_40 [2]),
        .I1(\fifo_mem_reg[1][6]_39 [2]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][5]_38 [2]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][4]_37 [2]),
        .O(\group_data_reg[1][2]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][2]_i_6 
       (.I0(\fifo_mem_reg[1][11]_44 [2]),
        .I1(\fifo_mem_reg[1][10]_43 [2]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][9]_42 [2]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][8]_41 [2]),
        .O(\group_data_reg[1][2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][2]_i_7 
       (.I0(\fifo_mem_reg[1][15]_48 [2]),
        .I1(\fifo_mem_reg[1][14]_47 [2]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][13]_46 [2]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][12]_45 [2]),
        .O(\group_data_reg[1][2]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][3]_i_4 
       (.I0(\fifo_mem_reg[1][3]_36 [3]),
        .I1(\fifo_mem_reg[1][2]_35 [3]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][1]_34 [3]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][0]_33 [3]),
        .O(\group_data_reg[1][3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][3]_i_5 
       (.I0(\fifo_mem_reg[1][7]_40 [3]),
        .I1(\fifo_mem_reg[1][6]_39 [3]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][5]_38 [3]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][4]_37 [3]),
        .O(\group_data_reg[1][3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][3]_i_6 
       (.I0(\fifo_mem_reg[1][11]_44 [3]),
        .I1(\fifo_mem_reg[1][10]_43 [3]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][9]_42 [3]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][8]_41 [3]),
        .O(\group_data_reg[1][3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][3]_i_7 
       (.I0(\fifo_mem_reg[1][15]_48 [3]),
        .I1(\fifo_mem_reg[1][14]_47 [3]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][13]_46 [3]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][12]_45 [3]),
        .O(\group_data_reg[1][3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][4]_i_4 
       (.I0(\fifo_mem_reg[1][3]_36 [4]),
        .I1(\fifo_mem_reg[1][2]_35 [4]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][1]_34 [4]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][0]_33 [4]),
        .O(\group_data_reg[1][4]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][4]_i_5 
       (.I0(\fifo_mem_reg[1][7]_40 [4]),
        .I1(\fifo_mem_reg[1][6]_39 [4]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][5]_38 [4]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][4]_37 [4]),
        .O(\group_data_reg[1][4]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][4]_i_6 
       (.I0(\fifo_mem_reg[1][11]_44 [4]),
        .I1(\fifo_mem_reg[1][10]_43 [4]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][9]_42 [4]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][8]_41 [4]),
        .O(\group_data_reg[1][4]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][4]_i_7 
       (.I0(\fifo_mem_reg[1][15]_48 [4]),
        .I1(\fifo_mem_reg[1][14]_47 [4]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][13]_46 [4]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][12]_45 [4]),
        .O(\group_data_reg[1][4]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][5]_i_4 
       (.I0(\fifo_mem_reg[1][3]_36 [5]),
        .I1(\fifo_mem_reg[1][2]_35 [5]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][1]_34 [5]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][0]_33 [5]),
        .O(\group_data_reg[1][5]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][5]_i_5 
       (.I0(\fifo_mem_reg[1][7]_40 [5]),
        .I1(\fifo_mem_reg[1][6]_39 [5]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][5]_38 [5]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][4]_37 [5]),
        .O(\group_data_reg[1][5]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][5]_i_6 
       (.I0(\fifo_mem_reg[1][11]_44 [5]),
        .I1(\fifo_mem_reg[1][10]_43 [5]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][9]_42 [5]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][8]_41 [5]),
        .O(\group_data_reg[1][5]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][5]_i_7 
       (.I0(\fifo_mem_reg[1][15]_48 [5]),
        .I1(\fifo_mem_reg[1][14]_47 [5]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][13]_46 [5]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][12]_45 [5]),
        .O(\group_data_reg[1][5]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][6]_i_4 
       (.I0(\fifo_mem_reg[1][3]_36 [6]),
        .I1(\fifo_mem_reg[1][2]_35 [6]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][1]_34 [6]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][0]_33 [6]),
        .O(\group_data_reg[1][6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][6]_i_5 
       (.I0(\fifo_mem_reg[1][7]_40 [6]),
        .I1(\fifo_mem_reg[1][6]_39 [6]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][5]_38 [6]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][4]_37 [6]),
        .O(\group_data_reg[1][6]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][6]_i_6 
       (.I0(\fifo_mem_reg[1][11]_44 [6]),
        .I1(\fifo_mem_reg[1][10]_43 [6]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][9]_42 [6]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][8]_41 [6]),
        .O(\group_data_reg[1][6]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][6]_i_7 
       (.I0(\fifo_mem_reg[1][15]_48 [6]),
        .I1(\fifo_mem_reg[1][14]_47 [6]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][13]_46 [6]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][12]_45 [6]),
        .O(\group_data_reg[1][6]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][7]_i_4 
       (.I0(\fifo_mem_reg[1][3]_36 [7]),
        .I1(\fifo_mem_reg[1][2]_35 [7]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][1]_34 [7]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][0]_33 [7]),
        .O(\group_data_reg[1][7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][7]_i_5 
       (.I0(\fifo_mem_reg[1][7]_40 [7]),
        .I1(\fifo_mem_reg[1][6]_39 [7]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][5]_38 [7]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][4]_37 [7]),
        .O(\group_data_reg[1][7]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][7]_i_6 
       (.I0(\fifo_mem_reg[1][11]_44 [7]),
        .I1(\fifo_mem_reg[1][10]_43 [7]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][9]_42 [7]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][8]_41 [7]),
        .O(\group_data_reg[1][7]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[1][7]_i_7 
       (.I0(\fifo_mem_reg[1][15]_48 [7]),
        .I1(\fifo_mem_reg[1][14]_47 [7]),
        .I2(\rd_ptr_reg_n_0_[1][1] ),
        .I3(\fifo_mem_reg[1][13]_46 [7]),
        .I4(\rd_ptr_reg_n_0_[1][0] ),
        .I5(\fifo_mem_reg[1][12]_45 [7]),
        .O(\group_data_reg[1][7]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][0]_i_4 
       (.I0(\fifo_mem_reg[2][3]_20 [0]),
        .I1(\fifo_mem_reg[2][2]_19 [0]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][1]_18 [0]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][0]_17 [0]),
        .O(\group_data_reg[2][0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][0]_i_5 
       (.I0(\fifo_mem_reg[2][7]_24 [0]),
        .I1(\fifo_mem_reg[2][6]_23 [0]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][5]_22 [0]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][4]_21 [0]),
        .O(\group_data_reg[2][0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][0]_i_6 
       (.I0(\fifo_mem_reg[2][11]_28 [0]),
        .I1(\fifo_mem_reg[2][10]_27 [0]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][9]_26 [0]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][8]_25 [0]),
        .O(\group_data_reg[2][0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][0]_i_7 
       (.I0(\fifo_mem_reg[2][15]_32 [0]),
        .I1(\fifo_mem_reg[2][14]_31 [0]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][13]_30 [0]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][12]_29 [0]),
        .O(\group_data_reg[2][0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][1]_i_4 
       (.I0(\fifo_mem_reg[2][3]_20 [1]),
        .I1(\fifo_mem_reg[2][2]_19 [1]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][1]_18 [1]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][0]_17 [1]),
        .O(\group_data_reg[2][1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][1]_i_5 
       (.I0(\fifo_mem_reg[2][7]_24 [1]),
        .I1(\fifo_mem_reg[2][6]_23 [1]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][5]_22 [1]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][4]_21 [1]),
        .O(\group_data_reg[2][1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][1]_i_6 
       (.I0(\fifo_mem_reg[2][11]_28 [1]),
        .I1(\fifo_mem_reg[2][10]_27 [1]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][9]_26 [1]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][8]_25 [1]),
        .O(\group_data_reg[2][1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][1]_i_7 
       (.I0(\fifo_mem_reg[2][15]_32 [1]),
        .I1(\fifo_mem_reg[2][14]_31 [1]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][13]_30 [1]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][12]_29 [1]),
        .O(\group_data_reg[2][1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][2]_i_4 
       (.I0(\fifo_mem_reg[2][3]_20 [2]),
        .I1(\fifo_mem_reg[2][2]_19 [2]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][1]_18 [2]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][0]_17 [2]),
        .O(\group_data_reg[2][2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][2]_i_5 
       (.I0(\fifo_mem_reg[2][7]_24 [2]),
        .I1(\fifo_mem_reg[2][6]_23 [2]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][5]_22 [2]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][4]_21 [2]),
        .O(\group_data_reg[2][2]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][2]_i_6 
       (.I0(\fifo_mem_reg[2][11]_28 [2]),
        .I1(\fifo_mem_reg[2][10]_27 [2]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][9]_26 [2]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][8]_25 [2]),
        .O(\group_data_reg[2][2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][2]_i_7 
       (.I0(\fifo_mem_reg[2][15]_32 [2]),
        .I1(\fifo_mem_reg[2][14]_31 [2]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][13]_30 [2]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][12]_29 [2]),
        .O(\group_data_reg[2][2]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][3]_i_4 
       (.I0(\fifo_mem_reg[2][3]_20 [3]),
        .I1(\fifo_mem_reg[2][2]_19 [3]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][1]_18 [3]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][0]_17 [3]),
        .O(\group_data_reg[2][3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][3]_i_5 
       (.I0(\fifo_mem_reg[2][7]_24 [3]),
        .I1(\fifo_mem_reg[2][6]_23 [3]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][5]_22 [3]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][4]_21 [3]),
        .O(\group_data_reg[2][3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][3]_i_6 
       (.I0(\fifo_mem_reg[2][11]_28 [3]),
        .I1(\fifo_mem_reg[2][10]_27 [3]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][9]_26 [3]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][8]_25 [3]),
        .O(\group_data_reg[2][3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][3]_i_7 
       (.I0(\fifo_mem_reg[2][15]_32 [3]),
        .I1(\fifo_mem_reg[2][14]_31 [3]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][13]_30 [3]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][12]_29 [3]),
        .O(\group_data_reg[2][3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][4]_i_4 
       (.I0(\fifo_mem_reg[2][3]_20 [4]),
        .I1(\fifo_mem_reg[2][2]_19 [4]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][1]_18 [4]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][0]_17 [4]),
        .O(\group_data_reg[2][4]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][4]_i_5 
       (.I0(\fifo_mem_reg[2][7]_24 [4]),
        .I1(\fifo_mem_reg[2][6]_23 [4]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][5]_22 [4]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][4]_21 [4]),
        .O(\group_data_reg[2][4]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][4]_i_6 
       (.I0(\fifo_mem_reg[2][11]_28 [4]),
        .I1(\fifo_mem_reg[2][10]_27 [4]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][9]_26 [4]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][8]_25 [4]),
        .O(\group_data_reg[2][4]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][4]_i_7 
       (.I0(\fifo_mem_reg[2][15]_32 [4]),
        .I1(\fifo_mem_reg[2][14]_31 [4]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][13]_30 [4]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][12]_29 [4]),
        .O(\group_data_reg[2][4]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][5]_i_4 
       (.I0(\fifo_mem_reg[2][3]_20 [5]),
        .I1(\fifo_mem_reg[2][2]_19 [5]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][1]_18 [5]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][0]_17 [5]),
        .O(\group_data_reg[2][5]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][5]_i_5 
       (.I0(\fifo_mem_reg[2][7]_24 [5]),
        .I1(\fifo_mem_reg[2][6]_23 [5]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][5]_22 [5]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][4]_21 [5]),
        .O(\group_data_reg[2][5]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][5]_i_6 
       (.I0(\fifo_mem_reg[2][11]_28 [5]),
        .I1(\fifo_mem_reg[2][10]_27 [5]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][9]_26 [5]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][8]_25 [5]),
        .O(\group_data_reg[2][5]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][5]_i_7 
       (.I0(\fifo_mem_reg[2][15]_32 [5]),
        .I1(\fifo_mem_reg[2][14]_31 [5]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][13]_30 [5]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][12]_29 [5]),
        .O(\group_data_reg[2][5]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][6]_i_4 
       (.I0(\fifo_mem_reg[2][3]_20 [6]),
        .I1(\fifo_mem_reg[2][2]_19 [6]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][1]_18 [6]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][0]_17 [6]),
        .O(\group_data_reg[2][6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][6]_i_5 
       (.I0(\fifo_mem_reg[2][7]_24 [6]),
        .I1(\fifo_mem_reg[2][6]_23 [6]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][5]_22 [6]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][4]_21 [6]),
        .O(\group_data_reg[2][6]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][6]_i_6 
       (.I0(\fifo_mem_reg[2][11]_28 [6]),
        .I1(\fifo_mem_reg[2][10]_27 [6]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][9]_26 [6]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][8]_25 [6]),
        .O(\group_data_reg[2][6]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][6]_i_7 
       (.I0(\fifo_mem_reg[2][15]_32 [6]),
        .I1(\fifo_mem_reg[2][14]_31 [6]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][13]_30 [6]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][12]_29 [6]),
        .O(\group_data_reg[2][6]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][7]_i_4 
       (.I0(\fifo_mem_reg[2][3]_20 [7]),
        .I1(\fifo_mem_reg[2][2]_19 [7]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][1]_18 [7]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][0]_17 [7]),
        .O(\group_data_reg[2][7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][7]_i_5 
       (.I0(\fifo_mem_reg[2][7]_24 [7]),
        .I1(\fifo_mem_reg[2][6]_23 [7]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][5]_22 [7]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][4]_21 [7]),
        .O(\group_data_reg[2][7]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][7]_i_6 
       (.I0(\fifo_mem_reg[2][11]_28 [7]),
        .I1(\fifo_mem_reg[2][10]_27 [7]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][9]_26 [7]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][8]_25 [7]),
        .O(\group_data_reg[2][7]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[2][7]_i_7 
       (.I0(\fifo_mem_reg[2][15]_32 [7]),
        .I1(\fifo_mem_reg[2][14]_31 [7]),
        .I2(\rd_ptr_reg_n_0_[2][1] ),
        .I3(\fifo_mem_reg[2][13]_30 [7]),
        .I4(\rd_ptr_reg_n_0_[2][0] ),
        .I5(\fifo_mem_reg[2][12]_29 [7]),
        .O(\group_data_reg[2][7]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][0]_i_4 
       (.I0(\fifo_mem_reg[3][3]_4 [0]),
        .I1(\fifo_mem_reg[3][2]_3 [0]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][1]_2 [0]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][0]_1 [0]),
        .O(\group_data_reg[3][0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][0]_i_5 
       (.I0(\fifo_mem_reg[3][7]_8 [0]),
        .I1(\fifo_mem_reg[3][6]_7 [0]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][5]_6 [0]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][4]_5 [0]),
        .O(\group_data_reg[3][0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][0]_i_6 
       (.I0(\fifo_mem_reg[3][11]_12 [0]),
        .I1(\fifo_mem_reg[3][10]_11 [0]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][9]_10 [0]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][8]_9 [0]),
        .O(\group_data_reg[3][0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][0]_i_7 
       (.I0(\fifo_mem_reg[3][15]_16 [0]),
        .I1(\fifo_mem_reg[3][14]_15 [0]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][13]_14 [0]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][12]_13 [0]),
        .O(\group_data_reg[3][0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][1]_i_4 
       (.I0(\fifo_mem_reg[3][3]_4 [1]),
        .I1(\fifo_mem_reg[3][2]_3 [1]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][1]_2 [1]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][0]_1 [1]),
        .O(\group_data_reg[3][1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][1]_i_5 
       (.I0(\fifo_mem_reg[3][7]_8 [1]),
        .I1(\fifo_mem_reg[3][6]_7 [1]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][5]_6 [1]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][4]_5 [1]),
        .O(\group_data_reg[3][1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][1]_i_6 
       (.I0(\fifo_mem_reg[3][11]_12 [1]),
        .I1(\fifo_mem_reg[3][10]_11 [1]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][9]_10 [1]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][8]_9 [1]),
        .O(\group_data_reg[3][1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][1]_i_7 
       (.I0(\fifo_mem_reg[3][15]_16 [1]),
        .I1(\fifo_mem_reg[3][14]_15 [1]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][13]_14 [1]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][12]_13 [1]),
        .O(\group_data_reg[3][1]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][2]_i_4 
       (.I0(\fifo_mem_reg[3][3]_4 [2]),
        .I1(\fifo_mem_reg[3][2]_3 [2]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][1]_2 [2]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][0]_1 [2]),
        .O(\group_data_reg[3][2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][2]_i_5 
       (.I0(\fifo_mem_reg[3][7]_8 [2]),
        .I1(\fifo_mem_reg[3][6]_7 [2]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][5]_6 [2]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][4]_5 [2]),
        .O(\group_data_reg[3][2]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][2]_i_6 
       (.I0(\fifo_mem_reg[3][11]_12 [2]),
        .I1(\fifo_mem_reg[3][10]_11 [2]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][9]_10 [2]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][8]_9 [2]),
        .O(\group_data_reg[3][2]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][2]_i_7 
       (.I0(\fifo_mem_reg[3][15]_16 [2]),
        .I1(\fifo_mem_reg[3][14]_15 [2]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][13]_14 [2]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][12]_13 [2]),
        .O(\group_data_reg[3][2]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][3]_i_4 
       (.I0(\fifo_mem_reg[3][3]_4 [3]),
        .I1(\fifo_mem_reg[3][2]_3 [3]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][1]_2 [3]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][0]_1 [3]),
        .O(\group_data_reg[3][3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][3]_i_5 
       (.I0(\fifo_mem_reg[3][7]_8 [3]),
        .I1(\fifo_mem_reg[3][6]_7 [3]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][5]_6 [3]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][4]_5 [3]),
        .O(\group_data_reg[3][3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][3]_i_6 
       (.I0(\fifo_mem_reg[3][11]_12 [3]),
        .I1(\fifo_mem_reg[3][10]_11 [3]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][9]_10 [3]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][8]_9 [3]),
        .O(\group_data_reg[3][3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][3]_i_7 
       (.I0(\fifo_mem_reg[3][15]_16 [3]),
        .I1(\fifo_mem_reg[3][14]_15 [3]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][13]_14 [3]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][12]_13 [3]),
        .O(\group_data_reg[3][3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][4]_i_4 
       (.I0(\fifo_mem_reg[3][3]_4 [4]),
        .I1(\fifo_mem_reg[3][2]_3 [4]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][1]_2 [4]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][0]_1 [4]),
        .O(\group_data_reg[3][4]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][4]_i_5 
       (.I0(\fifo_mem_reg[3][7]_8 [4]),
        .I1(\fifo_mem_reg[3][6]_7 [4]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][5]_6 [4]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][4]_5 [4]),
        .O(\group_data_reg[3][4]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][4]_i_6 
       (.I0(\fifo_mem_reg[3][11]_12 [4]),
        .I1(\fifo_mem_reg[3][10]_11 [4]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][9]_10 [4]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][8]_9 [4]),
        .O(\group_data_reg[3][4]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][4]_i_7 
       (.I0(\fifo_mem_reg[3][15]_16 [4]),
        .I1(\fifo_mem_reg[3][14]_15 [4]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][13]_14 [4]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][12]_13 [4]),
        .O(\group_data_reg[3][4]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][5]_i_4 
       (.I0(\fifo_mem_reg[3][3]_4 [5]),
        .I1(\fifo_mem_reg[3][2]_3 [5]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][1]_2 [5]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][0]_1 [5]),
        .O(\group_data_reg[3][5]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][5]_i_5 
       (.I0(\fifo_mem_reg[3][7]_8 [5]),
        .I1(\fifo_mem_reg[3][6]_7 [5]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][5]_6 [5]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][4]_5 [5]),
        .O(\group_data_reg[3][5]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][5]_i_6 
       (.I0(\fifo_mem_reg[3][11]_12 [5]),
        .I1(\fifo_mem_reg[3][10]_11 [5]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][9]_10 [5]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][8]_9 [5]),
        .O(\group_data_reg[3][5]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][5]_i_7 
       (.I0(\fifo_mem_reg[3][15]_16 [5]),
        .I1(\fifo_mem_reg[3][14]_15 [5]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][13]_14 [5]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][12]_13 [5]),
        .O(\group_data_reg[3][5]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][6]_i_4 
       (.I0(\fifo_mem_reg[3][3]_4 [6]),
        .I1(\fifo_mem_reg[3][2]_3 [6]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][1]_2 [6]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][0]_1 [6]),
        .O(\group_data_reg[3][6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][6]_i_5 
       (.I0(\fifo_mem_reg[3][7]_8 [6]),
        .I1(\fifo_mem_reg[3][6]_7 [6]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][5]_6 [6]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][4]_5 [6]),
        .O(\group_data_reg[3][6]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][6]_i_6 
       (.I0(\fifo_mem_reg[3][11]_12 [6]),
        .I1(\fifo_mem_reg[3][10]_11 [6]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][9]_10 [6]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][8]_9 [6]),
        .O(\group_data_reg[3][6]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][6]_i_7 
       (.I0(\fifo_mem_reg[3][15]_16 [6]),
        .I1(\fifo_mem_reg[3][14]_15 [6]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][13]_14 [6]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][12]_13 [6]),
        .O(\group_data_reg[3][6]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][7]_i_4 
       (.I0(\fifo_mem_reg[3][3]_4 [7]),
        .I1(\fifo_mem_reg[3][2]_3 [7]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][1]_2 [7]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][0]_1 [7]),
        .O(\group_data_reg[3][7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][7]_i_5 
       (.I0(\fifo_mem_reg[3][7]_8 [7]),
        .I1(\fifo_mem_reg[3][6]_7 [7]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][5]_6 [7]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][4]_5 [7]),
        .O(\group_data_reg[3][7]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][7]_i_6 
       (.I0(\fifo_mem_reg[3][11]_12 [7]),
        .I1(\fifo_mem_reg[3][10]_11 [7]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][9]_10 [7]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][8]_9 [7]),
        .O(\group_data_reg[3][7]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \group_data_reg[3][7]_i_7 
       (.I0(\fifo_mem_reg[3][15]_16 [7]),
        .I1(\fifo_mem_reg[3][14]_15 [7]),
        .I2(\rd_ptr_reg_n_0_[3][1] ),
        .I3(\fifo_mem_reg[3][13]_14 [7]),
        .I4(\rd_ptr_reg_n_0_[3][0] ),
        .I5(\fifo_mem_reg[3][12]_13 [7]),
        .O(\group_data_reg[3][7]_i_7_n_0 ));
  MUXF8 \group_data_reg_reg[0][0]_i_1 
       (.I0(\group_data_reg_reg[0][0]_i_2_n_0 ),
        .I1(\group_data_reg_reg[0][0]_i_3_n_0 ),
        .O(\lane_group_data_i[0] [0]),
        .S(\rd_ptr_reg_n_0_[0][3] ));
  MUXF7 \group_data_reg_reg[0][0]_i_2 
       (.I0(\group_data_reg[0][0]_i_4_n_0 ),
        .I1(\group_data_reg[0][0]_i_5_n_0 ),
        .O(\group_data_reg_reg[0][0]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF7 \group_data_reg_reg[0][0]_i_3 
       (.I0(\group_data_reg[0][0]_i_6_n_0 ),
        .I1(\group_data_reg[0][0]_i_7_n_0 ),
        .O(\group_data_reg_reg[0][0]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF8 \group_data_reg_reg[0][1]_i_1 
       (.I0(\group_data_reg_reg[0][1]_i_2_n_0 ),
        .I1(\group_data_reg_reg[0][1]_i_3_n_0 ),
        .O(\lane_group_data_i[0] [1]),
        .S(\rd_ptr_reg_n_0_[0][3] ));
  MUXF7 \group_data_reg_reg[0][1]_i_2 
       (.I0(\group_data_reg[0][1]_i_4_n_0 ),
        .I1(\group_data_reg[0][1]_i_5_n_0 ),
        .O(\group_data_reg_reg[0][1]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF7 \group_data_reg_reg[0][1]_i_3 
       (.I0(\group_data_reg[0][1]_i_6_n_0 ),
        .I1(\group_data_reg[0][1]_i_7_n_0 ),
        .O(\group_data_reg_reg[0][1]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF8 \group_data_reg_reg[0][2]_i_1 
       (.I0(\group_data_reg_reg[0][2]_i_2_n_0 ),
        .I1(\group_data_reg_reg[0][2]_i_3_n_0 ),
        .O(\lane_group_data_i[0] [2]),
        .S(\rd_ptr_reg_n_0_[0][3] ));
  MUXF7 \group_data_reg_reg[0][2]_i_2 
       (.I0(\group_data_reg[0][2]_i_4_n_0 ),
        .I1(\group_data_reg[0][2]_i_5_n_0 ),
        .O(\group_data_reg_reg[0][2]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF7 \group_data_reg_reg[0][2]_i_3 
       (.I0(\group_data_reg[0][2]_i_6_n_0 ),
        .I1(\group_data_reg[0][2]_i_7_n_0 ),
        .O(\group_data_reg_reg[0][2]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF8 \group_data_reg_reg[0][3]_i_1 
       (.I0(\group_data_reg_reg[0][3]_i_2_n_0 ),
        .I1(\group_data_reg_reg[0][3]_i_3_n_0 ),
        .O(\lane_group_data_i[0] [3]),
        .S(\rd_ptr_reg_n_0_[0][3] ));
  MUXF7 \group_data_reg_reg[0][3]_i_2 
       (.I0(\group_data_reg[0][3]_i_4_n_0 ),
        .I1(\group_data_reg[0][3]_i_5_n_0 ),
        .O(\group_data_reg_reg[0][3]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF7 \group_data_reg_reg[0][3]_i_3 
       (.I0(\group_data_reg[0][3]_i_6_n_0 ),
        .I1(\group_data_reg[0][3]_i_7_n_0 ),
        .O(\group_data_reg_reg[0][3]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF8 \group_data_reg_reg[0][4]_i_1 
       (.I0(\group_data_reg_reg[0][4]_i_2_n_0 ),
        .I1(\group_data_reg_reg[0][4]_i_3_n_0 ),
        .O(\lane_group_data_i[0] [4]),
        .S(\rd_ptr_reg_n_0_[0][3] ));
  MUXF7 \group_data_reg_reg[0][4]_i_2 
       (.I0(\group_data_reg[0][4]_i_4_n_0 ),
        .I1(\group_data_reg[0][4]_i_5_n_0 ),
        .O(\group_data_reg_reg[0][4]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF7 \group_data_reg_reg[0][4]_i_3 
       (.I0(\group_data_reg[0][4]_i_6_n_0 ),
        .I1(\group_data_reg[0][4]_i_7_n_0 ),
        .O(\group_data_reg_reg[0][4]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF8 \group_data_reg_reg[0][5]_i_1 
       (.I0(\group_data_reg_reg[0][5]_i_2_n_0 ),
        .I1(\group_data_reg_reg[0][5]_i_3_n_0 ),
        .O(\lane_group_data_i[0] [5]),
        .S(\rd_ptr_reg_n_0_[0][3] ));
  MUXF7 \group_data_reg_reg[0][5]_i_2 
       (.I0(\group_data_reg[0][5]_i_4_n_0 ),
        .I1(\group_data_reg[0][5]_i_5_n_0 ),
        .O(\group_data_reg_reg[0][5]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF7 \group_data_reg_reg[0][5]_i_3 
       (.I0(\group_data_reg[0][5]_i_6_n_0 ),
        .I1(\group_data_reg[0][5]_i_7_n_0 ),
        .O(\group_data_reg_reg[0][5]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF8 \group_data_reg_reg[0][6]_i_1 
       (.I0(\group_data_reg_reg[0][6]_i_2_n_0 ),
        .I1(\group_data_reg_reg[0][6]_i_3_n_0 ),
        .O(\lane_group_data_i[0] [6]),
        .S(\rd_ptr_reg_n_0_[0][3] ));
  MUXF7 \group_data_reg_reg[0][6]_i_2 
       (.I0(\group_data_reg[0][6]_i_4_n_0 ),
        .I1(\group_data_reg[0][6]_i_5_n_0 ),
        .O(\group_data_reg_reg[0][6]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF7 \group_data_reg_reg[0][6]_i_3 
       (.I0(\group_data_reg[0][6]_i_6_n_0 ),
        .I1(\group_data_reg[0][6]_i_7_n_0 ),
        .O(\group_data_reg_reg[0][6]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF8 \group_data_reg_reg[0][7]_i_1 
       (.I0(\group_data_reg_reg[0][7]_i_2_n_0 ),
        .I1(\group_data_reg_reg[0][7]_i_3_n_0 ),
        .O(\lane_group_data_i[0] [7]),
        .S(\rd_ptr_reg_n_0_[0][3] ));
  MUXF7 \group_data_reg_reg[0][7]_i_2 
       (.I0(\group_data_reg[0][7]_i_4_n_0 ),
        .I1(\group_data_reg[0][7]_i_5_n_0 ),
        .O(\group_data_reg_reg[0][7]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF7 \group_data_reg_reg[0][7]_i_3 
       (.I0(\group_data_reg[0][7]_i_6_n_0 ),
        .I1(\group_data_reg[0][7]_i_7_n_0 ),
        .O(\group_data_reg_reg[0][7]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[0][2] ));
  MUXF8 \group_data_reg_reg[1][0]_i_1 
       (.I0(\group_data_reg_reg[1][0]_i_2_n_0 ),
        .I1(\group_data_reg_reg[1][0]_i_3_n_0 ),
        .O(\lane_group_data_i[1] [0]),
        .S(\rd_ptr_reg_n_0_[1][3] ));
  MUXF7 \group_data_reg_reg[1][0]_i_2 
       (.I0(\group_data_reg[1][0]_i_4_n_0 ),
        .I1(\group_data_reg[1][0]_i_5_n_0 ),
        .O(\group_data_reg_reg[1][0]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF7 \group_data_reg_reg[1][0]_i_3 
       (.I0(\group_data_reg[1][0]_i_6_n_0 ),
        .I1(\group_data_reg[1][0]_i_7_n_0 ),
        .O(\group_data_reg_reg[1][0]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF8 \group_data_reg_reg[1][1]_i_1 
       (.I0(\group_data_reg_reg[1][1]_i_2_n_0 ),
        .I1(\group_data_reg_reg[1][1]_i_3_n_0 ),
        .O(\lane_group_data_i[1] [1]),
        .S(\rd_ptr_reg_n_0_[1][3] ));
  MUXF7 \group_data_reg_reg[1][1]_i_2 
       (.I0(\group_data_reg[1][1]_i_4_n_0 ),
        .I1(\group_data_reg[1][1]_i_5_n_0 ),
        .O(\group_data_reg_reg[1][1]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF7 \group_data_reg_reg[1][1]_i_3 
       (.I0(\group_data_reg[1][1]_i_6_n_0 ),
        .I1(\group_data_reg[1][1]_i_7_n_0 ),
        .O(\group_data_reg_reg[1][1]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF8 \group_data_reg_reg[1][2]_i_1 
       (.I0(\group_data_reg_reg[1][2]_i_2_n_0 ),
        .I1(\group_data_reg_reg[1][2]_i_3_n_0 ),
        .O(\lane_group_data_i[1] [2]),
        .S(\rd_ptr_reg_n_0_[1][3] ));
  MUXF7 \group_data_reg_reg[1][2]_i_2 
       (.I0(\group_data_reg[1][2]_i_4_n_0 ),
        .I1(\group_data_reg[1][2]_i_5_n_0 ),
        .O(\group_data_reg_reg[1][2]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF7 \group_data_reg_reg[1][2]_i_3 
       (.I0(\group_data_reg[1][2]_i_6_n_0 ),
        .I1(\group_data_reg[1][2]_i_7_n_0 ),
        .O(\group_data_reg_reg[1][2]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF8 \group_data_reg_reg[1][3]_i_1 
       (.I0(\group_data_reg_reg[1][3]_i_2_n_0 ),
        .I1(\group_data_reg_reg[1][3]_i_3_n_0 ),
        .O(\lane_group_data_i[1] [3]),
        .S(\rd_ptr_reg_n_0_[1][3] ));
  MUXF7 \group_data_reg_reg[1][3]_i_2 
       (.I0(\group_data_reg[1][3]_i_4_n_0 ),
        .I1(\group_data_reg[1][3]_i_5_n_0 ),
        .O(\group_data_reg_reg[1][3]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF7 \group_data_reg_reg[1][3]_i_3 
       (.I0(\group_data_reg[1][3]_i_6_n_0 ),
        .I1(\group_data_reg[1][3]_i_7_n_0 ),
        .O(\group_data_reg_reg[1][3]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF8 \group_data_reg_reg[1][4]_i_1 
       (.I0(\group_data_reg_reg[1][4]_i_2_n_0 ),
        .I1(\group_data_reg_reg[1][4]_i_3_n_0 ),
        .O(\lane_group_data_i[1] [4]),
        .S(\rd_ptr_reg_n_0_[1][3] ));
  MUXF7 \group_data_reg_reg[1][4]_i_2 
       (.I0(\group_data_reg[1][4]_i_4_n_0 ),
        .I1(\group_data_reg[1][4]_i_5_n_0 ),
        .O(\group_data_reg_reg[1][4]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF7 \group_data_reg_reg[1][4]_i_3 
       (.I0(\group_data_reg[1][4]_i_6_n_0 ),
        .I1(\group_data_reg[1][4]_i_7_n_0 ),
        .O(\group_data_reg_reg[1][4]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF8 \group_data_reg_reg[1][5]_i_1 
       (.I0(\group_data_reg_reg[1][5]_i_2_n_0 ),
        .I1(\group_data_reg_reg[1][5]_i_3_n_0 ),
        .O(\lane_group_data_i[1] [5]),
        .S(\rd_ptr_reg_n_0_[1][3] ));
  MUXF7 \group_data_reg_reg[1][5]_i_2 
       (.I0(\group_data_reg[1][5]_i_4_n_0 ),
        .I1(\group_data_reg[1][5]_i_5_n_0 ),
        .O(\group_data_reg_reg[1][5]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF7 \group_data_reg_reg[1][5]_i_3 
       (.I0(\group_data_reg[1][5]_i_6_n_0 ),
        .I1(\group_data_reg[1][5]_i_7_n_0 ),
        .O(\group_data_reg_reg[1][5]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF8 \group_data_reg_reg[1][6]_i_1 
       (.I0(\group_data_reg_reg[1][6]_i_2_n_0 ),
        .I1(\group_data_reg_reg[1][6]_i_3_n_0 ),
        .O(\lane_group_data_i[1] [6]),
        .S(\rd_ptr_reg_n_0_[1][3] ));
  MUXF7 \group_data_reg_reg[1][6]_i_2 
       (.I0(\group_data_reg[1][6]_i_4_n_0 ),
        .I1(\group_data_reg[1][6]_i_5_n_0 ),
        .O(\group_data_reg_reg[1][6]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF7 \group_data_reg_reg[1][6]_i_3 
       (.I0(\group_data_reg[1][6]_i_6_n_0 ),
        .I1(\group_data_reg[1][6]_i_7_n_0 ),
        .O(\group_data_reg_reg[1][6]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF8 \group_data_reg_reg[1][7]_i_1 
       (.I0(\group_data_reg_reg[1][7]_i_2_n_0 ),
        .I1(\group_data_reg_reg[1][7]_i_3_n_0 ),
        .O(\lane_group_data_i[1] [7]),
        .S(\rd_ptr_reg_n_0_[1][3] ));
  MUXF7 \group_data_reg_reg[1][7]_i_2 
       (.I0(\group_data_reg[1][7]_i_4_n_0 ),
        .I1(\group_data_reg[1][7]_i_5_n_0 ),
        .O(\group_data_reg_reg[1][7]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF7 \group_data_reg_reg[1][7]_i_3 
       (.I0(\group_data_reg[1][7]_i_6_n_0 ),
        .I1(\group_data_reg[1][7]_i_7_n_0 ),
        .O(\group_data_reg_reg[1][7]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[1][2] ));
  MUXF8 \group_data_reg_reg[2][0]_i_1 
       (.I0(\group_data_reg_reg[2][0]_i_2_n_0 ),
        .I1(\group_data_reg_reg[2][0]_i_3_n_0 ),
        .O(\lane_group_data_i[2] [0]),
        .S(\rd_ptr_reg_n_0_[2][3] ));
  MUXF7 \group_data_reg_reg[2][0]_i_2 
       (.I0(\group_data_reg[2][0]_i_4_n_0 ),
        .I1(\group_data_reg[2][0]_i_5_n_0 ),
        .O(\group_data_reg_reg[2][0]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF7 \group_data_reg_reg[2][0]_i_3 
       (.I0(\group_data_reg[2][0]_i_6_n_0 ),
        .I1(\group_data_reg[2][0]_i_7_n_0 ),
        .O(\group_data_reg_reg[2][0]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF8 \group_data_reg_reg[2][1]_i_1 
       (.I0(\group_data_reg_reg[2][1]_i_2_n_0 ),
        .I1(\group_data_reg_reg[2][1]_i_3_n_0 ),
        .O(\lane_group_data_i[2] [1]),
        .S(\rd_ptr_reg_n_0_[2][3] ));
  MUXF7 \group_data_reg_reg[2][1]_i_2 
       (.I0(\group_data_reg[2][1]_i_4_n_0 ),
        .I1(\group_data_reg[2][1]_i_5_n_0 ),
        .O(\group_data_reg_reg[2][1]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF7 \group_data_reg_reg[2][1]_i_3 
       (.I0(\group_data_reg[2][1]_i_6_n_0 ),
        .I1(\group_data_reg[2][1]_i_7_n_0 ),
        .O(\group_data_reg_reg[2][1]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF8 \group_data_reg_reg[2][2]_i_1 
       (.I0(\group_data_reg_reg[2][2]_i_2_n_0 ),
        .I1(\group_data_reg_reg[2][2]_i_3_n_0 ),
        .O(\lane_group_data_i[2] [2]),
        .S(\rd_ptr_reg_n_0_[2][3] ));
  MUXF7 \group_data_reg_reg[2][2]_i_2 
       (.I0(\group_data_reg[2][2]_i_4_n_0 ),
        .I1(\group_data_reg[2][2]_i_5_n_0 ),
        .O(\group_data_reg_reg[2][2]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF7 \group_data_reg_reg[2][2]_i_3 
       (.I0(\group_data_reg[2][2]_i_6_n_0 ),
        .I1(\group_data_reg[2][2]_i_7_n_0 ),
        .O(\group_data_reg_reg[2][2]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF8 \group_data_reg_reg[2][3]_i_1 
       (.I0(\group_data_reg_reg[2][3]_i_2_n_0 ),
        .I1(\group_data_reg_reg[2][3]_i_3_n_0 ),
        .O(\lane_group_data_i[2] [3]),
        .S(\rd_ptr_reg_n_0_[2][3] ));
  MUXF7 \group_data_reg_reg[2][3]_i_2 
       (.I0(\group_data_reg[2][3]_i_4_n_0 ),
        .I1(\group_data_reg[2][3]_i_5_n_0 ),
        .O(\group_data_reg_reg[2][3]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF7 \group_data_reg_reg[2][3]_i_3 
       (.I0(\group_data_reg[2][3]_i_6_n_0 ),
        .I1(\group_data_reg[2][3]_i_7_n_0 ),
        .O(\group_data_reg_reg[2][3]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF8 \group_data_reg_reg[2][4]_i_1 
       (.I0(\group_data_reg_reg[2][4]_i_2_n_0 ),
        .I1(\group_data_reg_reg[2][4]_i_3_n_0 ),
        .O(\lane_group_data_i[2] [4]),
        .S(\rd_ptr_reg_n_0_[2][3] ));
  MUXF7 \group_data_reg_reg[2][4]_i_2 
       (.I0(\group_data_reg[2][4]_i_4_n_0 ),
        .I1(\group_data_reg[2][4]_i_5_n_0 ),
        .O(\group_data_reg_reg[2][4]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF7 \group_data_reg_reg[2][4]_i_3 
       (.I0(\group_data_reg[2][4]_i_6_n_0 ),
        .I1(\group_data_reg[2][4]_i_7_n_0 ),
        .O(\group_data_reg_reg[2][4]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF8 \group_data_reg_reg[2][5]_i_1 
       (.I0(\group_data_reg_reg[2][5]_i_2_n_0 ),
        .I1(\group_data_reg_reg[2][5]_i_3_n_0 ),
        .O(\lane_group_data_i[2] [5]),
        .S(\rd_ptr_reg_n_0_[2][3] ));
  MUXF7 \group_data_reg_reg[2][5]_i_2 
       (.I0(\group_data_reg[2][5]_i_4_n_0 ),
        .I1(\group_data_reg[2][5]_i_5_n_0 ),
        .O(\group_data_reg_reg[2][5]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF7 \group_data_reg_reg[2][5]_i_3 
       (.I0(\group_data_reg[2][5]_i_6_n_0 ),
        .I1(\group_data_reg[2][5]_i_7_n_0 ),
        .O(\group_data_reg_reg[2][5]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF8 \group_data_reg_reg[2][6]_i_1 
       (.I0(\group_data_reg_reg[2][6]_i_2_n_0 ),
        .I1(\group_data_reg_reg[2][6]_i_3_n_0 ),
        .O(\lane_group_data_i[2] [6]),
        .S(\rd_ptr_reg_n_0_[2][3] ));
  MUXF7 \group_data_reg_reg[2][6]_i_2 
       (.I0(\group_data_reg[2][6]_i_4_n_0 ),
        .I1(\group_data_reg[2][6]_i_5_n_0 ),
        .O(\group_data_reg_reg[2][6]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF7 \group_data_reg_reg[2][6]_i_3 
       (.I0(\group_data_reg[2][6]_i_6_n_0 ),
        .I1(\group_data_reg[2][6]_i_7_n_0 ),
        .O(\group_data_reg_reg[2][6]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF8 \group_data_reg_reg[2][7]_i_1 
       (.I0(\group_data_reg_reg[2][7]_i_2_n_0 ),
        .I1(\group_data_reg_reg[2][7]_i_3_n_0 ),
        .O(\lane_group_data_i[2] [7]),
        .S(\rd_ptr_reg_n_0_[2][3] ));
  MUXF7 \group_data_reg_reg[2][7]_i_2 
       (.I0(\group_data_reg[2][7]_i_4_n_0 ),
        .I1(\group_data_reg[2][7]_i_5_n_0 ),
        .O(\group_data_reg_reg[2][7]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF7 \group_data_reg_reg[2][7]_i_3 
       (.I0(\group_data_reg[2][7]_i_6_n_0 ),
        .I1(\group_data_reg[2][7]_i_7_n_0 ),
        .O(\group_data_reg_reg[2][7]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[2][2] ));
  MUXF8 \group_data_reg_reg[3][0]_i_1 
       (.I0(\group_data_reg_reg[3][0]_i_2_n_0 ),
        .I1(\group_data_reg_reg[3][0]_i_3_n_0 ),
        .O(\lane_group_data_i[3] [0]),
        .S(\rd_ptr_reg_n_0_[3][3] ));
  MUXF7 \group_data_reg_reg[3][0]_i_2 
       (.I0(\group_data_reg[3][0]_i_4_n_0 ),
        .I1(\group_data_reg[3][0]_i_5_n_0 ),
        .O(\group_data_reg_reg[3][0]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF7 \group_data_reg_reg[3][0]_i_3 
       (.I0(\group_data_reg[3][0]_i_6_n_0 ),
        .I1(\group_data_reg[3][0]_i_7_n_0 ),
        .O(\group_data_reg_reg[3][0]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF8 \group_data_reg_reg[3][1]_i_1 
       (.I0(\group_data_reg_reg[3][1]_i_2_n_0 ),
        .I1(\group_data_reg_reg[3][1]_i_3_n_0 ),
        .O(\lane_group_data_i[3] [1]),
        .S(\rd_ptr_reg_n_0_[3][3] ));
  MUXF7 \group_data_reg_reg[3][1]_i_2 
       (.I0(\group_data_reg[3][1]_i_4_n_0 ),
        .I1(\group_data_reg[3][1]_i_5_n_0 ),
        .O(\group_data_reg_reg[3][1]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF7 \group_data_reg_reg[3][1]_i_3 
       (.I0(\group_data_reg[3][1]_i_6_n_0 ),
        .I1(\group_data_reg[3][1]_i_7_n_0 ),
        .O(\group_data_reg_reg[3][1]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF8 \group_data_reg_reg[3][2]_i_1 
       (.I0(\group_data_reg_reg[3][2]_i_2_n_0 ),
        .I1(\group_data_reg_reg[3][2]_i_3_n_0 ),
        .O(\lane_group_data_i[3] [2]),
        .S(\rd_ptr_reg_n_0_[3][3] ));
  MUXF7 \group_data_reg_reg[3][2]_i_2 
       (.I0(\group_data_reg[3][2]_i_4_n_0 ),
        .I1(\group_data_reg[3][2]_i_5_n_0 ),
        .O(\group_data_reg_reg[3][2]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF7 \group_data_reg_reg[3][2]_i_3 
       (.I0(\group_data_reg[3][2]_i_6_n_0 ),
        .I1(\group_data_reg[3][2]_i_7_n_0 ),
        .O(\group_data_reg_reg[3][2]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF8 \group_data_reg_reg[3][3]_i_1 
       (.I0(\group_data_reg_reg[3][3]_i_2_n_0 ),
        .I1(\group_data_reg_reg[3][3]_i_3_n_0 ),
        .O(\lane_group_data_i[3] [3]),
        .S(\rd_ptr_reg_n_0_[3][3] ));
  MUXF7 \group_data_reg_reg[3][3]_i_2 
       (.I0(\group_data_reg[3][3]_i_4_n_0 ),
        .I1(\group_data_reg[3][3]_i_5_n_0 ),
        .O(\group_data_reg_reg[3][3]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF7 \group_data_reg_reg[3][3]_i_3 
       (.I0(\group_data_reg[3][3]_i_6_n_0 ),
        .I1(\group_data_reg[3][3]_i_7_n_0 ),
        .O(\group_data_reg_reg[3][3]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF8 \group_data_reg_reg[3][4]_i_1 
       (.I0(\group_data_reg_reg[3][4]_i_2_n_0 ),
        .I1(\group_data_reg_reg[3][4]_i_3_n_0 ),
        .O(\lane_group_data_i[3] [4]),
        .S(\rd_ptr_reg_n_0_[3][3] ));
  MUXF7 \group_data_reg_reg[3][4]_i_2 
       (.I0(\group_data_reg[3][4]_i_4_n_0 ),
        .I1(\group_data_reg[3][4]_i_5_n_0 ),
        .O(\group_data_reg_reg[3][4]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF7 \group_data_reg_reg[3][4]_i_3 
       (.I0(\group_data_reg[3][4]_i_6_n_0 ),
        .I1(\group_data_reg[3][4]_i_7_n_0 ),
        .O(\group_data_reg_reg[3][4]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF8 \group_data_reg_reg[3][5]_i_1 
       (.I0(\group_data_reg_reg[3][5]_i_2_n_0 ),
        .I1(\group_data_reg_reg[3][5]_i_3_n_0 ),
        .O(\lane_group_data_i[3] [5]),
        .S(\rd_ptr_reg_n_0_[3][3] ));
  MUXF7 \group_data_reg_reg[3][5]_i_2 
       (.I0(\group_data_reg[3][5]_i_4_n_0 ),
        .I1(\group_data_reg[3][5]_i_5_n_0 ),
        .O(\group_data_reg_reg[3][5]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF7 \group_data_reg_reg[3][5]_i_3 
       (.I0(\group_data_reg[3][5]_i_6_n_0 ),
        .I1(\group_data_reg[3][5]_i_7_n_0 ),
        .O(\group_data_reg_reg[3][5]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF8 \group_data_reg_reg[3][6]_i_1 
       (.I0(\group_data_reg_reg[3][6]_i_2_n_0 ),
        .I1(\group_data_reg_reg[3][6]_i_3_n_0 ),
        .O(\lane_group_data_i[3] [6]),
        .S(\rd_ptr_reg_n_0_[3][3] ));
  MUXF7 \group_data_reg_reg[3][6]_i_2 
       (.I0(\group_data_reg[3][6]_i_4_n_0 ),
        .I1(\group_data_reg[3][6]_i_5_n_0 ),
        .O(\group_data_reg_reg[3][6]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF7 \group_data_reg_reg[3][6]_i_3 
       (.I0(\group_data_reg[3][6]_i_6_n_0 ),
        .I1(\group_data_reg[3][6]_i_7_n_0 ),
        .O(\group_data_reg_reg[3][6]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF8 \group_data_reg_reg[3][7]_i_1 
       (.I0(\group_data_reg_reg[3][7]_i_2_n_0 ),
        .I1(\group_data_reg_reg[3][7]_i_3_n_0 ),
        .O(\lane_group_data_i[3] [7]),
        .S(\rd_ptr_reg_n_0_[3][3] ));
  MUXF7 \group_data_reg_reg[3][7]_i_2 
       (.I0(\group_data_reg[3][7]_i_4_n_0 ),
        .I1(\group_data_reg[3][7]_i_5_n_0 ),
        .O(\group_data_reg_reg[3][7]_i_2_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  MUXF7 \group_data_reg_reg[3][7]_i_3 
       (.I0(\group_data_reg[3][7]_i_6_n_0 ),
        .I1(\group_data_reg[3][7]_i_7_n_0 ),
        .O(\group_data_reg_reg[3][7]_i_3_n_0 ),
        .S(\rd_ptr_reg_n_0_[3][2] ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \lane_cnt[0][0]_i_1 
       (.I0(\lane_cnt_reg[0]_65 [0]),
        .O(lane_cnt[0]));
  LUT3 #(
    .INIT(8'h69)) 
    \lane_cnt[0][1]_i_1 
       (.I0(\lane_cnt_reg[0]_65 [0]),
        .I1(\wr_ptr[0][3]_i_1_n_0 ),
        .I2(\lane_cnt_reg[0]_65 [1]),
        .O(\lane_cnt[0][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT4 #(
    .INIT(16'h78E1)) 
    \lane_cnt[0][2]_i_1 
       (.I0(\lane_cnt_reg[0]_65 [0]),
        .I1(\wr_ptr[0][3]_i_1_n_0 ),
        .I2(\lane_cnt_reg[0]_65 [2]),
        .I3(\lane_cnt_reg[0]_65 [1]),
        .O(lane_cnt[2]));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT5 #(
    .INIT(32'h7F80FE01)) 
    \lane_cnt[0][3]_i_1 
       (.I0(\wr_ptr[0][3]_i_1_n_0 ),
        .I1(\lane_cnt_reg[0]_65 [0]),
        .I2(\lane_cnt_reg[0]_65 [1]),
        .I3(\lane_cnt_reg[0]_65 [3]),
        .I4(\lane_cnt_reg[0]_65 [2]),
        .O(lane_cnt[3]));
  LUT6 #(
    .INIT(64'hAAAA9AAAAAAAAAAA)) 
    \lane_cnt[0][4]_i_1 
       (.I0(\rd_ptr_reg[3][3]_0 ),
        .I1(\lane_cnt_reg[0]_65 [4]),
        .I2(lane_valid_0_IBUF),
        .I3(hs_mode_IBUF),
        .I4(lp_mode_IBUF),
        .I5(\cfg_lane_enable_mask_byte_reg[3] [0]),
        .O(\lane_cnt[0][4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FFF8000FFFE0001)) 
    \lane_cnt[0][4]_i_2 
       (.I0(\lane_cnt_reg[0]_65 [1]),
        .I1(\lane_cnt_reg[0]_65 [0]),
        .I2(\wr_ptr[0][3]_i_1_n_0 ),
        .I3(\lane_cnt_reg[0]_65 [2]),
        .I4(\lane_cnt_reg[0]_65 [4]),
        .I5(\lane_cnt_reg[0]_65 [3]),
        .O(lane_cnt[4]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \lane_cnt[1][0]_i_1 
       (.I0(\lane_cnt_reg[1]_66 [0]),
        .O(lane_cnt__0[0]));
  LUT3 #(
    .INIT(8'h69)) 
    \lane_cnt[1][1]_i_1 
       (.I0(\lane_cnt_reg[1]_66 [0]),
        .I1(\wr_ptr[1][3]_i_1_n_0 ),
        .I2(\lane_cnt_reg[1]_66 [1]),
        .O(\lane_cnt[1][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT4 #(
    .INIT(16'h78E1)) 
    \lane_cnt[1][2]_i_1 
       (.I0(\lane_cnt_reg[1]_66 [0]),
        .I1(\wr_ptr[1][3]_i_1_n_0 ),
        .I2(\lane_cnt_reg[1]_66 [2]),
        .I3(\lane_cnt_reg[1]_66 [1]),
        .O(lane_cnt__0[2]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT5 #(
    .INIT(32'h7F80FE01)) 
    \lane_cnt[1][3]_i_1 
       (.I0(\wr_ptr[1][3]_i_1_n_0 ),
        .I1(\lane_cnt_reg[1]_66 [0]),
        .I2(\lane_cnt_reg[1]_66 [1]),
        .I3(\lane_cnt_reg[1]_66 [3]),
        .I4(\lane_cnt_reg[1]_66 [2]),
        .O(lane_cnt__0[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \lane_cnt[1][4]_i_1 
       (.I0(\rd_ptr_reg[3][3]_0 ),
        .I1(\wr_ptr[1][3]_i_1_n_0 ),
        .O(\lane_cnt[1][4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FFF8000FFFE0001)) 
    \lane_cnt[1][4]_i_2 
       (.I0(\lane_cnt_reg[1]_66 [1]),
        .I1(\lane_cnt_reg[1]_66 [0]),
        .I2(\wr_ptr[1][3]_i_1_n_0 ),
        .I3(\lane_cnt_reg[1]_66 [2]),
        .I4(\lane_cnt_reg[1]_66 [4]),
        .I5(\lane_cnt_reg[1]_66 [3]),
        .O(lane_cnt__0[4]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \lane_cnt[2][0]_i_1 
       (.I0(\lane_cnt_reg[2]_67 [0]),
        .O(lane_cnt__1[0]));
  LUT3 #(
    .INIT(8'h69)) 
    \lane_cnt[2][1]_i_1 
       (.I0(\lane_cnt_reg[2]_67 [0]),
        .I1(\wr_ptr[2][3]_i_1_n_0 ),
        .I2(\lane_cnt_reg[2]_67 [1]),
        .O(\lane_cnt[2][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT4 #(
    .INIT(16'h78E1)) 
    \lane_cnt[2][2]_i_1 
       (.I0(\lane_cnt_reg[2]_67 [0]),
        .I1(\wr_ptr[2][3]_i_1_n_0 ),
        .I2(\lane_cnt_reg[2]_67 [2]),
        .I3(\lane_cnt_reg[2]_67 [1]),
        .O(lane_cnt__1[2]));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT5 #(
    .INIT(32'h7F80FE01)) 
    \lane_cnt[2][3]_i_1 
       (.I0(\wr_ptr[2][3]_i_1_n_0 ),
        .I1(\lane_cnt_reg[2]_67 [0]),
        .I2(\lane_cnt_reg[2]_67 [1]),
        .I3(\lane_cnt_reg[2]_67 [3]),
        .I4(\lane_cnt_reg[2]_67 [2]),
        .O(lane_cnt__1[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \lane_cnt[2][4]_i_1 
       (.I0(\rd_ptr_reg[3][3]_0 ),
        .I1(\wr_ptr[2][3]_i_1_n_0 ),
        .O(\lane_cnt[2][4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FFF8000FFFE0001)) 
    \lane_cnt[2][4]_i_2 
       (.I0(\lane_cnt_reg[2]_67 [1]),
        .I1(\lane_cnt_reg[2]_67 [0]),
        .I2(\wr_ptr[2][3]_i_1_n_0 ),
        .I3(\lane_cnt_reg[2]_67 [2]),
        .I4(\lane_cnt_reg[2]_67 [4]),
        .I5(\lane_cnt_reg[2]_67 [3]),
        .O(lane_cnt__1[4]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \lane_cnt[3][0]_i_1 
       (.I0(\lane_cnt_reg[3]_68 [0]),
        .O(lane_cnt__2[0]));
  LUT3 #(
    .INIT(8'h69)) 
    \lane_cnt[3][1]_i_1 
       (.I0(\lane_cnt_reg[3]_68 [0]),
        .I1(\wr_ptr[3][3]_i_2_n_0 ),
        .I2(\lane_cnt_reg[3]_68 [1]),
        .O(\lane_cnt[3][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT4 #(
    .INIT(16'h78E1)) 
    \lane_cnt[3][2]_i_1 
       (.I0(\lane_cnt_reg[3]_68 [0]),
        .I1(\wr_ptr[3][3]_i_2_n_0 ),
        .I2(\lane_cnt_reg[3]_68 [2]),
        .I3(\lane_cnt_reg[3]_68 [1]),
        .O(lane_cnt__2[2]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT5 #(
    .INIT(32'h7F80FE01)) 
    \lane_cnt[3][3]_i_1 
       (.I0(\wr_ptr[3][3]_i_2_n_0 ),
        .I1(\lane_cnt_reg[3]_68 [0]),
        .I2(\lane_cnt_reg[3]_68 [1]),
        .I3(\lane_cnt_reg[3]_68 [3]),
        .I4(\lane_cnt_reg[3]_68 [2]),
        .O(lane_cnt__2[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \lane_cnt[3][4]_i_1 
       (.I0(\rd_ptr_reg[3][3]_0 ),
        .I1(\wr_ptr[3][3]_i_2_n_0 ),
        .O(\lane_cnt[3][4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h7FFF8000FFFE0001)) 
    \lane_cnt[3][4]_i_2 
       (.I0(\lane_cnt_reg[3]_68 [1]),
        .I1(\lane_cnt_reg[3]_68 [0]),
        .I2(\wr_ptr[3][3]_i_2_n_0 ),
        .I3(\lane_cnt_reg[3]_68 [2]),
        .I4(\lane_cnt_reg[3]_68 [4]),
        .I5(\lane_cnt_reg[3]_68 [3]),
        .O(lane_cnt__2[4]));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[0][0] 
       (.C(clk_wr),
        .CE(\lane_cnt[0][4]_i_1_n_0 ),
        .D(lane_cnt[0]),
        .Q(\lane_cnt_reg[0]_65 [0]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[0][1] 
       (.C(clk_wr),
        .CE(\lane_cnt[0][4]_i_1_n_0 ),
        .D(\lane_cnt[0][1]_i_1_n_0 ),
        .Q(\lane_cnt_reg[0]_65 [1]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[0][2] 
       (.C(clk_wr),
        .CE(\lane_cnt[0][4]_i_1_n_0 ),
        .D(lane_cnt[2]),
        .Q(\lane_cnt_reg[0]_65 [2]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[0][3] 
       (.C(clk_wr),
        .CE(\lane_cnt[0][4]_i_1_n_0 ),
        .D(lane_cnt[3]),
        .Q(\lane_cnt_reg[0]_65 [3]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[0][4] 
       (.C(clk_wr),
        .CE(\lane_cnt[0][4]_i_1_n_0 ),
        .D(lane_cnt[4]),
        .Q(\lane_cnt_reg[0]_65 [4]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[1][0] 
       (.C(clk_wr),
        .CE(\lane_cnt[1][4]_i_1_n_0 ),
        .D(lane_cnt__0[0]),
        .Q(\lane_cnt_reg[1]_66 [0]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[1][1] 
       (.C(clk_wr),
        .CE(\lane_cnt[1][4]_i_1_n_0 ),
        .D(\lane_cnt[1][1]_i_1_n_0 ),
        .Q(\lane_cnt_reg[1]_66 [1]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[1][2] 
       (.C(clk_wr),
        .CE(\lane_cnt[1][4]_i_1_n_0 ),
        .D(lane_cnt__0[2]),
        .Q(\lane_cnt_reg[1]_66 [2]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[1][3] 
       (.C(clk_wr),
        .CE(\lane_cnt[1][4]_i_1_n_0 ),
        .D(lane_cnt__0[3]),
        .Q(\lane_cnt_reg[1]_66 [3]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[1][4] 
       (.C(clk_wr),
        .CE(\lane_cnt[1][4]_i_1_n_0 ),
        .D(lane_cnt__0[4]),
        .Q(\lane_cnt_reg[1]_66 [4]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[2][0] 
       (.C(clk_wr),
        .CE(\lane_cnt[2][4]_i_1_n_0 ),
        .D(lane_cnt__1[0]),
        .Q(\lane_cnt_reg[2]_67 [0]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[2][1] 
       (.C(clk_wr),
        .CE(\lane_cnt[2][4]_i_1_n_0 ),
        .D(\lane_cnt[2][1]_i_1_n_0 ),
        .Q(\lane_cnt_reg[2]_67 [1]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[2][2] 
       (.C(clk_wr),
        .CE(\lane_cnt[2][4]_i_1_n_0 ),
        .D(lane_cnt__1[2]),
        .Q(\lane_cnt_reg[2]_67 [2]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[2][3] 
       (.C(clk_wr),
        .CE(\lane_cnt[2][4]_i_1_n_0 ),
        .D(lane_cnt__1[3]),
        .Q(\lane_cnt_reg[2]_67 [3]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[2][4] 
       (.C(clk_wr),
        .CE(\lane_cnt[2][4]_i_1_n_0 ),
        .D(lane_cnt__1[4]),
        .Q(\lane_cnt_reg[2]_67 [4]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[3][0] 
       (.C(clk_wr),
        .CE(\lane_cnt[3][4]_i_1_n_0 ),
        .D(lane_cnt__2[0]),
        .Q(\lane_cnt_reg[3]_68 [0]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[3][1] 
       (.C(clk_wr),
        .CE(\lane_cnt[3][4]_i_1_n_0 ),
        .D(\lane_cnt[3][1]_i_1_n_0 ),
        .Q(\lane_cnt_reg[3]_68 [1]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[3][2] 
       (.C(clk_wr),
        .CE(\lane_cnt[3][4]_i_1_n_0 ),
        .D(lane_cnt__2[2]),
        .Q(\lane_cnt_reg[3]_68 [2]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[3][3] 
       (.C(clk_wr),
        .CE(\lane_cnt[3][4]_i_1_n_0 ),
        .D(lane_cnt__2[3]),
        .Q(\lane_cnt_reg[3]_68 [3]),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_cnt_reg[3][4] 
       (.C(clk_wr),
        .CE(\lane_cnt[3][4]_i_1_n_0 ),
        .D(lane_cnt__2[4]),
        .Q(\lane_cnt_reg[3]_68 [4]),
        .R(\wr_ptr_reg[3][3]_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    lane_err_toggle_byte_i_1
       (.I0(deskew_overflow),
        .I1(lane_err_toggle_byte),
        .O(lane_err_toggle_byte_reg));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \rd_ptr[0][0]_i_1 
       (.I0(\rd_ptr_reg_n_0_[0][0] ),
        .O(\rd_ptr[0][0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_ptr[0][1]_i_1 
       (.I0(\rd_ptr_reg_n_0_[0][1] ),
        .I1(\rd_ptr_reg_n_0_[0][0] ),
        .O(\rd_ptr[0][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rd_ptr[0][2]_i_1 
       (.I0(\rd_ptr_reg_n_0_[0][1] ),
        .I1(\rd_ptr_reg_n_0_[0][0] ),
        .I2(\rd_ptr_reg_n_0_[0][2] ),
        .O(\rd_ptr[0][2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \rd_ptr[0][3]_i_1 
       (.I0(\rd_ptr_reg_n_0_[0][1] ),
        .I1(\rd_ptr_reg_n_0_[0][0] ),
        .I2(\rd_ptr_reg_n_0_[0][2] ),
        .I3(\rd_ptr_reg_n_0_[0][3] ),
        .O(\rd_ptr[0][3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \rd_ptr[1][0]_i_1 
       (.I0(\rd_ptr_reg_n_0_[1][0] ),
        .O(\rd_ptr[1][0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_ptr[1][1]_i_1 
       (.I0(\rd_ptr_reg_n_0_[1][1] ),
        .I1(\rd_ptr_reg_n_0_[1][0] ),
        .O(\rd_ptr[1][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rd_ptr[1][2]_i_1 
       (.I0(\rd_ptr_reg_n_0_[1][1] ),
        .I1(\rd_ptr_reg_n_0_[1][0] ),
        .I2(\rd_ptr_reg_n_0_[1][2] ),
        .O(\rd_ptr[1][2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \rd_ptr[1][3]_i_1 
       (.I0(\rd_ptr_reg_n_0_[1][1] ),
        .I1(\rd_ptr_reg_n_0_[1][0] ),
        .I2(\rd_ptr_reg_n_0_[1][2] ),
        .I3(\rd_ptr_reg_n_0_[1][3] ),
        .O(\rd_ptr[1][3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \rd_ptr[2][0]_i_1 
       (.I0(\rd_ptr_reg_n_0_[2][0] ),
        .O(\rd_ptr[2][0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_ptr[2][1]_i_1 
       (.I0(\rd_ptr_reg_n_0_[2][1] ),
        .I1(\rd_ptr_reg_n_0_[2][0] ),
        .O(\rd_ptr[2][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rd_ptr[2][2]_i_1 
       (.I0(\rd_ptr_reg_n_0_[2][1] ),
        .I1(\rd_ptr_reg_n_0_[2][0] ),
        .I2(\rd_ptr_reg_n_0_[2][2] ),
        .O(\rd_ptr[2][2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \rd_ptr[2][3]_i_1 
       (.I0(\rd_ptr_reg_n_0_[2][1] ),
        .I1(\rd_ptr_reg_n_0_[2][0] ),
        .I2(\rd_ptr_reg_n_0_[2][2] ),
        .I3(\rd_ptr_reg_n_0_[2][3] ),
        .O(\rd_ptr[2][3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \rd_ptr[3][0]_i_1 
       (.I0(\rd_ptr_reg_n_0_[3][0] ),
        .O(\rd_ptr[3][0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \rd_ptr[3][1]_i_1 
       (.I0(\rd_ptr_reg_n_0_[3][1] ),
        .I1(\rd_ptr_reg_n_0_[3][0] ),
        .O(\rd_ptr[3][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \rd_ptr[3][2]_i_1 
       (.I0(\rd_ptr_reg_n_0_[3][1] ),
        .I1(\rd_ptr_reg_n_0_[3][0] ),
        .I2(\rd_ptr_reg_n_0_[3][2] ),
        .O(\rd_ptr[3][2]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \rd_ptr[3][3]_i_1 
       (.I0(deskew_valid),
        .I1(merge_byte_valid),
        .O(\rd_ptr_reg[3][3]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \rd_ptr[3][3]_i_2 
       (.I0(\rd_ptr_reg_n_0_[3][1] ),
        .I1(\rd_ptr_reg_n_0_[3][0] ),
        .I2(\rd_ptr_reg_n_0_[3][2] ),
        .I3(\rd_ptr_reg_n_0_[3][3] ),
        .O(\rd_ptr[3][3]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h0001)) 
    \rd_ptr[3][3]_i_3 
       (.I0(\rd_ptr[3][3]_i_4_n_0 ),
        .I1(\rd_ptr[3][3]_i_5_n_0 ),
        .I2(\rd_ptr[3][3]_i_6_n_0 ),
        .I3(\rd_ptr[3][3]_i_7_n_0 ),
        .O(deskew_valid));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \rd_ptr[3][3]_i_4 
       (.I0(\lane_cnt_reg[3]_68 [3]),
        .I1(\lane_cnt_reg[3]_68 [4]),
        .I2(\lane_cnt_reg[3]_68 [0]),
        .I3(\lane_cnt_reg[3]_68 [1]),
        .I4(\lane_cnt_reg[3]_68 [2]),
        .O(\rd_ptr[3][3]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \rd_ptr[3][3]_i_5 
       (.I0(\lane_cnt_reg[2]_67 [3]),
        .I1(\lane_cnt_reg[2]_67 [4]),
        .I2(\lane_cnt_reg[2]_67 [0]),
        .I3(\lane_cnt_reg[2]_67 [1]),
        .I4(\lane_cnt_reg[2]_67 [2]),
        .O(\rd_ptr[3][3]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \rd_ptr[3][3]_i_6 
       (.I0(\lane_cnt_reg[0]_65 [3]),
        .I1(\lane_cnt_reg[0]_65 [4]),
        .I2(\lane_cnt_reg[0]_65 [0]),
        .I3(\lane_cnt_reg[0]_65 [1]),
        .I4(\lane_cnt_reg[0]_65 [2]),
        .O(\rd_ptr[3][3]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \rd_ptr[3][3]_i_7 
       (.I0(\lane_cnt_reg[1]_66 [3]),
        .I1(\lane_cnt_reg[1]_66 [4]),
        .I2(\lane_cnt_reg[1]_66 [0]),
        .I3(\lane_cnt_reg[1]_66 [1]),
        .I4(\lane_cnt_reg[1]_66 [2]),
        .O(\rd_ptr[3][3]_i_7_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[0][0] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[0][0]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[0][0] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[0][1] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[0][1]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[0][1] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[0][2] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[0][2]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[0][2] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[0][3] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[0][3]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[0][3] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[1][0] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[1][0]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[1][0] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[1][1] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[1][1]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[1][1] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[1][2] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[1][2]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[1][2] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[1][3] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[1][3]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[1][3] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[2][0] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[2][0]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[2][0] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[2][1] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[2][1]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[2][1] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[2][2] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[2][2]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[2][2] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[2][3] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[2][3]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[2][3] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[3][0] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[3][0]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[3][0] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[3][1] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[3][1]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[3][1] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[3][2] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[3][2]_i_1_n_0 ),
        .Q(\rd_ptr_reg_n_0_[3][2] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \rd_ptr_reg[3][3] 
       (.C(clk_wr),
        .CE(\rd_ptr_reg[3][3]_0 ),
        .D(\rd_ptr[3][3]_i_2_n_0 ),
        .Q(\rd_ptr_reg_n_0_[3][3] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \wr_ptr[0][0]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][0] ),
        .O(\wr_ptr[0][0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_ptr[0][1]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][1] ),
        .I1(\wr_ptr_reg_n_0_[0][0] ),
        .O(\wr_ptr[0][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \wr_ptr[0][2]_i_1 
       (.I0(\wr_ptr_reg_n_0_[0][1] ),
        .I1(\wr_ptr_reg_n_0_[0][0] ),
        .I2(\wr_ptr_reg_n_0_[0][2] ),
        .O(\wr_ptr[0][2]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00002000)) 
    \wr_ptr[0][3]_i_1 
       (.I0(\cfg_lane_enable_mask_byte_reg[3] [0]),
        .I1(lp_mode_IBUF),
        .I2(hs_mode_IBUF),
        .I3(lane_valid_0_IBUF),
        .I4(\lane_cnt_reg[0]_65 [4]),
        .O(\wr_ptr[0][3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \wr_ptr[0][3]_i_2 
       (.I0(\wr_ptr_reg_n_0_[0][1] ),
        .I1(\wr_ptr_reg_n_0_[0][0] ),
        .I2(\wr_ptr_reg_n_0_[0][2] ),
        .I3(\wr_ptr_reg_n_0_[0][3] ),
        .O(\wr_ptr[0][3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \wr_ptr[1][0]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][0] ),
        .O(\wr_ptr[1][0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_ptr[1][1]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][1] ),
        .I1(\wr_ptr_reg_n_0_[1][0] ),
        .O(\wr_ptr[1][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \wr_ptr[1][2]_i_1 
       (.I0(\wr_ptr_reg_n_0_[1][1] ),
        .I1(\wr_ptr_reg_n_0_[1][0] ),
        .I2(\wr_ptr_reg_n_0_[1][2] ),
        .O(\wr_ptr[1][2]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \wr_ptr[1][3]_i_1 
       (.I0(phy_lane_valid[1]),
        .I1(\lane_cnt_reg[1]_66 [4]),
        .O(\wr_ptr[1][3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \wr_ptr[1][3]_i_2 
       (.I0(\wr_ptr_reg_n_0_[1][1] ),
        .I1(\wr_ptr_reg_n_0_[1][0] ),
        .I2(\wr_ptr_reg_n_0_[1][2] ),
        .I3(\wr_ptr_reg_n_0_[1][3] ),
        .O(\wr_ptr[1][3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0808080000000000)) 
    \wr_ptr[1][3]_i_3 
       (.I0(lane_valid_1_IBUF),
        .I1(hs_mode_IBUF),
        .I2(lp_mode_IBUF),
        .I3(\wr_ptr[2][3]_i_3_n_0 ),
        .I4(\wr_ptr[3][3]_i_5_n_0 ),
        .I5(\cfg_lane_enable_mask_byte_reg[3] [1]),
        .O(phy_lane_valid[1]));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \wr_ptr[2][0]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][0] ),
        .O(\wr_ptr[2][0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_ptr[2][1]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][1] ),
        .I1(\wr_ptr_reg_n_0_[2][0] ),
        .O(\wr_ptr[2][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \wr_ptr[2][2]_i_1 
       (.I0(\wr_ptr_reg_n_0_[2][1] ),
        .I1(\wr_ptr_reg_n_0_[2][0] ),
        .I2(\wr_ptr_reg_n_0_[2][2] ),
        .O(\wr_ptr[2][2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000008000000)) 
    \wr_ptr[2][3]_i_1 
       (.I0(\cfg_lane_enable_mask_byte_reg[3] [2]),
        .I1(\wr_ptr[2][3]_i_3_n_0 ),
        .I2(lp_mode_IBUF),
        .I3(hs_mode_IBUF),
        .I4(lane_valid_2_IBUF),
        .I5(\lane_cnt_reg[2]_67 [4]),
        .O(\wr_ptr[2][3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \wr_ptr[2][3]_i_2 
       (.I0(\wr_ptr_reg_n_0_[2][1] ),
        .I1(\wr_ptr_reg_n_0_[2][0] ),
        .I2(\wr_ptr_reg_n_0_[2][2] ),
        .I3(\wr_ptr_reg_n_0_[2][3] ),
        .O(\wr_ptr[2][3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT4 #(
    .INIT(16'hA888)) 
    \wr_ptr[2][3]_i_3 
       (.I0(\cfg_lane_num_byte_reg[1] [1]),
        .I1(\active_lane_num_byte_reg[2] [2]),
        .I2(\active_lane_num_byte_reg[2] [0]),
        .I3(\active_lane_num_byte_reg[2] [1]),
        .O(\wr_ptr[2][3]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \wr_ptr[3][0]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][0] ),
        .O(\wr_ptr[3][0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \wr_ptr[3][1]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][1] ),
        .I1(\wr_ptr_reg_n_0_[3][0] ),
        .O(\wr_ptr[3][1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \wr_ptr[3][2]_i_1 
       (.I0(\wr_ptr_reg_n_0_[3][1] ),
        .I1(\wr_ptr_reg_n_0_[3][0] ),
        .I2(\wr_ptr_reg_n_0_[3][2] ),
        .O(\wr_ptr[3][2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h6F)) 
    \wr_ptr[3][3]_i_1 
       (.I0(resync_toggle_byte_d),
        .I1(out),
        .I2(rst_n_IBUF),
        .O(\wr_ptr_reg[3][3]_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \wr_ptr[3][3]_i_2 
       (.I0(phy_lane_valid[3]),
        .I1(\lane_cnt_reg[3]_68 [4]),
        .O(\wr_ptr[3][3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \wr_ptr[3][3]_i_3 
       (.I0(\wr_ptr_reg_n_0_[3][1] ),
        .I1(\wr_ptr_reg_n_0_[3][0] ),
        .I2(\wr_ptr_reg_n_0_[3][2] ),
        .I3(\wr_ptr_reg_n_0_[3][3] ),
        .O(\wr_ptr[3][3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0800000000000000)) 
    \wr_ptr[3][3]_i_4 
       (.I0(lane_valid_3_IBUF),
        .I1(hs_mode_IBUF),
        .I2(lp_mode_IBUF),
        .I3(\wr_ptr[2][3]_i_3_n_0 ),
        .I4(\wr_ptr[3][3]_i_5_n_0 ),
        .I5(\cfg_lane_enable_mask_byte_reg[3] [3]),
        .O(phy_lane_valid[3]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'hF202FA00)) 
    \wr_ptr[3][3]_i_5 
       (.I0(\active_lane_num_byte_reg[2] [1]),
        .I1(\active_lane_num_byte_reg[2] [0]),
        .I2(\active_lane_num_byte_reg[2] [2]),
        .I3(\cfg_lane_num_byte_reg[1] [0]),
        .I4(\cfg_lane_num_byte_reg[1] [1]),
        .O(\wr_ptr[3][3]_i_5_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[0][0] 
       (.C(clk_wr),
        .CE(\wr_ptr[0][3]_i_1_n_0 ),
        .D(\wr_ptr[0][0]_i_1_n_0 ),
        .Q(\wr_ptr_reg_n_0_[0][0] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[0][1] 
       (.C(clk_wr),
        .CE(\wr_ptr[0][3]_i_1_n_0 ),
        .D(\wr_ptr[0][1]_i_1_n_0 ),
        .Q(\wr_ptr_reg_n_0_[0][1] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[0][2] 
       (.C(clk_wr),
        .CE(\wr_ptr[0][3]_i_1_n_0 ),
        .D(\wr_ptr[0][2]_i_1_n_0 ),
        .Q(\wr_ptr_reg_n_0_[0][2] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[0][3] 
       (.C(clk_wr),
        .CE(\wr_ptr[0][3]_i_1_n_0 ),
        .D(\wr_ptr[0][3]_i_2_n_0 ),
        .Q(\wr_ptr_reg_n_0_[0][3] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[1][0] 
       (.C(clk_wr),
        .CE(\wr_ptr[1][3]_i_1_n_0 ),
        .D(\wr_ptr[1][0]_i_1_n_0 ),
        .Q(\wr_ptr_reg_n_0_[1][0] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[1][1] 
       (.C(clk_wr),
        .CE(\wr_ptr[1][3]_i_1_n_0 ),
        .D(\wr_ptr[1][1]_i_1_n_0 ),
        .Q(\wr_ptr_reg_n_0_[1][1] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[1][2] 
       (.C(clk_wr),
        .CE(\wr_ptr[1][3]_i_1_n_0 ),
        .D(\wr_ptr[1][2]_i_1_n_0 ),
        .Q(\wr_ptr_reg_n_0_[1][2] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[1][3] 
       (.C(clk_wr),
        .CE(\wr_ptr[1][3]_i_1_n_0 ),
        .D(\wr_ptr[1][3]_i_2_n_0 ),
        .Q(\wr_ptr_reg_n_0_[1][3] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[2][0] 
       (.C(clk_wr),
        .CE(\wr_ptr[2][3]_i_1_n_0 ),
        .D(\wr_ptr[2][0]_i_1_n_0 ),
        .Q(\wr_ptr_reg_n_0_[2][0] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[2][1] 
       (.C(clk_wr),
        .CE(\wr_ptr[2][3]_i_1_n_0 ),
        .D(\wr_ptr[2][1]_i_1_n_0 ),
        .Q(\wr_ptr_reg_n_0_[2][1] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[2][2] 
       (.C(clk_wr),
        .CE(\wr_ptr[2][3]_i_1_n_0 ),
        .D(\wr_ptr[2][2]_i_1_n_0 ),
        .Q(\wr_ptr_reg_n_0_[2][2] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[2][3] 
       (.C(clk_wr),
        .CE(\wr_ptr[2][3]_i_1_n_0 ),
        .D(\wr_ptr[2][3]_i_2_n_0 ),
        .Q(\wr_ptr_reg_n_0_[2][3] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[3][0] 
       (.C(clk_wr),
        .CE(\wr_ptr[3][3]_i_2_n_0 ),
        .D(\wr_ptr[3][0]_i_1_n_0 ),
        .Q(\wr_ptr_reg_n_0_[3][0] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[3][1] 
       (.C(clk_wr),
        .CE(\wr_ptr[3][3]_i_2_n_0 ),
        .D(\wr_ptr[3][1]_i_1_n_0 ),
        .Q(\wr_ptr_reg_n_0_[3][1] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[3][2] 
       (.C(clk_wr),
        .CE(\wr_ptr[3][3]_i_2_n_0 ),
        .D(\wr_ptr[3][2]_i_1_n_0 ),
        .Q(\wr_ptr_reg_n_0_[3][2] ),
        .R(\wr_ptr_reg[3][3]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wr_ptr_reg[3][3] 
       (.C(clk_wr),
        .CE(\wr_ptr[3][3]_i_2_n_0 ),
        .D(\wr_ptr[3][3]_i_3_n_0 ),
        .Q(\wr_ptr_reg_n_0_[3][3] ),
        .R(\wr_ptr_reg[3][3]_0 ));
endmodule

module lane_reorder_merge
   (merge_byte_valid,
    wr_data,
    out,
    resync_toggle_byte_d,
    rst_n_IBUF,
    clk_wr,
    SR,
    E,
    D,
    \rd_ptr_reg[1][3] ,
    \rd_ptr_reg[2][3] ,
    \rd_ptr_reg[3][3] ,
    active_reg_0,
    deskew_valid);
  output merge_byte_valid;
  output [7:0]wr_data;
  input out;
  input resync_toggle_byte_d;
  input rst_n_IBUF;
  input clk_wr;
  input [0:0]SR;
  input [0:0]E;
  input [7:0]D;
  input [7:0]\rd_ptr_reg[1][3] ;
  input [7:0]\rd_ptr_reg[2][3] ;
  input [7:0]\rd_ptr_reg[3][3] ;
  input active_reg_0;
  input deskew_valid;

  wire \<const0> ;
  wire \<const1> ;
  wire [7:0]D;
  wire [0:0]E;
  wire [0:0]SR;
  wire active_i_1_n_0;
  wire active_reg_0;
  wire clk_wr;
  wire deskew_valid;
  wire [7:0]\group_data_reg_reg[0]_73 ;
  wire [7:0]\group_data_reg_reg[1]_74 ;
  wire [7:0]\group_data_reg_reg[2]_75 ;
  wire [7:0]\group_data_reg_reg[3]_76 ;
  wire lane_idx;
  wire \lane_idx[1]_i_1_n_0 ;
  wire \lane_idx[1]_i_4_n_0 ;
  wire \lane_idx_reg_n_0_[0] ;
  wire \lane_idx_reg_n_0_[1] ;
  wire merge_byte_valid;
  wire out;
  wire [1:0]p_1_in;
  wire [7:0]\rd_ptr_reg[1][3] ;
  wire [7:0]\rd_ptr_reg[2][3] ;
  wire [7:0]\rd_ptr_reg[3][3] ;
  wire resync_toggle_byte_d;
  wire rst_n_IBUF;
  wire [7:0]wr_data;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT4 #(
    .INIT(16'h00E2)) 
    active_i_1
       (.I0(merge_byte_valid),
        .I1(\lane_idx[1]_i_4_n_0 ),
        .I2(E),
        .I3(SR),
        .O(active_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    active_reg
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(active_i_1_n_0),
        .Q(merge_byte_valid),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[0][0] 
       (.C(clk_wr),
        .CE(E),
        .D(D[0]),
        .Q(\group_data_reg_reg[0]_73 [0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[0][1] 
       (.C(clk_wr),
        .CE(E),
        .D(D[1]),
        .Q(\group_data_reg_reg[0]_73 [1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[0][2] 
       (.C(clk_wr),
        .CE(E),
        .D(D[2]),
        .Q(\group_data_reg_reg[0]_73 [2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[0][3] 
       (.C(clk_wr),
        .CE(E),
        .D(D[3]),
        .Q(\group_data_reg_reg[0]_73 [3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[0][4] 
       (.C(clk_wr),
        .CE(E),
        .D(D[4]),
        .Q(\group_data_reg_reg[0]_73 [4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[0][5] 
       (.C(clk_wr),
        .CE(E),
        .D(D[5]),
        .Q(\group_data_reg_reg[0]_73 [5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[0][6] 
       (.C(clk_wr),
        .CE(E),
        .D(D[6]),
        .Q(\group_data_reg_reg[0]_73 [6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[0][7] 
       (.C(clk_wr),
        .CE(E),
        .D(D[7]),
        .Q(\group_data_reg_reg[0]_73 [7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[1][0] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[1][3] [0]),
        .Q(\group_data_reg_reg[1]_74 [0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[1][1] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[1][3] [1]),
        .Q(\group_data_reg_reg[1]_74 [1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[1][2] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[1][3] [2]),
        .Q(\group_data_reg_reg[1]_74 [2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[1][3] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[1][3] [3]),
        .Q(\group_data_reg_reg[1]_74 [3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[1][4] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[1][3] [4]),
        .Q(\group_data_reg_reg[1]_74 [4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[1][5] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[1][3] [5]),
        .Q(\group_data_reg_reg[1]_74 [5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[1][6] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[1][3] [6]),
        .Q(\group_data_reg_reg[1]_74 [6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[1][7] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[1][3] [7]),
        .Q(\group_data_reg_reg[1]_74 [7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[2][0] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[2][3] [0]),
        .Q(\group_data_reg_reg[2]_75 [0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[2][1] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[2][3] [1]),
        .Q(\group_data_reg_reg[2]_75 [1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[2][2] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[2][3] [2]),
        .Q(\group_data_reg_reg[2]_75 [2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[2][3] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[2][3] [3]),
        .Q(\group_data_reg_reg[2]_75 [3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[2][4] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[2][3] [4]),
        .Q(\group_data_reg_reg[2]_75 [4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[2][5] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[2][3] [5]),
        .Q(\group_data_reg_reg[2]_75 [5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[2][6] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[2][3] [6]),
        .Q(\group_data_reg_reg[2]_75 [6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[2][7] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[2][3] [7]),
        .Q(\group_data_reg_reg[2]_75 [7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[3][0] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[3][3] [0]),
        .Q(\group_data_reg_reg[3]_76 [0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[3][1] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[3][3] [1]),
        .Q(\group_data_reg_reg[3]_76 [1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[3][2] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[3][3] [2]),
        .Q(\group_data_reg_reg[3]_76 [2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[3][3] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[3][3] [3]),
        .Q(\group_data_reg_reg[3]_76 [3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[3][4] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[3][3] [4]),
        .Q(\group_data_reg_reg[3]_76 [4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[3][5] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[3][3] [5]),
        .Q(\group_data_reg_reg[3]_76 [5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[3][6] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[3][3] [6]),
        .Q(\group_data_reg_reg[3]_76 [6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \group_data_reg_reg[3][7] 
       (.C(clk_wr),
        .CE(E),
        .D(\rd_ptr_reg[3][3] [7]),
        .Q(\group_data_reg_reg[3]_76 [7]),
        .R(SR));
  LUT1 #(
    .INIT(2'h1)) 
    \lane_idx[0]_i_1 
       (.I0(\lane_idx_reg_n_0_[0] ),
        .O(p_1_in[0]));
  LUT4 #(
    .INIT(16'hBEFF)) 
    \lane_idx[1]_i_1 
       (.I0(\lane_idx[1]_i_4_n_0 ),
        .I1(out),
        .I2(resync_toggle_byte_d),
        .I3(rst_n_IBUF),
        .O(\lane_idx[1]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \lane_idx[1]_i_2 
       (.I0(merge_byte_valid),
        .I1(active_reg_0),
        .O(lane_idx));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \lane_idx[1]_i_3 
       (.I0(\lane_idx_reg_n_0_[0] ),
        .I1(\lane_idx_reg_n_0_[1] ),
        .O(p_1_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT5 #(
    .INIT(32'h80FF8000)) 
    \lane_idx[1]_i_4 
       (.I0(active_reg_0),
        .I1(\lane_idx_reg_n_0_[1] ),
        .I2(\lane_idx_reg_n_0_[0] ),
        .I3(merge_byte_valid),
        .I4(deskew_valid),
        .O(\lane_idx[1]_i_4_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_idx_reg[0] 
       (.C(clk_wr),
        .CE(lane_idx),
        .D(p_1_in[0]),
        .Q(\lane_idx_reg_n_0_[0] ),
        .R(\lane_idx[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \lane_idx_reg[1] 
       (.C(clk_wr),
        .CE(lane_idx),
        .D(p_1_in[1]),
        .Q(\lane_idx_reg_n_0_[1] ),
        .R(\lane_idx[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    mem_reg_0_15_0_5_i_2
       (.I0(\group_data_reg_reg[2]_75 [1]),
        .I1(\group_data_reg_reg[3]_76 [1]),
        .I2(\group_data_reg_reg[0]_73 [1]),
        .I3(\lane_idx_reg_n_0_[1] ),
        .I4(\lane_idx_reg_n_0_[0] ),
        .I5(\group_data_reg_reg[1]_74 [1]),
        .O(wr_data[1]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    mem_reg_0_15_0_5_i_3
       (.I0(\group_data_reg_reg[2]_75 [0]),
        .I1(\group_data_reg_reg[3]_76 [0]),
        .I2(\group_data_reg_reg[0]_73 [0]),
        .I3(\lane_idx_reg_n_0_[1] ),
        .I4(\lane_idx_reg_n_0_[0] ),
        .I5(\group_data_reg_reg[1]_74 [0]),
        .O(wr_data[0]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    mem_reg_0_15_0_5_i_4
       (.I0(\group_data_reg_reg[2]_75 [3]),
        .I1(\group_data_reg_reg[3]_76 [3]),
        .I2(\group_data_reg_reg[0]_73 [3]),
        .I3(\lane_idx_reg_n_0_[1] ),
        .I4(\lane_idx_reg_n_0_[0] ),
        .I5(\group_data_reg_reg[1]_74 [3]),
        .O(wr_data[3]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    mem_reg_0_15_0_5_i_5
       (.I0(\group_data_reg_reg[2]_75 [2]),
        .I1(\group_data_reg_reg[3]_76 [2]),
        .I2(\group_data_reg_reg[0]_73 [2]),
        .I3(\lane_idx_reg_n_0_[1] ),
        .I4(\lane_idx_reg_n_0_[0] ),
        .I5(\group_data_reg_reg[1]_74 [2]),
        .O(wr_data[2]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    mem_reg_0_15_0_5_i_6
       (.I0(\group_data_reg_reg[2]_75 [5]),
        .I1(\group_data_reg_reg[3]_76 [5]),
        .I2(\group_data_reg_reg[0]_73 [5]),
        .I3(\lane_idx_reg_n_0_[1] ),
        .I4(\lane_idx_reg_n_0_[0] ),
        .I5(\group_data_reg_reg[1]_74 [5]),
        .O(wr_data[5]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    mem_reg_0_15_0_5_i_7
       (.I0(\group_data_reg_reg[2]_75 [4]),
        .I1(\group_data_reg_reg[3]_76 [4]),
        .I2(\group_data_reg_reg[0]_73 [4]),
        .I3(\lane_idx_reg_n_0_[1] ),
        .I4(\lane_idx_reg_n_0_[0] ),
        .I5(\group_data_reg_reg[1]_74 [4]),
        .O(wr_data[4]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    mem_reg_0_15_0_5_i_8
       (.I0(\group_data_reg_reg[2]_75 [7]),
        .I1(\group_data_reg_reg[3]_76 [7]),
        .I2(\group_data_reg_reg[0]_73 [7]),
        .I3(\lane_idx_reg_n_0_[1] ),
        .I4(\lane_idx_reg_n_0_[0] ),
        .I5(\group_data_reg_reg[1]_74 [7]),
        .O(wr_data[7]));
  LUT6 #(
    .INIT(64'hCCFFAAF0CC00AAF0)) 
    mem_reg_0_15_0_5_i_9
       (.I0(\group_data_reg_reg[2]_75 [6]),
        .I1(\group_data_reg_reg[3]_76 [6]),
        .I2(\group_data_reg_reg[0]_73 [6]),
        .I3(\lane_idx_reg_n_0_[1] ),
        .I4(\lane_idx_reg_n_0_[0] ),
        .I5(\group_data_reg_reg[1]_74 [6]),
        .O(wr_data[6]));
endmodule

(* AXI_ADDR_WIDTH = "32" *) (* AXI_DATA_WIDTH = "128" *) (* AXI_FIFO_ADDR_WIDTH = "6" *) 
(* AXI_MAX_BURST_LEN = "16" *) (* BYTE_FIFO_ADDR_WIDTH = "4" *) (* DESKEW_DEPTH = "16" *) 
(* LANE_NUM = "4" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module mipi_csi2_capture_fpga_wrapper
   (clk_sys,
    clk_byte,
    clk_axi,
    clk_ddr,
    rst_n,
    lane_data_0,
    lane_data_1,
    lane_data_2,
    lane_data_3,
    lane_valid_0,
    lane_valid_1,
    lane_valid_2,
    lane_valid_3,
    hs_mode,
    lp_mode,
    frame_start_o,
    frame_end_o,
    line_start_o,
    line_end_o,
    err_ecc_o,
    err_crc_o,
    err_sync_o,
    pixel_data_o,
    pixel_valid_o,
    pixel_sof_o,
    pixel_sol_o,
    cfg_init_done_o);
  input clk_sys;
  input clk_byte;
  input clk_axi;
  input clk_ddr;
  input rst_n;
  input [31:0]lane_data_0;
  input [31:0]lane_data_1;
  input [31:0]lane_data_2;
  input [31:0]lane_data_3;
  input lane_valid_0;
  input lane_valid_1;
  input lane_valid_2;
  input lane_valid_3;
  input hs_mode;
  input lp_mode;
  output frame_start_o;
  output frame_end_o;
  output line_start_o;
  output line_end_o;
  output err_ecc_o;
  output err_crc_o;
  output err_sync_o;
  output [23:0]pixel_data_o;
  output pixel_valid_o;
  output pixel_sof_o;
  output pixel_sol_o;
  output cfg_init_done_o;

  wire VCC_1;
  wire aw_seen_q;
  wire [0:0]beats_remaining_q;
  wire cfg_init_done_o;
  wire cfg_init_done_o_OBUF;
  wire clk_axi;
  wire clk_axi_IBUF;
  wire clk_axi_IBUF_BUFG;
  wire clk_byte;
  wire clk_byte_IBUF;
  wire clk_byte_IBUF_BUFG;
  wire clk_sys;
  wire clk_sys_IBUF;
  wire clk_sys_IBUF_BUFG;
  wire err_crc_o;
  wire err_crc_o_OBUF;
  wire err_ecc_o;
  wire err_ecc_o_OBUF;
  wire err_sync_o;
  wire err_sync_o_OBUF;
  wire frame_end_o;
  wire frame_end_o_OBUF;
  wire frame_start_o;
  wire frame_start_o_OBUF;
  wire hs_mode;
  wire hs_mode_IBUF;
  wire [31:0]lane_data_0;
  wire [7:0]lane_data_0_IBUF;
  wire [31:0]lane_data_1;
  wire [7:0]lane_data_1_IBUF;
  wire [31:0]lane_data_2;
  wire [7:0]lane_data_2_IBUF;
  wire [31:0]lane_data_3;
  wire [7:0]lane_data_3_IBUF;
  wire lane_valid_0;
  wire lane_valid_0_IBUF;
  wire lane_valid_1;
  wire lane_valid_1_IBUF;
  wire lane_valid_2;
  wire lane_valid_2_IBUF;
  wire lane_valid_3;
  wire lane_valid_3_IBUF;
  wire line_end_o;
  wire line_end_o_OBUF;
  wire line_start_o;
  wire line_start_o_OBUF;
  wire lp_mode;
  wire lp_mode_IBUF;
  wire m_axi_bvalid;
  wire m_axi_wlast;
  wire m_axi_wready;
  wire p_0_in;
  wire [23:0]pixel_data_o;
  wire [23:0]pixel_data_o_OBUF;
  wire pixel_sof_o;
  wire pixel_sof_o_OBUF;
  wire pixel_sol_o;
  wire pixel_sol_o_OBUF;
  wire pixel_valid_o;
  wire pixel_valid_o_OBUF;
  wire rst_n;
  wire rst_n_IBUF;
  wire u_axi_write_null_slave_n_1;
  wire u_axi_write_null_slave_n_2;
  wire u_mipi_csi2_capture_top_n_1;
  wire u_mipi_csi2_capture_top_n_2;
  wire u_mipi_csi2_capture_top_n_5;
  wire u_mipi_csi2_capture_top_n_6;
  wire u_mipi_csi2_capture_top_n_7;
  wire u_mipi_csi2_capture_top_n_8;

  VCC VCC
       (.P(VCC_1));
  OBUF cfg_init_done_o_OBUF_inst
       (.I(cfg_init_done_o_OBUF),
        .O(cfg_init_done_o));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC")) 
    clk_axi_IBUF_BUFG_inst
       (.CE(VCC_1),
        .I(clk_axi_IBUF),
        .O(clk_axi_IBUF_BUFG));
  IBUF clk_axi_IBUF_inst
       (.I(clk_axi),
        .O(clk_axi_IBUF));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC")) 
    clk_byte_IBUF_BUFG_inst
       (.CE(VCC_1),
        .I(clk_byte_IBUF),
        .O(clk_byte_IBUF_BUFG));
  IBUF clk_byte_IBUF_inst
       (.I(clk_byte),
        .O(clk_byte_IBUF));
  (* XILINX_LEGACY_PRIM = "BUFG" *) 
  BUFGCE #(
    .CE_TYPE("ASYNC")) 
    clk_sys_IBUF_BUFG_inst
       (.CE(VCC_1),
        .I(clk_sys_IBUF),
        .O(clk_sys_IBUF_BUFG));
  IBUF clk_sys_IBUF_inst
       (.I(clk_sys),
        .O(clk_sys_IBUF));
  OBUF err_crc_o_OBUF_inst
       (.I(err_crc_o_OBUF),
        .O(err_crc_o));
  OBUF err_ecc_o_OBUF_inst
       (.I(err_ecc_o_OBUF),
        .O(err_ecc_o));
  OBUF err_sync_o_OBUF_inst
       (.I(err_sync_o_OBUF),
        .O(err_sync_o));
  OBUF frame_end_o_OBUF_inst
       (.I(frame_end_o_OBUF),
        .O(frame_end_o));
  OBUF frame_start_o_OBUF_inst
       (.I(frame_start_o_OBUF),
        .O(frame_start_o));
  IBUF hs_mode_IBUF_inst
       (.I(hs_mode),
        .O(hs_mode_IBUF));
  IBUF \lane_data_0_IBUF[0]_inst 
       (.I(lane_data_0[0]),
        .O(lane_data_0_IBUF[0]));
  IBUF \lane_data_0_IBUF[1]_inst 
       (.I(lane_data_0[1]),
        .O(lane_data_0_IBUF[1]));
  IBUF \lane_data_0_IBUF[2]_inst 
       (.I(lane_data_0[2]),
        .O(lane_data_0_IBUF[2]));
  IBUF \lane_data_0_IBUF[3]_inst 
       (.I(lane_data_0[3]),
        .O(lane_data_0_IBUF[3]));
  IBUF \lane_data_0_IBUF[4]_inst 
       (.I(lane_data_0[4]),
        .O(lane_data_0_IBUF[4]));
  IBUF \lane_data_0_IBUF[5]_inst 
       (.I(lane_data_0[5]),
        .O(lane_data_0_IBUF[5]));
  IBUF \lane_data_0_IBUF[6]_inst 
       (.I(lane_data_0[6]),
        .O(lane_data_0_IBUF[6]));
  IBUF \lane_data_0_IBUF[7]_inst 
       (.I(lane_data_0[7]),
        .O(lane_data_0_IBUF[7]));
  IBUF \lane_data_1_IBUF[0]_inst 
       (.I(lane_data_1[0]),
        .O(lane_data_1_IBUF[0]));
  IBUF \lane_data_1_IBUF[1]_inst 
       (.I(lane_data_1[1]),
        .O(lane_data_1_IBUF[1]));
  IBUF \lane_data_1_IBUF[2]_inst 
       (.I(lane_data_1[2]),
        .O(lane_data_1_IBUF[2]));
  IBUF \lane_data_1_IBUF[3]_inst 
       (.I(lane_data_1[3]),
        .O(lane_data_1_IBUF[3]));
  IBUF \lane_data_1_IBUF[4]_inst 
       (.I(lane_data_1[4]),
        .O(lane_data_1_IBUF[4]));
  IBUF \lane_data_1_IBUF[5]_inst 
       (.I(lane_data_1[5]),
        .O(lane_data_1_IBUF[5]));
  IBUF \lane_data_1_IBUF[6]_inst 
       (.I(lane_data_1[6]),
        .O(lane_data_1_IBUF[6]));
  IBUF \lane_data_1_IBUF[7]_inst 
       (.I(lane_data_1[7]),
        .O(lane_data_1_IBUF[7]));
  IBUF \lane_data_2_IBUF[0]_inst 
       (.I(lane_data_2[0]),
        .O(lane_data_2_IBUF[0]));
  IBUF \lane_data_2_IBUF[1]_inst 
       (.I(lane_data_2[1]),
        .O(lane_data_2_IBUF[1]));
  IBUF \lane_data_2_IBUF[2]_inst 
       (.I(lane_data_2[2]),
        .O(lane_data_2_IBUF[2]));
  IBUF \lane_data_2_IBUF[3]_inst 
       (.I(lane_data_2[3]),
        .O(lane_data_2_IBUF[3]));
  IBUF \lane_data_2_IBUF[4]_inst 
       (.I(lane_data_2[4]),
        .O(lane_data_2_IBUF[4]));
  IBUF \lane_data_2_IBUF[5]_inst 
       (.I(lane_data_2[5]),
        .O(lane_data_2_IBUF[5]));
  IBUF \lane_data_2_IBUF[6]_inst 
       (.I(lane_data_2[6]),
        .O(lane_data_2_IBUF[6]));
  IBUF \lane_data_2_IBUF[7]_inst 
       (.I(lane_data_2[7]),
        .O(lane_data_2_IBUF[7]));
  IBUF \lane_data_3_IBUF[0]_inst 
       (.I(lane_data_3[0]),
        .O(lane_data_3_IBUF[0]));
  IBUF \lane_data_3_IBUF[1]_inst 
       (.I(lane_data_3[1]),
        .O(lane_data_3_IBUF[1]));
  IBUF \lane_data_3_IBUF[2]_inst 
       (.I(lane_data_3[2]),
        .O(lane_data_3_IBUF[2]));
  IBUF \lane_data_3_IBUF[3]_inst 
       (.I(lane_data_3[3]),
        .O(lane_data_3_IBUF[3]));
  IBUF \lane_data_3_IBUF[4]_inst 
       (.I(lane_data_3[4]),
        .O(lane_data_3_IBUF[4]));
  IBUF \lane_data_3_IBUF[5]_inst 
       (.I(lane_data_3[5]),
        .O(lane_data_3_IBUF[5]));
  IBUF \lane_data_3_IBUF[6]_inst 
       (.I(lane_data_3[6]),
        .O(lane_data_3_IBUF[6]));
  IBUF \lane_data_3_IBUF[7]_inst 
       (.I(lane_data_3[7]),
        .O(lane_data_3_IBUF[7]));
  IBUF lane_valid_0_IBUF_inst
       (.I(lane_valid_0),
        .O(lane_valid_0_IBUF));
  IBUF lane_valid_1_IBUF_inst
       (.I(lane_valid_1),
        .O(lane_valid_1_IBUF));
  IBUF lane_valid_2_IBUF_inst
       (.I(lane_valid_2),
        .O(lane_valid_2_IBUF));
  IBUF lane_valid_3_IBUF_inst
       (.I(lane_valid_3),
        .O(lane_valid_3_IBUF));
  OBUF line_end_o_OBUF_inst
       (.I(line_end_o_OBUF),
        .O(line_end_o));
  OBUF line_start_o_OBUF_inst
       (.I(line_start_o_OBUF),
        .O(line_start_o));
  IBUF lp_mode_IBUF_inst
       (.I(lp_mode),
        .O(lp_mode_IBUF));
  OBUF \pixel_data_o_OBUF[0]_inst 
       (.I(pixel_data_o_OBUF[0]),
        .O(pixel_data_o[0]));
  OBUF \pixel_data_o_OBUF[10]_inst 
       (.I(pixel_data_o_OBUF[10]),
        .O(pixel_data_o[10]));
  OBUF \pixel_data_o_OBUF[11]_inst 
       (.I(pixel_data_o_OBUF[11]),
        .O(pixel_data_o[11]));
  OBUF \pixel_data_o_OBUF[12]_inst 
       (.I(pixel_data_o_OBUF[12]),
        .O(pixel_data_o[12]));
  OBUF \pixel_data_o_OBUF[13]_inst 
       (.I(pixel_data_o_OBUF[13]),
        .O(pixel_data_o[13]));
  OBUF \pixel_data_o_OBUF[14]_inst 
       (.I(pixel_data_o_OBUF[14]),
        .O(pixel_data_o[14]));
  OBUF \pixel_data_o_OBUF[15]_inst 
       (.I(pixel_data_o_OBUF[15]),
        .O(pixel_data_o[15]));
  OBUF \pixel_data_o_OBUF[16]_inst 
       (.I(pixel_data_o_OBUF[16]),
        .O(pixel_data_o[16]));
  OBUF \pixel_data_o_OBUF[17]_inst 
       (.I(pixel_data_o_OBUF[17]),
        .O(pixel_data_o[17]));
  OBUF \pixel_data_o_OBUF[18]_inst 
       (.I(pixel_data_o_OBUF[18]),
        .O(pixel_data_o[18]));
  OBUF \pixel_data_o_OBUF[19]_inst 
       (.I(pixel_data_o_OBUF[19]),
        .O(pixel_data_o[19]));
  OBUF \pixel_data_o_OBUF[1]_inst 
       (.I(pixel_data_o_OBUF[1]),
        .O(pixel_data_o[1]));
  OBUF \pixel_data_o_OBUF[20]_inst 
       (.I(pixel_data_o_OBUF[20]),
        .O(pixel_data_o[20]));
  OBUF \pixel_data_o_OBUF[21]_inst 
       (.I(pixel_data_o_OBUF[21]),
        .O(pixel_data_o[21]));
  OBUF \pixel_data_o_OBUF[22]_inst 
       (.I(pixel_data_o_OBUF[22]),
        .O(pixel_data_o[22]));
  OBUF \pixel_data_o_OBUF[23]_inst 
       (.I(pixel_data_o_OBUF[23]),
        .O(pixel_data_o[23]));
  OBUF \pixel_data_o_OBUF[2]_inst 
       (.I(pixel_data_o_OBUF[2]),
        .O(pixel_data_o[2]));
  OBUF \pixel_data_o_OBUF[3]_inst 
       (.I(pixel_data_o_OBUF[3]),
        .O(pixel_data_o[3]));
  OBUF \pixel_data_o_OBUF[4]_inst 
       (.I(pixel_data_o_OBUF[4]),
        .O(pixel_data_o[4]));
  OBUF \pixel_data_o_OBUF[5]_inst 
       (.I(pixel_data_o_OBUF[5]),
        .O(pixel_data_o[5]));
  OBUF \pixel_data_o_OBUF[6]_inst 
       (.I(pixel_data_o_OBUF[6]),
        .O(pixel_data_o[6]));
  OBUF \pixel_data_o_OBUF[7]_inst 
       (.I(pixel_data_o_OBUF[7]),
        .O(pixel_data_o[7]));
  OBUF \pixel_data_o_OBUF[8]_inst 
       (.I(pixel_data_o_OBUF[8]),
        .O(pixel_data_o[8]));
  OBUF \pixel_data_o_OBUF[9]_inst 
       (.I(pixel_data_o_OBUF[9]),
        .O(pixel_data_o[9]));
  OBUF pixel_sof_o_OBUF_inst
       (.I(pixel_sof_o_OBUF),
        .O(pixel_sof_o));
  OBUF pixel_sol_o_OBUF_inst
       (.I(pixel_sol_o_OBUF),
        .O(pixel_sol_o));
  OBUF pixel_valid_o_OBUF_inst
       (.I(pixel_valid_o_OBUF),
        .O(pixel_valid_o));
  IBUF rst_n_IBUF_inst
       (.I(rst_n),
        .O(rst_n_IBUF));
  axi_write_null_slave u_axi_write_null_slave
       (.D(u_mipi_csi2_capture_top_n_5),
        .Q({u_mipi_csi2_capture_top_n_1,u_mipi_csi2_capture_top_n_2}),
        .aw_seen_q(aw_seen_q),
        .\beats_remaining_q_reg[0]_0 (u_axi_write_null_slave_n_1),
        .\beats_remaining_q_reg[1]_0 (beats_remaining_q),
        .clk_axi_IBUF_BUFG(clk_axi_IBUF_BUFG),
        .m_axi_bvalid(m_axi_bvalid),
        .m_axi_wlast(m_axi_wlast),
        .m_axi_wready(m_axi_wready),
        .p_0_in(p_0_in),
        .rst_n_IBUF(rst_n_IBUF),
        .\state_reg[0] (u_axi_write_null_slave_n_2),
        .\state_reg[0]_0 (u_mipi_csi2_capture_top_n_7),
        .\state_reg[1] (u_mipi_csi2_capture_top_n_8),
        .\state_reg[1]_0 (u_mipi_csi2_capture_top_n_6));
  fpga_apb_boot_cfg u_fpga_apb_boot_cfg
       (.cfg_init_done_o_OBUF(cfg_init_done_o_OBUF),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .p_0_in(p_0_in));
  mipi_csi2_capture_top u_mipi_csi2_capture_top
       (.D(u_mipi_csi2_capture_top_n_5),
        .Q({u_mipi_csi2_capture_top_n_1,u_mipi_csi2_capture_top_n_2}),
        .aw_seen_q(aw_seen_q),
        .aw_seen_q_reg(u_mipi_csi2_capture_top_n_7),
        .aw_seen_q_reg_0(u_axi_write_null_slave_n_1),
        .\beats_remaining_q_reg[0] (u_mipi_csi2_capture_top_n_6),
        .\beats_remaining_q_reg[0]_0 (beats_remaining_q),
        .clk_axi_IBUF_BUFG(clk_axi_IBUF_BUFG),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .clk_wr(clk_byte_IBUF_BUFG),
        .err_crc_o_OBUF(err_crc_o_OBUF),
        .err_ecc_o_OBUF(err_ecc_o_OBUF),
        .frame_end(frame_end_o_OBUF),
        .frame_start(frame_start_o_OBUF),
        .hs_mode_IBUF(hs_mode_IBUF),
        .\lane_data_i[0] (lane_data_0_IBUF),
        .\lane_data_i[1] (lane_data_1_IBUF),
        .\lane_data_i[2] (lane_data_2_IBUF),
        .\lane_data_i[3] (lane_data_3_IBUF),
        .lane_valid_0_IBUF(lane_valid_0_IBUF),
        .lane_valid_1_IBUF(lane_valid_1_IBUF),
        .lane_valid_2_IBUF(lane_valid_2_IBUF),
        .lane_valid_3_IBUF(lane_valid_3_IBUF),
        .line_end(line_end_o_OBUF),
        .line_start(line_start_o_OBUF),
        .lp_mode_IBUF(lp_mode_IBUF),
        .m_axi_bvalid(m_axi_bvalid),
        .m_axi_wlast(m_axi_wlast),
        .m_axi_wready(m_axi_wready),
        .p_0_in(p_0_in),
        .\pixel_data_o[23] (pixel_data_o_OBUF),
        .pixel_sof_o_OBUF(pixel_sof_o_OBUF),
        .pixel_sol_o_OBUF(pixel_sol_o_OBUF),
        .pixel_valid_o_OBUF(pixel_valid_o_OBUF),
        .rst_n_IBUF(rst_n_IBUF),
        .s_axi_bvalid_o_reg(u_mipi_csi2_capture_top_n_8),
        .s_axi_bvalid_o_reg_0(u_axi_write_null_slave_n_2),
        .sync_error(err_sync_o_OBUF));
endmodule

module mipi_csi2_capture_top
   (p_0_in,
    Q,
    m_axi_wlast,
    sync_error,
    D,
    \beats_remaining_q_reg[0] ,
    aw_seen_q_reg,
    s_axi_bvalid_o_reg,
    frame_start,
    frame_end,
    line_start,
    line_end,
    \pixel_data_o[23] ,
    pixel_valid_o_OBUF,
    pixel_sof_o_OBUF,
    pixel_sol_o_OBUF,
    err_crc_o_OBUF,
    err_ecc_o_OBUF,
    clk_axi_IBUF_BUFG,
    clk_sys_IBUF_BUFG,
    clk_wr,
    rst_n_IBUF,
    s_axi_bvalid_o_reg_0,
    m_axi_wready,
    \beats_remaining_q_reg[0]_0 ,
    aw_seen_q_reg_0,
    aw_seen_q,
    m_axi_bvalid,
    lp_mode_IBUF,
    hs_mode_IBUF,
    lane_valid_2_IBUF,
    lane_valid_0_IBUF,
    lane_valid_1_IBUF,
    lane_valid_3_IBUF,
    \lane_data_i[3] ,
    \lane_data_i[2] ,
    \lane_data_i[1] ,
    \lane_data_i[0] );
  output p_0_in;
  output [1:0]Q;
  output m_axi_wlast;
  output sync_error;
  output [0:0]D;
  output \beats_remaining_q_reg[0] ;
  output aw_seen_q_reg;
  output s_axi_bvalid_o_reg;
  output frame_start;
  output frame_end;
  output line_start;
  output line_end;
  output [23:0]\pixel_data_o[23] ;
  output pixel_valid_o_OBUF;
  output pixel_sof_o_OBUF;
  output pixel_sol_o_OBUF;
  output err_crc_o_OBUF;
  output err_ecc_o_OBUF;
  input clk_axi_IBUF_BUFG;
  input clk_sys_IBUF_BUFG;
  input clk_wr;
  input rst_n_IBUF;
  input s_axi_bvalid_o_reg_0;
  input m_axi_wready;
  input [0:0]\beats_remaining_q_reg[0]_0 ;
  input aw_seen_q_reg_0;
  input aw_seen_q;
  input m_axi_bvalid;
  input lp_mode_IBUF;
  input hs_mode_IBUF;
  input lane_valid_2_IBUF;
  input lane_valid_0_IBUF;
  input lane_valid_1_IBUF;
  input lane_valid_3_IBUF;
  input [7:0]\lane_data_i[3] ;
  input [7:0]\lane_data_i[2] ;
  input [7:0]\lane_data_i[1] ;
  input [7:0]\lane_data_i[0] ;

  wire \<const0> ;
  wire \<const1> ;
  wire [0:0]D;
  wire [1:0]Q;
  wire active;
  wire active0;
  wire [2:1]active_lane_num;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]active_lane_num_byte;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [2:0]active_lane_num_meta_byte;
  wire aw_seen_q;
  wire aw_seen_q_reg;
  wire aw_seen_q_reg_0;
  wire axi_clear_busy;
  wire \beats_remaining_q_reg[0] ;
  wire [0:0]\beats_remaining_q_reg[0]_0 ;
  wire byte0_reg;
  wire byte1_reg;
  wire [1:0]byte_idx;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [3:0]cfg_lane_enable_mask_byte;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [3:0]cfg_lane_enable_mask_meta_byte;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [1:0]cfg_lane_num_byte;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire [1:0]cfg_lane_num_meta_byte;
  wire clk_axi_IBUF_BUFG;
  wire clk_sys_IBUF_BUFG;
  wire clk_wr;
  wire [11:8]crc16_next_byte_return;
  wire crc_error;
  wire crc_start;
  wire crc_valid;
  wire [7:0]\deskew_data[0]_72 ;
  wire [7:0]\deskew_data[1]_71 ;
  wire [7:0]\deskew_data[2]_70 ;
  wire [7:0]\deskew_data[3]_69 ;
  wire deskew_valid;
  wire err_crc_o_OBUF;
  wire err_ecc_o_OBUF;
  wire err_valid;
  wire [7:0]expected_crc;
  wire [7:0]fifo_rd_data;
  wire [15:11]finish_crc;
  wire frame_end;
  wire frame_start;
  wire hs_mode_IBUF;
  wire [7:0]\lane_data_i[0] ;
  wire [7:0]\lane_data_i[1] ;
  wire [7:0]\lane_data_i[2] ;
  wire [7:0]\lane_data_i[3] ;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire lane_err_sync;
  wire lane_err_sync_d;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire lane_err_sync_meta;
  wire lane_err_toggle_byte;
  wire lane_valid_0_IBUF;
  wire lane_valid_1_IBUF;
  wire lane_valid_2_IBUF;
  wire lane_valid_3_IBUF;
  wire line_end;
  wire line_start;
  wire lp_mode_IBUF;
  wire m_axi_bvalid;
  wire m_axi_wlast;
  wire m_axi_wready;
  wire [7:0]merge_byte_data;
  wire merge_byte_valid;
  wire p_0_in;
  wire p_0_in2_in;
  wire [9:0]p_0_in_1;
  wire [5:0]payload_dt_reg;
  wire payload_sof_i0;
  wire payload_sol_i0;
  wire payload_valid_i01_out;
  wire payload_valid_i03_out;
  wire pending_sof;
  wire pending_sol;
  wire pending_sol_reg_n_0;
  wire [23:0]\pixel_data_o[23] ;
  wire pixel_sof_o;
  wire pixel_sof_o3_out;
  wire pixel_sof_o_OBUF;
  wire pixel_sol_o;
  wire pixel_sol_o1_out;
  wire pixel_sol_o_OBUF;
  wire pixel_valid_o_OBUF;
  wire [5:0]pkt_dt;
  wire [9:8]raw10_pixel_data;
  wire raw10_pixel_valid;
  wire raw8_pixel_valid;
  wire [23:0]repack_pixel_data;
  wire repack_pixel_valid;
  wire resync_drop_packet;
  wire resync_req_d;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire resync_toggle_byte;
  wire resync_toggle_byte_d;
  (* async_reg = "true" *) (* shreg_extract = "no" *) wire resync_toggle_meta_byte;
  wire resync_toggle_sys;
  wire [9:0]rgb888_pixel_data;
  wire rgb888_pixel_sof;
  wire rgb888_pixel_sol;
  wire rgb888_pixel_valid;
  wire rst_n_IBUF;
  wire s_axi_bvalid_o_reg;
  wire s_axi_bvalid_o_reg_0;
  wire sol_reg;
  wire sync_error;
  wire u_byte_to_sys_fifo_n_0;
  wire u_byte_to_sys_fifo_n_1;
  wire u_byte_to_sys_fifo_n_10;
  wire u_byte_to_sys_fifo_n_15;
  wire u_byte_to_sys_fifo_n_19;
  wire u_csi2_long_packet_parser_n_10;
  wire u_csi2_long_packet_parser_n_11;
  wire u_csi2_long_packet_parser_n_12;
  wire u_csi2_long_packet_parser_n_13;
  wire u_csi2_long_packet_parser_n_14;
  wire u_csi2_long_packet_parser_n_15;
  wire u_csi2_long_packet_parser_n_16;
  wire u_csi2_long_packet_parser_n_17;
  wire u_csi2_long_packet_parser_n_18;
  wire u_csi2_long_packet_parser_n_21;
  wire u_csi2_long_packet_parser_n_24;
  wire u_csi2_long_packet_parser_n_27;
  wire u_csi2_long_packet_parser_n_28;
  wire u_csi2_long_packet_parser_n_29;
  wire u_csi2_long_packet_parser_n_30;
  wire u_csi2_long_packet_parser_n_31;
  wire u_csi2_long_packet_parser_n_32;
  wire u_csi2_long_packet_parser_n_33;
  wire u_csi2_long_packet_parser_n_35;
  wire u_csi2_long_packet_parser_n_38;
  wire u_csi2_long_packet_parser_n_41;
  wire u_csi2_long_packet_parser_n_42;
  wire u_csi2_long_packet_parser_n_43;
  wire u_csi2_long_packet_parser_n_45;
  wire u_csi2_long_packet_parser_n_54;
  wire u_csi2_long_packet_parser_n_6;
  wire u_csi2_long_packet_parser_n_7;
  wire u_csi2_long_packet_parser_n_8;
  wire u_csi2_long_packet_parser_n_9;
  wire u_frame_line_sync_fsm_n_5;
  wire u_frame_line_sync_fsm_n_6;
  wire u_frame_line_sync_fsm_n_7;
  wire u_frame_line_sync_fsm_n_8;
  wire u_lane_deskew_buffer_n_0;
  wire u_lane_deskew_buffer_n_1;
  wire u_lane_deskew_buffer_n_3;
  wire u_payload_crc_checker_n_11;
  wire u_payload_crc_checker_n_13;
  wire u_payload_crc_checker_n_14;
  wire u_payload_crc_checker_n_15;
  wire u_payload_crc_checker_n_16;
  wire u_payload_crc_checker_n_17;
  wire u_payload_crc_checker_n_18;
  wire u_payload_crc_checker_n_19;
  wire u_payload_crc_checker_n_20;
  wire u_payload_crc_checker_n_21;
  wire u_payload_crc_checker_n_22;
  wire u_payload_crc_checker_n_23;
  wire u_preprocess_bypass_mux_n_0;
  wire u_preprocess_bypass_mux_n_1;
  wire u_preprocess_bypass_mux_n_2;
  wire u_preprocess_bypass_mux_n_3;
  wire u_raw10_unpack_n_1;
  wire u_raw10_unpack_n_2;
  wire u_raw8_unpack_n_10;
  wire u_raw8_unpack_n_3;
  wire u_raw8_unpack_n_4;
  wire u_raw8_unpack_n_5;
  wire u_raw8_unpack_n_6;
  wire u_raw8_unpack_n_7;
  wire u_raw8_unpack_n_8;
  wire u_raw8_unpack_n_9;
  wire u_resync_ctrl_fsm_n_1;
  wire u_resync_ctrl_fsm_n_2;
  wire u_resync_ctrl_fsm_n_3;
  wire u_rgb888_unpack_n_26;
  wire u_rgb888_unpack_n_28;
  wire u_yuv422_unpack_n_0;
  wire u_yuv422_unpack_n_1;
  wire u_yuv422_unpack_n_19;
  wire u_yuv422_unpack_n_2;
  wire u_yuv422_unpack_n_20;
  wire u_yuv422_unpack_n_21;
  wire u_yuv422_unpack_n_22;
  wire u_yuv422_unpack_n_23;
  wire u_yuv422_unpack_n_24;
  wire u_yuv422_unpack_n_25;
  wire u_yuv422_unpack_n_28;
  wire u_yuv422_unpack_n_3;
  wire u_yuv422_unpack_n_4;
  wire [23:10]yuv422_pixel_data;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \active_lane_num_byte_reg[0] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(active_lane_num_meta_byte[0]),
        .Q(active_lane_num_byte[0]),
        .R(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \active_lane_num_byte_reg[1] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(active_lane_num_meta_byte[1]),
        .Q(active_lane_num_byte[1]),
        .R(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDSE #(
    .INIT(1'b1)) 
    \active_lane_num_byte_reg[2] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(active_lane_num_meta_byte[2]),
        .Q(active_lane_num_byte[2]),
        .S(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \active_lane_num_meta_byte_reg[0] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(active_lane_num_meta_byte[0]),
        .R(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \active_lane_num_meta_byte_reg[1] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(active_lane_num[1]),
        .Q(active_lane_num_meta_byte[1]),
        .R(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDSE #(
    .INIT(1'b1)) 
    \active_lane_num_meta_byte_reg[2] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(active_lane_num[2]),
        .Q(active_lane_num_meta_byte[2]),
        .S(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDSE #(
    .INIT(1'b1)) 
    \cfg_lane_enable_mask_byte_reg[0] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(cfg_lane_enable_mask_meta_byte[0]),
        .Q(cfg_lane_enable_mask_byte[0]),
        .S(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDSE #(
    .INIT(1'b1)) 
    \cfg_lane_enable_mask_byte_reg[1] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(cfg_lane_enable_mask_meta_byte[1]),
        .Q(cfg_lane_enable_mask_byte[1]),
        .S(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \cfg_lane_enable_mask_byte_reg[2] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(cfg_lane_enable_mask_meta_byte[2]),
        .Q(cfg_lane_enable_mask_byte[2]),
        .R(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \cfg_lane_enable_mask_byte_reg[3] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(cfg_lane_enable_mask_meta_byte[3]),
        .Q(cfg_lane_enable_mask_byte[3]),
        .R(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDSE #(
    .INIT(1'b1)) 
    \cfg_lane_enable_mask_meta_byte_reg[0] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(\<const1> ),
        .Q(cfg_lane_enable_mask_meta_byte[0]),
        .S(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDSE #(
    .INIT(1'b1)) 
    \cfg_lane_enable_mask_meta_byte_reg[1] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(\<const1> ),
        .Q(cfg_lane_enable_mask_meta_byte[1]),
        .S(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \cfg_lane_enable_mask_meta_byte_reg[2] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(cfg_lane_enable_mask_meta_byte[2]),
        .R(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \cfg_lane_enable_mask_meta_byte_reg[3] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(cfg_lane_enable_mask_meta_byte[3]),
        .R(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDSE #(
    .INIT(1'b1)) 
    \cfg_lane_num_byte_reg[0] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(cfg_lane_num_meta_byte[0]),
        .Q(cfg_lane_num_byte[0]),
        .S(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \cfg_lane_num_byte_reg[1] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(cfg_lane_num_meta_byte[1]),
        .Q(cfg_lane_num_byte[1]),
        .R(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDSE #(
    .INIT(1'b1)) 
    \cfg_lane_num_meta_byte_reg[0] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(\<const1> ),
        .Q(cfg_lane_num_meta_byte[0]),
        .S(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    \cfg_lane_num_meta_byte_reg[1] 
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(\<const0> ),
        .Q(cfg_lane_num_meta_byte[1]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    lane_err_sync_d_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(lane_err_sync),
        .Q(lane_err_sync_d),
        .R(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    lane_err_sync_meta_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(lane_err_toggle_byte),
        .Q(lane_err_sync_meta),
        .R(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    lane_err_sync_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(lane_err_sync_meta),
        .Q(lane_err_sync),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    lane_err_toggle_byte_reg
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(u_lane_deskew_buffer_n_0),
        .Q(lane_err_toggle_byte),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \payload_dt_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_start),
        .D(pkt_dt[0]),
        .Q(payload_dt_reg[0]),
        .R(u_resync_ctrl_fsm_n_3));
  FDSE #(
    .INIT(1'b1)) 
    \payload_dt_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_start),
        .D(pkt_dt[1]),
        .Q(payload_dt_reg[1]),
        .S(u_resync_ctrl_fsm_n_3));
  FDRE #(
    .INIT(1'b0)) 
    \payload_dt_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_start),
        .D(pkt_dt[2]),
        .Q(payload_dt_reg[2]),
        .R(u_resync_ctrl_fsm_n_3));
  FDSE #(
    .INIT(1'b1)) 
    \payload_dt_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_start),
        .D(pkt_dt[3]),
        .Q(payload_dt_reg[3]),
        .S(u_resync_ctrl_fsm_n_3));
  FDRE #(
    .INIT(1'b0)) 
    \payload_dt_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_start),
        .D(pkt_dt[4]),
        .Q(payload_dt_reg[4]),
        .R(u_resync_ctrl_fsm_n_3));
  FDSE #(
    .INIT(1'b1)) 
    \payload_dt_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(crc_start),
        .D(pkt_dt[5]),
        .Q(payload_dt_reg[5]),
        .S(u_resync_ctrl_fsm_n_3));
  FDRE #(
    .INIT(1'b0)) 
    pending_sof_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(u_frame_line_sync_fsm_n_7),
        .Q(pending_sof),
        .R(pending_sol));
  FDRE #(
    .INIT(1'b0)) 
    pending_sol_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(u_frame_line_sync_fsm_n_8),
        .Q(pending_sol_reg_n_0),
        .R(pending_sol));
  FDRE #(
    .INIT(1'b0)) 
    resync_req_d_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(resync_drop_packet),
        .Q(resync_req_d),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    resync_toggle_byte_d_reg
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(resync_toggle_byte),
        .Q(resync_toggle_byte_d),
        .R(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    resync_toggle_byte_reg
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(resync_toggle_meta_byte),
        .Q(resync_toggle_byte),
        .R(p_0_in));
  (* ASYNC_REG *) 
  (* KEEP = "yes" *) 
  (* SHREG_EXTRACT = "no" *) 
  FDRE #(
    .INIT(1'b0)) 
    resync_toggle_meta_byte_reg
       (.C(clk_wr),
        .CE(\<const1> ),
        .D(resync_toggle_sys),
        .Q(resync_toggle_meta_byte),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    resync_toggle_sys_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(u_resync_ctrl_fsm_n_1),
        .Q(resync_toggle_sys),
        .R(p_0_in));
  async_fifo u_byte_to_sys_fifo
       (.D(crc16_next_byte_return),
        .\FSM_onehot_state_reg[3] (u_csi2_long_packet_parser_n_7),
        .Q({p_0_in_1[6:0],u_payload_crc_checker_n_11}),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .clk_wr(clk_wr),
        .\crc_calc_reg[15] ({finish_crc[15],finish_crc[12:11]}),
        .\crc_calc_reg[15]_0 (u_payload_crc_checker_n_17),
        .crc_error_reg(u_byte_to_sys_fifo_n_1),
        .crc_error_reg_0(u_byte_to_sys_fifo_n_10),
        .crc_error_reg_1(u_byte_to_sys_fifo_n_15),
        .merge_byte_valid(merge_byte_valid),
        .rd_data(fifo_rd_data),
        .\rd_ptr_bin_reg[3]_0 (u_byte_to_sys_fifo_n_19),
        .resync_req_o_reg(u_resync_ctrl_fsm_n_2),
        .resync_toggle_byte_d_reg(u_lane_deskew_buffer_n_3),
        .wr_data(merge_byte_data),
        .\wr_ptr_bin_reg[3]_0 (u_byte_to_sys_fifo_n_0));
  csi2_long_packet_parser u_csi2_long_packet_parser
       (.D(fifo_rd_data),
        .E(byte1_reg),
        .\FSM_onehot_byte_idx_reg[0] (u_csi2_long_packet_parser_n_9),
        .\FSM_onehot_byte_idx_reg[0]_0 (u_csi2_long_packet_parser_n_10),
        .\FSM_onehot_byte_idx_reg[0]_1 (u_csi2_long_packet_parser_n_11),
        .I137(u_csi2_long_packet_parser_n_24),
        .I138(u_csi2_long_packet_parser_n_21),
        .O59(u_rgb888_unpack_n_28),
        .Q(pkt_dt),
        .SR(u_resync_ctrl_fsm_n_3),
        .active(active),
        .active_reg(u_csi2_long_packet_parser_n_30),
        .\byte_idx_reg[1] (payload_valid_i01_out),
        .\byte_idx_reg[1]_0 (byte_idx),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .\crc_calc_reg[15] (u_csi2_long_packet_parser_n_31),
        .\crc_calc_reg[15]_0 (u_csi2_long_packet_parser_n_42),
        .\crc_calc_reg[15]_1 (active0),
        .\crc_calc_reg[5] ({u_payload_crc_checker_n_18,u_payload_crc_checker_n_19,u_payload_crc_checker_n_20,u_payload_crc_checker_n_21,u_payload_crc_checker_n_22,u_payload_crc_checker_n_23}),
        .crc_error(crc_error),
        .crc_error_reg(u_csi2_long_packet_parser_n_41),
        .crc_error_reg_0(u_csi2_long_packet_parser_n_43),
        .crc_error_reg_1(u_csi2_long_packet_parser_n_45),
        .crc_error_reg_2(u_csi2_long_packet_parser_n_54),
        .\crc_reg_reg[10] (p_0_in_1[9]),
        .\crc_reg_reg[7] (u_byte_to_sys_fifo_n_1),
        .crc_valid(crc_valid),
        .crc_valid_reg(u_payload_crc_checker_n_14),
        .crc_valid_reg_0(u_payload_crc_checker_n_15),
        .err_ecc_o_OBUF(err_ecc_o_OBUF),
        .err_valid_o_reg(u_csi2_long_packet_parser_n_6),
        .\expected_crc_reg_reg[0] (u_csi2_long_packet_parser_n_29),
        .\expected_crc_reg_reg[7] (expected_crc),
        .frame_active_reg(u_csi2_long_packet_parser_n_32),
        .frame_active_reg_0(u_frame_line_sync_fsm_n_5),
        .frame_end_reg(u_csi2_long_packet_parser_n_16),
        .frame_start_reg(u_csi2_long_packet_parser_n_13),
        .in1(u_csi2_long_packet_parser_n_8),
        .lane_err_sync_d(lane_err_sync_d),
        .line_active_reg(u_csi2_long_packet_parser_n_33),
        .line_active_reg_0(u_frame_line_sync_fsm_n_6),
        .line_end_reg(u_csi2_long_packet_parser_n_17),
        .line_start_reg(u_csi2_long_packet_parser_n_15),
        .out(lane_err_sync),
        .out11(p_0_in2_in),
        .payload_done_reg(u_payload_crc_checker_n_16),
        .\payload_dt_reg_reg[0] (crc_start),
        .\payload_dt_reg_reg[0]_0 (u_rgb888_unpack_n_26),
        .\payload_dt_reg_reg[2] (u_preprocess_bypass_mux_n_2),
        .\payload_dt_reg_reg[2]_0 (u_preprocess_bypass_mux_n_1),
        .\payload_dt_reg_reg[3] (u_preprocess_bypass_mux_n_0),
        .\payload_dt_reg_reg[5] (u_preprocess_bypass_mux_n_3),
        .\payload_dt_reg_reg[5]_0 (payload_dt_reg),
        .\payload_dt_reg_reg[5]_1 (u_payload_crc_checker_n_13),
        .payload_sof_i(payload_sof_i0),
        .payload_sol_i(payload_sol_i0),
        .pending_sof(pending_sof),
        .pending_sol(pending_sol),
        .pending_sol_reg(u_csi2_long_packet_parser_n_12),
        .pending_sol_reg_0(u_csi2_long_packet_parser_n_35),
        .pending_sol_reg_1(u_csi2_long_packet_parser_n_38),
        .pending_sol_reg_2(pending_sol_reg_n_0),
        .\pixel_data_o_reg[0] (payload_valid_i03_out),
        .pixel_sof_o3_out(pixel_sof_o3_out),
        .pixel_sof_o_reg(u_csi2_long_packet_parser_n_27),
        .pixel_sol_o1_out(pixel_sol_o1_out),
        .pixel_sol_o_reg(u_csi2_long_packet_parser_n_28),
        .pixel_valid_o(rgb888_pixel_valid),
        .raw10_pixel_valid(raw10_pixel_valid),
        .\rd_ptr_bin_reg[3] (u_csi2_long_packet_parser_n_7),
        .\rd_ptr_gray_reg[3] (u_byte_to_sys_fifo_n_19),
        .resync_drop_packet(resync_drop_packet),
        .resync_req_d(resync_req_d),
        .resync_req_o_reg(u_resync_ctrl_fsm_n_2),
        .rst_n(p_0_in),
        .rst_n_IBUF(rst_n_IBUF),
        .sof_reg(byte0_reg),
        .sol_reg(sol_reg),
        .state_reg(u_yuv422_unpack_n_0),
        .sync_error_reg(u_csi2_long_packet_parser_n_14),
        .sync_error_reg_0(u_csi2_long_packet_parser_n_18),
        .sync_error_reg_1(sync_error));
  degrade_recover_fsm u_degrade_recover_fsm
       (.Q(active_lane_num),
        .SR(p_0_in),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .err_valid(err_valid),
        .frame_end_reg(frame_end),
        .lane_err_sync_d(lane_err_sync_d),
        .out(lane_err_sync),
        .rst_n_IBUF(rst_n_IBUF));
  err_classifier u_err_classifier
       (.SR(p_0_in),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .err_valid(err_valid),
        .lane_err_sync_reg(u_csi2_long_packet_parser_n_6));
  frame_line_sync_fsm u_frame_line_sync_fsm
       (.clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .\dt_reg[0] (u_csi2_long_packet_parser_n_17),
        .\dt_reg[0]_0 (u_csi2_long_packet_parser_n_14),
        .\dt_reg[0]_1 (u_csi2_long_packet_parser_n_32),
        .\dt_reg[1] (u_csi2_long_packet_parser_n_13),
        .frame_active_reg_0(u_frame_line_sync_fsm_n_5),
        .frame_active_reg_1(u_csi2_long_packet_parser_n_16),
        .frame_active_reg_2(u_csi2_long_packet_parser_n_15),
        .frame_end(frame_end),
        .frame_start(frame_start),
        .line_active_reg_0(u_frame_line_sync_fsm_n_6),
        .line_active_reg_1(u_csi2_long_packet_parser_n_33),
        .line_end(line_end),
        .line_start(line_start),
        .pending_sof(pending_sof),
        .pending_sof_reg(u_frame_line_sync_fsm_n_7),
        .pending_sol_reg(u_frame_line_sync_fsm_n_8),
        .pending_sol_reg_0(pending_sol_reg_n_0),
        .resync_req_d_reg(u_csi2_long_packet_parser_n_18),
        .resync_req_o_reg(u_resync_ctrl_fsm_n_2),
        .state_reg(sync_error));
  lane_deskew_buffer u_lane_deskew_buffer
       (.\active_lane_num_byte_reg[2] (active_lane_num_byte),
        .\cfg_lane_enable_mask_byte_reg[3] (cfg_lane_enable_mask_byte),
        .\cfg_lane_num_byte_reg[1] (cfg_lane_num_byte),
        .clk_wr(clk_wr),
        .deskew_valid(deskew_valid),
        .hs_mode_IBUF(hs_mode_IBUF),
        .\lane_data_i[0] (\lane_data_i[0] ),
        .\lane_data_i[1] (\lane_data_i[1] ),
        .\lane_data_i[2] (\lane_data_i[2] ),
        .\lane_data_i[3] (\lane_data_i[3] ),
        .lane_err_toggle_byte(lane_err_toggle_byte),
        .lane_err_toggle_byte_reg(u_lane_deskew_buffer_n_0),
        .\lane_group_data_i[0] (\deskew_data[0]_72 ),
        .\lane_group_data_i[1] (\deskew_data[1]_71 ),
        .\lane_group_data_i[2] (\deskew_data[2]_70 ),
        .\lane_group_data_i[3] (\deskew_data[3]_69 ),
        .lane_valid_0_IBUF(lane_valid_0_IBUF),
        .lane_valid_1_IBUF(lane_valid_1_IBUF),
        .lane_valid_2_IBUF(lane_valid_2_IBUF),
        .lane_valid_3_IBUF(lane_valid_3_IBUF),
        .lp_mode_IBUF(lp_mode_IBUF),
        .merge_byte_valid(merge_byte_valid),
        .out(resync_toggle_byte),
        .\rd_ptr_reg[3][3]_0 (u_lane_deskew_buffer_n_1),
        .resync_toggle_byte_d(resync_toggle_byte_d),
        .rst_n_IBUF(rst_n_IBUF),
        .\wr_ptr_reg[3][3]_0 (u_lane_deskew_buffer_n_3));
  lane_reorder_merge u_lane_reorder_merge
       (.D(\deskew_data[0]_72 ),
        .E(u_lane_deskew_buffer_n_1),
        .SR(u_lane_deskew_buffer_n_3),
        .active_reg_0(u_byte_to_sys_fifo_n_0),
        .clk_wr(clk_wr),
        .deskew_valid(deskew_valid),
        .merge_byte_valid(merge_byte_valid),
        .out(resync_toggle_byte),
        .\rd_ptr_reg[1][3] (\deskew_data[1]_71 ),
        .\rd_ptr_reg[2][3] (\deskew_data[2]_70 ),
        .\rd_ptr_reg[3][3] (\deskew_data[3]_69 ),
        .resync_toggle_byte_d(resync_toggle_byte_d),
        .rst_n_IBUF(rst_n_IBUF),
        .wr_data(merge_byte_data));
  csi2_payload_crc_checker u_payload_crc_checker
       (.D({finish_crc[15],finish_crc[12:11]}),
        .E(active0),
        .\FSM_onehot_state_reg[6] (u_csi2_long_packet_parser_n_29),
        .\FSM_onehot_state_reg[6]_0 (u_csi2_long_packet_parser_n_30),
        .\FSM_onehot_state_reg[7] (u_csi2_long_packet_parser_n_12),
        .Q({p_0_in_1[9],p_0_in_1[6:0],u_payload_crc_checker_n_11}),
        .active(active),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .\crc_calc_reg[15]_0 (u_byte_to_sys_fifo_n_15),
        .crc_error(crc_error),
        .crc_error_reg_0(u_payload_crc_checker_n_14),
        .crc_error_reg_1({u_payload_crc_checker_n_17,u_payload_crc_checker_n_18,u_payload_crc_checker_n_19,u_payload_crc_checker_n_20,u_payload_crc_checker_n_21,u_payload_crc_checker_n_22,u_payload_crc_checker_n_23}),
        .\crc_lsb_reg_reg[0] (u_csi2_long_packet_parser_n_45),
        .\crc_lsb_reg_reg[3] (u_csi2_long_packet_parser_n_54),
        .\crc_lsb_reg_reg[7] (expected_crc),
        .\crc_reg_reg[10]_0 (u_csi2_long_packet_parser_n_41),
        .\crc_reg_reg[3]_0 (crc16_next_byte_return),
        .\crc_reg_reg[6]_0 (u_byte_to_sys_fifo_n_10),
        .crc_valid(crc_valid),
        .err_crc_o_OBUF(err_crc_o_OBUF),
        .out11(p_0_in2_in),
        .\payload_cnt_reg[0] (u_payload_crc_checker_n_15),
        .\payload_cnt_reg[12] (u_csi2_long_packet_parser_n_42),
        .\payload_cnt_reg[15] (u_csi2_long_packet_parser_n_43),
        .\payload_dt_reg_reg[0] (u_csi2_long_packet_parser_n_31),
        .\payload_dt_reg_reg[0]_0 (u_csi2_long_packet_parser_n_35),
        .\payload_dt_reg_reg[1] (u_csi2_long_packet_parser_n_38),
        .\payload_dt_reg_reg[5] (payload_dt_reg[5:4]),
        .pending_sol_reg(u_payload_crc_checker_n_13),
        .pending_sol_reg_0(u_payload_crc_checker_n_16),
        .rd_data(fifo_rd_data),
        .\rd_ptr_gray_reg[3] (u_byte_to_sys_fifo_n_19),
        .state_reg(u_yuv422_unpack_n_1));
  pixel_to_axi_writer u_pixel_to_axi_writer
       (.D(D),
        .Q(Q),
        .SR(p_0_in),
        .aw_seen_q(aw_seen_q),
        .aw_seen_q_reg(aw_seen_q_reg),
        .aw_seen_q_reg_0(aw_seen_q_reg_0),
        .axi_clear_busy(axi_clear_busy),
        .\beats_remaining_q_reg[0] (\beats_remaining_q_reg[0] ),
        .\beats_remaining_q_reg[0]_0 (\beats_remaining_q_reg[0]_0 ),
        .clk_axi_IBUF_BUFG(clk_axi_IBUF_BUFG),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .m_axi_bvalid(m_axi_bvalid),
        .m_axi_wlast(m_axi_wlast),
        .m_axi_wready(m_axi_wready),
        .resync_drop_packet(resync_drop_packet),
        .resync_req_d(resync_req_d),
        .rst_n_IBUF(rst_n_IBUF),
        .s_axi_bvalid_o_reg(s_axi_bvalid_o_reg),
        .s_axi_bvalid_o_reg_0(s_axi_bvalid_o_reg_0));
  preprocess_bypass_mux u_preprocess_bypass_mux
       (.D(repack_pixel_data),
        .Q(payload_dt_reg),
        .SR(p_0_in),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .\pixel_data_o[23] (\pixel_data_o[23] ),
        .\pixel_data_o_reg[0]_0 (u_preprocess_bypass_mux_n_2),
        .\pixel_data_o_reg[8]_0 (u_preprocess_bypass_mux_n_0),
        .\pixel_data_o_reg[8]_1 (u_preprocess_bypass_mux_n_1),
        .\pixel_data_o_reg[8]_2 (u_preprocess_bypass_mux_n_3),
        .pixel_sof_o_OBUF(pixel_sof_o_OBUF),
        .pixel_sol_o_OBUF(pixel_sol_o_OBUF),
        .pixel_valid_o0(repack_pixel_valid),
        .pixel_valid_o_OBUF(pixel_valid_o_OBUF),
        .rst_n_IBUF(rst_n_IBUF),
        .state_reg(u_raw10_unpack_n_2),
        .state_reg_0(u_raw10_unpack_n_1));
  raw10_unpack u_raw10_unpack
       (.D(repack_pixel_data[7:0]),
        .E(u_csi2_long_packet_parser_n_10),
        .Q(raw10_pixel_data),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .\payload_dt_reg_reg[2] (u_preprocess_bypass_mux_n_1),
        .payload_sof_i(payload_sof_i0),
        .payload_sol_i(payload_sol_i0),
        .\pixel_data_o_reg[0]_0 (u_yuv422_unpack_n_4),
        .\pixel_data_o_reg[1]_0 (u_yuv422_unpack_n_19),
        .\pixel_data_o_reg[2]_0 (u_yuv422_unpack_n_20),
        .\pixel_data_o_reg[3]_0 (u_yuv422_unpack_n_21),
        .\pixel_data_o_reg[4]_0 (u_yuv422_unpack_n_22),
        .\pixel_data_o_reg[5]_0 (u_yuv422_unpack_n_23),
        .\pixel_data_o_reg[6]_0 (u_yuv422_unpack_n_24),
        .\pixel_data_o_reg[7]_0 (u_yuv422_unpack_n_25),
        .pixel_sof_o_reg_0(u_raw10_unpack_n_2),
        .pixel_sof_o_reg_1(u_yuv422_unpack_n_3),
        .pixel_sol_o_reg_0(u_raw10_unpack_n_1),
        .pixel_sol_o_reg_1(u_yuv422_unpack_n_2),
        .pixel_valid_o0(repack_pixel_valid),
        .pixel_valid_o_reg(u_yuv422_unpack_n_28),
        .raw10_pixel_valid(raw10_pixel_valid),
        .\rd_ptr_bin_reg[3] (fifo_rd_data),
        .resync_req_o_reg(u_resync_ctrl_fsm_n_2),
        .state_reg_0(u_csi2_long_packet_parser_n_11));
  raw8_unpack u_raw8_unpack
       (.E(payload_valid_i03_out),
        .Q({u_raw8_unpack_n_3,u_raw8_unpack_n_4,u_raw8_unpack_n_5,u_raw8_unpack_n_6,u_raw8_unpack_n_7,u_raw8_unpack_n_8,u_raw8_unpack_n_9,u_raw8_unpack_n_10}),
        .SR(u_resync_ctrl_fsm_n_3),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .pending_sof_reg(u_csi2_long_packet_parser_n_27),
        .pending_sol_reg(u_csi2_long_packet_parser_n_28),
        .pixel_sof_o(pixel_sof_o),
        .pixel_sol_o(pixel_sol_o),
        .raw8_pixel_valid(raw8_pixel_valid),
        .rd_data(fifo_rd_data));
  resync_ctrl_fsm u_resync_ctrl_fsm
       (.SR(p_0_in),
        .axi_clear_busy(axi_clear_busy),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .out_idx_reg(u_resync_ctrl_fsm_n_2),
        .pixel_sol_o_reg(u_resync_ctrl_fsm_n_3),
        .resync_drop_packet(resync_drop_packet),
        .resync_req_d(resync_req_d),
        .resync_toggle_sys(resync_toggle_sys),
        .resync_toggle_sys_reg(u_resync_ctrl_fsm_n_1),
        .rst_n_IBUF(rst_n_IBUF),
        .sync_error_reg(sync_error));
  rgb888_unpack u_rgb888_unpack
       (.D(repack_pixel_data[23:10]),
        .E(payload_valid_i01_out),
        .I137(u_csi2_long_packet_parser_n_24),
        .I138(u_csi2_long_packet_parser_n_21),
        .O59(u_rgb888_unpack_n_28),
        .Q({payload_dt_reg[5:4],payload_dt_reg[2],payload_dt_reg[0]}),
        .byte_idx(byte_idx),
        .\byte_idx_reg[1]_0 (byte1_reg),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .\payload_dt_reg_reg[3] (u_preprocess_bypass_mux_n_0),
        .\payload_dt_reg_reg[5] (u_preprocess_bypass_mux_n_3),
        .payload_sof_i(payload_sof_i0),
        .payload_sol_i(payload_sol_i0),
        .pixel_data_o(rgb888_pixel_data),
        .\pixel_data_o_reg[23]_0 (yuv422_pixel_data),
        .pixel_sof_o(rgb888_pixel_sof),
        .pixel_sof_o3_out(pixel_sof_o3_out),
        .pixel_sol_o(rgb888_pixel_sol),
        .pixel_sol_o1_out(pixel_sol_o1_out),
        .pixel_sol_o_reg_0(u_rgb888_unpack_n_26),
        .pixel_valid_o(rgb888_pixel_valid),
        .rd_data(fifo_rd_data),
        .resync_req_o_reg(u_resync_ctrl_fsm_n_2),
        .sof_reg(byte0_reg),
        .sol_reg(sol_reg));
  yuv422_unpack u_yuv422_unpack
       (.D(repack_pixel_data[9:8]),
        .E(u_csi2_long_packet_parser_n_8),
        .Q({payload_dt_reg[5:4],payload_dt_reg[2],payload_dt_reg[0]}),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .crc_error_reg(u_yuv422_unpack_n_1),
        .\payload_dt_reg_reg[2] (u_preprocess_bypass_mux_n_2),
        .\payload_dt_reg_reg[2]_0 (u_preprocess_bypass_mux_n_1),
        .\payload_dt_reg_reg[3] (u_preprocess_bypass_mux_n_0),
        .\payload_dt_reg_reg[5] (u_preprocess_bypass_mux_n_3),
        .payload_sof_i(payload_sof_i0),
        .payload_sol_i(payload_sol_i0),
        .pixel_data_o(rgb888_pixel_data),
        .\pixel_data_o_reg[0]_0 (u_yuv422_unpack_n_4),
        .\pixel_data_o_reg[0]_1 (u_yuv422_unpack_n_28),
        .\pixel_data_o_reg[1]_0 (u_yuv422_unpack_n_19),
        .\pixel_data_o_reg[23]_0 (yuv422_pixel_data),
        .\pixel_data_o_reg[2]_0 (u_yuv422_unpack_n_20),
        .\pixel_data_o_reg[3]_0 (u_yuv422_unpack_n_21),
        .\pixel_data_o_reg[4]_0 (u_yuv422_unpack_n_22),
        .\pixel_data_o_reg[5]_0 (u_yuv422_unpack_n_23),
        .\pixel_data_o_reg[6]_0 (u_yuv422_unpack_n_24),
        .\pixel_data_o_reg[7]_0 (u_yuv422_unpack_n_25),
        .\pixel_data_o_reg[7]_1 ({u_raw8_unpack_n_3,u_raw8_unpack_n_4,u_raw8_unpack_n_5,u_raw8_unpack_n_6,u_raw8_unpack_n_7,u_raw8_unpack_n_8,u_raw8_unpack_n_9,u_raw8_unpack_n_10}),
        .\pixel_data_o_reg[9]_0 (raw10_pixel_data),
        .pixel_sof_o(rgb888_pixel_sof),
        .pixel_sof_o_reg_0(u_yuv422_unpack_n_3),
        .pixel_sof_o_reg_1(pixel_sof_o),
        .pixel_sol_o(rgb888_pixel_sol),
        .pixel_sol_o_reg_0(u_yuv422_unpack_n_2),
        .pixel_sol_o_reg_1(pixel_sol_o),
        .pixel_valid_o(rgb888_pixel_valid),
        .pixel_valid_o_reg_0(u_yuv422_unpack_n_0),
        .raw8_pixel_valid(raw8_pixel_valid),
        .rd_data(fifo_rd_data),
        .resync_req_o_reg(u_resync_ctrl_fsm_n_2),
        .state_reg_0(u_csi2_long_packet_parser_n_9));
endmodule

module pixel_to_axi_writer
   (axi_clear_busy,
    Q,
    m_axi_wlast,
    D,
    \beats_remaining_q_reg[0] ,
    aw_seen_q_reg,
    s_axi_bvalid_o_reg,
    SR,
    clk_axi_IBUF_BUFG,
    clk_sys_IBUF_BUFG,
    rst_n_IBUF,
    s_axi_bvalid_o_reg_0,
    m_axi_wready,
    resync_req_d,
    resync_drop_packet,
    \beats_remaining_q_reg[0]_0 ,
    aw_seen_q_reg_0,
    aw_seen_q,
    m_axi_bvalid);
  output axi_clear_busy;
  output [1:0]Q;
  output m_axi_wlast;
  output [0:0]D;
  output \beats_remaining_q_reg[0] ;
  output aw_seen_q_reg;
  output s_axi_bvalid_o_reg;
  input [0:0]SR;
  input clk_axi_IBUF_BUFG;
  input clk_sys_IBUF_BUFG;
  input rst_n_IBUF;
  input s_axi_bvalid_o_reg_0;
  input m_axi_wready;
  input resync_req_d;
  input resync_drop_packet;
  input [0:0]\beats_remaining_q_reg[0]_0 ;
  input aw_seen_q_reg_0;
  input aw_seen_q;
  input m_axi_bvalid;

  wire \<const0> ;
  wire \<const1> ;
  wire [0:0]D;
  wire [1:0]Q;
  wire [0:0]SR;
  wire aw_seen_q;
  wire aw_seen_q_reg;
  wire aw_seen_q_reg_0;
  wire axi_clear_busy;
  wire \beats_remaining_q_reg[0] ;
  wire [0:0]\beats_remaining_q_reg[0]_0 ;
  wire clear_busy_sys_q_i_1_n_0;
  wire clear_commit_sync1_sys;
  wire clear_commit_sync2_d_sys;
  wire clear_commit_sync2_sys;
  wire clear_commit_toggle_axi;
  wire clear_commit_toggle_axi0;
  wire clear_pending_axi_q;
  wire clear_req_sync1_axi;
  wire clear_req_sync2_axi;
  wire clear_req_sync2_d_axi;
  wire clear_req_toggle_sys;
  wire clear_req_toggle_sys_i_1_n_0;
  wire clk_axi_IBUF_BUFG;
  wire clk_sys_IBUF_BUFG;
  wire data_fifo_clear_rd_axi;
  wire data_fifo_clear_wr_sys;
  wire data_fifo_clear_wr_sys0;
  wire data_fifo_rd_valid;
  wire m_axi_bvalid;
  wire m_axi_wlast;
  wire m_axi_wready;
  wire rd_fire;
  wire rd_ptr_bin0;
  wire resync_drop_packet;
  wire resync_req_d;
  wire rst_n_IBUF;
  wire s_axi_bvalid_o_reg;
  wire s_axi_bvalid_o_reg_0;
  wire u_axi_write_master_n_0;
  wire u_axi_write_master_n_10;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT5 #(
    .INIT(32'h909F9090)) 
    clear_busy_sys_q_i_1
       (.I0(clear_commit_sync2_d_sys),
        .I1(clear_commit_sync2_sys),
        .I2(axi_clear_busy),
        .I3(resync_req_d),
        .I4(resync_drop_packet),
        .O(clear_busy_sys_q_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    clear_busy_sys_q_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(clear_busy_sys_q_i_1_n_0),
        .Q(axi_clear_busy),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    clear_commit_sync1_sys_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(clear_commit_toggle_axi),
        .Q(clear_commit_sync1_sys),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    clear_commit_sync2_d_sys_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(clear_commit_sync2_sys),
        .Q(clear_commit_sync2_d_sys),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    clear_commit_sync2_sys_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(clear_commit_sync1_sys),
        .Q(clear_commit_sync2_sys),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    clear_commit_toggle_axi_reg
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(u_axi_write_master_n_10),
        .Q(clear_commit_toggle_axi),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    clear_pending_axi_q_reg
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(u_axi_write_master_n_0),
        .Q(clear_pending_axi_q),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    clear_req_sync1_axi_reg
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(clear_req_toggle_sys),
        .Q(clear_req_sync1_axi),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    clear_req_sync2_axi_reg
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(clear_req_sync1_axi),
        .Q(clear_req_sync2_axi),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    clear_req_sync2_d_axi_reg
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(clear_req_sync2_axi),
        .Q(clear_req_sync2_d_axi),
        .R(SR));
  LUT4 #(
    .INIT(16'hEF10)) 
    clear_req_toggle_sys_i_1
       (.I0(axi_clear_busy),
        .I1(resync_req_d),
        .I2(resync_drop_packet),
        .I3(clear_req_toggle_sys),
        .O(clear_req_toggle_sys_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    clear_req_toggle_sys_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(clear_req_toggle_sys_i_1_n_0),
        .Q(clear_req_toggle_sys),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    data_fifo_clear_rd_axi_reg
       (.C(clk_axi_IBUF_BUFG),
        .CE(\<const1> ),
        .D(clear_commit_toggle_axi0),
        .Q(data_fifo_clear_rd_axi),
        .R(SR));
  LUT4 #(
    .INIT(16'h2080)) 
    data_fifo_clear_wr_sys_i_1
       (.I0(rst_n_IBUF),
        .I1(clear_commit_sync2_d_sys),
        .I2(axi_clear_busy),
        .I3(clear_commit_sync2_sys),
        .O(data_fifo_clear_wr_sys0));
  FDRE #(
    .INIT(1'b0)) 
    data_fifo_clear_wr_sys_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(data_fifo_clear_wr_sys0),
        .Q(data_fifo_clear_wr_sys),
        .R(\<const0> ));
  axi_write_master u_axi_write_master
       (.D(D),
        .E(rd_fire),
        .Q(Q),
        .SR(SR),
        .aw_seen_q(aw_seen_q),
        .aw_seen_q_reg(aw_seen_q_reg),
        .aw_seen_q_reg_0(aw_seen_q_reg_0),
        .\beats_remaining_q_reg[0] (\beats_remaining_q_reg[0] ),
        .\beats_remaining_q_reg[0]_0 (\beats_remaining_q_reg[0]_0 ),
        .clear_commit_toggle_axi(clear_commit_toggle_axi),
        .clear_commit_toggle_axi0(clear_commit_toggle_axi0),
        .clear_commit_toggle_axi_reg(u_axi_write_master_n_10),
        .clear_pending_axi_q(clear_pending_axi_q),
        .clear_pending_axi_q_reg(u_axi_write_master_n_0),
        .clear_req_sync2_axi(clear_req_sync2_axi),
        .clear_req_sync2_d_axi(clear_req_sync2_d_axi),
        .clk_axi_IBUF_BUFG(clk_axi_IBUF_BUFG),
        .data_fifo_rd_valid(data_fifo_rd_valid),
        .m_axi_bvalid(m_axi_bvalid),
        .m_axi_wlast(m_axi_wlast),
        .m_axi_wready(m_axi_wready),
        .rst_n_IBUF(rst_n_IBUF),
        .s_axi_bvalid_o_reg(s_axi_bvalid_o_reg),
        .s_axi_bvalid_o_reg_0(s_axi_bvalid_o_reg_0));
  async_fifo__parameterized1 u_line_cmd_fifo
       (.SR(rd_ptr_bin0),
        .clk_axi_IBUF_BUFG(clk_axi_IBUF_BUFG),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .data_fifo_clear_wr_sys(data_fifo_clear_wr_sys),
        .rst_n_IBUF(rst_n_IBUF));
  async_fifo__parameterized0 u_pixel_data_fifo
       (.E(rd_fire),
        .SR(rd_ptr_bin0),
        .clk_axi_IBUF_BUFG(clk_axi_IBUF_BUFG),
        .clk_sys_IBUF_BUFG(clk_sys_IBUF_BUFG),
        .data_fifo_clear_rd_axi(data_fifo_clear_rd_axi),
        .data_fifo_clear_wr_sys(data_fifo_clear_wr_sys),
        .data_fifo_rd_valid(data_fifo_rd_valid),
        .rst_n_IBUF(rst_n_IBUF));
endmodule

module preprocess_bypass_mux
   (\pixel_data_o_reg[8]_0 ,
    \pixel_data_o_reg[8]_1 ,
    \pixel_data_o_reg[0]_0 ,
    \pixel_data_o_reg[8]_2 ,
    SR,
    \pixel_data_o[23] ,
    pixel_valid_o_OBUF,
    pixel_sof_o_OBUF,
    pixel_sol_o_OBUF,
    Q,
    rst_n_IBUF,
    pixel_valid_o0,
    D,
    clk_sys_IBUF_BUFG,
    state_reg,
    state_reg_0);
  output \pixel_data_o_reg[8]_0 ;
  output \pixel_data_o_reg[8]_1 ;
  output \pixel_data_o_reg[0]_0 ;
  output \pixel_data_o_reg[8]_2 ;
  output [0:0]SR;
  output [23:0]\pixel_data_o[23] ;
  output pixel_valid_o_OBUF;
  output pixel_sof_o_OBUF;
  output pixel_sol_o_OBUF;
  input [5:0]Q;
  input rst_n_IBUF;
  input pixel_valid_o0;
  input [23:0]D;
  input clk_sys_IBUF_BUFG;
  input state_reg;
  input state_reg_0;

  wire \<const1> ;
  wire [23:0]D;
  wire [5:0]Q;
  wire [0:0]SR;
  wire clk_sys_IBUF_BUFG;
  wire [23:0]\pixel_data_o[23] ;
  wire \pixel_data_o_reg[0]_0 ;
  wire \pixel_data_o_reg[8]_0 ;
  wire \pixel_data_o_reg[8]_1 ;
  wire \pixel_data_o_reg[8]_2 ;
  wire pixel_sof_o_OBUF;
  wire pixel_sol_o_OBUF;
  wire pixel_valid_o0;
  wire pixel_valid_o_OBUF;
  wire rst_n_IBUF;
  wire state_reg;
  wire state_reg_0;

  VCC VCC
       (.P(\<const1> ));
  LUT6 #(
    .INIT(64'h0000000400000000)) 
    \byte_idx[1]_i_4 
       (.I0(Q[3]),
        .I1(Q[2]),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(Q[4]),
        .I5(Q[5]),
        .O(\pixel_data_o_reg[8]_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    ecc_valid_i_1
       (.I0(rst_n_IBUF),
        .O(SR));
  LUT6 #(
    .INIT(64'h0000400000000000)) 
    \pixel_data_o[23]_i_3__0 
       (.I0(Q[2]),
        .I1(Q[3]),
        .I2(Q[1]),
        .I3(Q[5]),
        .I4(Q[4]),
        .I5(Q[0]),
        .O(\pixel_data_o_reg[8]_1 ));
  LUT6 #(
    .INIT(64'h0040000000000000)) 
    \pixel_data_o[23]_i_5 
       (.I0(Q[5]),
        .I1(Q[4]),
        .I2(Q[2]),
        .I3(Q[0]),
        .I4(Q[3]),
        .I5(Q[1]),
        .O(\pixel_data_o_reg[8]_2 ));
  LUT6 #(
    .INIT(64'h0000000000004000)) 
    \pixel_data_o[7]_i_2__1 
       (.I0(Q[2]),
        .I1(Q[3]),
        .I2(Q[1]),
        .I3(Q[5]),
        .I4(Q[4]),
        .I5(Q[0]),
        .O(\pixel_data_o_reg[0]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[0]),
        .Q(\pixel_data_o[23] [0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[10] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[10]),
        .Q(\pixel_data_o[23] [10]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[11] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[11]),
        .Q(\pixel_data_o[23] [11]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[12] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[12]),
        .Q(\pixel_data_o[23] [12]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[13] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[13]),
        .Q(\pixel_data_o[23] [13]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[14] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[14]),
        .Q(\pixel_data_o[23] [14]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[15] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[15]),
        .Q(\pixel_data_o[23] [15]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[16] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[16]),
        .Q(\pixel_data_o[23] [16]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[17] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[17]),
        .Q(\pixel_data_o[23] [17]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[18] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[18]),
        .Q(\pixel_data_o[23] [18]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[19] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[19]),
        .Q(\pixel_data_o[23] [19]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[1]),
        .Q(\pixel_data_o[23] [1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[20] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[20]),
        .Q(\pixel_data_o[23] [20]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[21] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[21]),
        .Q(\pixel_data_o[23] [21]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[22] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[22]),
        .Q(\pixel_data_o[23] [22]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[23] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[23]),
        .Q(\pixel_data_o[23] [23]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[2]),
        .Q(\pixel_data_o[23] [2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[3]),
        .Q(\pixel_data_o[23] [3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[4]),
        .Q(\pixel_data_o[23] [4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[5]),
        .Q(\pixel_data_o[23] [5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[6]),
        .Q(\pixel_data_o[23] [6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[7]),
        .Q(\pixel_data_o[23] [7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[8]),
        .Q(\pixel_data_o[23] [8]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_valid_o0),
        .D(D[9]),
        .Q(\pixel_data_o[23] [9]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    pixel_sof_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(state_reg),
        .Q(pixel_sof_o_OBUF),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    pixel_sol_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(state_reg_0),
        .Q(pixel_sol_o_OBUF),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    pixel_valid_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(pixel_valid_o0),
        .Q(pixel_valid_o_OBUF),
        .R(SR));
endmodule

module raw10_unpack
   (raw10_pixel_valid,
    pixel_sol_o_reg_0,
    pixel_sof_o_reg_0,
    D,
    Q,
    pixel_valid_o0,
    state_reg_0,
    \payload_dt_reg_reg[2] ,
    pixel_valid_o_reg,
    pixel_sol_o_reg_1,
    pixel_sof_o_reg_1,
    resync_req_o_reg,
    \pixel_data_o_reg[0]_0 ,
    \pixel_data_o_reg[1]_0 ,
    \pixel_data_o_reg[2]_0 ,
    \pixel_data_o_reg[3]_0 ,
    \pixel_data_o_reg[4]_0 ,
    \pixel_data_o_reg[5]_0 ,
    \pixel_data_o_reg[6]_0 ,
    \pixel_data_o_reg[7]_0 ,
    E,
    clk_sys_IBUF_BUFG,
    \rd_ptr_bin_reg[3] ,
    payload_sof_i,
    payload_sol_i);
  output raw10_pixel_valid;
  output pixel_sol_o_reg_0;
  output pixel_sof_o_reg_0;
  output [7:0]D;
  output [1:0]Q;
  output pixel_valid_o0;
  input state_reg_0;
  input \payload_dt_reg_reg[2] ;
  input pixel_valid_o_reg;
  input pixel_sol_o_reg_1;
  input pixel_sof_o_reg_1;
  input resync_req_o_reg;
  input \pixel_data_o_reg[0]_0 ;
  input \pixel_data_o_reg[1]_0 ;
  input \pixel_data_o_reg[2]_0 ;
  input \pixel_data_o_reg[3]_0 ;
  input \pixel_data_o_reg[4]_0 ;
  input \pixel_data_o_reg[5]_0 ;
  input \pixel_data_o_reg[6]_0 ;
  input \pixel_data_o_reg[7]_0 ;
  input [0:0]E;
  input clk_sys_IBUF_BUFG;
  input [7:0]\rd_ptr_bin_reg[3] ;
  input payload_sof_i;
  input payload_sol_i;

  wire \<const0> ;
  wire \<const1> ;
  wire [7:0]D;
  wire [0:0]E;
  (* RTL_KEEP = "yes" *) wire \FSM_onehot_byte_idx_reg_n_0_[4] ;
  wire \FSM_sequential_out_idx[0]_i_1_n_0 ;
  wire \FSM_sequential_out_idx[1]_i_1_n_0 ;
  wire \FSM_sequential_out_idx[1]_i_2_n_0 ;
  wire [1:0]Q;
  (* RTL_KEEP = "yes" *) wire byte0_reg;
  wire \byte0_reg[7]_i_1_n_0 ;
  wire [7:0]byte0_reg__0;
  (* RTL_KEEP = "yes" *) wire byte1_reg;
  wire \byte1_reg[7]_i_1_n_0 ;
  wire [7:0]byte1_reg__0;
  (* RTL_KEEP = "yes" *) wire byte2_reg;
  wire \byte2_reg[7]_i_1_n_0 ;
  wire [7:0]byte2_reg__0;
  (* RTL_KEEP = "yes" *) wire byte3_reg;
  wire \byte3_reg[7]_i_1_n_0 ;
  wire [7:0]byte3_reg__0;
  wire clk_sys_IBUF_BUFG;
  (* RTL_KEEP = "yes" *) wire [1:0]out_idx;
  wire \payload_dt_reg_reg[2] ;
  wire payload_sof_i;
  wire payload_sol_i;
  wire [9:0]pixel_data_o0_out;
  wire \pixel_data_o[0]_i_2_n_0 ;
  wire \pixel_data_o[1]_i_2_n_0 ;
  wire \pixel_data_o[2]_i_2_n_0 ;
  wire \pixel_data_o[3]_i_2_n_0 ;
  wire \pixel_data_o[4]_i_2_n_0 ;
  wire \pixel_data_o[5]_i_2_n_0 ;
  wire \pixel_data_o[6]_i_2_n_0 ;
  wire \pixel_data_o[7]_i_2_n_0 ;
  wire \pixel_data_o[8]_i_2_n_0 ;
  wire \pixel_data_o[9]_i_2_n_0 ;
  wire \pixel_data_o_reg[0]_0 ;
  wire \pixel_data_o_reg[1]_0 ;
  wire \pixel_data_o_reg[2]_0 ;
  wire \pixel_data_o_reg[3]_0 ;
  wire \pixel_data_o_reg[4]_0 ;
  wire \pixel_data_o_reg[5]_0 ;
  wire \pixel_data_o_reg[6]_0 ;
  wire \pixel_data_o_reg[7]_0 ;
  wire pixel_reg;
  wire \pixel_reg[1][9]_i_1_n_0 ;
  wire \pixel_reg_reg_n_0_[1][0] ;
  wire \pixel_reg_reg_n_0_[1][1] ;
  wire \pixel_reg_reg_n_0_[1][2] ;
  wire \pixel_reg_reg_n_0_[1][3] ;
  wire \pixel_reg_reg_n_0_[1][4] ;
  wire \pixel_reg_reg_n_0_[1][5] ;
  wire \pixel_reg_reg_n_0_[1][6] ;
  wire \pixel_reg_reg_n_0_[1][7] ;
  wire \pixel_reg_reg_n_0_[1][8] ;
  wire \pixel_reg_reg_n_0_[1][9] ;
  wire \pixel_reg_reg_n_0_[2][0] ;
  wire \pixel_reg_reg_n_0_[2][1] ;
  wire \pixel_reg_reg_n_0_[2][2] ;
  wire \pixel_reg_reg_n_0_[2][3] ;
  wire \pixel_reg_reg_n_0_[2][4] ;
  wire \pixel_reg_reg_n_0_[2][5] ;
  wire \pixel_reg_reg_n_0_[2][6] ;
  wire \pixel_reg_reg_n_0_[2][7] ;
  wire \pixel_reg_reg_n_0_[2][8] ;
  wire \pixel_reg_reg_n_0_[2][9] ;
  wire \pixel_reg_reg_n_0_[3][0] ;
  wire \pixel_reg_reg_n_0_[3][1] ;
  wire \pixel_reg_reg_n_0_[3][2] ;
  wire \pixel_reg_reg_n_0_[3][3] ;
  wire \pixel_reg_reg_n_0_[3][4] ;
  wire \pixel_reg_reg_n_0_[3][5] ;
  wire \pixel_reg_reg_n_0_[3][6] ;
  wire \pixel_reg_reg_n_0_[3][7] ;
  wire \pixel_reg_reg_n_0_[3][8] ;
  wire \pixel_reg_reg_n_0_[3][9] ;
  wire pixel_sof_o_i_1_n_0;
  wire pixel_sof_o_i_2__0_n_0;
  wire pixel_sof_o_i_3_n_0;
  wire pixel_sof_o_reg_0;
  wire pixel_sof_o_reg_1;
  wire pixel_sol_o_i_1_n_0;
  wire pixel_sol_o_reg_0;
  wire pixel_sol_o_reg_1;
  wire pixel_valid_o0;
  wire pixel_valid_o_reg;
  wire [7:0]raw10_pixel_data;
  wire raw10_pixel_sof;
  wire raw10_pixel_sol;
  wire raw10_pixel_valid;
  wire [7:0]\rd_ptr_bin_reg[3] ;
  wire resync_req_o_reg;
  wire sof_reg_reg_n_0;
  wire sol_reg_reg_n_0;
  wire state_i_1__1_n_0;
  wire state_reg_0;

  LUT4 #(
    .INIT(16'h0001)) 
    \FSM_onehot_byte_idx[0]_i_1 
       (.I0(byte3_reg),
        .I1(byte2_reg),
        .I2(byte0_reg),
        .I3(byte1_reg),
        .O(pixel_reg));
  (* FSM_ENCODED_STATES = "iSTATE:00001,iSTATE0:00010,iSTATE1:00100,iSTATE2:01000,iSTATE3:10000" *) 
  (* KEEP = "yes" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_byte_idx_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(pixel_reg),
        .Q(byte0_reg),
        .S(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "iSTATE:00001,iSTATE0:00010,iSTATE1:00100,iSTATE2:01000,iSTATE3:10000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_byte_idx_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(byte0_reg),
        .Q(byte1_reg),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "iSTATE:00001,iSTATE0:00010,iSTATE1:00100,iSTATE2:01000,iSTATE3:10000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_byte_idx_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(byte1_reg),
        .Q(byte2_reg),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "iSTATE:00001,iSTATE0:00010,iSTATE1:00100,iSTATE2:01000,iSTATE3:10000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_byte_idx_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(byte2_reg),
        .Q(byte3_reg),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "iSTATE:00001,iSTATE0:00010,iSTATE1:00100,iSTATE2:01000,iSTATE3:10000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_byte_idx_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(byte3_reg),
        .Q(\FSM_onehot_byte_idx_reg_n_0_[4] ),
        .R(resync_req_o_reg));
  LUT2 #(
    .INIT(4'h2)) 
    \FSM_sequential_out_idx[0]_i_1 
       (.I0(raw10_pixel_valid),
        .I1(out_idx[0]),
        .O(\FSM_sequential_out_idx[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAAAABAAAAAAAA)) 
    \FSM_sequential_out_idx[1]_i_1 
       (.I0(raw10_pixel_valid),
        .I1(byte3_reg),
        .I2(byte2_reg),
        .I3(byte0_reg),
        .I4(byte1_reg),
        .I5(state_reg_0),
        .O(\FSM_sequential_out_idx[1]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h28)) 
    \FSM_sequential_out_idx[1]_i_2 
       (.I0(raw10_pixel_valid),
        .I1(out_idx[1]),
        .I2(out_idx[0]),
        .O(\FSM_sequential_out_idx[1]_i_2_n_0 ));
  (* FSM_ENCODED_STATES = "iSTATE:00,iSTATE0:01,iSTATE1:10,iSTATE2:11" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_out_idx_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_sequential_out_idx[1]_i_1_n_0 ),
        .D(\FSM_sequential_out_idx[0]_i_1_n_0 ),
        .Q(out_idx[0]),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "iSTATE:00,iSTATE0:01,iSTATE1:10,iSTATE2:11" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_out_idx_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_sequential_out_idx[1]_i_1_n_0 ),
        .D(\FSM_sequential_out_idx[1]_i_2_n_0 ),
        .Q(out_idx[1]),
        .R(resync_req_o_reg));
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT3 #(
    .INIT(8'h08)) 
    \byte0_reg[7]_i_1 
       (.I0(byte0_reg),
        .I1(state_reg_0),
        .I2(raw10_pixel_valid),
        .O(\byte0_reg[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte0_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [0]),
        .Q(byte0_reg__0[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte0_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [1]),
        .Q(byte0_reg__0[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte0_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [2]),
        .Q(byte0_reg__0[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte0_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [3]),
        .Q(byte0_reg__0[3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte0_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [4]),
        .Q(byte0_reg__0[4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte0_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [5]),
        .Q(byte0_reg__0[5]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte0_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [6]),
        .Q(byte0_reg__0[6]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte0_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [7]),
        .Q(byte0_reg__0[7]),
        .R(resync_req_o_reg));
  LUT3 #(
    .INIT(8'h08)) 
    \byte1_reg[7]_i_1 
       (.I0(byte1_reg),
        .I1(state_reg_0),
        .I2(raw10_pixel_valid),
        .O(\byte1_reg[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte1_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [0]),
        .Q(byte1_reg__0[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte1_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [1]),
        .Q(byte1_reg__0[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte1_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [2]),
        .Q(byte1_reg__0[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte1_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [3]),
        .Q(byte1_reg__0[3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte1_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [4]),
        .Q(byte1_reg__0[4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte1_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [5]),
        .Q(byte1_reg__0[5]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte1_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [6]),
        .Q(byte1_reg__0[6]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte1_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [7]),
        .Q(byte1_reg__0[7]),
        .R(resync_req_o_reg));
  LUT3 #(
    .INIT(8'h08)) 
    \byte2_reg[7]_i_1 
       (.I0(byte2_reg),
        .I1(state_reg_0),
        .I2(raw10_pixel_valid),
        .O(\byte2_reg[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \byte2_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte2_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [0]),
        .Q(byte2_reg__0[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte2_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte2_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [1]),
        .Q(byte2_reg__0[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte2_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte2_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [2]),
        .Q(byte2_reg__0[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte2_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte2_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [3]),
        .Q(byte2_reg__0[3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte2_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte2_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [4]),
        .Q(byte2_reg__0[4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte2_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte2_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [5]),
        .Q(byte2_reg__0[5]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte2_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte2_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [6]),
        .Q(byte2_reg__0[6]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte2_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte2_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [7]),
        .Q(byte2_reg__0[7]),
        .R(resync_req_o_reg));
  LUT3 #(
    .INIT(8'h08)) 
    \byte3_reg[7]_i_1 
       (.I0(byte3_reg),
        .I1(state_reg_0),
        .I2(raw10_pixel_valid),
        .O(\byte3_reg[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \byte3_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte3_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [0]),
        .Q(byte3_reg__0[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte3_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte3_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [1]),
        .Q(byte3_reg__0[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte3_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte3_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [2]),
        .Q(byte3_reg__0[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte3_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte3_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [3]),
        .Q(byte3_reg__0[3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte3_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte3_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [4]),
        .Q(byte3_reg__0[4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte3_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte3_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [5]),
        .Q(byte3_reg__0[5]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte3_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte3_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [6]),
        .Q(byte3_reg__0[6]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte3_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte3_reg[7]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [7]),
        .Q(byte3_reg__0[7]),
        .R(resync_req_o_reg));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[0]_i_1 
       (.I0(\pixel_data_o[0]_i_2_n_0 ),
        .I1(raw10_pixel_valid),
        .I2(\rd_ptr_bin_reg[3] [0]),
        .O(pixel_data_o0_out[0]));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT3 #(
    .INIT(8'hF8)) 
    \pixel_data_o[0]_i_1__0 
       (.I0(raw10_pixel_data[0]),
        .I1(\payload_dt_reg_reg[2] ),
        .I2(\pixel_data_o_reg[0]_0 ),
        .O(D[0]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \pixel_data_o[0]_i_2 
       (.I0(\pixel_reg_reg_n_0_[2][0] ),
        .I1(out_idx[0]),
        .I2(\pixel_reg_reg_n_0_[3][0] ),
        .I3(out_idx[1]),
        .I4(\pixel_reg_reg_n_0_[1][0] ),
        .O(\pixel_data_o[0]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[1]_i_1 
       (.I0(\pixel_data_o[1]_i_2_n_0 ),
        .I1(raw10_pixel_valid),
        .I2(\rd_ptr_bin_reg[3] [1]),
        .O(pixel_data_o0_out[1]));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT3 #(
    .INIT(8'hF8)) 
    \pixel_data_o[1]_i_1__0 
       (.I0(raw10_pixel_data[1]),
        .I1(\payload_dt_reg_reg[2] ),
        .I2(\pixel_data_o_reg[1]_0 ),
        .O(D[1]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \pixel_data_o[1]_i_2 
       (.I0(\pixel_reg_reg_n_0_[2][1] ),
        .I1(out_idx[0]),
        .I2(\pixel_reg_reg_n_0_[3][1] ),
        .I3(out_idx[1]),
        .I4(\pixel_reg_reg_n_0_[1][1] ),
        .O(\pixel_data_o[1]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT3 #(
    .INIT(8'hF8)) 
    \pixel_data_o[23]_i_1__0 
       (.I0(raw10_pixel_valid),
        .I1(\payload_dt_reg_reg[2] ),
        .I2(pixel_valid_o_reg),
        .O(pixel_valid_o0));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[2]_i_1 
       (.I0(\pixel_data_o[2]_i_2_n_0 ),
        .I1(raw10_pixel_valid),
        .I2(byte0_reg__0[0]),
        .O(pixel_data_o0_out[2]));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT3 #(
    .INIT(8'hF8)) 
    \pixel_data_o[2]_i_1__0 
       (.I0(raw10_pixel_data[2]),
        .I1(\payload_dt_reg_reg[2] ),
        .I2(\pixel_data_o_reg[2]_0 ),
        .O(D[2]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \pixel_data_o[2]_i_2 
       (.I0(\pixel_reg_reg_n_0_[2][2] ),
        .I1(out_idx[0]),
        .I2(\pixel_reg_reg_n_0_[3][2] ),
        .I3(out_idx[1]),
        .I4(\pixel_reg_reg_n_0_[1][2] ),
        .O(\pixel_data_o[2]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[3]_i_1 
       (.I0(\pixel_data_o[3]_i_2_n_0 ),
        .I1(raw10_pixel_valid),
        .I2(byte0_reg__0[1]),
        .O(pixel_data_o0_out[3]));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT3 #(
    .INIT(8'hF8)) 
    \pixel_data_o[3]_i_1__0 
       (.I0(raw10_pixel_data[3]),
        .I1(\payload_dt_reg_reg[2] ),
        .I2(\pixel_data_o_reg[3]_0 ),
        .O(D[3]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \pixel_data_o[3]_i_2 
       (.I0(\pixel_reg_reg_n_0_[2][3] ),
        .I1(out_idx[0]),
        .I2(\pixel_reg_reg_n_0_[3][3] ),
        .I3(out_idx[1]),
        .I4(\pixel_reg_reg_n_0_[1][3] ),
        .O(\pixel_data_o[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[4]_i_1 
       (.I0(\pixel_data_o[4]_i_2_n_0 ),
        .I1(raw10_pixel_valid),
        .I2(byte0_reg__0[2]),
        .O(pixel_data_o0_out[4]));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT3 #(
    .INIT(8'hF8)) 
    \pixel_data_o[4]_i_1__0 
       (.I0(raw10_pixel_data[4]),
        .I1(\payload_dt_reg_reg[2] ),
        .I2(\pixel_data_o_reg[4]_0 ),
        .O(D[4]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \pixel_data_o[4]_i_2 
       (.I0(\pixel_reg_reg_n_0_[2][4] ),
        .I1(out_idx[0]),
        .I2(\pixel_reg_reg_n_0_[3][4] ),
        .I3(out_idx[1]),
        .I4(\pixel_reg_reg_n_0_[1][4] ),
        .O(\pixel_data_o[4]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[5]_i_1 
       (.I0(\pixel_data_o[5]_i_2_n_0 ),
        .I1(raw10_pixel_valid),
        .I2(byte0_reg__0[3]),
        .O(pixel_data_o0_out[5]));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT3 #(
    .INIT(8'hF8)) 
    \pixel_data_o[5]_i_1__0 
       (.I0(raw10_pixel_data[5]),
        .I1(\payload_dt_reg_reg[2] ),
        .I2(\pixel_data_o_reg[5]_0 ),
        .O(D[5]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \pixel_data_o[5]_i_2 
       (.I0(\pixel_reg_reg_n_0_[2][5] ),
        .I1(out_idx[0]),
        .I2(\pixel_reg_reg_n_0_[3][5] ),
        .I3(out_idx[1]),
        .I4(\pixel_reg_reg_n_0_[1][5] ),
        .O(\pixel_data_o[5]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[6]_i_1 
       (.I0(\pixel_data_o[6]_i_2_n_0 ),
        .I1(raw10_pixel_valid),
        .I2(byte0_reg__0[4]),
        .O(pixel_data_o0_out[6]));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT3 #(
    .INIT(8'hF8)) 
    \pixel_data_o[6]_i_1__0 
       (.I0(raw10_pixel_data[6]),
        .I1(\payload_dt_reg_reg[2] ),
        .I2(\pixel_data_o_reg[6]_0 ),
        .O(D[6]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \pixel_data_o[6]_i_2 
       (.I0(\pixel_reg_reg_n_0_[2][6] ),
        .I1(out_idx[0]),
        .I2(\pixel_reg_reg_n_0_[3][6] ),
        .I3(out_idx[1]),
        .I4(\pixel_reg_reg_n_0_[1][6] ),
        .O(\pixel_data_o[6]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[7]_i_1 
       (.I0(\pixel_data_o[7]_i_2_n_0 ),
        .I1(raw10_pixel_valid),
        .I2(byte0_reg__0[5]),
        .O(pixel_data_o0_out[7]));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT3 #(
    .INIT(8'hF8)) 
    \pixel_data_o[7]_i_1__0 
       (.I0(raw10_pixel_data[7]),
        .I1(\payload_dt_reg_reg[2] ),
        .I2(\pixel_data_o_reg[7]_0 ),
        .O(D[7]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \pixel_data_o[7]_i_2 
       (.I0(\pixel_reg_reg_n_0_[2][7] ),
        .I1(out_idx[0]),
        .I2(\pixel_reg_reg_n_0_[3][7] ),
        .I3(out_idx[1]),
        .I4(\pixel_reg_reg_n_0_[1][7] ),
        .O(\pixel_data_o[7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[8]_i_1 
       (.I0(\pixel_data_o[8]_i_2_n_0 ),
        .I1(raw10_pixel_valid),
        .I2(byte0_reg__0[6]),
        .O(pixel_data_o0_out[8]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \pixel_data_o[8]_i_2 
       (.I0(\pixel_reg_reg_n_0_[2][8] ),
        .I1(out_idx[0]),
        .I2(\pixel_reg_reg_n_0_[3][8] ),
        .I3(out_idx[1]),
        .I4(\pixel_reg_reg_n_0_[1][8] ),
        .O(\pixel_data_o[8]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[9]_i_1 
       (.I0(\pixel_data_o[9]_i_2_n_0 ),
        .I1(raw10_pixel_valid),
        .I2(byte0_reg__0[7]),
        .O(pixel_data_o0_out[9]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \pixel_data_o[9]_i_2 
       (.I0(\pixel_reg_reg_n_0_[2][9] ),
        .I1(out_idx[0]),
        .I2(\pixel_reg_reg_n_0_[3][9] ),
        .I3(out_idx[1]),
        .I4(\pixel_reg_reg_n_0_[1][9] ),
        .O(\pixel_data_o[9]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_sequential_out_idx[1]_i_1_n_0 ),
        .D(pixel_data_o0_out[0]),
        .Q(raw10_pixel_data[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_sequential_out_idx[1]_i_1_n_0 ),
        .D(pixel_data_o0_out[1]),
        .Q(raw10_pixel_data[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_sequential_out_idx[1]_i_1_n_0 ),
        .D(pixel_data_o0_out[2]),
        .Q(raw10_pixel_data[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_sequential_out_idx[1]_i_1_n_0 ),
        .D(pixel_data_o0_out[3]),
        .Q(raw10_pixel_data[3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_sequential_out_idx[1]_i_1_n_0 ),
        .D(pixel_data_o0_out[4]),
        .Q(raw10_pixel_data[4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_sequential_out_idx[1]_i_1_n_0 ),
        .D(pixel_data_o0_out[5]),
        .Q(raw10_pixel_data[5]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_sequential_out_idx[1]_i_1_n_0 ),
        .D(pixel_data_o0_out[6]),
        .Q(raw10_pixel_data[6]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_sequential_out_idx[1]_i_1_n_0 ),
        .D(pixel_data_o0_out[7]),
        .Q(raw10_pixel_data[7]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_sequential_out_idx[1]_i_1_n_0 ),
        .D(pixel_data_o0_out[8]),
        .Q(Q[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\FSM_sequential_out_idx[1]_i_1_n_0 ),
        .D(pixel_data_o0_out[9]),
        .Q(Q[1]),
        .R(resync_req_o_reg));
  LUT6 #(
    .INIT(64'h0000000000010000)) 
    \pixel_reg[1][9]_i_1 
       (.I0(byte3_reg),
        .I1(byte2_reg),
        .I2(byte0_reg),
        .I3(byte1_reg),
        .I4(state_reg_0),
        .I5(raw10_pixel_valid),
        .O(\pixel_reg[1][9]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[1][0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [2]),
        .Q(\pixel_reg_reg_n_0_[1][0] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[1][1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [3]),
        .Q(\pixel_reg_reg_n_0_[1][1] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[1][2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte1_reg__0[0]),
        .Q(\pixel_reg_reg_n_0_[1][2] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[1][3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte1_reg__0[1]),
        .Q(\pixel_reg_reg_n_0_[1][3] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[1][4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte1_reg__0[2]),
        .Q(\pixel_reg_reg_n_0_[1][4] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[1][5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte1_reg__0[3]),
        .Q(\pixel_reg_reg_n_0_[1][5] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[1][6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte1_reg__0[4]),
        .Q(\pixel_reg_reg_n_0_[1][6] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[1][7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte1_reg__0[5]),
        .Q(\pixel_reg_reg_n_0_[1][7] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[1][8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte1_reg__0[6]),
        .Q(\pixel_reg_reg_n_0_[1][8] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[1][9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte1_reg__0[7]),
        .Q(\pixel_reg_reg_n_0_[1][9] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[2][0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [4]),
        .Q(\pixel_reg_reg_n_0_[2][0] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[2][1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [5]),
        .Q(\pixel_reg_reg_n_0_[2][1] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[2][2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte2_reg__0[0]),
        .Q(\pixel_reg_reg_n_0_[2][2] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[2][3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte2_reg__0[1]),
        .Q(\pixel_reg_reg_n_0_[2][3] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[2][4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte2_reg__0[2]),
        .Q(\pixel_reg_reg_n_0_[2][4] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[2][5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte2_reg__0[3]),
        .Q(\pixel_reg_reg_n_0_[2][5] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[2][6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte2_reg__0[4]),
        .Q(\pixel_reg_reg_n_0_[2][6] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[2][7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte2_reg__0[5]),
        .Q(\pixel_reg_reg_n_0_[2][7] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[2][8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte2_reg__0[6]),
        .Q(\pixel_reg_reg_n_0_[2][8] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[2][9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte2_reg__0[7]),
        .Q(\pixel_reg_reg_n_0_[2][9] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[3][0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [6]),
        .Q(\pixel_reg_reg_n_0_[3][0] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[3][1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(\rd_ptr_bin_reg[3] [7]),
        .Q(\pixel_reg_reg_n_0_[3][1] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[3][2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte3_reg__0[0]),
        .Q(\pixel_reg_reg_n_0_[3][2] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[3][3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte3_reg__0[1]),
        .Q(\pixel_reg_reg_n_0_[3][3] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[3][4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte3_reg__0[2]),
        .Q(\pixel_reg_reg_n_0_[3][4] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[3][5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte3_reg__0[3]),
        .Q(\pixel_reg_reg_n_0_[3][5] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[3][6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte3_reg__0[4]),
        .Q(\pixel_reg_reg_n_0_[3][6] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[3][7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte3_reg__0[5]),
        .Q(\pixel_reg_reg_n_0_[3][7] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[3][8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte3_reg__0[6]),
        .Q(\pixel_reg_reg_n_0_[3][8] ),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_reg_reg[3][9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_reg[1][9]_i_1_n_0 ),
        .D(byte3_reg__0[7]),
        .Q(\pixel_reg_reg_n_0_[3][9] ),
        .R(resync_req_o_reg));
  LUT4 #(
    .INIT(16'h9F90)) 
    pixel_sof_o_i_1
       (.I0(out_idx[1]),
        .I1(out_idx[0]),
        .I2(raw10_pixel_valid),
        .I3(pixel_sof_o_i_3_n_0),
        .O(pixel_sof_o_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT5 #(
    .INIT(32'hF8C8F800)) 
    pixel_sof_o_i_1__3
       (.I0(raw10_pixel_valid),
        .I1(\payload_dt_reg_reg[2] ),
        .I2(pixel_valid_o_reg),
        .I3(pixel_sof_o_reg_1),
        .I4(raw10_pixel_sof),
        .O(pixel_sof_o_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT2 #(
    .INIT(4'h2)) 
    pixel_sof_o_i_2__0
       (.I0(sof_reg_reg_n_0),
        .I1(raw10_pixel_valid),
        .O(pixel_sof_o_i_2__0_n_0));
  LUT5 #(
    .INIT(32'h00000002)) 
    pixel_sof_o_i_3
       (.I0(state_reg_0),
        .I1(byte1_reg),
        .I2(byte0_reg),
        .I3(byte2_reg),
        .I4(byte3_reg),
        .O(pixel_sof_o_i_3_n_0));
  FDRE #(
    .INIT(1'b0)) 
    pixel_sof_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_sof_o_i_1_n_0),
        .D(pixel_sof_o_i_2__0_n_0),
        .Q(raw10_pixel_sof),
        .R(resync_req_o_reg));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT2 #(
    .INIT(4'h2)) 
    pixel_sol_o_i_1
       (.I0(sol_reg_reg_n_0),
        .I1(raw10_pixel_valid),
        .O(pixel_sol_o_i_1_n_0));
  LUT5 #(
    .INIT(32'hF8C8F800)) 
    pixel_sol_o_i_1__2
       (.I0(raw10_pixel_valid),
        .I1(\payload_dt_reg_reg[2] ),
        .I2(pixel_valid_o_reg),
        .I3(pixel_sol_o_reg_1),
        .I4(raw10_pixel_sol),
        .O(pixel_sol_o_reg_0));
  FDRE #(
    .INIT(1'b0)) 
    pixel_sol_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(pixel_sof_o_i_1_n_0),
        .D(pixel_sol_o_i_1_n_0),
        .Q(raw10_pixel_sol),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    sof_reg_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte0_reg[7]_i_1_n_0 ),
        .D(payload_sof_i),
        .Q(sof_reg_reg_n_0),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    sol_reg_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte0_reg[7]_i_1_n_0 ),
        .D(payload_sol_i),
        .Q(sol_reg_reg_n_0),
        .R(resync_req_o_reg));
  LUT6 #(
    .INIT(64'h0000000020ECECEC)) 
    state_i_1__1
       (.I0(state_reg_0),
        .I1(raw10_pixel_valid),
        .I2(pixel_sof_o_i_3_n_0),
        .I3(out_idx[0]),
        .I4(out_idx[1]),
        .I5(resync_req_o_reg),
        .O(state_i_1__1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    state_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(state_i_1__1_n_0),
        .Q(raw10_pixel_valid),
        .R(\<const0> ));
endmodule

module raw8_unpack
   (raw8_pixel_valid,
    pixel_sof_o,
    pixel_sol_o,
    Q,
    SR,
    E,
    clk_sys_IBUF_BUFG,
    pending_sof_reg,
    pending_sol_reg,
    rd_data);
  output raw8_pixel_valid;
  output pixel_sof_o;
  output pixel_sol_o;
  output [7:0]Q;
  input [0:0]SR;
  input [0:0]E;
  input clk_sys_IBUF_BUFG;
  input pending_sof_reg;
  input pending_sol_reg;
  input [7:0]rd_data;

  wire \<const1> ;
  wire [0:0]E;
  wire [7:0]Q;
  wire [0:0]SR;
  wire clk_sys_IBUF_BUFG;
  wire pending_sof_reg;
  wire pending_sol_reg;
  wire pixel_sof_o;
  wire pixel_sol_o;
  wire raw8_pixel_valid;
  wire [7:0]rd_data;

  VCC VCC
       (.P(\<const1> ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(rd_data[0]),
        .Q(Q[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(rd_data[1]),
        .Q(Q[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(rd_data[2]),
        .Q(Q[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(rd_data[3]),
        .Q(Q[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(rd_data[4]),
        .Q(Q[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(rd_data[5]),
        .Q(Q[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(rd_data[6]),
        .Q(Q[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(rd_data[7]),
        .Q(Q[7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    pixel_sof_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(pending_sof_reg),
        .Q(pixel_sof_o),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    pixel_sol_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(pending_sol_reg),
        .Q(pixel_sol_o),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    pixel_valid_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(E),
        .Q(raw8_pixel_valid),
        .R(SR));
endmodule

module resync_ctrl_fsm
   (resync_drop_packet,
    resync_toggle_sys_reg,
    out_idx_reg,
    pixel_sol_o_reg,
    SR,
    clk_sys_IBUF_BUFG,
    sync_error_reg,
    resync_req_d,
    axi_clear_busy,
    resync_toggle_sys,
    rst_n_IBUF);
  output resync_drop_packet;
  output resync_toggle_sys_reg;
  output out_idx_reg;
  output [0:0]pixel_sol_o_reg;
  input [0:0]SR;
  input clk_sys_IBUF_BUFG;
  input sync_error_reg;
  input resync_req_d;
  input axi_clear_busy;
  input resync_toggle_sys;
  input rst_n_IBUF;

  wire \<const0> ;
  wire \<const1> ;
  wire [0:0]SR;
  wire axi_clear_busy;
  wire clk_sys_IBUF_BUFG;
  wire out_idx_reg;
  wire [0:0]pixel_sol_o_reg;
  wire resync_drop_packet;
  wire resync_req_d;
  wire resync_req_o_i_1_n_0;
  wire resync_toggle_sys;
  wire resync_toggle_sys_reg;
  wire rst_n_IBUF;
  wire state;
  wire state_i_1_n_0;
  wire sync_error_reg;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT3 #(
    .INIT(8'h2F)) 
    \payload_dt_reg[5]_i_1 
       (.I0(resync_drop_packet),
        .I1(resync_req_d),
        .I2(rst_n_IBUF),
        .O(pixel_sol_o_reg));
  LUT6 #(
    .INIT(64'hCCCCC0CC88888888)) 
    resync_req_o_i_1
       (.I0(sync_error_reg),
        .I1(rst_n_IBUF),
        .I2(resync_req_d),
        .I3(resync_drop_packet),
        .I4(axi_clear_busy),
        .I5(state),
        .O(resync_req_o_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    resync_req_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(resync_req_o_i_1_n_0),
        .Q(resync_drop_packet),
        .R(\<const0> ));
  LUT3 #(
    .INIT(8'hD2)) 
    resync_toggle_sys_i_1
       (.I0(resync_drop_packet),
        .I1(resync_req_d),
        .I2(resync_toggle_sys),
        .O(resync_toggle_sys_reg));
  LUT5 #(
    .INIT(32'hFFCFAAAA)) 
    state_i_1
       (.I0(sync_error_reg),
        .I1(resync_req_d),
        .I2(resync_drop_packet),
        .I3(axi_clear_busy),
        .I4(state),
        .O(state_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    state_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(state_i_1_n_0),
        .Q(state),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT3 #(
    .INIT(8'h5D)) 
    \wr_ptr_gray_rdclk_ff1[4]_i_1 
       (.I0(rst_n_IBUF),
        .I1(resync_drop_packet),
        .I2(resync_req_d),
        .O(out_idx_reg));
endmodule

module rgb888_unpack
   (byte_idx,
    D,
    pixel_data_o,
    pixel_sol_o_reg_0,
    pixel_valid_o,
    O59,
    pixel_sof_o,
    sol_reg,
    pixel_sol_o,
    \payload_dt_reg_reg[3] ,
    \pixel_data_o_reg[23]_0 ,
    \payload_dt_reg_reg[5] ,
    Q,
    resync_req_o_reg,
    E,
    clk_sys_IBUF_BUFG,
    I137,
    I138,
    \byte_idx_reg[1]_0 ,
    rd_data,
    sof_reg,
    payload_sof_i,
    pixel_sof_o3_out,
    payload_sol_i,
    pixel_sol_o1_out);
  output [1:0]byte_idx;
  output [13:0]D;
  output [9:0]pixel_data_o;
  output pixel_sol_o_reg_0;
  output pixel_valid_o;
  output O59;
  output pixel_sof_o;
  output sol_reg;
  output pixel_sol_o;
  input \payload_dt_reg_reg[3] ;
  input [13:0]\pixel_data_o_reg[23]_0 ;
  input \payload_dt_reg_reg[5] ;
  input [3:0]Q;
  input resync_req_o_reg;
  input [0:0]E;
  input clk_sys_IBUF_BUFG;
  input I137;
  input I138;
  input [0:0]\byte_idx_reg[1]_0 ;
  input [7:0]rd_data;
  input sof_reg;
  input payload_sof_i;
  input pixel_sof_o3_out;
  input payload_sol_i;
  input pixel_sol_o1_out;

  wire [13:0]D;
  wire [0:0]E;
  wire I137;
  wire I138;
  wire O59;
  wire [3:0]Q;
  wire [1:0]byte_idx;
  wire \byte_idx[0]_i_1_n_0 ;
  wire \byte_idx[1]_i_2_n_0 ;
  wire [0:0]\byte_idx_reg[1]_0 ;
  wire clk_sys_IBUF_BUFG;
  wire [23:8]p_1_in;
  wire \payload_dt_reg_reg[3] ;
  wire \payload_dt_reg_reg[5] ;
  wire payload_sof_i;
  wire payload_sol_i;
  wire [9:0]pixel_data_o;
  wire [13:0]\pixel_data_o_reg[23]_0 ;
  wire pixel_sof_o;
  wire pixel_sof_o3_out;
  wire pixel_sol_o;
  wire pixel_sol_o1_out;
  wire pixel_sol_o_reg_0;
  wire pixel_valid_o;
  wire [7:0]rd_data;
  wire resync_req_o_reg;
  wire [23:10]rgb888_pixel_data;
  wire sof_reg;
  wire sol_reg;

  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(sof_reg),
        .D(rd_data[0]),
        .Q(p_1_in[16]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(sof_reg),
        .D(rd_data[1]),
        .Q(p_1_in[17]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(sof_reg),
        .D(rd_data[2]),
        .Q(p_1_in[18]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(sof_reg),
        .D(rd_data[3]),
        .Q(p_1_in[19]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(sof_reg),
        .D(rd_data[4]),
        .Q(p_1_in[20]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(sof_reg),
        .D(rd_data[5]),
        .Q(p_1_in[21]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(sof_reg),
        .D(rd_data[6]),
        .Q(p_1_in[22]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte0_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(sof_reg),
        .D(rd_data[7]),
        .Q(p_1_in[23]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte_idx_reg[1]_0 ),
        .D(rd_data[0]),
        .Q(p_1_in[8]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte_idx_reg[1]_0 ),
        .D(rd_data[1]),
        .Q(p_1_in[9]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte_idx_reg[1]_0 ),
        .D(rd_data[2]),
        .Q(p_1_in[10]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte_idx_reg[1]_0 ),
        .D(rd_data[3]),
        .Q(p_1_in[11]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte_idx_reg[1]_0 ),
        .D(rd_data[4]),
        .Q(p_1_in[12]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte_idx_reg[1]_0 ),
        .D(rd_data[5]),
        .Q(p_1_in[13]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte_idx_reg[1]_0 ),
        .D(rd_data[6]),
        .Q(p_1_in[14]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte1_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\byte_idx_reg[1]_0 ),
        .D(rd_data[7]),
        .Q(p_1_in[15]),
        .R(resync_req_o_reg));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \byte_idx[0]_i_1 
       (.I0(byte_idx[1]),
        .I1(byte_idx[0]),
        .O(\byte_idx[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \byte_idx[1]_i_2 
       (.I0(byte_idx[0]),
        .I1(byte_idx[1]),
        .O(\byte_idx[1]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hB8BB)) 
    \byte_idx[1]_i_5 
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(Q[2]),
        .I3(Q[3]),
        .O(pixel_sol_o_reg_0));
  FDRE #(
    .INIT(1'b0)) 
    \byte_idx_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(\byte_idx[0]_i_1_n_0 ),
        .Q(byte_idx[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \byte_idx_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(\byte_idx[1]_i_2_n_0 ),
        .Q(byte_idx[1]),
        .R(resync_req_o_reg));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[10]_i_1 
       (.I0(rgb888_pixel_data[10]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [0]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[0]));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[11]_i_1 
       (.I0(rgb888_pixel_data[11]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [1]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[1]));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[12]_i_1 
       (.I0(rgb888_pixel_data[12]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [2]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[2]));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[13]_i_1 
       (.I0(rgb888_pixel_data[13]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [3]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[3]));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[14]_i_1 
       (.I0(rgb888_pixel_data[14]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [4]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[4]));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[15]_i_1 
       (.I0(rgb888_pixel_data[15]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [5]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[5]));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[16]_i_1__0 
       (.I0(rgb888_pixel_data[16]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [6]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[6]));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[17]_i_1__0 
       (.I0(rgb888_pixel_data[17]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [7]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[7]));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[18]_i_1__0 
       (.I0(rgb888_pixel_data[18]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [8]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[8]));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[19]_i_1__0 
       (.I0(rgb888_pixel_data[19]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [9]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[9]));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[20]_i_1__0 
       (.I0(rgb888_pixel_data[20]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [10]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[10]));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[21]_i_1__0 
       (.I0(rgb888_pixel_data[21]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [11]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[11]));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[22]_i_1__0 
       (.I0(rgb888_pixel_data[22]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [12]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[12]));
  LUT4 #(
    .INIT(16'hF888)) 
    \pixel_data_o[23]_i_2__0 
       (.I0(rgb888_pixel_data[23]),
        .I1(\payload_dt_reg_reg[3] ),
        .I2(\pixel_data_o_reg[23]_0 [13]),
        .I3(\payload_dt_reg_reg[5] ),
        .O(D[13]));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(rd_data[0]),
        .Q(pixel_data_o[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[10] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[10]),
        .Q(rgb888_pixel_data[10]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[11] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[11]),
        .Q(rgb888_pixel_data[11]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[12] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[12]),
        .Q(rgb888_pixel_data[12]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[13] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[13]),
        .Q(rgb888_pixel_data[13]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[14] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[14]),
        .Q(rgb888_pixel_data[14]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[15] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[15]),
        .Q(rgb888_pixel_data[15]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[16] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[16]),
        .Q(rgb888_pixel_data[16]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[17] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[17]),
        .Q(rgb888_pixel_data[17]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[18] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[18]),
        .Q(rgb888_pixel_data[18]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[19] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[19]),
        .Q(rgb888_pixel_data[19]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(rd_data[1]),
        .Q(pixel_data_o[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[20] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[20]),
        .Q(rgb888_pixel_data[20]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[21] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[21]),
        .Q(rgb888_pixel_data[21]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[22] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[22]),
        .Q(rgb888_pixel_data[22]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[23] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[23]),
        .Q(rgb888_pixel_data[23]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(rd_data[2]),
        .Q(pixel_data_o[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(rd_data[3]),
        .Q(pixel_data_o[3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(rd_data[4]),
        .Q(pixel_data_o[4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(rd_data[5]),
        .Q(pixel_data_o[5]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(rd_data[6]),
        .Q(pixel_data_o[6]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(rd_data[7]),
        .Q(pixel_data_o[7]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[8]),
        .Q(pixel_data_o[8]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(I138),
        .D(p_1_in[9]),
        .Q(pixel_data_o[9]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    pixel_sof_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(I137),
        .D(pixel_sof_o3_out),
        .Q(pixel_sof_o),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    pixel_sol_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(I137),
        .D(pixel_sol_o1_out),
        .Q(pixel_sol_o),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    pixel_valid_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(I137),
        .D(I138),
        .Q(pixel_valid_o),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    sof_reg_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(sof_reg),
        .D(payload_sof_i),
        .Q(O59),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    sol_reg_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(sof_reg),
        .D(payload_sol_i),
        .Q(sol_reg),
        .R(resync_req_o_reg));
endmodule

module yuv422_unpack
   (pixel_valid_o_reg_0,
    crc_error_reg,
    pixel_sol_o_reg_0,
    pixel_sof_o_reg_0,
    \pixel_data_o_reg[0]_0 ,
    \pixel_data_o_reg[23]_0 ,
    \pixel_data_o_reg[1]_0 ,
    \pixel_data_o_reg[2]_0 ,
    \pixel_data_o_reg[3]_0 ,
    \pixel_data_o_reg[4]_0 ,
    \pixel_data_o_reg[5]_0 ,
    \pixel_data_o_reg[6]_0 ,
    \pixel_data_o_reg[7]_0 ,
    D,
    \pixel_data_o_reg[0]_1 ,
    state_reg_0,
    Q,
    \payload_dt_reg_reg[5] ,
    \payload_dt_reg_reg[3] ,
    pixel_sol_o,
    pixel_sol_o_reg_1,
    \payload_dt_reg_reg[2] ,
    pixel_sof_o,
    pixel_sof_o_reg_1,
    pixel_data_o,
    \pixel_data_o_reg[7]_1 ,
    \pixel_data_o_reg[9]_0 ,
    \payload_dt_reg_reg[2]_0 ,
    pixel_valid_o,
    raw8_pixel_valid,
    resync_req_o_reg,
    E,
    clk_sys_IBUF_BUFG,
    rd_data,
    payload_sof_i,
    payload_sol_i);
  output pixel_valid_o_reg_0;
  output crc_error_reg;
  output pixel_sol_o_reg_0;
  output pixel_sof_o_reg_0;
  output \pixel_data_o_reg[0]_0 ;
  output [13:0]\pixel_data_o_reg[23]_0 ;
  output \pixel_data_o_reg[1]_0 ;
  output \pixel_data_o_reg[2]_0 ;
  output \pixel_data_o_reg[3]_0 ;
  output \pixel_data_o_reg[4]_0 ;
  output \pixel_data_o_reg[5]_0 ;
  output \pixel_data_o_reg[6]_0 ;
  output \pixel_data_o_reg[7]_0 ;
  output [1:0]D;
  output \pixel_data_o_reg[0]_1 ;
  input state_reg_0;
  input [3:0]Q;
  input \payload_dt_reg_reg[5] ;
  input \payload_dt_reg_reg[3] ;
  input pixel_sol_o;
  input pixel_sol_o_reg_1;
  input \payload_dt_reg_reg[2] ;
  input pixel_sof_o;
  input pixel_sof_o_reg_1;
  input [9:0]pixel_data_o;
  input [7:0]\pixel_data_o_reg[7]_1 ;
  input [1:0]\pixel_data_o_reg[9]_0 ;
  input \payload_dt_reg_reg[2]_0 ;
  input pixel_valid_o;
  input raw8_pixel_valid;
  input resync_req_o_reg;
  input [0:0]E;
  input clk_sys_IBUF_BUFG;
  input [7:0]rd_data;
  input payload_sof_i;
  input payload_sol_i;

  wire \<const0> ;
  wire \<const1> ;
  wire [1:0]D;
  wire [0:0]E;
  (* RTL_KEEP = "yes" *) wire \FSM_onehot_byte_idx_reg_n_0_[3] ;
  wire [3:0]Q;
  wire clk_sys_IBUF_BUFG;
  wire crc_error_reg;
  wire out_idx;
  wire out_idx_i_1_n_0;
  wire [23:16]p_2_in;
  wire \payload_dt_reg_reg[2] ;
  wire \payload_dt_reg_reg[2]_0 ;
  wire \payload_dt_reg_reg[3] ;
  wire \payload_dt_reg_reg[5] ;
  wire payload_sof_i;
  wire payload_sol_i;
  wire [9:0]pixel_data_o;
  wire \pixel_data_o[23]_i_1_n_0 ;
  wire \pixel_data_o[23]_i_2_n_0 ;
  wire \pixel_data_o_reg[0]_0 ;
  wire \pixel_data_o_reg[0]_1 ;
  wire \pixel_data_o_reg[1]_0 ;
  wire [13:0]\pixel_data_o_reg[23]_0 ;
  wire \pixel_data_o_reg[2]_0 ;
  wire \pixel_data_o_reg[3]_0 ;
  wire \pixel_data_o_reg[4]_0 ;
  wire \pixel_data_o_reg[5]_0 ;
  wire \pixel_data_o_reg[6]_0 ;
  wire \pixel_data_o_reg[7]_0 ;
  wire [7:0]\pixel_data_o_reg[7]_1 ;
  wire [1:0]\pixel_data_o_reg[9]_0 ;
  wire pixel_sof_o;
  wire pixel_sof_o_i_1__0_n_0;
  wire pixel_sof_o_reg_0;
  wire pixel_sof_o_reg_1;
  wire pixel_sol_o;
  wire pixel_sol_o_reg_0;
  wire pixel_sol_o_reg_1;
  wire pixel_valid_o;
  wire pixel_valid_o_i_1_n_0;
  wire pixel_valid_o_reg_0;
  wire raw8_pixel_valid;
  wire [7:0]rd_data;
  wire resync_req_o_reg;
  wire sof_reg;
  wire sol_reg_reg_n_0;
  wire state;
  wire state3_out;
  wire state_i_1__0_n_0;
  wire state_reg_0;
  (* RTL_KEEP = "yes" *) wire u_reg;
  wire \u_reg[7]_i_1_n_0 ;
  wire [7:0]u_reg__0;
  (* RTL_KEEP = "yes" *) wire v_reg;
  wire \v_reg[7]_i_1_n_0 ;
  wire [7:0]v_reg__0;
  (* RTL_KEEP = "yes" *) wire y0_reg;
  wire \y0_reg[7]_i_1_n_0 ;
  wire [7:0]y0_reg__0;
  wire [7:0]y1_reg;
  wire \y1_reg[7]_i_1_n_0 ;
  wire [9:0]yuv422_pixel_data;
  wire yuv422_pixel_sof;
  wire yuv422_pixel_sol;
  wire yuv422_pixel_valid;

  LUT3 #(
    .INIT(8'h01)) 
    \FSM_onehot_byte_idx[0]_i_1__0 
       (.I0(y0_reg),
        .I1(u_reg),
        .I2(v_reg),
        .O(state));
  (* FSM_ENCODED_STATES = "iSTATE:0001,iSTATE0:0010,iSTATE1:0100,iSTATE2:1000" *) 
  (* KEEP = "yes" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_byte_idx_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(state),
        .Q(u_reg),
        .S(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "iSTATE:0001,iSTATE0:0010,iSTATE1:0100,iSTATE2:1000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_byte_idx_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(u_reg),
        .Q(y0_reg),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "iSTATE:0001,iSTATE0:0010,iSTATE1:0100,iSTATE2:1000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_byte_idx_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(y0_reg),
        .Q(v_reg),
        .R(resync_req_o_reg));
  (* FSM_ENCODED_STATES = "iSTATE:0001,iSTATE0:0010,iSTATE1:0100,iSTATE2:1000" *) 
  (* KEEP = "yes" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_byte_idx_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(E),
        .D(v_reg),
        .Q(\FSM_onehot_byte_idx_reg_n_0_[3] ),
        .R(resync_req_o_reg));
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT5 #(
    .INIT(32'hFFF355FF)) 
    crc_error_i_54
       (.I0(pixel_valid_o_reg_0),
        .I1(Q[3]),
        .I2(Q[2]),
        .I3(Q[1]),
        .I4(Q[0]),
        .O(crc_error_reg));
  LUT3 #(
    .INIT(8'h38)) 
    out_idx_i_1
       (.I0(pixel_valid_o_reg_0),
        .I1(\pixel_data_o[23]_i_2_n_0 ),
        .I2(out_idx),
        .O(out_idx_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    out_idx_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(out_idx_i_1_n_0),
        .Q(out_idx),
        .R(resync_req_o_reg));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    \pixel_data_o[0]_i_2__0 
       (.I0(\payload_dt_reg_reg[5] ),
        .I1(yuv422_pixel_data[0]),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_data_o[0]),
        .I4(\pixel_data_o_reg[7]_1 [0]),
        .I5(\payload_dt_reg_reg[2] ),
        .O(\pixel_data_o_reg[0]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair117" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[16]_i_1 
       (.I0(y1_reg[0]),
        .I1(pixel_valid_o_reg_0),
        .I2(y0_reg__0[0]),
        .O(p_2_in[16]));
  (* SOFT_HLUTNM = "soft_lutpair117" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[17]_i_1 
       (.I0(y1_reg[1]),
        .I1(pixel_valid_o_reg_0),
        .I2(y0_reg__0[1]),
        .O(p_2_in[17]));
  (* SOFT_HLUTNM = "soft_lutpair118" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[18]_i_1 
       (.I0(y1_reg[2]),
        .I1(pixel_valid_o_reg_0),
        .I2(y0_reg__0[2]),
        .O(p_2_in[18]));
  (* SOFT_HLUTNM = "soft_lutpair118" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[19]_i_1 
       (.I0(y1_reg[3]),
        .I1(pixel_valid_o_reg_0),
        .I2(y0_reg__0[3]),
        .O(p_2_in[19]));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    \pixel_data_o[1]_i_2__0 
       (.I0(\payload_dt_reg_reg[5] ),
        .I1(yuv422_pixel_data[1]),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_data_o[1]),
        .I4(\pixel_data_o_reg[7]_1 [1]),
        .I5(\payload_dt_reg_reg[2] ),
        .O(\pixel_data_o_reg[1]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair119" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[20]_i_1 
       (.I0(y1_reg[4]),
        .I1(pixel_valid_o_reg_0),
        .I2(y0_reg__0[4]),
        .O(p_2_in[20]));
  (* SOFT_HLUTNM = "soft_lutpair119" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[21]_i_1 
       (.I0(y1_reg[5]),
        .I1(pixel_valid_o_reg_0),
        .I2(y0_reg__0[5]),
        .O(p_2_in[21]));
  (* SOFT_HLUTNM = "soft_lutpair120" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[22]_i_1 
       (.I0(y1_reg[6]),
        .I1(pixel_valid_o_reg_0),
        .I2(y0_reg__0[6]),
        .O(p_2_in[22]));
  LUT4 #(
    .INIT(16'hEAAA)) 
    \pixel_data_o[23]_i_1 
       (.I0(resync_req_o_reg),
        .I1(yuv422_pixel_valid),
        .I2(out_idx),
        .I3(pixel_valid_o_reg_0),
        .O(\pixel_data_o[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h88888888888888B8)) 
    \pixel_data_o[23]_i_2 
       (.I0(yuv422_pixel_valid),
        .I1(pixel_valid_o_reg_0),
        .I2(state_reg_0),
        .I3(v_reg),
        .I4(u_reg),
        .I5(y0_reg),
        .O(\pixel_data_o[23]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair120" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \pixel_data_o[23]_i_3 
       (.I0(y1_reg[7]),
        .I1(pixel_valid_o_reg_0),
        .I2(y0_reg__0[7]),
        .O(p_2_in[23]));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    \pixel_data_o[23]_i_4 
       (.I0(\payload_dt_reg_reg[5] ),
        .I1(yuv422_pixel_valid),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_valid_o),
        .I4(raw8_pixel_valid),
        .I5(\payload_dt_reg_reg[2] ),
        .O(\pixel_data_o_reg[0]_1 ));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    \pixel_data_o[2]_i_2__0 
       (.I0(\payload_dt_reg_reg[5] ),
        .I1(yuv422_pixel_data[2]),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_data_o[2]),
        .I4(\pixel_data_o_reg[7]_1 [2]),
        .I5(\payload_dt_reg_reg[2] ),
        .O(\pixel_data_o_reg[2]_0 ));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    \pixel_data_o[3]_i_2__0 
       (.I0(\payload_dt_reg_reg[5] ),
        .I1(yuv422_pixel_data[3]),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_data_o[3]),
        .I4(\pixel_data_o_reg[7]_1 [3]),
        .I5(\payload_dt_reg_reg[2] ),
        .O(\pixel_data_o_reg[3]_0 ));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    \pixel_data_o[4]_i_2__0 
       (.I0(\payload_dt_reg_reg[5] ),
        .I1(yuv422_pixel_data[4]),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_data_o[4]),
        .I4(\pixel_data_o_reg[7]_1 [4]),
        .I5(\payload_dt_reg_reg[2] ),
        .O(\pixel_data_o_reg[4]_0 ));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    \pixel_data_o[5]_i_2__0 
       (.I0(\payload_dt_reg_reg[5] ),
        .I1(yuv422_pixel_data[5]),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_data_o[5]),
        .I4(\pixel_data_o_reg[7]_1 [5]),
        .I5(\payload_dt_reg_reg[2] ),
        .O(\pixel_data_o_reg[5]_0 ));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    \pixel_data_o[6]_i_2__0 
       (.I0(\payload_dt_reg_reg[5] ),
        .I1(yuv422_pixel_data[6]),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_data_o[6]),
        .I4(\pixel_data_o_reg[7]_1 [6]),
        .I5(\payload_dt_reg_reg[2] ),
        .O(\pixel_data_o_reg[6]_0 ));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    \pixel_data_o[7]_i_2__0 
       (.I0(\payload_dt_reg_reg[5] ),
        .I1(yuv422_pixel_data[7]),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_data_o[7]),
        .I4(\pixel_data_o_reg[7]_1 [7]),
        .I5(\payload_dt_reg_reg[2] ),
        .O(\pixel_data_o_reg[7]_0 ));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    \pixel_data_o[8]_i_1__0 
       (.I0(\payload_dt_reg_reg[5] ),
        .I1(yuv422_pixel_data[8]),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_data_o[8]),
        .I4(\pixel_data_o_reg[9]_0 [0]),
        .I5(\payload_dt_reg_reg[2]_0 ),
        .O(D[0]));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    \pixel_data_o[9]_i_1__0 
       (.I0(\payload_dt_reg_reg[5] ),
        .I1(yuv422_pixel_data[9]),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_data_o[9]),
        .I4(\pixel_data_o_reg[9]_0 [1]),
        .I5(\payload_dt_reg_reg[2]_0 ),
        .O(D[1]));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(v_reg__0[0]),
        .Q(yuv422_pixel_data[0]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[10] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(u_reg__0[2]),
        .Q(\pixel_data_o_reg[23]_0 [0]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[11] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(u_reg__0[3]),
        .Q(\pixel_data_o_reg[23]_0 [1]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[12] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(u_reg__0[4]),
        .Q(\pixel_data_o_reg[23]_0 [2]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[13] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(u_reg__0[5]),
        .Q(\pixel_data_o_reg[23]_0 [3]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[14] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(u_reg__0[6]),
        .Q(\pixel_data_o_reg[23]_0 [4]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[15] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(u_reg__0[7]),
        .Q(\pixel_data_o_reg[23]_0 [5]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[16] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(p_2_in[16]),
        .Q(\pixel_data_o_reg[23]_0 [6]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[17] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(p_2_in[17]),
        .Q(\pixel_data_o_reg[23]_0 [7]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[18] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(p_2_in[18]),
        .Q(\pixel_data_o_reg[23]_0 [8]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[19] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(p_2_in[19]),
        .Q(\pixel_data_o_reg[23]_0 [9]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(v_reg__0[1]),
        .Q(yuv422_pixel_data[1]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[20] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(p_2_in[20]),
        .Q(\pixel_data_o_reg[23]_0 [10]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[21] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(p_2_in[21]),
        .Q(\pixel_data_o_reg[23]_0 [11]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[22] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(p_2_in[22]),
        .Q(\pixel_data_o_reg[23]_0 [12]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[23] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(p_2_in[23]),
        .Q(\pixel_data_o_reg[23]_0 [13]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(v_reg__0[2]),
        .Q(yuv422_pixel_data[2]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(v_reg__0[3]),
        .Q(yuv422_pixel_data[3]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(v_reg__0[4]),
        .Q(yuv422_pixel_data[4]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(v_reg__0[5]),
        .Q(yuv422_pixel_data[5]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(v_reg__0[6]),
        .Q(yuv422_pixel_data[6]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(v_reg__0[7]),
        .Q(yuv422_pixel_data[7]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[8] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(u_reg__0[0]),
        .Q(yuv422_pixel_data[8]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \pixel_data_o_reg[9] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\pixel_data_o[23]_i_2_n_0 ),
        .D(u_reg__0[1]),
        .Q(yuv422_pixel_data[9]),
        .R(\pixel_data_o[23]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hEA)) 
    pixel_sof_o_i_1__0
       (.I0(resync_req_o_reg),
        .I1(yuv422_pixel_valid),
        .I2(pixel_valid_o_reg_0),
        .O(pixel_sof_o_i_1__0_n_0));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    pixel_sof_o_i_2
       (.I0(\payload_dt_reg_reg[5] ),
        .I1(yuv422_pixel_sof),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_sof_o),
        .I4(pixel_sof_o_reg_1),
        .I5(\payload_dt_reg_reg[2] ),
        .O(pixel_sof_o_reg_0));
  FDRE #(
    .INIT(1'b0)) 
    pixel_sof_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y1_reg[7]_i_1_n_0 ),
        .D(sof_reg),
        .Q(yuv422_pixel_sof),
        .R(pixel_sof_o_i_1__0_n_0));
  LUT6 #(
    .INIT(64'hFFFFF888F888F888)) 
    pixel_sol_o_i_2
       (.I0(\payload_dt_reg_reg[5] ),
        .I1(yuv422_pixel_sol),
        .I2(\payload_dt_reg_reg[3] ),
        .I3(pixel_sol_o),
        .I4(pixel_sol_o_reg_1),
        .I5(\payload_dt_reg_reg[2] ),
        .O(pixel_sol_o_reg_0));
  FDRE #(
    .INIT(1'b0)) 
    pixel_sol_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y1_reg[7]_i_1_n_0 ),
        .D(sol_reg_reg_n_0),
        .Q(yuv422_pixel_sol),
        .R(pixel_sof_o_i_1__0_n_0));
  LUT6 #(
    .INIT(64'h000000000DFD0808)) 
    pixel_valid_o_i_1
       (.I0(state3_out),
        .I1(state_reg_0),
        .I2(pixel_valid_o_reg_0),
        .I3(out_idx),
        .I4(yuv422_pixel_valid),
        .I5(resync_req_o_reg),
        .O(pixel_valid_o_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    pixel_valid_o_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(pixel_valid_o_i_1_n_0),
        .Q(yuv422_pixel_valid),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0)) 
    sof_reg_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\u_reg[7]_i_1_n_0 ),
        .D(payload_sof_i),
        .Q(sof_reg),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    sol_reg_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\u_reg[7]_i_1_n_0 ),
        .D(payload_sol_i),
        .Q(sol_reg_reg_n_0),
        .R(resync_req_o_reg));
  LUT5 #(
    .INIT(32'h2EEE0CCC)) 
    state_i_1__0
       (.I0(state_reg_0),
        .I1(pixel_valid_o_reg_0),
        .I2(yuv422_pixel_valid),
        .I3(out_idx),
        .I4(state3_out),
        .O(state_i_1__0_n_0));
  LUT4 #(
    .INIT(16'h0002)) 
    state_i_2
       (.I0(state_reg_0),
        .I1(v_reg),
        .I2(u_reg),
        .I3(y0_reg),
        .O(state3_out));
  FDRE #(
    .INIT(1'b0)) 
    state_reg
       (.C(clk_sys_IBUF_BUFG),
        .CE(\<const1> ),
        .D(state_i_1__0_n_0),
        .Q(pixel_valid_o_reg_0),
        .R(resync_req_o_reg));
  LUT3 #(
    .INIT(8'h08)) 
    \u_reg[7]_i_1 
       (.I0(u_reg),
        .I1(state_reg_0),
        .I2(pixel_valid_o_reg_0),
        .O(\u_reg[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \u_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\u_reg[7]_i_1_n_0 ),
        .D(rd_data[0]),
        .Q(u_reg__0[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \u_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\u_reg[7]_i_1_n_0 ),
        .D(rd_data[1]),
        .Q(u_reg__0[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \u_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\u_reg[7]_i_1_n_0 ),
        .D(rd_data[2]),
        .Q(u_reg__0[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \u_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\u_reg[7]_i_1_n_0 ),
        .D(rd_data[3]),
        .Q(u_reg__0[3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \u_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\u_reg[7]_i_1_n_0 ),
        .D(rd_data[4]),
        .Q(u_reg__0[4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \u_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\u_reg[7]_i_1_n_0 ),
        .D(rd_data[5]),
        .Q(u_reg__0[5]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \u_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\u_reg[7]_i_1_n_0 ),
        .D(rd_data[6]),
        .Q(u_reg__0[6]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \u_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\u_reg[7]_i_1_n_0 ),
        .D(rd_data[7]),
        .Q(u_reg__0[7]),
        .R(resync_req_o_reg));
  LUT3 #(
    .INIT(8'h08)) 
    \v_reg[7]_i_1 
       (.I0(v_reg),
        .I1(state_reg_0),
        .I2(pixel_valid_o_reg_0),
        .O(\v_reg[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \v_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\v_reg[7]_i_1_n_0 ),
        .D(rd_data[0]),
        .Q(v_reg__0[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \v_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\v_reg[7]_i_1_n_0 ),
        .D(rd_data[1]),
        .Q(v_reg__0[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \v_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\v_reg[7]_i_1_n_0 ),
        .D(rd_data[2]),
        .Q(v_reg__0[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \v_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\v_reg[7]_i_1_n_0 ),
        .D(rd_data[3]),
        .Q(v_reg__0[3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \v_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\v_reg[7]_i_1_n_0 ),
        .D(rd_data[4]),
        .Q(v_reg__0[4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \v_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\v_reg[7]_i_1_n_0 ),
        .D(rd_data[5]),
        .Q(v_reg__0[5]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \v_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\v_reg[7]_i_1_n_0 ),
        .D(rd_data[6]),
        .Q(v_reg__0[6]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \v_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\v_reg[7]_i_1_n_0 ),
        .D(rd_data[7]),
        .Q(v_reg__0[7]),
        .R(resync_req_o_reg));
  LUT3 #(
    .INIT(8'h08)) 
    \y0_reg[7]_i_1 
       (.I0(y0_reg),
        .I1(state_reg_0),
        .I2(pixel_valid_o_reg_0),
        .O(\y0_reg[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \y0_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y0_reg[7]_i_1_n_0 ),
        .D(rd_data[0]),
        .Q(y0_reg__0[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y0_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y0_reg[7]_i_1_n_0 ),
        .D(rd_data[1]),
        .Q(y0_reg__0[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y0_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y0_reg[7]_i_1_n_0 ),
        .D(rd_data[2]),
        .Q(y0_reg__0[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y0_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y0_reg[7]_i_1_n_0 ),
        .D(rd_data[3]),
        .Q(y0_reg__0[3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y0_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y0_reg[7]_i_1_n_0 ),
        .D(rd_data[4]),
        .Q(y0_reg__0[4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y0_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y0_reg[7]_i_1_n_0 ),
        .D(rd_data[5]),
        .Q(y0_reg__0[5]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y0_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y0_reg[7]_i_1_n_0 ),
        .D(rd_data[6]),
        .Q(y0_reg__0[6]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y0_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y0_reg[7]_i_1_n_0 ),
        .D(rd_data[7]),
        .Q(y0_reg__0[7]),
        .R(resync_req_o_reg));
  LUT5 #(
    .INIT(32'h00000100)) 
    \y1_reg[7]_i_1 
       (.I0(y0_reg),
        .I1(u_reg),
        .I2(v_reg),
        .I3(state_reg_0),
        .I4(pixel_valid_o_reg_0),
        .O(\y1_reg[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \y1_reg_reg[0] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y1_reg[7]_i_1_n_0 ),
        .D(rd_data[0]),
        .Q(y1_reg[0]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y1_reg_reg[1] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y1_reg[7]_i_1_n_0 ),
        .D(rd_data[1]),
        .Q(y1_reg[1]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y1_reg_reg[2] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y1_reg[7]_i_1_n_0 ),
        .D(rd_data[2]),
        .Q(y1_reg[2]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y1_reg_reg[3] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y1_reg[7]_i_1_n_0 ),
        .D(rd_data[3]),
        .Q(y1_reg[3]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y1_reg_reg[4] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y1_reg[7]_i_1_n_0 ),
        .D(rd_data[4]),
        .Q(y1_reg[4]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y1_reg_reg[5] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y1_reg[7]_i_1_n_0 ),
        .D(rd_data[5]),
        .Q(y1_reg[5]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y1_reg_reg[6] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y1_reg[7]_i_1_n_0 ),
        .D(rd_data[6]),
        .Q(y1_reg[6]),
        .R(resync_req_o_reg));
  FDRE #(
    .INIT(1'b0)) 
    \y1_reg_reg[7] 
       (.C(clk_sys_IBUF_BUFG),
        .CE(\y1_reg[7]_i_1_n_0 ),
        .D(rd_data[7]),
        .Q(y1_reg[7]),
        .R(resync_req_o_reg));
endmodule
