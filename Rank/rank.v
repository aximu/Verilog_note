`timescale 1ns / 1ps
//
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/21 15:40:50
// Design Name: 
// Module Name: rank
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
//


module rank(
 input wire aclk,   //模块输入时钟
 input wire aken,   //模块中断信号
 input wire [7:0]   in_data,    //输入信号数据
 input  wire ready,     
 output reg valid,
 output reg [7:0]   out_data    //输出信号数据
    );

 reg [7:0]  state   [255:0][255:0]; //比较大小记录寄存器
 reg [7:0]  sum [255:0];    //比较大小记录求和
 reg [7:0]  save_data   [255:0];    //输入数据存储
 reg    [7:0]   output_data [255:0];    //输出数据缓存
 reg    cacu_flag = 0;  //计算比较标志位
 reg    output_flag = 0;    //输出信号标志位
 reg clear_state = 0;   //清除内存标志位

 //一些计数变量
 integer out_data_i = 0;
 integer dat_num = 0;
 integer    temp_i = 0;
 integer    temp_j = 0;
 integer clear_i = 0;
 integer clear_j = 0; 

 parameter [1:0] ranking = 2'b00, // This is the initial/idle state               

    adding = 2'b01, // This state initializes the counter, ones   
        // the counter reaches C_M_START_COUNT count,        
        // the state machine changes state to INIT_WRITE     
    saving = 2'b10;
 reg    [1:0]   mst_exec_state;  

 initial $readmemh("C:/Users/74339/Desktop/vivado_code/ranking/int.txt",sum);

 always@(posedge aclk)  //清理内存逻辑控制
 begin
  if(clear_state)
  begin
   for(clear_i=0;clear_i<256;clear_i=clear_i+1)
   begin
    for(clear_j=0;clear_j<256;clear_j=clear_j+1)
    begin
     state[clear_i][clear_j]<=0;
    end
    sum[clear_i] <=0;
   end
   clear_state <= 0;
  end
 end

 always@(posedge aclk)  //计算开始逻辑控制
 begin
  if(dat_num>255)
  begin
   cacu_flag <= 1;
   valid <= 0;
  end
  else
  begin
   valid <= 1;
  end
 end

 always@(posedge aclk)  //输入控制信号逻辑
 begin
  if(valid&ready)
  begin
   save_data[dat_num] <= in_data;
   dat_num <= dat_num + 1;
  end
 end

 always@(posedge aclk)
 begin
  if(!aken)
  begin
   clear_state <= 1;
   dat_num <= 0;
   valid <= 0;
   cacu_flag <= 0;
   out_data <= 8'h00;
   mst_exec_state <= ranking;
  end
  else
  begin

   case (mst_exec_state)  
   ranking: 
    if(cacu_flag)
    begin   
     for(temp_j=0;temp_j<255;temp_j=temp_j+1)   //对比
     begin
      for(temp_i=temp_j+1;temp_i<256;temp_i=temp_i+1)    
      begin 
       //#5;
       if(save_data[temp_j]>save_data[temp_i])     
       begin      
        state[temp_j][temp_i]<=1;     
       end     
       else     
       begin      
        state[temp_i][temp_j]<=1;     
       end
      end
     end
     mst_exec_state <= adding;
    end
   adding: 
    if(cacu_flag)
    begin
     for(temp_j=0;temp_j<256;temp_j=temp_j+1)   //求和
     begin
      for(temp_i=0;temp_i<256;temp_i=temp_i+1)    
      begin 
       sum[temp_j] = state[temp_j][temp_i] + sum[temp_j];
      end
     end 
     mst_exec_state <= saving;
    end
   saving: 
    if(cacu_flag)
    begin
     for(temp_j=0;temp_j<256;temp_j=temp_j+1)   //输入对应位置
     begin    
      output_data[sum[temp_j]] <= save_data[temp_j];    
     end
     out_data_i <=0;
     output_flag <=1;
     cacu_flag <=0;   
     dat_num <=0;
     mst_exec_state <= ranking;
     clear_state<=1;
    end
   endcase
  end
 end  


 always@(posedge aclk)
 begin
  if(output_flag)
  begin
   out_data <= output_data[out_data_i];
   out_data_i <= out_data_i + 1;
  end
 end

 always@(posedge aclk)
 begin
  if(out_data_i>=256)
  begin
   out_data_i <= 0;
   output_flag <= 0;
  end
 end 
endmodule