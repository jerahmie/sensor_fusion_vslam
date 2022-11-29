
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
(yet) have a 3D printer, the printed case structure will be completed at a later
date.

## Logic Design, IP Layout, and Custom Logic Overview

## Software Overview

## Conclusions, Comments, and Next Steps

