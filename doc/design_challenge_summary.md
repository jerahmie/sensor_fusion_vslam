
# VSLAM Sensor Fusion

## Summary and Current Status

My entry for the Experimenting with Sensor Fusion from Element14 and AMD/Xilinx Design Challenge is a 
Visual Simultaneous Localization and Mapping (VSLAM) platform for navigation of indoor spaces.
This is an ambitious project that includes FPGA digital logic design, embedded software 
development, and algorithm development.  And while I was not able to achieve all of
my goals by the due date for this project, I was able to pull together a system consisting of a soft cpu core,
a MIPI CSI-2 video processing tool chain, and custom RTL blocks that will compose the finished VSLAM 
system.  I will share the present state of this project, my design rationale, some challenges 
I encountered, and future steps. It was a privilege to participate in this design challenge, 
and I would like to thank Element14 and AMD/Xilinx for providing the hardware for these exeriments.

## Sensor Overview
Sensor fusion applications combine data from different sensors to determine properties about a
system that typically can't be measured directly.  A classic example from aviation is to combine 
altitude (altimeter), airspeed velocity (air flow meter), and direction (magnetic compass) measurements to
determine the trajectory of an aircraft. A more advanced version of this problem could 
incorporate radar, GPS, and/or measurements from redundant sensors to increase accuracy and robustness of the aircraft path.
More recent examples of data fusion includes self driving and autonomous systems, augmented 
reality, and scanning/mapping applications.  A sensor fusion application is more that the sum of its parts.
The hardware provided for this design challenge is PCAM 5C camera module, 
a PMOD NAV IMU, and a SP701 Spartan-7 Evaluation Kit.  

