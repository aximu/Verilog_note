 /* 组合主模块
 LED闪烁和流水模块并行进行
  */
 
 module mix_module(
     CLK,
     RSTn,
     Flash_LED,
     Run_LED
 );

    input CLK;
    input RSTn;
    output Flash_LED;
    output [2:0]Run_LED;

    wire Flash_LED;
    flash_module U1(
        .CLK(CLK),
        .RSTn(RSTn),
        .LED_Out(Flash_LED)
    );

    wire [2:0]Run_LED;
    run_module U2(
        .CLK(CLK),
        .RSTn(RSTn),
        .LED_Out(Run_LED)
    );

    assign Flash_LED = Flash_LED;
    assign Run_LED = Run_LED;

endmodule