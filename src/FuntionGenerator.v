module FuntionGenerator(
    input clk_50MHz,
    input rstn,                     // 0-复位(停止输出)  1-正常输出
    input [1:0] wave_select,        // 选择波形
    // input [7:0] phase_init,		// 初相位
    input [1:0] gears, 		        // 档位(频率)控制

    output [9:0] data_out,          // 电平输出
    output reg data_out_en,              // 可能需要用到的D/A开关
    output data_clk                // 供D/A时钟
);

// 分频时钟线
wire clk;

// 频率步长
wire [7:0] f_step;

// 相位累加器
reg phase_en;                   // 相位累加器使能
reg [7:0] phase_init_num;       // 相位初始值
wire [7:0] phase_state;         // 累加器输出相位

// ROM表 
reg wave_en;                // ROM表使能

initial begin
    phase_en = 0;
    wave_en = 0;
    phase_init_num = 8'd128;
end

always @(negedge rstn or posedge clk) begin
    if(!rstn) begin 
        // 停止输出
        phase_en = 0;   // 相位置初始化
        wave_en = 0;    // 输出波形置低电平
        data_out_en = 0;
    end
    else begin
        // 开始输出
        phase_en = 1;
        wave_en = 1;
        data_out_en = 1;
    end
end

assign data_clk = clk_50MHz;

Divider200 divider200_1(
    .clkIn (clk_50MHz),
    .clkOut (clk)
);

FrequencyControl frequency_control_1 (
    .gears (gears),
    .f_step (f_step)
);

PhaseCounter phase_counter_1(
    .clk (clk),
    .en (phase_en),
    .init_phase (phase_init_num),   // 初始相位
    .step (f_step),                 // 步长
    .phase (phase_state)            // 输出相位
);

ROM rom_1(
    .clk (clk),
    .en (wave_en),
    .select (wave_select),          // 选择波形
    .phase_in (phase_state),        // 输入相位
    .amplitude (data_out)           // 输出电平(波形)
);

endmodule