### PCAM 5C
The PCAM 5C is a fixed focus, five megapixel camera from Digilent
(https://digilent.com/shop/pcam-5c-5-mp-fixed-focus-color-camera-module/).  This camera conforms to the MIPI CSI-2 standard
for mobile camera devices (https://www.mipi.org/specifications/csi-2#).  The PCAM 5C camera module provides
the "visual" portion of Visual Simultaneous Localization by providing the image sequence for visual 
odometry.

### PMOD NAV IMU
Digilent's PMOD NAV (https://digilent.com/shop/pmod-nav-9-axis-imu-plus-barometer/) is an 
9-axis plus barometer IMU (inertial measurement unit) plus barometer.  This module is based on
two devices: a LSM9DS1 iNEMO 9-axis IMU and a LPS25HB digital barometer, both from ST Microelectronics.
By combining both devices on a single module, positioning information can be extracted from the module.
The three axis accelerometer provides acceleration information, which can be integrated twice to determine relative
position.  The three axis gyroscope provides angular rotation about the local x-, y-, and z- axes. 
The three axis magnetometer provides module orientation information with respect to the Earth's magnetic
field, and finally, the barometer can provide a height estimate using the relative change in pressure. 
The sensor module provides a single SPI interface, where individual sensors are addressed using three chip 
select signals which are detailed in the user manual (https://digilent.com/reference/pmod/pmodnav/reference-manual).

### AMD/Xilinx SP701 Spartan-7 Evaluation Kit
Based on the Xilinx Spartan-7 XC7S100, and having over 100k logic cells, the AMD/Xilinx SP701 Spartan-7 FPGA Evaluation kit is capable of 
complex system designs consisting of soft CPU cores, sensors, and signal processing chains.  The Xilinx SP701 is 
responsible for conditioning and combining sensor data in 
this project. The PCAM 5C is connected via ribbon cable to the SP701 MIPI CSI-2 camera ribbon connector (J8) and the PMOD NAV IMU is
connected to the SP701 PMOD1 connector (J14).  


## Classical VSLAM Overview and Project Objectives
Visual Simultaneous Localization and Mapping (VSLAM) is a sensor fusion 
technique that commonly combines visual odometry with system orientation to 
simultaneously map out an environment and determine the location within the 
environment. Common applications are robotics, autonomous vehicles, 3D scanning 
and computer vision. This technique is well suited for indoor environments 
where GPS is unavailable and in the absence of other positioning markers, 
beacons, etc. [GA021]

### VSLAM Assembly
The mapping platform assembly is to mount the PCAM 5C in a fixed positition 
that looks down from the SP701 evaluation board.  The PMOD NAV IMU module 
will be attached to the PMOD1 port on the SP701.  A 3D printed case is being 
being designed to simultaneously position the camera and secure the IMU as well as 
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
this project since I have more experience using Arm architecture from Zynq 7000 projects.  The Arm Cortex 
M1 and M4 IP is available free of charge through Arm DesignStart FPGA program with access
provided directly by Arm.  While my early impressions of using the Arm core were promising,
I ultimately decided to use a Xilinx MicroBlaze Soft Processor core. While this was my 
was my fist experience using a MicroBlaze core, I was able to get up and running
up and running quickly thanks to a wide selection of documentation and examples provied 
by Xilinx. 

Since the PMOD 5C camera implements the MIPI CSI-2 standard, I was able to leverage Xilinx
IP to capture and process image data.  The MIPI CSI-2 Receiver Subsystem module consists of a 
MIPI PHY module for interfacing to the camera module.  And the output is an AXI-stream video
data signal that undergoes further signal processing.

A custom logic block to perform the visual odometry is still under development.  The is a custom Verilog block that will take the AXI-stream video signal as input 
and the output is an estimated distance (dx, dy).

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
In the Xilinx ecosystem, the hardware design from the previous section is exported to the 
Vitis IDE.  Vitis is a relatively new replacement for the Xilinx ISE software IDE, but 
fortunately Xilinx provides an excellent tutorial to implement a MicroBlaze core on the 
SP701 evaluation board (https://xilinx.github.io/Embedded-Design-Tutorials/docs/2021.2/build/html/docs/Feature_Tutorials/microblaze-system/README.html).
I decided to take a detour from my design to complete this tutorial since this is my fist 
experience implementing a full MicroBlaze system and using Vitis. 

Right now the software components of this project are in the "Hello World" phase. It can quite
literally print "Hello World" over the UART serial connection.  When considering all the 
components that must be in place for this to work, it is actually quite motivating to tackle 
future algorithm implementation that will be the heart of the VSLAM platform. My next step will 
be to replace "Hello World" with integration tests to ensure my custom RTL blocks perform as expected
in the FPGA implementation.  


## Conclusions, Comments, and Next Steps
I had a lot of fun participating in the Experimenting with Sensor Fusion Design Challenge from 
Element14 and AMD/Xilinx.  FPGAs are essentially blank slates, so it was a little overwhelming to 
get started.  I had a couple false starts when settling on the system architecture. My initial designs used
Arm microcontroller soft cores, which I reasoned would be more useful if I want to re-implement this 
logic on a Zynq 7000 or Zynq Ultrascale MPSoC system.  In the end, I found the MicroBlaze examples from 
to be easy to use and the fastest way to get from zero to a running platform.  However, in the future I 
would like to revisit an Arm Cortex M1 or M4 version of this project.

Because the PCAM 5C conforms to the MIPI CSI-2 standard, the Xilinx IP integration tools were a fast way to create a video signal processing 
workflow.  This allowed me to identify targeted regions where custom RTL can be developed to add my own functionality 
to the system.  I did find some challenges with IP between different versions of Vivado.  This wasn't an issue for 
stable IP packages, but there were some instances where noticibly different IP interfaces were present when one Xilinx example was created with
a previous Vivado version and I attempted to open it in a newer version.  Additionally, some IP was not supported at all in
recent versions of Vivado.  That said, IP integration as a FPGA design strategy was orders of magnitude faster
that pure RTL design strategies.

The project repository is located at https://github.com/jerahmie/sensor_fusion_vslam.git.
I intend to continue to develop this platform over the next few months to finish implementing the final VSLAM
algorithms.  What I learned through this design challenge can be incorporated in future projects.

[GA021] Gao, X.; Zhang, T. Introduction to Visual SLAM: From Theory to Practice; Springer Nature: Berlin, Germany, 2021.
