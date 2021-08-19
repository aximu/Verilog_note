 `timescale 1ns / 1ps
 /* LED 闪烁 */
 
 module flash_module(
    input CLK,
    input RSTn,
    output LED_Out
 );
 
    parameter T50MS = 22'd2_499_999;

    reg [21:0] Count1;

    always @(posedge CLK or negedge RSTn) begin
        if(!RSTn)
            Count1 <= 22'd0;
        else if(Count1 == T50MS)
            Count1 <= 22'd0;
        else 
            Count1 <= Count1 + 1'b1;
    end

    reg rLED_Out;

    always @(posedge CLK or negedge RSTn) begin
        if(!RSTn)
            rLED_Out <= 1'b0;
        else if(Count1 == T50MS)
            rLED_Out <= ~rLED_Out;
    end

    assign LED_Out = rLED_Out;

endmodule