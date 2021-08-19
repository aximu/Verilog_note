//led 流水灯---低级建模2

module led_funcmod
(
input CLOCK, RESET,
output [3:0]LED
);
    //常量声明，1秒至1毫秒；
    parameter T1S = 26'd50_000_000; //1Hz
    parameter T100MS = 26'd5_000_000; //10Hz
    parameter T10MS = 26'd500_000; //100Hz
    parameter T1MS = 26'd50_000; //1000Hz

    reg [3:0]i;         //指向步骤
    reg [25:0]C1;       //用来计数
    reg [3:0]D;         //暂存结果和驱动输出
    reg [25:0]T;        //暂存计数量
    reg [3:0]isTag;     //暂存延迟标签

    always @ ( posedge CLOCK or negedge RESET )

        if( !RESET )
            begin
            i <= 4'd0;
            C1 <= 26'd0;
            D <= 4'b0001;
            T <= T1S;
            isTag <= 4'b0001;
            end
        else

            case( i )

            0:                          //步骤0~3实现1秒的流水效果
            if( C1 == T -1) 
                begin 
                C1 <= 26'd0; 
                i <= i + 1'b1; 
                end
            else 
                begin 
                C1 <= C1 + 1'b1; 
                D <= 4'b0001; 
                end

            1:
            if( C1 == T -1) 
                begin 
                C1 <= 26'd0; 
                i <= i + 1'b1; 
                end
            else 
                begin 
                C1 <= C1 + 1'b1; 
                D <= 4'b0010; 
                end

            2:
            if( C1 == T -1) 
                begin 
                C1 <= 26'd0; 
                i <= i + 1'b1; 
                end
            else 
                begin 
                C1 <= C1 + 1'b1;
                D <= 4'b0100; 
                end

            3:
            if( C1 == T -1) 
                begin 
                C1 <= 26'd0; 
                i <= i + 1'b1; 
                end
            else 
                begin 
                C1 <= C1 + 1'b1; 
                D <= 4'b1000; 
                end

            4:                                  //用来切换模式
                begin 
                isTag <= { isTag[2:0], isTag[3] }; 
                i <= i + 1'b1; 
                end

            5:                                  //根据istag的内容再为T寄存器载入不同延时内容
            if( isTag[0] ) 
                begin 
                T <= T1S; 
                i <= 4'd0; 
                end
            else if( isTag[1] ) 
                begin 
                T <= T100MS; 
                i <= 4'd0; 
                end
            else if( isTag[2] ) 
                begin 
                T <= T10MS; 
                i <= 4'd0; 
                end
            else if( isTag[3] ) 
                begin 
                T <= T1MS; 
                i <= 4'd0; 
                end

            endcase


    assign LED = D;

 endmodule
