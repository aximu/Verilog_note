//电平检测模块

module detect_module 
(
    CLK, RSTn, Pin_In, H2L_Sig, L2H_Sig
);

    input CLK;
	input RSTn;
	input Pin_In;
	output H2L_Sig;
	output L2H_Sig;
	 
	 /**********************************/
	 
	 parameter T100US = 11'd4_999;//DB4CE15开发板使用的晶振为50MHz，50M*0.0001-1=4_999
	 
	 /*****************延时100us*****************/
	 //在复位的一瞬间，电平容易处于不稳定的状态，我们需要延迟100us
	 reg [10:0]Count1;
	 reg isEn;				//判读延时是否完成

	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      begin
		          Count1 <= 11'd0;
		          isEn <= 1'b0;
				end
	     else if( Count1 == T100US )
				isEn <= 1'b1;
		  else
		      Count1 <= Count1 + 1'b1;
				
    /************************************/
	 
	 reg H2L_F1;
	 reg H2L_F2;		//检测电平由高变低
	 reg L2H_F1;
	 reg L2H_F2;		//检测电平由低变高
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      begin
				    H2L_F1 <= 1'b1;
					H2L_F2 <= 1'b1;
					L2H_F1 <= 1'b0;
					L2H_F2 <= 1'b0;
			   end
		  else
		      begin
					 H2L_F1 <= Pin_In; 
					 H2L_F2 <= H2L_F1;
					 L2H_F1 <= Pin_In;
					 L2H_F2 <= L2H_F1;
				end
				
    /***********************************/
	 
	//电平检测模块的有效是发生在100us的延迟之后
	 assign H2L_Sig = isEn ? ( H2L_F2 & !H2L_F1 ) : 1'b0;
	 assign L2H_Sig = isEn ? ( !L2H_F2 & L2H_F1 ) : 1'b0;

	 
	 /***********************************/
	 
endmodule

	     
	 