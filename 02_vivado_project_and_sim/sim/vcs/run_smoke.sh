#!/usr/bin/env bash
set -eo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FILELIST="${ROOT_DIR}/sim/vcs/compile.f"
OUT_DIR="${ROOT_DIR}/sim/logs/smoke"
SIM="${SIM:-auto}"

mkdir -p "${OUT_DIR}"
cd "${ROOT_DIR}"

detect_sim() {
    if [[ "${SIM}" != "auto" ]]; then
        echo "${SIM}"
    elif command -v vcs >/dev/null 2>&1; then
        echo "vcs"
    elif command -v iverilog >/dev/null 2>&1; then
        echo "iverilog"
    else
        echo "ERROR: neither vcs nor iverilog is available" >&2
        exit 1
    fi
}

SIM_TOOL="$(detect_sim)"
echo "INFO: smoke simulator=${SIM_TOOL}"

run_sv_test() {
    local name="$1"
    local top="$2"
    local test_file="$3"
    shift 3
    local extra_opts=("$@")
    local log_file="${OUT_DIR}/${name}.log"

    echo "INFO: [SMOKE] ${name}"
    if [[ "${SIM_TOOL}" == "vcs" ]]; then
        local simv="${OUT_DIR}/${name}.simv"
        vcs -full64 -sverilog -timescale=1ns/1ps -f "${FILELIST}" "${ROOT_DIR}/${test_file}" \
            -top "${top}" "${extra_opts[@]}" -l "${OUT_DIR}/${name}.compile.log" -o "${simv}"
        "${simv}" -l "${log_file}"
    elif [[ "${SIM_TOOL}" == "iverilog" ]]; then
        local vvp_file="${OUT_DIR}/${name}.vvp"
        iverilog -g2012 -Wall -s "${top}" "${extra_opts[@]}" -o "${vvp_file}" -f "${FILELIST}" "${ROOT_DIR}/${test_file}" \
            > "${OUT_DIR}/${name}.compile.log" 2>&1
        vvp "${vvp_file}" > "${log_file}" 2>&1
    else
        echo "ERROR: unsupported simulator '${SIM_TOOL}'" >&2
        exit 1
    fi
}

compile_only() {
    local name="$1"
    local top="$2"
    shift 2
    local extra_opts=("$@")

    echo "INFO: [COMPILE] ${name}"
    if [[ "${SIM_TOOL}" == "vcs" ]]; then
        vcs -full64 -sverilog -timescale=1ns/1ps -f "${FILELIST}" -top "${top}" \
            "${extra_opts[@]}" -l "${OUT_DIR}/${name}.compile.log" -o "${OUT_DIR}/${name}.simv"
    elif [[ "${SIM_TOOL}" == "iverilog" ]]; then
        iverilog -g2012 -Wall -s "${top}" "${extra_opts[@]}" -o "${OUT_DIR}/${name}.vvp" -f "${FILELIST}" \
            > "${OUT_DIR}/${name}.compile.log" 2>&1
    else
        echo "ERROR: unsupported simulator '${SIM_TOOL}'" >&2
        exit 1
    fi
}

run_system_variant() {
    local name="$1"
    local lane_num="$2"
    local data_type="$3"

    if [[ "${SIM_TOOL}" == "vcs" ]]; then
        run_sv_test "${name}" "tb_mipi_csi2_capture_top" "tb/top/tb_mipi_csi2_capture_top.sv" \
            "-pvalue+tb_mipi_csi2_capture_top.LANE_NUM=${lane_num}" \
            "-pvalue+tb_mipi_csi2_capture_top.DATA_TYPE=${data_type}"
    else
        run_sv_test "${name}" "tb_mipi_csi2_capture_top" "tb/top/tb_mipi_csi2_capture_top.sv" \
            "-Ptb_mipi_csi2_capture_top.LANE_NUM=${lane_num}" \
            "-Ptb_mipi_csi2_capture_top.DATA_TYPE=${data_type}"
    fi
}

run_sv_test "tb_async_fifo"            "tb_async_fifo"            "tb/tests/tb_async_fifo.sv"
run_sv_test "tb_header_ecc"            "tb_header_ecc"            "tb/tests/tb_header_ecc.sv"
run_sv_test "tb_payload_crc"           "tb_payload_crc"           "tb/tests/tb_payload_crc.sv"
run_sv_test "tb_short_packet_parser"   "tb_short_packet_parser"   "tb/tests/tb_short_packet_parser.sv"
run_sv_test "tb_long_packet_parser"    "tb_long_packet_parser"    "tb/tests/tb_long_packet_parser.sv"
run_sv_test "tb_lane_reorder_merge"    "tb_lane_reorder_merge"    "tb/tests/tb_lane_reorder_merge.sv"
run_sv_test "tb_phy_digital_adapter"   "tb_phy_digital_adapter"   "tb/tests/tb_phy_digital_adapter.sv"
run_sv_test "tb_cfg_reg_if_apb"        "tb_cfg_reg_if_apb"        "tb/tests/tb_cfg_reg_if_apb.sv"
run_sv_test "tb_packet_error_policy"   "tb_packet_error_policy"   "tb/tests/tb_packet_error_policy.sv"
run_sv_test "tb_raw8_unpack"           "tb_raw8_unpack"           "tb/tests/tb_raw8_unpack.sv"
run_sv_test "tb_rgb888_unpack"         "tb_rgb888_unpack"         "tb/tests/tb_rgb888_unpack.sv"
run_sv_test "tb_axi_write_master"      "tb_axi_write_master"      "tb/tests/tb_axi_write_master.sv"
run_sv_test "tb_pixel_to_axi_writer"   "tb_pixel_to_axi_writer"   "tb/tests/tb_pixel_to_axi_writer.sv"
run_sv_test "tb_contrast_adjust"       "tb_contrast_adjust"       "tb/tests/tb_contrast_adjust.sv"
run_sv_test "tb_pixel_frame_stats_v1"  "tb_pixel_frame_stats_v1"  "tb/tests/tb_pixel_frame_stats_v1.sv"
run_sv_test "tb_adaptive_preprocess_ctrl_v1" "tb_adaptive_preprocess_ctrl_v1" "tb/tests/tb_adaptive_preprocess_ctrl_v1.sv"

