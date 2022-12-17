module Divider2000(
    input clkIn,
    output reg clkOut
);

reg [10:0] state;

always @(posedge clkIn) begin
    if(state < 1000) begin clkOut = 1; state = state+1; end
    else if(state < 2000) begin clkOut = 1; state = state+1; end
    else begin state = 1; clkOut = 1; end
end

endmodule