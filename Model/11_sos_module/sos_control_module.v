module sos_control_module
(
    CLK, RSTn,
	 Start_Sig,
	 S_Done_Sig, O_Done_Sig,
	 S_Start_Sig, O_Start_Sig,
	 Done_Sig
);

	input CLK;
	input RSTn;
	input Start_Sig;
	input S_Done_Sig, O_Done_Sig;
	output S_Start_Sig, O_Start_Sig;
	output Done_Sig;
	 
	 /*************************************/
	 
	 reg [3:0]i;
	 reg isO;
	 reg isS;
	 reg isDone;
	 
	 always @ ( posedge CLK or negedge RSTn )
        if( !RSTn )
		      begin
		          i <= 4'd0;
					 isO <= 1'b0;
					 isS <= 1'b0;
					 isDone <= 1'b0;
			   end
		  else if( Start_Sig )
		      case( i )
				    
					 4'd0:
					 if( S_Done_Sig ) begin isS <= 1'b0; i <= i + 1'b1; end
					 else isS <= 1'b1;
					 
					 4'd1:
					 if( O_Done_Sig ) begin isO <= 1'b0; i <= i + 1'b1; end
					 else isO <= 1'b1;
					 
					 4'd2:
					 if( S_Done_Sig ) begin isS <= 1'b0; i <= i + 1'b1; end
					 else isS <= 1'b1;
					 
					 4'd3:
                begin isDone <= 1'b1; i <= 4'd4; end
					 
					 4'd4:
					 begin isDone <= 1'b0; i <= 4'd0; end
					  
				endcase
				
    /*****************************************/

    assign S_Start_Sig = isS;
    assign O_Start_Sig = isO;
    assign Done_Sig = isDone;	 
	 
	 /*****************************************/
	 
endmodule
