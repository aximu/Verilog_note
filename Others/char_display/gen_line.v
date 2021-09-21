`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/21 13:35:47
// Design Name: 
// Module Name: gen_line
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

 module gen_line
#(
    parameter COL_CNT = 16'd80,                 //设置一行显示的字的个数
    parameter TURN = 1'b1                       //设置显示效果，设置为1效果是绿底黑字，设置为0效果是黑底绿字。
  )
   (
    input [127:0]row_data,
    output odata,

    input bit_clk,       //100ns
    input bit1_roll_clk, //2ns
    input reset_p
  );
  reg [23:0]col_cnt;
  wire odata_temp;

  always@(posedge bit_clk or posedge reset_p)
  begin
    if(reset_p)
      col_cnt <= 0;
   else if(col_cnt == COL_CNT-1)
     col_cnt <= COL_CNT - 1;
    else
      col_cnt <= col_cnt + 1;
  end

  assign odata_temp_p = row_data[COL_CNT - 1 - col_cnt] ? bit1_roll_clk : 1'd1;
  assign odata_temp_n = row_data[COL_CNT - 1 - col_cnt] ? 1'd1 : bit1_roll_clk;

  assign odata = TURN ? odata_temp_n : odata_temp_p;

  endmodule
