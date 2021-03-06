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
 * @file BinaryStreamer.v
 * @engineer Matthew Hardenburgh
 * @date 4/14/19
 * @email mdhardenburgh@gmail.com
 * @brief converts the output of the delta sigma adc
 * @details modules specific to the delta sigma adc. Takes the serial binary stream
 *          output of the delta sigma modulator and converts it to an eight bit
 *          parallel data stream
 */

module binaryStreamer
(
    input clk,
    input rst,
    input adcInput,
    input fifoReadEnable,

    output[7:0] streamerData,
    output fifoEmpty,
    output fifoFull
);

    wire[7:0] byteStream;

    reg[31:0] counter;
    reg fifoWriteEnable;
    reg accumRst;

    //Instantiate IP cores
    c_accum_0 myAccumulator(adcInput, clk, accumRst, byteStream);
    fifo_generator_0 myFifo(clk, rst, byteStream, fifoWriteEnable, fifoReadEnable, streamerData, fifoFull, fifoEmpty);

    //Decimator counter
    always@(posedge clk, posedge rst)
    begin
        if(rst == 1'b1)
        begin
            counter <= 32'b0;
            fifoWriteEnable <= 1'b0;
            accumRst <= 1'b1;
        end

        else
        begin
            if(counter < 32'd256)
            begin
                counter <= counter + 1'b1;
                fifoWriteEnable <= 1'b0;
                accumRst <= 1'b0;
            end

            else
            begin
                fifoWriteEnable <= 1'b1;
                accumRst <= 1'b1;
                counter <= 1'b0;
            end
        end
    end
endmodule