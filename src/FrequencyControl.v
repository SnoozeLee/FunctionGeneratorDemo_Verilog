module FrequencyControl(
    input [1:0] gears,      // 11 01 00 10 -> 10KHz 4kHz 2kHz 1kHz
    output [7:0] f_step
);
// 256个点
// 需要配置clk为50MHz 2000分频 -> 40us
reg [7:0] step;
always @(*) begin
    if(gears == 2'b11) begin 
        step=8'd10;    // 10000Hz 
    end
    else if(gears == 2'b01) begin step=8'd4; end
    else if(gears == 2'b00) begin step=8'd2; end
    else begin 
        step=8'd1;   // 1000Hz
    end
end

assign f_step = step;
endmodule