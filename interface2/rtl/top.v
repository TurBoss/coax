`default_nettype none

module top (
    input clk_16mhz,

    // Receiver
    input rx,
    output rx_active,
    output rx_error,

    input reset,
    output debug,

    output usb_pu
);
    // 38 MHz
    //
    // icepll -i 16 -o 37.738
    wire clk_38mhz;

    SB_PLL40_CORE #(
        .FEEDBACK_PATH("SIMPLE"),
        .DIVR(4'b0000),
        .DIVF(7'b0100101),
        .DIVQ(3'b100),
        .FILTER_RANGE(3'b001)
    ) clk_38mhz_pll (
        .RESETB(1'b1),
        .BYPASS(1'b0),
        .REFERENCECLK(clk_16mhz),
        .PLLOUTCORE(clk_38mhz)
    );

    reg rx_0 = 0;
    reg rx_1 = 1;

    always @(posedge clk_38mhz)
    begin
        rx_0 <= rx;
        rx_1 <= rx_0;
    end

    coax_rx #(
        .CLOCKS_PER_BIT(16)
    ) coax_rx (
        .clk(clk_38mhz),
        .rx(rx_1),
        .reset(reset),
        .active(rx_active),
        .error(rx_error)
    );

    assign debug = rx_1;

    assign usb_pu = 0;
endmodule
