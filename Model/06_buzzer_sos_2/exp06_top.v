module exp06_top 
(
    CLK, RSTn,
	Pin_In, Pin_Out
);

    input CLK;
	input RSTn;
	input Pin_In;
	output Pin_Out;
	 
	 /***************************************/
	 
	 wire Trig_Sig;
	 
	 debounce_module2 U1
	 (
	      .CLK( CLK ),
		  .RSTn( RSTn ),
		  .Pin_In( Pin_In ),   // input - from top
		  .Pin_Out( Trig_Sig ) // output - to U2
	 );
	 
	 /***************************************/
	 
	 wire SOS_En_Sig;
	 
	 inter_control_module U2
	 (
	        .CLK( CLK ),
			.RSTn( RSTn ),
			.Trig_Sig( Trig_Sig ),    // input - from U1
			.SOS_En_Sig( SOS_En_Sig ) // output - to U2
	 );
	 
	 /***************************************/
	 
	 sos_module U3
	 (
	     .CLK( CLK ),
		  .RSTn( RSTn ),
		  .SOS_En_Sig( SOS_En_Sig ), // input - from U2
		  .Pin_Out( Pin_Out )        // ouput - to top
	 );
	 
	 /***************************************/

endmodule
