`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 10:03:47
// Design Name: 
// Module Name: ram_wr
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


module ram_wr(
    input               clk,
    input               rst_n,
    
    output reg          ram_en,
    output reg          rw,
    output reg [4:0]    ram_addr,
    output reg [7:0]    ram_wr_data
    );
    
    //ram enable
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            ram_en <= 1'b0;
        else
            ram_en <= 1'b1;
        end

    //read or write counter;counter <= 31 -->write; >=31 -->read;
    reg [5:0] cnt_wr;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt_wr <= 6'b0;
        else if(cnt_wr == 6'd63)
            cnt_wr <= 6'b0;
        else
            cnt_wr <= cnt_wr + 1;
    end
    
    //wrirte data 
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            ram_wr_data <= 8'b0;
        else if((cnt_wr <= 6'd31) && ram_en)
            ram_wr_data <= ram_wr_data + 1;
        else
            ram_wr_data <= ram_wr_data;
    end

    //read write decide
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            rw <= 1'b1;     //read station
        else if(cnt_wr <= 6'd31)
            rw <= 1'b1;
        else
            rw <= 1'b0;       //write station
    end

    //addr
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            ram_addr <= 5'b0;     //read station
        else
            ram_addr <= cnt_wr[4:0];       //write station
    end



endmodule
