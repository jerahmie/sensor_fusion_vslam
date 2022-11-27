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
//          rw: module buffer read/write
//
//       cs_ag: chip select
//    sdi/mosi: serial data in
//    sdo/miso: serial data out
//         spc: SPI clock
//          it: interrupt for all components
//      drdy_m: data ready, magnetometer
//        cs_m: chip select, magnetometer
//        cs_alt: chip select, altimeter
// 
// The pmod_nav interface module reads data from the PMOD NAV module by 
// implementing a full duplex SPI state machine. 
module pmod_nav(
  input wire clk,
  input wire rst,
  inout wire [15:0] data,
  input wire rw,
  output reg cs_ag,
  input wire sdi,
  output reg sdo,
  output reg spc,
  input wire it,
  input wire drdy_m,
  output reg cs_m,
  output reg cs_alt
  );
 
  // internal storage buffers
  reg [15:0] input_buffer;
  reg [15:0] outpu_buffer;

  always @(posedge clk) begin
    cs_ag <= 0;
    sdo <= 0;
    spc <= 0;
    cs_m <= 0;
    cs_alt <= 0;
  end //clk
endmodule
