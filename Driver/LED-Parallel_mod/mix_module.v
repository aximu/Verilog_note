 `timescale 1ns / 1ps
// /* 组合主模�?
// LED闪烁和流水模块并行进�?
//  */
 
 module mix_module(
    input CLK,
    input RSTn,
    output Flash_LED,
    output [2:0]Run_LED
 );

    wire wFlash_LED;        //ע����������wire
    flash_module U1(
        .CLK(CLK),
        .RSTn(RSTn),
        .LED_Out(wFlash_LED)
    );

    wire [2:0]wRun_LED;
    run_module U2(
        .CLK(CLK),
        .RSTn(RSTn),
        .LED_Out(wRun_LED)
    );

    assign Flash_LED = wFlash_LED;
    assign Run_LED = wRun_LED;

endmodule