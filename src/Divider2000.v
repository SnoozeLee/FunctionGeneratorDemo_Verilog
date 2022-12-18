module Divider200(
    input clkIn,
    output reg clkOut,
    output [10:0] statenow
);

reg [10:0] state;
initial begin
    state = 0;
end
always @(posedge clkIn) begin
    if(state < 100) begin clkOut = 1; state = state+1; end
    else if(state < 200) begin clkOut = 0; state = state+1; end
    else begin state = 1; clkOut = 1; end
end
assign statenow = state;
endmodule