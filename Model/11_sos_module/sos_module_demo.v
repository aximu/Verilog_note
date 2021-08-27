module sos_module_demo
(
    CLK, RSTn,
	 Pin_Out
);

    input CLK;
	 input RSTn;
	 output Pin_Out;
	 
	 /***********************/
	 
	 reg isStart;
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		     isStart <= 1'b1;
		  else if( Done_Sig )
		     isStart <= 1'b0;
			 
	 /*********************************/
	
	 wire Done_Sig;
	 
    sos_module U1
	 (
	    .CLK( CLK ),
		 .RSTn( RSTn ),
		 .Start_Sig( isStart ),
		 .Done_Sig( Done_Sig ),
		 .Pin_Out( Pin_Out )
	 ); 
    
	 /*********************************/
endmodule
