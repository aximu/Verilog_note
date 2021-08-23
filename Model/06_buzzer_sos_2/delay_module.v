module delay_module 
(
    CLK, RSTn, H2L_Sig, L2H_Sig, Pin_Out
);

    input CLK;
	 input RSTn;
	 input H2L_Sig;
	 input L2H_Sig;
	 output Pin_Out;
	 
	 /****************************************/
	 
	 parameter T1MS = 16'd49_999;//DB4CE15开发板使用的晶振为50MHz，50M*0.001-1=49_999
	 
	 /***************************************/
	 
	 reg [15:0]Count1;

	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      Count1 <= 16'd0;
		  else if( isCount && Count1 == T1MS )
		      Count1 <= 16'd0;
		  else if( isCount )
		      Count1 <= Count1 + 1'b1;
		  else if( !isCount )
		      Count1 <= 16'd0;
	
    /****************************************/	
				
    reg [3:0]Count_MS;
	    
	 always @ ( posedge CLK or negedge RSTn )
        if( !RSTn )
		      Count_MS <= 4'd0;
		  else if( isCount && Count1 == T1MS )
		      Count_MS <= Count_MS + 1'b1;
		  else if( !isCount )
		      Count_MS <= 4'd0;
	
	/******************************************/
	
	 reg isCount;
	 reg rPin_Out;
	 reg [1:0]i;
	
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      begin
		          isCount <= 1'b0;
					 rPin_Out <= 1'b0;
					 i <= 2'd0;
			   end
		  else
		       case ( i )
				
				     3'd0 : 
					  if( H2L_Sig ) i <= 2'd1;
					  else if( L2H_Sig ) i <= 2'd3;
					
				     3'd1 : 
					  if( Count_MS == 4'd10 ) begin isCount <= 1'b0; rPin_Out <= 1'b1; i <= 2'd2; end
				     else	isCount <= 1'b1;
					 
					  3'd2 : 
					  begin rPin_Out <= 1'b0; i <= 2'd0; end
					 
					  3'd3 :
					  if( Count_MS == 4'd10 ) begin isCount <= 1'b0; i <= 2'd0; end
				     else	isCount <= 1'b1;
					   
				
				 endcase

							
    /********************************************/
	 
	 assign Pin_Out = rPin_Out;
	 
	 /********************************************/
		      


endmodule
