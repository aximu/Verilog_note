`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/21 13:37:16
// Design Name: 
// Module Name: sim_char_display
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

  module sim_char_display();
  parameter LINE = 24;
  parameter ROW_LENTH = 72;
  
    wire [LINE-1:0]odata;
    reg [ROW_LENTH-1:0]data1_row[LINE-1:0];
    reg [63:0]data2_row[15:0];
    
    reg bit_clk;
    reg bit1_roll_clk;
    reg reset_p;
    
    initial bit_clk = 1'b1;
    always #50 bit_clk = ~bit_clk;

    initial bit1_roll_clk = 1'b1;
    always #1 bit1_roll_clk = ~bit1_roll_clk;

    
    initial begin                               //'无心学习'
    //   data1_row[15] = 64'h0000000000000000 ;
    //   data1_row[14] = 64'h3FF0010011080004;
    //   data1_row[13] = 64'h020000801110FFFE ;
    //   data1_row[12] = 64'h020000C000200004 ;
    //   data1_row[11] = 64'h020008807FFE0804 ;
    //   data1_row[10] = 64'h0208080040020404;
    //   data1_row[9 ] = 64'h7FFC280880040204 ;
    //   data1_row[8 ] = 64'h028028041FE00224 ;
    //   data1_row[7 ] = 64'h02802802004000C4 ;
    //   data1_row[6 ] = 64'h0480480201840304 ;
    //   data1_row[5 ] = 64'h04808802FFFE0C04;
    //   data1_row[4 ] = 64'h0880080001003004 ;
    //   data1_row[3 ] = 64'h0882081001001004 ;
    //   data1_row[2 ] = 64'h1082081001000044 ;
    //   data1_row[1 ] = 64'h207E07F005000028;
    //   data1_row[0 ] = 64'h4000000002000010 ;

    //   data1_row[15] = 64'h0000000001000000;
    //   data1_row[14] = 64'h7DFEFFFE01002000;
    //   data1_row[13] = 64'h44080440010017FC;
    //   data1_row[12] = 64'h4808044001001040;
    //   data1_row[11] = 64'h49E804407FFC8040;
    //   data1_row[10] = 64'h51283FF803804040;
    //   data1_row[9 ] = 64'h4928244805404840;
    //   data1_row[8 ] = 64'h4928244805400840;
    //   data1_row[7 ] = 64'h4528244809201040;
    //   data1_row[6 ] = 64'h4528244811101040;
    //   data1_row[5 ] = 64'h45E828382108E040;
    //   data1_row[4 ] = 64'h6928300841042040;
    //   data1_row[3 ] = 64'h5008200881022040;
    //   data1_row[2 ] = 64'h4008200801002FFE;
    //   data1_row[1 ] = 64'h40283FF801002000;
    //   data1_row[0 ] = 64'h4010200801000000;
    


      data1_row[23] =  72'hFFFF_FFFF_FFFF_FFFF_FF;
      data1_row[22] =  72'hFFFF_FFFF_FFFF_FFFF_FF;
      data1_row[21] =  72'hFFFF_FFFF_FFFF_FFFF_FF;
      data1_row[20] =  72'hFFFF_FFFF_FFFF_FFFF_FF;
      data1_row[19] =  72'hFFFF_FFFF_FFFF_FFFF_FF;
      data1_row[18] =  72'hFFF3_FFFF_FFFF_FF3F_FF;
      data1_row[17] =  72'hFFF3_FFFF_FFFF_FF3F_FF;
      data1_row[16] =  72'hFFF3_FFFF_FFFF_3F3F_FF;
      data1_row[15] =  72'hFFF3_FFFF_FFFF_3F3F_FF;
      data1_row[14] =  72'hFFF3_FFFF_FFFE_9F3D_FF;
      data1_row[13] =  72'hFFF3_FFFF_FFFE_9F3C_FF;
      data1_row[12] =  72'hFBF3_07FF_FDFF_F33C_7F;
      data1_row[11] =  72'hFFF3_F9F8_FDFF_F33A_3F;
      data1_row[10] =  72'hFFF3_FCF6_7DF7_7333_1F;
      data1_row[9 ] =  72'hFF33_F8E7_7DF7_7333_4F;
      data1_row[8 ] =  72'hFF33_F1EF_3CF7_733B_6F;
      data1_row[7 ] =  72'h9F33_C5C7_3CE7_3738_6F;
      data1_row[6 ] =  72'h9F38_1E10_0008_0780_0F;
      data1_row[5 ] =  72'h9F3F_FFFF_FFFF_FFFF_FF;
      data1_row[4 ] =  72'h9F7F_FFFF_FFFF_FFFF_FF;
      data1_row[3 ] =  72'hDE7F_E7FF_FFFF_FFFF_FF;
      data1_row[2 ] =  72'hE0FF_FFFF_FFFF_FFFF_FF;
      data1_row[1 ] =  72'hFFFF_FFFF_FFFF_FFFF_FF;
      data1_row[0 ] =  72'hFFFF_FFFF_FFFF_FFFF_FF;

    end               
   
  
   

      //reset
      initial begin
        reset_p = 1'b1;
        #200
        reset_p = 1'b0; 

        #8000
        $stop;    
      end

    generate
      genvar i;
      for(i=0;i<LINE;i=i+1)
      begin:gen_line_data1
        gen_line #(72,1)gen_line0(data1_row[i],odata[i],bit_clk,bit1_roll_clk,reset_p);
      end
    endgenerate

    
  endmodule


















 









 


