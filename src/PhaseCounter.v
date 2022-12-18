module PhaseCounter(
    input clk,
    input en,              // 0-初始化 1-正常计数
    input [7:0] init_phase,     // 初始相位
    input [7:0] step,    // 步长，用以控制频率

    output [7:0] phase     //输出相位
);
// 在此次设计中，2pai分解为256个点
reg [8:0] phase_state;    // 当前相位状态

always @(posedge clk or negedge en) begin
    if(!en) begin phase_state = init_phase; end
    else if(clk) begin 
        // phase_state = phase_state + step; // 设置了定宽[7:0]，自动达到取模的效果 -> 但是这样会导致信号抖动（因为每次刷新周期时可能都是不同相位)
        phase_state = phase_state + step; 
        if(phase_state >= 9'b100000000) begin phase_state = init_phase; end
    end
    else begin phase_state = init_phase; end
end

assign phase = phase_state[7:0];

endmodule   // PhaseCounter