module inter_control_module
(
    CLK, RSTn, Trig_Sig, SOS_En_Sig
);

    input CLK;
	 input RSTn;
	 input Trig_Sig;
	 output SOS_En_Sig;
	 
	 /***********************************/
	 
	 reg i;
	 reg isEn;
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      begin
		          i <= 1'd0;
				  isEn <= 1'b0;
			  end
		  else
		      case( i )
				
				    2'd0 :
					 if( Trig_Sig ) begin 
						 isEn <= 1'b1; 
						 i <= 1'd1; 
						 end
					 
					 2'd1 :
					 begin 
						 isEn <= 1'b0; 
						 i <= 1'd0; 
						 end
				
				endcase

    /***********************************************/
	 
	 assign SOS_En_Sig = isEn;
	 
	 /***********************************************/

endmodule
