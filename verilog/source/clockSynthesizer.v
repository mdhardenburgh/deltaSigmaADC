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
 * @file clockSynthesizer.v
 * @engineer Matthew Hardenburgh
 * @date 3/31/19
 * @email mdhardenburgh@gmail.com
 * @brief divides the system clock to a local clock
 **/

/**
 * @brief divides the system clock. Has a high imedance reset
 *
 * @input system clock
 * @input system reset 
 * @output slower clock
 **/
module clockSynthesizer #(parameter frequencySel = 32'd50)
(
    input clk,
    input rst,

    output outClock
);
    reg slowerClock;
    reg[31:0] counter;
    
    assign outClock = (rst == 1'b1)? 1'bZ: slowerClock;
    
    always@(posedge clk, negedge rst)
    begin
        if(rst == 1'b1)
        begin
            counter <= 32'b0;
            slowerClock <= 1'b0;
        end

        else
        begin

            if(counter == frequencySel)
            begin
                counter <= 32'b0;
                slowerClock = ~slowerClock;
            end

            else
            begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule

/**
 * @brief divides the system clock.
 * 
 * @input system clock
 * @input system reset button
 * @output slower clock
 **/
module clockDivider #(parameter frequencySel = 32'd50)
(
    input clk,
    input rst,

    output reg slowerClock
);
    reg[31:0] counter;
    
    always@(posedge clk, negedge rst)
    begin
        if(rst == 1'b1)
        begin
            counter <= 32'b0;
            slowerClock <= 1'b0;
        end

        else
        begin

            if(counter == frequencySel)
            begin
                counter <= 32'b0;
                slowerClock = ~slowerClock;
            end

            else
            begin
                counter <= counter + 1'b1;
            end
        end
    end


endmodule