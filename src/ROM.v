module ROM(
    input clk,
    input en,       
    input [1:0] select,   // 选择波形 00-三角波 01-反三角波 10-方波 11-余弦波
    input [7:0] phase_in,   // 输入相位

    output [9:0] amplitude // 输出波形 0-1023
);
wire [9:0] amp_out_cos;  // amplitude 输出波形前先在第一个clk到来时把幅值信号计算好放在这
wire [9:0] amp_out_tri;  // amplitude 输出波形前先在第一个clk到来时把幅值信号计算好放在这
wire [9:0] amp_out_tri_rev;  // amplitude 输出波形前先在第一个clk到来时把幅值信号计算好放在这
wire [9:0] amp_out_square;  // amplitude 输出波形前先在第一个clk到来时把幅值信号计算好放在这
reg [1:0] en_wait;  // en_wait[0]高电平时计算幅值 en_wait[1]高电平时才输出
Cos_ROM cosrom_1(
    .clk (clk),
    .en (en_wait[0] & (select == 2'b11)),
    .addr (phase_in),
    .q (amp_out_cos)
);

Square_ROM squarerom_1(
    .clk (clk),
    .en (en_wait[0] & (select == 2'b10)),
    .addr (phase_in),
    .q (amp_out_square)
);

Triangle_ROM trianglerom_1(
    .clk (clk),
    .en (en_wait[0] & (select == 2'b00)),
    .addr (phase_in),
    .q (amp_out_tri)
);

Triangle_Reverse_ROM triangle_reverse_rom_1(
    .clk (clk),
    .en (en_wait[0] & (select == 2'b01)),
    .addr (phase_in),
    .q (amp_out_tri_rev)
);

always @(posedge clk or negedge en) begin
    if(!en) begin en_wait <= 2'b00; end
    else begin 
        en_wait = {en_wait[0], en}; // 延期一个时钟信号
    end
end

assign amplitude = en_wait[1]?
    (amp_out_cos|amp_out_tri|amp_out_tri_rev|amp_out_square) : 10'b0;     // 第一个时钟上升沿不输出

endmodule

module Triangle_ROM (
    input clk,
    input en,
    input [7:0] addr,   // 0-255

    output [9:0] q
);
reg [7:0] data_out;
always @(posedge clk or negedge en) begin
    if(!en) begin
       data_out <= 8'b0;
    end 
    else begin 
        // if ( addr<8'd128 ) begin
        //     data_out <= addr;
        // end else begin
        //     data_out <= 0;
        // end
        data_out <= addr;
    end
end
assign q = {data_out, 2'b0};
endmodule

module Triangle_Reverse_ROM (
    input clk,
    input en,
    input [7:0] addr,   // 0-255

    output [9:0] q
);
reg [7:0] data_out;
always @(posedge clk or negedge en) begin
    if(!en) begin
       data_out <= 8'b0;
    end 
    else begin 
        // if ( addr<8'd128 ) begin
        //     data_out <= 8'd128-addr;
        // end else begin
        //     data_out <= 0;
        // end
        data_out <= 8'd255-addr; 
    end
end
assign q = {data_out, 2'b0};
endmodule

module Square_ROM (
    input clk,
    input en,
    input [7:0] addr,   // 0-255

    output [9:0] q
);
reg data_out;
always @(posedge clk or negedge en) begin
    if(!en) begin data_out <= 8'b0; end
    else if(clk) begin 
        if(0<addr && addr<=8'd128) begin data_out <= 1'b1; end
        else begin data_out <= 1'b0; end
    end
end
// assign q = {data_out, 9'b0};
assign q = (data_out == 1'b1)? 10'd1023 : 10'd0;

endmodule

module Cos_ROM (
    input clk,
    input en,
    input [7:0] addr,   // 0-255

    output reg [9:0] q
);

// reg [8:0] ROM_t [0 : 64];
reg [8:0] ROM_t [0 : 64];
initial begin
    ROM_t[0] = 9'd511;
    ROM_t[1] = 9'd510;
    ROM_t[2] = 9'd510;
    ROM_t[3] = 9'd509;
    ROM_t[4] = 9'd508;
    ROM_t[5] = 9'd507;
    ROM_t[6] = 9'd505;
    ROM_t[7] = 9'd503;
    ROM_t[8] = 9'd501;
    ROM_t[9] = 9'd498;

    ROM_t[10] = 9'd495;
    ROM_t[11] = 9'd492;
    ROM_t[12] = 9'd488;
    ROM_t[13] = 9'd485;
    ROM_t[14] = 9'd481;
    ROM_t[15] = 9'd476;
    ROM_t[16] = 9'd472;
    ROM_t[17] = 9'd467;
    ROM_t[18] = 9'd461;
    ROM_t[19] = 9'd456;

    ROM_t[20] = 9'd450;
    ROM_t[21] = 9'd444;
    ROM_t[22] = 9'd438;
    ROM_t[23] = 9'd431;
    ROM_t[24] = 9'd424;
    ROM_t[25] = 9'd417;
    ROM_t[26] = 9'd410;
    ROM_t[27] = 9'd402;
    ROM_t[28] = 9'd395;
    ROM_t[29] = 9'd386;

    ROM_t[30] = 9'd378;
    ROM_t[31] = 9'd370;
    ROM_t[32] = 9'd361;
    ROM_t[33] = 9'd352;
    ROM_t[34] = 9'd343;
    ROM_t[35] = 9'd333;
    ROM_t[36] = 9'd324;
    ROM_t[37] = 9'd314;
    ROM_t[38] = 9'd304;
    ROM_t[39] = 9'd294;

    ROM_t[40] = 9'd283;
    ROM_t[41] = 9'd273;
    ROM_t[42] = 9'd262;
    ROM_t[43] = 9'd251;
    ROM_t[44] = 9'd240;
    ROM_t[45] = 9'd229;
    ROM_t[46] = 9'd218;
    ROM_t[47] = 9'd207;
    ROM_t[48] = 9'd195;
    ROM_t[49] = 9'd183;

    ROM_t[50] = 9'd172;
    ROM_t[51] = 9'd160;
    ROM_t[52] = 9'd148;
    ROM_t[53] = 9'd136;
    ROM_t[54] = 9'd124;
    ROM_t[55] = 9'd111;
    ROM_t[56] = 9'd99;
    ROM_t[57] = 9'd87;
    ROM_t[58] = 9'd74;
    ROM_t[59] = 9'd62;

    ROM_t[60] = 9'd50;
    ROM_t[61] = 9'd37;
    ROM_t[62] = 9'd25;
    ROM_t[63] = 9'd12;
    ROM_t[64] = 9'd0;
end
// reg [8:0] ROM_t [0 : 64] = '{
// 9'd511, 9'd510, 9'd510, 9'd509, 9'd508, 9'd507, 9'd505, 9'd503,
// 9'd501, 9'd498,   9'd495, 9'd492, 9'd488, 9'd485, 9'd481, 9'd476,
// 9'd472, 9'd467, 9'd461, 9'd456,   9'd450, 9'd444, 9'd438, 9'd431,
// 9'd424, 9'd417, 9'd410, 9'd402, 9'd395, 9'd386,   9'd378, 9'd370,
// 9'd361, 9'd352, 9'd343, 9'd333, 9'd324, 9'd314, 9'd304, 9'd294,
//    9'd283, 9'd273, 9'd262, 9'd251, 9'd240, 9'd229, 9'd218, 9'd207,
// 9'd195, 9'd183,    9'd172, 9'd160, 9'd148, 9'd136, 9'd124, 9'd111,
// 9'd99 , 9'd87 , 9'd74 , 9'd62 , 9'd50 , 9'd37 , 9'd25 , 9'd12 ,
// 9'd0};
//as the symmetry of cos function, just store 1/4 data of one cycle

always @(posedge clk) begin
    if (en) begin
        if (addr[7:6] == 2'b00 ) begin  //quadrant 1, addr[0, 63]
            q <= ROM_t[addr[5:0]] + 10'd512 ; //上移
        end
        else if (addr[7:6] == 2'b01 ) begin //2nd, addr[64, 127]
            q <= 10'd512 - ROM_t[64-addr[5:0]] ; //两次翻转
        end
        else if (addr[7:6] == 2'b10 ) begin //3rd, addr[128, 192]
            q <= 10'd512 - ROM_t[addr[5:0]]; //翻转右移
        end
        else begin     //4th quadrant, addr [193, 256]
            q <= 10'd512 + ROM_t[64-addr[5:0]]; //翻转上移
        end
    end
    else begin
        q <= 10'b0 ;
    end
end

/* 原定方案 - 出bug
reg [9:0] amplitude;    // 幅值 0-1024
// wire [9:0] ROM_t [0 : 64] ;
integer ROM_t[0:64] = {
    511, 510, 510, 509, 508, 507, 505, 503,
    501, 498, 495, 492, 488, 485, 481, 476,
    472, 467, 461, 456, 450, 444, 438, 431,
    424, 417, 410, 402, 395, 386, 378, 370,
    361, 352, 343, 333, 324, 314, 304, 294,
    283, 273, 262, 251, 240, 229, 218, 207,
    195, 183, 172, 160, 148, 136, 124, 111,
    99 , 87 , 74 , 62 , 50 , 37 , 25 , 12 ,
    0
};     // cos函数的 0到pai/2

always @(posedge clk or negedge en) begin
    if(!en) begin
        amplitude = 8'b0;
    end
    else if(clk) begin 
        if(10'd0<=addr && addr <10'd64) begin amplitude=10'd512+ROM_t[addr]; end  // 1023->524
        else if(10'd64<=addr && addr<10'd128) begin amplitude=10'd512-ROM_t[10'd128-addr]; end   // 512->2
        else if(10'd128<=addr && addr<10'd192) begin amplitude=10'd511-ROM_t[addr-10'd128]; end   // 0->509
        else if(10'd192<=addr && addr<10'd256) begin amplitude=10'd512+ROM_t[10'd256-addr]; end    // 512->1022    
    end
end

assign q = amplitude;
// endfunction

*/
endmodule