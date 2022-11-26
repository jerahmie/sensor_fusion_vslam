// Testbench for PMOD-NAV
//

`timescale 1 ns/10 ps
`include "../src/hdl/pmod_nav.v"

module pmod_nav_tb_top;
  // register declarations
  reg clk;
  reg rst;
  reg sclk_in;
  reg [7:0]data;
  reg rw;
  reg cs;
  reg sclk;
  reg mosi;
  reg miso;
  reg it;

  pmod_nav UUT(clk, rst, sclk_in, data, rw, cs, sclk, mosi, miso, it);
 
  integer i;
  integer n_period = 50;
  initial begin
    $dumpfile("testbench_out.vcd");
    $dumpvars(0, pmod_nav_tb_top);
    clk = 0;
    for (i=0; i<n_period; i++) begin
      #10 clk = ~clk;
    end
  end

endmodule
