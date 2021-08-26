`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:12:57 03/10/2016 
// Design Name: 
// Module Name:    sorting_part 
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
module sorting_part( input clk,
		input partD,
		input [3:0] unsort_num0,
		input [3:0] unsort_num1,
		input [3:0] unsort_num2,
		input [3:0] unsort_num3,
		output reg[3:0] sort_num0,
		output reg[3:0] sort_num1,
		output reg[3:0] sort_num2,
		output reg[3:0] sort_num3,
		output start_display
		);

	reg [3:0] num [3:0];
	reg [1:0] i;
	reg [1:0] j;
	
	always @(posedge partD)
	begin
		i=0;
		j=0;
		num[0]=unsort_num0;
		num[1]=unsort_num1;
		num[2]=unsort_num2;
		num[3]=unsort_num3;

		mysort(i, j);
	end
	
	// Bubble sort//
	task mysort;
		input [1:0] i;
		input [1:0] j;
		reg [3:0] temp;
		begin
			if(num[j]>num[j+1])
			begin
				temp=num[j];
				num[j]=num[j+1];
				num[j+1]=temp;
			end
			if(j == 2)
			begin
				j=0;
				i=i+1;
			end
			if(i == 3)
			begin
				sort_num0=num[0];
				sort_num1=num[1];
				sort_num2=num[2];
				sort_num3=num[3];
			end
			else
			begin
				j=j+1;
				mysort(i,j);
			end
		end
	endtask
	assign start_display=1;		
		
endmodule
