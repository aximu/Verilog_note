//是“图像控制的核心”控制模块，有关 Red, Green, Blue 信号的控制，
//x地址和y地址的控制，图像显示控制，帧控制，完全都是在这个模块中完成操作。
//vga_control_module.v的工作是 “图像显示控制”
module vga_control_module
(
    CLK, RSTn,
	 Ready_Sig, Column_Addr_Sig, Row_Addr_Sig,
	 Red_Sig, Green_Sig, Blue_Sig
);
    input CLK;
	 input RSTn;
	 input Ready_Sig;
	 input [10:0]Column_Addr_Sig;
	 input [10:0]Row_Addr_Sig;
	 output Red_Sig;
	 output Green_Sig;
	 output Blue_Sig;
	 
	 /**********************************/
	 
	 reg isRectangle;				//标志寄存器　显示白色矩形图像
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      isRectangle <= 1'b0;
		  else if( Column_Addr_Sig > 11'd0 && Row_Addr_Sig < 11'd100 )
            isRectangle <= 1'b1;
		  else
		      isRectangle <= 1'b0;
				
	/************************************/
				
	 assign Red_Sig = Ready_Sig && isRectangle ? 1'b1 : 1'b0;
	 assign Green_Sig = Ready_Sig && isRectangle ? 1'b1 : 1'b0;
	 assign Blue_Sig = Ready_Sig && isRectangle ? 1'b1 : 1'b0;
	 
	/***********************************/
	 

endmodule
