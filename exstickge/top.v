`default_nettype none

module top(
	   input wire sys_clk_p,
	   input wire sys_clk_n,
	   input wire sys_rst_n,
	   output wire [31:0] PCout
	   );

    wire clk;
    wire locked;
    wire rst_n;

    clk_wiz_0 clk_wiz_0_i
      (
       .clk_out1(clk),
       .reset(~sys_rst_n),
       .locked(locked),
       .clk_in1_p(sys_clk_p),
       .clk_in1_n(sys_clk_n)
       );

    main U(
	   .CLK(clk),
	   .RST_X(sys_rst_n),
	   .PCout(PCout)
	   );

endmodule // top

`default_nettype wire
