//对HSYNC Signal 和 VSYNC Signal 控制的“功能模块”。
//它扮演了“VGA驱动的核心”的角色。除此之外，sync_module.v还输出当前的 x地址（Column_Addr_Sig），y地址 ( Row_Addr_Sig ) 和有效区域信号（Ready_Sig）。
//sync_module.v 的工作是“显示标准控制”;

module sync_module
(
     CLK, RSTn,
	 VSYNC_Sig, HSYNC_Sig, Ready_Sig,
	 Column_Addr_Sig, Row_Addr_Sig
);

    input CLK;
	 input RSTn;
	 output VSYNC_Sig;
	 output HSYNC_Sig;
	 output Ready_Sig;
	 output [10:0]Column_Addr_Sig;				//x地址
	 output [10:0]Row_Addr_Sig;					//ｙ地址
	 
	 /********************************/
	 
	 reg [10:0]Count_H;　　					//列像素计数　０～1056

	 always @ ( posedge CLK or negedge RSTn )
	    if( !RSTn )
		　　 Count_H <= 11'd0;
		else if( Count_H == 11'd1056 )
			Count_H <= 11'd0;
		else 
			Count_H <= Count_H + 1'b1;
    
	 /********************************/
	 
	 reg [10:0]Count_V;						//行像素计数　0～628
		 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      Count_V <= 11'd0;
		  else if( Count_V == 11'd628 )
		      Count_V <= 11'd0;
		  else if( Count_H == 11'd1056 )
		      Count_V <= Count_V + 1'b1;
	
	 /********************************/
	 
	 reg isReady;				//图像有效区域标志
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      isReady <= 1'b0;
        else if( ( Count_H > 11'd216 && Count_H < 11'd1017 ) && 
			        ( Count_V > 11'd27 && Count_V < 11'd627 ) )
		      isReady <= 1'b1;
		else
		      isReady <= 1'b0;
		    
	 /*********************************/
	 
	 assign VSYNC_Sig = ( Count_V <= 11'd4 ) ? 1'b0 : 1'b1;
	 assign HSYNC_Sig = ( Count_H <= 11'd128 ) ? 1'b0 : 1'b1;
	 assign Ready_Sig = isReady; 
	                       
	 
	 /********************************/
	 
	 assign Column_Addr_Sig = isReady ? Count_H - 11'd217 : 11'd0;    // Count from 0;
	 assign Row_Addr_Sig = isReady ? Count_V - 11'd28 : 11'd0; // Count from 0;
	
	 /********************************/
	 
endmodule