run_system_variant "tb_system_lane2_raw8"   2 42
run_system_variant "tb_system_lane1_raw8"   1 42
run_system_variant "tb_system_lane4_raw8"   4 42
run_system_variant "tb_system_lane2_rgb888" 2 36
run_sv_test "tb_fpga_wrapper_raw8_smoke" "tb_fpga_wrapper_raw8_smoke" "tb/tests/tb_fpga_wrapper_raw8_smoke.sv"
run_sv_test "tb_fpga_wrapper_crc_error" "tb_fpga_wrapper_crc_error" "tb/tests/tb_fpga_wrapper_crc_error.sv"
run_sv_test "tb_fpga_wrapper_ecc_error" "tb_fpga_wrapper_ecc_error" "tb/tests/tb_fpga_wrapper_ecc_error.sv"
run_sv_test "tb_fpga_wrapper_sync_illegal_order" "tb_fpga_wrapper_sync_illegal_order" "tb/tests/tb_fpga_wrapper_sync_illegal_order.sv"
run_sv_test "tb_fpga_wrapper_lane_skew_tolerance" "tb_fpga_wrapper_lane_skew_tolerance" "tb/tests/tb_fpga_wrapper_lane_skew_tolerance.sv"
run_sv_test "tb_fpga_wrapper_lane_skew_scan" "tb_fpga_wrapper_lane_skew_scan" "tb/tests/tb_fpga_wrapper_lane_skew_scan.sv"
run_sv_test "tb_fpga_wrapper_resync_recovery" "tb_fpga_wrapper_resync_recovery" "tb/tests/tb_fpga_wrapper_resync_recovery.sv"
run_sv_test "tb_fpga_wrapper_resync_metrics" "tb_fpga_wrapper_resync_metrics" "tb/tests/tb_fpga_wrapper_resync_metrics.sv"
run_sv_test "tb_fpga_wrapper_resync_clean_frame" "tb_fpga_wrapper_resync_clean_frame" "tb/tests/tb_fpga_wrapper_resync_clean_frame.sv"
run_sv_test "tb_fpga_wrapper_axi_backpressure" "tb_fpga_wrapper_axi_backpressure" "tb/tests/tb_fpga_wrapper_axi_backpressure.sv"
run_sv_test "tb_fpga_wrapper_resync_repeated_error" "tb_fpga_wrapper_resync_repeated_error" "tb/tests/tb_fpga_wrapper_resync_repeated_error.sv"
run_sv_test "tb_fpga_wrapper_lane_skew_overflow" "tb_fpga_wrapper_lane_skew_overflow" "tb/tests/tb_fpga_wrapper_lane_skew_overflow.sv"
run_sv_test "tb_fpga_wrapper_raw8_metrics" "tb_fpga_wrapper_raw8_metrics" "tb/tests/tb_fpga_wrapper_raw8_metrics.sv"
run_sv_test "tb_fpga_wrapper_axi_backpressure_metrics" "tb_fpga_wrapper_axi_backpressure_metrics" "tb/tests/tb_fpga_wrapper_axi_backpressure_metrics.sv"
run_sv_test "tb_fpga_wrapper_rgb888_smoke" "tb_fpga_wrapper_rgb888_smoke" "tb/tests/tb_fpga_wrapper_rgb888_smoke.sv"
run_sv_test "tb_fpga_wrapper_rgb888_metrics" "tb_fpga_wrapper_rgb888_metrics" "tb/tests/tb_fpga_wrapper_rgb888_metrics.sv"
run_sv_test "tb_fpga_wrapper_raw10_smoke" "tb_fpga_wrapper_raw10_smoke" "tb/tests/tb_fpga_wrapper_raw10_smoke.sv"
run_sv_test "tb_fpga_wrapper_raw10_metrics" "tb_fpga_wrapper_raw10_metrics" "tb/tests/tb_fpga_wrapper_raw10_metrics.sv"
run_sv_test "tb_fpga_wrapper_yuv422_smoke" "tb_fpga_wrapper_yuv422_smoke" "tb/tests/tb_fpga_wrapper_yuv422_smoke.sv"
run_sv_test "tb_fpga_wrapper_yuv422_metrics" "tb_fpga_wrapper_yuv422_metrics" "tb/tests/tb_fpga_wrapper_yuv422_metrics.sv"

compile_only "mipi_csi2_capture_top" "mipi_csi2_capture_top"

echo "PASS: smoke regression completed. Logs: ${OUT_DIR}"
