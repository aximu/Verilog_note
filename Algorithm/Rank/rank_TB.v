`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/21 17:14:18
// Design Name: 
// Module Name: rank_TB
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


module rank_TB;
 reg    aken;
 reg aclk = 0;
 reg    [7:0]   in_data = 0;
 reg    ready;
 wire   valid;
 wire [7:0] out_data;

 rank uut(
 .aclk(aclk),
 .aken(aken),
 .in_data(in_data),
 .ready(ready),
 .valid(valid),
 .out_data(out_data)
 );

 reg[11:0] mem0_re[700:0];
 integer    temp_i = 0;

 initial $readmemh("E:/program/vivado/rank/data.txt",mem0_re);


 always #5 aclk <= !aclk;

 always @(posedge aclk)
 begin

  ready <= 1;

  if(ready&&ready)
  begin
  in_data <= mem0_re[temp_i];
   temp_i <= temp_i+1;
  end

 end

 initial
 begin
  aken <=0 ;

  #30;

  aken <= 1;


 end
endmodule