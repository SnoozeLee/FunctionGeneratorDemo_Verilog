module FrequencyControl(
    input [1:0] gears,
    output [7:0] f_step
);
// 256个点
// 需要配置clk为50MHz 2000分频 -> 40us
reg [7:0] step;
always @(*) begin
    if(gears == 2'b00) begin 
        step=8'd1;    // 100Hz 
    end
    if(gears == 2'b01) begin step=8'd2; end
    if(gears == 2'b10) begin step=8'd10; end
    else begin 
        step=8'd20;   // 2kHz
    end
end

assign f_step = step;
endmodule