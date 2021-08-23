//当检测到由高变低的电平变化时，产生一个时钟的高脉冲。
//当检测到由低变高的电平变化时，只有消抖动作，输出没有任何影响

module debounce_module2
(
    CLK, RSTn, Pin_In, Pin_Out
);
    
	 input CLK;
	 input RSTn;
	 input Pin_In;
	 output Pin_Out;
	 
	 /**************************/
	 
	 wire H2L_Sig;
	 wire L2H_Sig;
	 
	 detect_module U1
	 (
	     .CLK( CLK ),
		  .RSTn( RSTn ),
		  .Pin_In( Pin_In ),   // input - from top
		  .H2L_Sig( H2L_Sig ), // output - to U2
		  .L2H_Sig( L2H_Sig )  // output - to U2
	 );
	 
	 /**************************/
	 
	 delay_module U2
	 (
	     .CLK( CLK ),
		  .RSTn( RSTn ),
		  .H2L_Sig( H2L_Sig ), // input - from U1
		  .L2H_Sig( L2H_Sig ), // input - from U1
		  .Pin_Out( Pin_Out )  // output - to top
	 );
	 
	 /*******************************/

endmodule