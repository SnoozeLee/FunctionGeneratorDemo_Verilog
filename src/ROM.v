module Triangle_ROM (
// module ROM (    // 测试行
    input clk,
    input en,
    input [7:0] addr,   // 0-255

    output [9:0] q
);
reg [7:0] data_out;
always @(posedge clk or negedge en) begin
    if(!en) begin
       data_out <= 7'b0;
    end 
    else begin 
        if ( addr<8'd128 ) begin
            data_out <= addr;
        end else begin
            data_out <= 0;
        end
    end
end
assign q = {data_out, 3'b0};
endmodule

// module Triangle_Reverse_ROM (
module ROM (    // 测试行
    input clk,
    input en,
    input [7:0] addr,   // 0-255

    output [9:0] q
);
reg [7:0] data_out;
always @(posedge clk or negedge en) begin
    if(!en) begin
       data_out <= 7'b0;
    end 
    else begin 
        if ( addr<8'd128 ) begin
            data_out <= 8'd128-addr;
        end else begin
            data_out <= 0;
        end
    end
end
assign q = {data_out, 3'b0};
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
        if(0<addr<=8'd128) begin data_out <= 1'b1; end
        else begin data_out <= 1'b0; end
    end
end
assign q = {data_out, 9'b0};

endmodule

module Cos_ROM (
    input clk,
    input en,
    input [7:0] addr,   // 0-255

    output [9:0] q
);
reg[7:0] data_out;
always @(posedge clk or negedge en) begin
    if(!en) begin
        data_out <= 8'b0;
    end
    else if(clk) begin 
        data_out = getPoint(addr);
    end
end
function  [7:0] getPoint;
    input [7:0] addr;   // 0-255
    reg [0:64] ROM_t[9:0] = {
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
    reg [9:0] amplitude;    // 幅值 0-1024

    if(10'd0<=addr && addr <10'd64) begin amplitude=10'd512+ROM_t[addr]; end  // 1023->524
    else if(10'd64<=addr && addr<10'd128) begin amplitude=10'd512-ROM_t[10'd128-addr]; end   // 512->2
    else if(10'd128<=addr && addr<10'd192) begin amplitude=10'd511-ROM_t[addr-10'd128]; end   // 0->509
    else if(10'd192<=addr && addr<10'd256) begin amplitude=10'd512+ROM_t[10'd256-addr]; end    // 512->1022    
    
    getPoint = amplitude;
endfunction
endmodule