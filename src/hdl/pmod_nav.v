// pmod_nav module
//
//      +---------------------+
//      |                     |
//    --| clk             *CS |--
//    --| rst            sclk |--
//    --| sclk_in        mosi |--
//    ==| data           miso |--
//    --| rw              it |--
//      |                     |
//      +---------------------+
//
//      INPUT
//      clk: module clock
//      rst: module reset
//  SCLK_IN: SPI CLK IN
//     DATA: DATA I/O (8-bit)
//      R/W: module buffer read/write
//
//      OUTPUT
//      *CS: chip select
//     SCLK: SPI clok out
//     MOSI: Main out, Subnode in
//     MISO: Main in, Subnode out
//      IT: CPU interrupt

module pmod_nav(
  input wire clk,
  input wire rst,
  input wire sclk_in,
  input wire [7:0] data,
  input wire rw,
  output reg cs,
  output reg sclk,
  output reg mosi,
  output reg miso,
  output reg it
  );
  
  always @(posedge clk) begin
    
  end //clk
endmodule
