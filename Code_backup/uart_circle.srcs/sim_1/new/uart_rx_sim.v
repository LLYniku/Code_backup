`timescale  1ns / 1ps

module tb_uart;

// uart Parameters
parameter PERIOD  = 20      ;
parameter TIMES   = 5208    ;
parameter TIMES2  = 9       ;

// uart Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   rx_uart                              = 1 ; //初始化

// uart Outputs
wire  [2:0]  led                           ;
wire  [7:0]  out_data                      ;
wire  out_flag                             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) 
    rst_n       <=  1;
end
//使用initial来进行任务调用
initial begin
    #200
    rx_bit(8'd0);
    rx_bit(8'd1);    
    rx_bit(8'd2);
    rx_bit(8'd3);    
    rx_bit(8'd4);
    rx_bit(8'd5);    
    rx_bit(8'd6);
    rx_bit(8'd7);     
    rx_bit(8'd8);  
end

//输入信号使用task进行配置
task rx_bit(
    input [7:0]     data        
);
    integer i;
    for (i = 0; i < 10; i = i + 1) begin//每次循环只发一个data数据 加上begin是问题所在
        case(i)
            0:rx_uart   <=  0;
            1:rx_uart   <=  data[0];
            2:rx_uart   <=  data[1];
            3:rx_uart   <=  data[2];
            4:rx_uart   <=  data[3];
            5:rx_uart   <=  data[4];
            6:rx_uart   <=  data[5];
            7:rx_uart   <=  data[6];
            8:rx_uart   <=  data[7];
            9:rx_uart   <=  1;            
        endcase
        #(5208*20); //实际需要加这个逗号
        end
endtask

uart_rx #(
    .TIMES  ( TIMES  ),
    .TIMES2 ( TIMES2 ))
 u_uart (
    .clk                     ( clk             ),
    .rst_n                   ( rst_n           ),
    .rx_uart                 ( rx_uart         ),

    .led                     ( led       [2:0] ),
    .out_data                ( out_data  [7:0] ),
    .out_flag                ( out_flag        )
);

// initial
// begin

//     $finish;
// end

endmodule