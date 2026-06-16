`timescale 1ns/1ps

// Thin runner wrappers that bind tb_recapture_strategy_compare's STRATEGY
// parameter in RTL, so each strategy is elaborated by module name without any
// command-line generic override (the local Vivado arg-parser mishandles '=').
//
//   xelab tb_strat_line_a   -> A: line-level recapture (STRATEGY=1)
//   xelab tb_strat_frame_b  -> B: full-frame retransmit (STRATEGY=2)
//   xelab tb_strat_drop_c   -> C: discard, no recovery  (STRATEGY=0)

module tb_strat_line_a;
    tb_recapture_strategy_compare #(.STRATEGY(1)) u_dut ();
endmodule

module tb_strat_frame_b;
    tb_recapture_strategy_compare #(.STRATEGY(2)) u_dut ();
endmodule

module tb_strat_drop_c;
    tb_recapture_strategy_compare #(.STRATEGY(0)) u_dut ();
endmodule

// T4 design-space sweep: A (line recapture) with the recapture sent D lines
// after the error, to measure recovery latency vs the round-trip window D.
module tb_strat_a_d1;
    tb_recapture_strategy_compare #(.STRATEGY(1), .D_LINES(1)) u_dut ();
endmodule

module tb_strat_a_d2;
    tb_recapture_strategy_compare #(.STRATEGY(1), .D_LINES(2)) u_dut ();
endmodule

module tb_strat_a_d4;
    tb_recapture_strategy_compare #(.STRATEGY(1), .D_LINES(4)) u_dut ();
endmodule
