// pmod_nav module
//
// A module to provide an FPGA interface to the Digilent PMOD NAV
// https://digilent.com/reference/pmod/pmodnav/reference-manual
//
// 9-axis accelerometer + gyroscope + magnetometer LSM9DS1 
// https://www.st.com/resource/en/datasheet/lsm9ds1.pdf
//
// MEMS pressure sensor LPS25HB
// https://www.st.com/resource/en/datasheet/lps25hb.pdf
//
//
//      +-------------------------+
//      |                         |
//   -->| clk              cs_ag  |-->
//   -->| rst            sdi/mosi |-->
//   -->| spc            sdo/miso |<--
//   <=>| data                spc |-->
//   -->| rw                  int |<--
//      |                  drdy_m |<--
//      |                    cs_m |-->
//      |                  cs_alt |-->
//      |                         |
//      +-------------------------+
//
//         clk: module clock
//         rst: module reset
//        data: DATA I/O (16-bit)
//         R/W: module buffer read/write
//
//       cs_ag: chip select
//    sdi/mosi: serial data in
//    sdo/miso: serial data out
//         spc: SPI clock
//         int: interrupt for all components
//      drdy_m: data ready, magnetometer
//        cs_m: chip select for the magnetometer
//

module pmod_nav(
  input wire clk,
  input wire rst,
  input wire sclk_in,
  inout wire [15:0] data,
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
