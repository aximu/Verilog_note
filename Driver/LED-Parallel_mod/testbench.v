`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/19 11:25:42
// Design Name: 
// Module Name: testbench
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


module testbench();
     reg CLK;
     reg  RSTn;
     wire Flash_LED;
     wire [2:0]Run_LED;
     
     mix_module i1(
        .CLK(CLK),
        .RSTn(RSTn),
        .Flash_LED(Flash_LED),
        .Run_LED(Run_LED)
     );
     
     initial begin
        CLK = 0;
        RSTn = 0;
        #50;
        RSTn = 1;
     end
     
     always #5 CLK = ~CLK;

endmodule
