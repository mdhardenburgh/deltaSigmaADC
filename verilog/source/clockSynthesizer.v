/**
 * @file clockSynthesizer.v
 * @engineer Matthew Hardenburgh
 * @copyright Delta Technologies
 * @license GPL V3
 * @date 3/31/19
 * @email mdhardenburgh@gmail.com
 * @brief generates a 1MHz system clock from the on chip 100MHz clock
 */

/**
 * @brief divides the board clock using a 32 bit counter
 * @input system clock
 * @input reset button
 * @output slower clock signal
 */
module clockDivider #(parameter frequencySel = 32'd50)
(
    input clk,
    input rst,

    output reg[7:0] slowerClock
);

    reg[31:0] counter;
    always@(posedge clk, posedge rst)
    begin
        if(rst == 1'b1)
        begin
            slowerClock <= 8'b0;
            counter <= 32'b0;
        end

        else
        begin
            if(counter == frequencySel)
            begin
                counter <= 32'b0;
                slowerClock <= ~slowerClock;
            end

            else
            begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule