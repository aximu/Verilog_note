`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:11:58 03/10/2016 
// Design Name: 
// Module Name:    input_part 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module input_part(input clk,
	input [3:0] partA,
	input [3:0] partB,
	input partC,
	output reg [3:0] uns_num0, 
	output reg [3:0] uns_num1,
	output reg [3:0] uns_num2,	 
	output reg [3:0] uns_num3
	);
	
always@(posedge partC)
begin
	case(partA)
		4'b0001:  uns_num0 = partB;
		4'b0010:  uns_num1 = partB;
		4'b0100:  uns_num2 = partB;
		4'b1000:  uns_num3 = partB;
	endcase
end

endmodule
