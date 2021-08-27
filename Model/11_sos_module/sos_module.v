module sos_module
(
    CLK, RSTn,
    Start_Sig,
	 Done_Sig,
	 Pin_Out
);

     input CLK;
	 input RSTn;
	 input Start_Sig;
	 output Done_Sig;
	 output Pin_Out;
	 
	 /*****************************/
	 
	 wire S_Done_Sig;
	 wire S_Pin_Out;
	 
	 s_module U1
	 (
	     .CLK( CLK ),
		  .RSTn( RSTn ),
		  .Start_Sig( S_Start_Sig ),  // input - from U3
		  .Done_Sig( S_Done_Sig ),    // output - to U3
		  .Pin_Out( S_Pin_Out )       // output - to selector
		  
	  ) ;
	 
	 /*********************************/
	 
	 wire O_Done_Sig;
	 wire O_Pin_Out;
	 
	 o_module U2
	 (
	     .CLK( CLK ),
		  .RSTn( RSTn ),
		  .Start_Sig( O_Start_Sig ),  // input - from U3
		  .Done_Sig( O_Done_Sig ),    // output - to U3
		  .Pin_Out( O_Pin_Out )       // output - to selector
	 );
	 
	 /*********************************/
	 
	 wire S_Start_Sig;
	 wire O_Start_Sig;
	 
	 sos_control_module U3
	 (
	     .CLK( CLK ),
		  .RSTn( RSTn ),
		  .Start_Sig( Start_Sig ),      // input - from top
		  .S_Done_Sig( S_Done_Sig ),    // input - from U1
		  .O_Done_Sig( O_Done_Sig ),    // input - from U2
		  .S_Start_Sig( S_Start_Sig ),  // output - to U1
		  .O_Start_Sig( O_Start_Sig ),  // output - to U2
		  .Done_Sig( Done_Sig )         // output - to top
	 );
	 
	 /*********************************/
	 
	 //selector
	 
	 reg Pin_Out;
	 
	 always @ ( * )
	     if( S_Start_Sig ) Pin_Out = S_Pin_Out;      // select from U1
		  else if( O_Start_Sig ) Pin_Out = O_Pin_Out;  // select from U2
		  else Pin_Out = 1'bx; 
		  
    /*********************************/

endmodule
