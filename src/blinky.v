// Shared LED blinker for multiple FPGA boards
// Drives one LED from the MSB of a free-running counter.
// Clock frequency and pin mapping are board-specific (see constraints/ and boards/).

module blinky (
    input  wire clk,
    output wire led
);

    // 26-bit counter gives a visible blink on typical 25-100 MHz clocks
    reg [25:0] counter = 0;

    always @(posedge clk) begin
        counter <= counter + 1;
    end

    // MSB toggles roughly once per 2^26 clocks
    assign led = counter[25];

endmodule
