`timescale 1ns / 1ps
// /* 3个LED 流水�? */
 
 module run_module(
    input CLK,
    input RSTn,
    output [2:0]LED_Out
 );
    parameter T1MS = 16'd49_999;        //3.3hz

//    /*1毫秒计数�?*/
    reg [15:0] Count1;
    always @(posedge CLK or negedge RSTn) begin
        if(!RSTn)
            Count1 <= 16'd0;
        else if(Count1 == T1MS)
            Count1 <= 16'd0;
        else 
            Count1 <= Count1 + 1'b1;
    end

    reg [9:0] Count_MS;         //100毫秒计数�?
    always @(posedge CLK or negedge RSTn) begin
        if(!RSTn)
            Count_MS <= 10'd0;
        else if(Count_MS == 10'd100)
            Count_MS <= 10'd0;
        else if(Count1 == T1MS)
            Count_MS <= Count_MS + 1'b1;
    end

    reg [2:0]rLED_Out;              //3Bit的移位操�?
    always @(posedge CLK or negedge RSTn) begin
        if(!RSTn)
            rLED_Out <= 3'b001;
        else if(Count_MS == 10'd100) begin      //�?100ms发生�?次移�?
            if(rLED_Out == 3'b000)
                rLED_Out <= 3'b001;
            else
                rLED_Out <= {rLED_Out[1:0],1'b0};
        end
    end

    assign LED_Out = rLED_Out;

endmodule