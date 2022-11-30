
# VSLAM Sensor Fusion

## Summary and Current Status

My entry is for the Element14 FPGA Sensor Fusion Design Challenge is a Visual Simultaneous 
Localization and Mapping (VSLAM) platform for navigation of indoor spaces.  This is an 
ambitious project that includes FPGA digital logic design, embedded software 
development, and algorithm design.  And while I was not able to achieve all of
my goals for this project, I will share the present state of this project, my 
design rationale, some challenges I encountered, and future steps.

It was a privilege to participate in this design challenge, and I would like to 
thank Element14 and [the sponsors] for providing the hardware for this design
challenge.  The AMD/Xilinx SP701 Spartan-7 FPGA Evaluation kit is capable of 
complex system designs consisting of soft CPU cores, sensors, and signal
processing chains.

## Classical VSLAM Overview and Project Objectives
Visual Simultaneous Localization and Mapping (VSLAM) is a sensor fusion 
technique that commonly combines visual odometry with system orientation to 
simultaneously map out an environment and determine the location within the 
environment. Common applications are robotics, autonomous vehicles, 3D scanning 
and computer vision. This technique is well suited for indoor environments 
where GPS is unavailable and in the absence of other positioning markers, 
beacons, etc.


## Hardware Overview
### AMD/Xilinx SP701 Spartan-7 Evaluation Kit

### PCAM 5C

### PMOD NAV IMU

### VSLAM Assembly
The mapping platform assembly is to mount the PCAM 5C in a fixed positition 
that looks outward from the SP701 evaluation board.  The PMOD NAV IMU module 
will be attached to the PMOD1 port on the SP701.  A 3D printed case will 
satisfy all the requirements to simultaneously position the camera as well as 
handles to hold the asseembly while testing the VSLAM platform.  Since I don't
have a 3D printer at the time of this writing, the printed case structure will 
be completed at a later date.

## Logic Design, IP Layout, and Custom Logic Overview

At the top level, this is a microcontroller-based system with supporting digital 
logic to interface with the PCAM 5C and the PMOD NAV IMU peripherals.  The system state,
the VLAM algorithms, as well as all external communications will be controlled by the,
soft microcontroller. A combination of Xilinx IP as well as custom logic collect,
filter, and process raw sensor module data to minimize the amount of work required of 
the microcontroller. 

The SP701 has ample resources to implement a soft CPU core with required subsystems.
I initially wanted to use an Arm Cortex M1 or M4 soft microcontroller as the basis for 
this project since I have more experience using Arm architecture.  The Arm Cortex 
M1 and M4 IP is available free of charge through Arm DesignStart FPGA program with access
provided directly by Arm.  While my early impressions of using the Arm core were promising,
I ultimately decided to use a Xilinx MicroBlaze Soft Processor core. While this was my 
was my fist experience using a MicroBlaze core, I was able to get up and running
up and running quickly thanks to a wide selection of documentation and examples provied 
by Xilinx. 

Since the PMOD 5C camera implements the MIPI CSI-2 standard, I was able to leverage Xilinx
IP to capture and process image data.  MIPI CSI-2 IP module consists of a MIPI PHY module 
and ...

A custom logic block to perform the visual odometry is still under development.  
The is a custom Verilog block that will take the processed video stream from the MIPI
CSI-2 as input and the output is an estimated distance (dx, dy).

The final custom logic block is the PMOD NAV IMU module.  This is another Verilog module
that implements the SPI interface to provide orientation data for the sensor fusion algorithm.
Digilent provides an IP module for the PMOD NAV IMU, however, the documentation states that
it is for pre-Vitis versions of Vivado.  I had concerns that I would not be able to use 
the IP as-is, and since the module supports a straight-forward SPI interface, I felt 
comfortable creating my own implementation.

My perference for RTL development is to use open source tools whenever possible.
I use Icarus Verilog for module and testbench development.  I then import the 
custom RTL components into the hardware design.  After the Verilog components
are finalized, the Verilog hardware can be exported to Vitis for software
development.

## Software Overview


## Conclusions, Comments, and Next Steps

