`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/01 21:40:51
// Design Name: 
// Module Name: test_ip_ram
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


module test_ip_ram();

    reg clk;
    reg rstn;

ip_ram ip_ram_u0(
    .sys_clk             (clk),
    .sys_rst_n           (rstn)
    );

    initial begin
        clk = 0;
        rstn = 0;
        #50;
        rstn = 1'b1; 
        #1000;
        $finish;
    end

    always #10 clk=~clk;
    
endmodule
