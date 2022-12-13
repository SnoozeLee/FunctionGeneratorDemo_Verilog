module PhaseCounter(
    input clk,
    input en,
    input [7:0] init_phase,     // 初始相位
    input [7:0] step,    // 步长，用以控制频率

    output [7:0] phase     //输出相位
);
// 在此次设计中，2pai分解为256个点
reg [7:0] phase_state;    // 当前相位状态

always @(posedge clk or negedge en) begin
    if(!en) begin phase_state = init_phase; end
    else if(clk) begin 
        phase_state = phase_state + step; // 设置了定宽[7:0]，自动达到取模的效果
    end
    else begin phase_state = init_phase; end
end

assign phase = phase_state;

endmodule   // PhaseCounter