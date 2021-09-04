`timescale 1ns/1ps

module test ;

   reg          clk;
   reg          rstn ;
   reg [1:0]    coin ;
   wire [1:0]   change ;
   wire         sell ;

   //clock generating
   parameter    CYCLE_200MHz = 10 ; //
   always begin
      clk = 0 ; #(CYCLE_200MHz/2) ;
      clk = 1 ; #(CYCLE_200MHz/2) ;
   end

   //motivation generating
   reg [9:0]    buy_oper ; //store state of the buy operation
   initial begin
      buy_oper  = 'h0 ;
      coin      = 2'h0 ;
      rstn      = 1'b0 ;
      #8 rstn   = 1'b1 ;
      @(negedge clk) ;

      //case(1) 0.5 -> 0.5 -> 0.5 -> 0.5
      #16 ;
      buy_oper  = 10'b00_0101_0101 ;
      repeat(5) begin
         @(negedge clk) ;
         coin      = buy_oper[1:0] ;
         buy_oper  = buy_oper >> 2 ;
      end

      //case(2) 1 -> 0.5 -> 1, taking change
      #16 ;
      buy_oper  = 10'b00_0010_0110 ;
      repeat(5) begin
         @(negedge clk) ;
         coin      = buy_oper[1:0] ;
         buy_oper  = buy_oper >> 2 ;
      end

      //case(3) 0.5 -> 1 -> 0.5
      #16 ;
      buy_oper  = 10'b00_0001_1001 ;
      repeat(5) begin
         @(negedge clk) ;
         coin      = buy_oper[1:0] ;
         buy_oper  = buy_oper >> 2 ;
      end

      //case(4) 0.5 -> 0.5 -> 0.5 -> 1, taking change
      #16 ;
      buy_oper  = 10'b00_1001_0101 ;
      repeat(5) begin
         @(negedge clk) ;
         coin      = buy_oper[1:0] ;
         buy_oper  = buy_oper >> 2 ;
      end
   end

   //(1) mealy state with 3-stage
   vending_machine_p3    u_mealy_p3
     (
      .clk              (clk),
      .rstn             (rstn),
      .coin             (coin),
      .change           (change),
      .sell             (sell)
      );

   //(2) mealy state with 2-stage
   wire [1:0]           change_p2 ;
   wire                 sell_p2 ;
   vending_machine_p2    u_mealy_p2
     (
      .clk              (clk),
      .rstn             (rstn),
      .coin             (coin),
      .change           (change_p2),
      .sell             (sell_p2)
      );

   //(3) mealy state with 1-stage
   wire [1:0]           change_p1 ;
   wire                 sell_p1 ;
   vending_machine_p1    u_mealy_p1
     (
      .clk              (clk),
      .rstn             (rstn),
      .coin             (coin),
      .change           (change_p1),
      .sell             (sell_p1));

   //(4) mealy state with 1-stage
   wire [1:0]           change_moore ;
   wire                 sell_moore ;
   vending_machine_moore    u_moore_p3
     (
      .clk              (clk),
      .rstn             (rstn),
      .coin             (coin),
      .change           (change_moore),
      .sell             (sell_moore));


   //simulation finish
   always begin
      #100;
      if ($time >= 10000)  $finish ;
   end

endmodule // test
