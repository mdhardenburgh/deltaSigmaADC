/** 
* Copyright (C) 2019  Delta Technologies
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation version 3 of the License.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see https://www.gnu.org/licenses/ 
**/

/**
 * @file uartTransmit.v
 * @engineer Matthew Hardenburgh
 * @date 4/3/19
 * @email mdhardenburgh@gmail.com
 * @brief state machine to send bits to a computer's com port
 */

/**
 * 100MHz clock and a 921600 bit rate (baud rate)
 * (100000000) / (921600) = 108.5 clocks per bit ~ 108 clocks
 *
 * 10MHz clock and a 921600 bit rate (baud rate)
 * (10000000) / (921600) = 10.85 clocks per bit ~ 11 clocks
 *
 * 5MHz clock and a 921600 bit rate (baud rate)
 * (5000000) / (921600) = 5.425 clocks per bit ~ 5 clocks
 *
 * 1MHz clock and a 921600 bit rate (baud rate)
 * (1000000) / (921600) = 1.085 clocks per bit ~ 1 clock
 **/


/**
 * @brief serial communication module using the UART (RS232) protocol
 *
 * @input clock input
 * @input system reset input
 * @input byte of the bitstream
 * @input control flow input. Prevents reciving serial buffer overflow
 * @input data ready to be read. Data flow control bit
 *
 * @output serial transmit line
 * @output ready to accept data. Data flow control bit
 * @output test signal for debugging
 **/
module uartTransmitter #(parameter clks_per_bit = 8'd108)
(
    input clk, 
    input rst,
    input [7:0] adcInput,
    input txCtlFlow,
    input dataRdy,

    output reg tx,
    output reg dataRead,
    output reg printStatement
);
    //Output for UART
    localparam startCondition = 1'b0;
    localparam endCondition = 1'b1;

    //States
    localparam startTransmission = 2'd0;
    localparam transmitData = 2'd1;
    localparam endTransmission = 2'd2;
    localparam idleSpin = 2'd3;

    //Counter and state counter declarations
    reg[1:0] stateCounter;
    reg[7:0] binaryCounter;
    reg[1:0] endCounter;
    reg[7:0] clockCounter;

    reg[7:0] adcHold;

    always@(posedge clk, posedge rst)
    begin
        if(rst == 1'b1)
        begin
            tx <= 1'b1;
            endCounter <= 2'b0;
            binaryCounter <= 8'b0;
            clockCounter <= 8'd0;
            stateCounter <= idleSpin;
            dataRead <= 1'b1;
        end

        else
        begin
            case(stateCounter)
            
                startTransmission:
                begin
                    tx <= startCondition;
                    if(clockCounter < clks_per_bit)
                    begin
                        clockCounter <= clockCounter + 1'b1;
                        stateCounter <= startTransmission;
                    end

                    else
                    begin
                        clockCounter <= 4'b0;
                        stateCounter <= transmitData;
                    end
                end

                transmitData:
                begin
                    tx <= adcHold[binaryCounter];

                    if(binaryCounter < 8'd8)
                    begin             
                        
                        stateCounter <= transmitData;
                        
                        if(clockCounter < clks_per_bit)
                        begin
                            clockCounter <= clockCounter + 1'b1;
                        end

                        else
                        begin
                            clockCounter <= 4'b0;
                            binaryCounter <= binaryCounter + 1'b1;
                        end

                    end

                    else
                    begin
                        stateCounter <= endTransmission;
                        binaryCounter <= 4'd0;
                        dataRead <= 1'b1;
                    end
                end

                endTransmission:
                begin
                    tx <= endCondition;
                    dataRead <= 1'b0;
                    if(endCounter < 2'd2)
                    begin
                        stateCounter <= endTransmission;
                        if(clockCounter < clks_per_bit)
                        begin
                            clockCounter <= clockCounter + 1'b1;
                        end

                        else
                        begin
                            clockCounter <= 4'b0;
                            endCounter <= endCounter + 1'b1;
                        end
                    end

                    else
                    begin
                        stateCounter <= idleSpin;
                        endCounter <= 2'b0;
                    end
                end

                idleSpin:
                begin
                    //printStatement <= txCtlFlow;
                    dataRead <= 1'b0;
                    adcHold <= adcInput;
                    if(txCtlFlow == 1'b1)
                    begin
                        stateCounter <= idleSpin;
                    end

                    else
                    begin
                        stateCounter <= startTransmission;
   
                        if(dataRdy == 1'b1)
                        begin
                            stateCounter <= startTransmission;
                            //printStatement <= 1'b1;
                        end

                        else
                        begin
                            stateCounter <= idleSpin;
                            printStatement <= 1'b1;
                        end
                    end
                end

            endcase
        end
    end
endmodule

/**
 * @brief top level module
 * 
 * @input system clock
 * @input system reset
 * @input input from delta sigma modulator
 * @input UART control flow line
 * 
 * @output UART serial output
 * @output clock for the delta sigma modulator
 * @output PLL is locked and functional. Used for debugging.
 * @output used for debugging
 **/
module uartTop
(
    input clk, 
    input rst,
    input adcInput,
    input txCtlFlow,
    
    output tx,
    output outClock,
    output pllLocked,
    output printStatment
);
    
    wire clkWire;
    wire streamerClk;
    wire clk1;
    wire clk2;
    wire clk3;
    wire dataRead;
    wire dataRdy;
    wire[7:0] adcStream;

    clk_wiz_0 systemClock(clk1, clk2, clk3, rst, pllLocked, clk);
    clockSynthesizer #(50) div1(clk1, rst, outClock);
    clockDivider #(50) div3(clk3, rst, streamerClk);

    binaryStreamer myStream(streamerClk, dataRead, adcInput, adcStream, dataRdy);
    uartTransmitter myTransmitter(clk2, rst, adcStream, txCtlFlow, dataRdy, tx, dataRead, printStatment);
endmodule