module o_module
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
	  
	  /****************************************/
	 
	 parameter T1MS = 17'd49_999;			//delay 1ms
	 
	 /***************************************/
	 
	 reg [16:0]Count1;

	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      Count1 <= 17'd0;
		  else if( Count1 == T1MS )
		      Count1 <= 17'd0;
		  else if( isCount )
		      Count1 <= Count1 + 1'b1;
		  else if( !isCount )
		      Count1 <= 17'd0;
	
    /****************************************/	
				
    reg [9:0]Count_MS;
	    
	 always @ ( posedge CLK or negedge RSTn )
        if( !RSTn )
		      Count_MS <= 10'd0;
		  else if( Count_MS == rTimes )
		      Count_MS <= 10'd0;
		  else if( Count1 == T1MS )
		      Count_MS <= Count_MS + 1'b1;

	/******************************************/
	
	reg [3:0]i;
	reg rPin_Out;
	reg [9:0]rTimes;
	reg isCount;
	reg isDone;
	
	always @ ( posedge CLK or negedge RSTn )
	    if( !RSTn )
		     begin 
			      i <= 4'd0;
		         rPin_Out <= 1'b0;
					rTimes <= 10'd1000;
				   isCount <= 1'b0;	
				   isDone <= 1'b0;
			  end
		 else if( Start_Sig )
		     case( i )
			  
			      4'd0, 4'd2, 4'd4:
			      if( Count_MS == rTimes ) begin rPin_Out <= 1'b0; isCount <= 1'b0; i <= i + 1'b1; end
				   else begin isCount <= 1'b1; rPin_Out <= 1'b1; rTimes <= 10'd400; end
					
					4'd1, 4'd3, 4'd5:
					if( Count_MS == rTimes ) begin isCount <= 1'b0; i <= i + 1'b1; end
					else  begin isCount <= 1'b1; rTimes <= 10'd50; end
					
					4'd6:
					begin isDone <= 1'b1; i <= 4'd7; end
					
					4'd7:
					begin isDone <= 1'b0; i <= 4'd0; end
					
			  endcase	
	
	/******************************************/
	
	assign Done_Sig = isDone;
	assign Pin_Out = !rPin_Out;
	
	/******************************************/

endmodule
