module clockDivider
(
    input clk,
    input rst,

    output wire outClock,
    output wire locked
);

    clk_wiz_0 myClock(outClock, rst, locked, clk);

endmodule