/**
 * @file adcFF.v
 * @engineer Matthew Hardenburgh
 * @date 4//19
 * @email mdhardenburgh@gmail.com
 * @brief get ADC bit at a time
 */

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
*/

module adcFF
(
    input clk,
    input rst,
    input adc,
    
    output reg adcSample
);

    always@ (posedge clk)
    begin
        if(rst == 1'b1)
        begin
            adcSample <= 1'b0
        end

        else
        begin
            adcSample <= adc
        end
    end
endmodule

