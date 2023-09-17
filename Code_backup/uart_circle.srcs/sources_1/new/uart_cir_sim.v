`timescale  1ns / 1ps

module tb_uart_cir;

// uart_cir Parameters
parameter PERIOD  = 20;


// uart_cir Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   rx_uart                              = 0 ;

// uart_cir Outputs
wire  tx_uart                              ;

//clk
initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

//rst_n
initial
begin
    #(PERIOD*2) rst_n  =  1;
end

//实例化模块
uart_cir  u_uart_cir (
    .clk                     ( clk       ),
    .rst_n                   ( rst_n     ),
    .rx_uart                 ( rx_uart   ),

    .tx_uart                 ( tx_uart   )
);

//加入信号输入rx_uart，之前使用的task
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
  
//第二种方法，用另一个task函数，原理是一样的，需要再加一个initial进行任务的一个调用
task    rx_byte();
    integer j;
    for ( j = 0; j < 10; j = j + 1) begin//j的数值决定发到多少停止
        rx_bit(j);
    end
endtask

//initial 进行任务调用
initial begin
    begin
      #200;
      rx_byte;
    end
end

endmodule