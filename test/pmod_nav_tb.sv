// Testbench for PMOD-NAV
//

`timescale 1 ns/10 ps
`include "../src/hdl/pmod_nav.v"

module pmod_nav_tb_top;
  // register declarations
  reg clk;        // system board clock
  reg rst;        // system reset
  reg [15:0]data; // Data for I/O
  reg rw;         // read/write for data to module
  reg cs_ag;      // chip select for accleromoeter/gyrometer
  reg sdi;        // serial data in (mosi)
  reg sdo;        // serial data out (miso)
  reg spc;        // SPI clock
  reg it;         // iterupt for all components
  reg drdy_m;     // data ready, magnetometer
  reg cs_m;       // chip select, magnetometer
  reg cs_alt;     // chip select, altimeter

  pmod_nav UUT(clk, rst, data, rw, cs_ag,
               sdi, sdo, spc, it,
               drdy_m, cs_m, cs_alt);
 
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
