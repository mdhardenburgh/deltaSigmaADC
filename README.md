# 2019 Senior Capstone Project: Delta Sigma ADC
## Designed by Matthew Hardenburgh. California State University, Chico Electrical Engineering and Computer Engineering Department

For this project I designed and implemented a Delta Sigma ADC. I implemented the Delta Sigma Modulator circuit on a breadboard. The 
modulator is a second order modulator that operates at 10MHz. The output of the modulator is fed into an FPGA that performs the digital filtering. The digital filter is a cascaded integrator–comb filter block from Xilinx. The FPGA is connected over Via UART over USB to a computer running a simple MATLAB script that displays the output.

Please see sigmaDelta.pdf for a full project description and test results.

The ECAD folder contains a circuit diagram of the modulator and associated datasheets.

The verilog/source folder contains the source verilog code for the project. It is under the GPLv3 license.

The verilog/digitalSignalProcessing folder is the Vivado project folder.

The matlabAndSimulink folder contains the matlab code for the project. It contains: filter designer files (.fda), Xilinx coefficient files (.coe), text documents of FIR filter coefficients, simulink model of the delta sigma modulator, and various files associated with the simulink model. The file fftStreamer.m can be used to view the fft of the output of the ADC. The file uart.m can be used to view the output waveform of the file.

### Bill of Materials (BOM)
- Digilent Nexys 4 DDR
- AD8044 Quad 15MHz Rail-to-Rail Amplifier
- AD8561 Ultrafast 7ns Singl Supply Comparator
- ADG1633 Tripple SPDT ±5V, +12V, +5V, and +3.3V Switches
- Double large breadboard
- 3.5mm Headphone jack
- Breadboard wires and jumpers

### Software Used
- KiCAD 5.0.0
- Xilinx Vivado 2018.1
- MATLAB R2019a
- LTspice XVII
