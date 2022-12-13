module FuntionGenerator(
    input clk,
    input rstn,
    input wave_en,
    input [1:0] wave_select,
    input [7:0] phase_init,		// 初相位
    input [7:0] f_step, 		// 频率步长

    output [9:0] data_out,
    output data_out_en
);

endmodule