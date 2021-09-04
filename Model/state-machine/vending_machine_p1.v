//vending-machine
// 2 yuan for a bottle of drink
// only 2 coins supported: 5 jiao and 1 yuan
// finish the function of selling and changing

module  vending_machine_p1
    (
        input           clk ,
        input           rstn ,
        input [1:0]     coin ,     //01 for 0.5 jiao, 10 for 1 yuan

        output [1:0]    change ,
        output          sell    //output the drink
     );

   //machine state decode
   parameter            IDLE   = 3'd0 ;
   parameter            GET05  = 3'd1 ;
   parameter            GET10  = 3'd2 ;
   parameter            GET15  = 3'd3 ;

   //machine variable
   reg [2:0]            st_cur ;

   //(1) using one state-variable do describe
   reg  [1:0]   change_r ;
   reg          sell_r ;
   always @(posedge clk or negedge rstn) begin
      if (!rstn) begin
         st_cur     <= 'b0 ;
         change_r   <= 2'b0 ;
         sell_r     <= 1'b0 ;
      end
      else begin
         case(st_cur)

           IDLE: begin
              change_r  <= 2'b0 ;
              sell_r    <= 1'b0 ;
              case (coin)
                2'b01:     st_cur <= GET05 ;
                2'b10:     st_cur <= GET10 ;
              endcase
           end
           GET05: begin
              case (coin)
                2'b01:     st_cur <= GET10 ;
                2'b10:     st_cur <= GET15 ;
              endcase
           end

           GET10:
             case (coin)
               2'b01:     begin
                  st_cur   <=  GET15 ;
               end
               2'b10:     begin
                  st_cur   <= IDLE ;
                  sell_r   <= 1'b1 ;
               end
             endcase

           GET15:
             case (coin)
               2'b01:     begin
                  st_cur   <= IDLE ;
                  sell_r   <= 1'b1 ;
               end
               2'b10:     begin
                  st_cur   <= IDLE ;
                  change_r <= 2'b1 ;
                  sell_r   <= 1'b1 ;
               end
             endcase

           default:  begin
              st_cur    <= IDLE ;
           end

         endcase // case (st_cur)
      end // else: !if(!rstn)
   end

   assign       sell    = sell_r ;
   assign       change  = change_r ;

endmodule
