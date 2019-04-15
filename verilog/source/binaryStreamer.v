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

    output reg[7:0] adcOutput,
    output reg newDataReady
);
    
    reg[7:0] counter;

    always@(posedge clk, posedge rst)
    begin
        if(rst == 1'b1)
        begin
            newDataReady <= 1'b0;
            adcOutput <= 8'b0;
            counter <= 7'b0;
        end

        else
        begin
            adcOutput[counter] <= adcInput;

            if(counter < 8'd8)
            begin
                counter <= counter + 1'b1;
            end

            else
            begin
                newDataReady <= 1'b1;
            end
        end
    end


endmodule