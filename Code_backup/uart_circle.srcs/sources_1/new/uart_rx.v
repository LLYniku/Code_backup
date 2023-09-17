//led0      H18
//led1      K17
//led2      E19 0-7的变化范围
//clk       N18
//rst_n     T19
//rx_uart   H16   
module uart_rx (
    clk     ,
    rst_n   ,
    led     ,
    rx_uart ,
    out_data ,
    out_flag
);

input       clk     ;
input       rst_n   ;
input       rx_uart ;
output[2:0] led     ;
output[7:0] out_data ;
output      out_flag ;

//reg [7:0]   out_data    ;//only for part 1 test only rx test !
//reg         out_flag    ;

parameter TIMES     = 5208  ;
parameter TIMES2    = 10     ;

reg [12:0]  cnt0        ;
wire        add_cnt0    ;
wire        end_cnt0    ;
reg [3:0]   cnt1        ;
wire        add_cnt1    ;
wire        end_cnt1    ;
reg         rx_uart_ff0 ;
reg         rx_uart_ff1 ;
reg         rx_uart_ff2 ;
reg         flag_add    ;
reg [2:0]   led         ;
reg         rx_flag     ;
reg [7:0]   rx_data     ;
reg         bit_flag    ;
reg         out_flag    ;
reg [7:0]   out_data    ;

//计数器1，以时钟为单位产生5208个计数
always @( posedge clk or negedge rst_n ) begin
    if(!rst_n)begin
        cnt0 <= 0;
    end
    else if(add_cnt0)begin
        if(end_cnt0)begin
            cnt0 <= 0;
        end
        else begin
            cnt0 <= cnt0 + 1;
        end
    end    
end
assign add_cnt0 = flag_add;
assign end_cnt0 = add_cnt0 && cnt0== TIMES - 1;

//计数器2，以计数器1为单位产生4个计数
always @( posedge clk or negedge rst_n ) begin
    if(!rst_n)begin
        cnt1 <= 0;
    end
    else if(add_cnt1)begin
        if(end_cnt1)begin
            cnt1 <= 0;
        end
        else begin
            cnt1 <= cnt1 + 1;
        end
    end    
end
assign add_cnt1 = end_cnt0;
assign end_cnt1 = add_cnt1 && cnt1== TIMES2 - 1;

//异步数字系统的同步化--两个触发器处理，使用ff1和ff2来进行下一个边沿判断
always @( posedge clk or negedge rst_n ) begin
    if(!rst_n)begin
        rx_uart_ff0 <= 1;
        rx_uart_ff1 <= 1;
        rx_uart_ff2 <= 1;
    end
    else begin
        rx_uart_ff0 <= rx_uart;
        rx_uart_ff1 <= rx_uart_ff0;
        rx_uart_ff2 <= rx_uart_ff1;
    end    
end
assign add_cnt1 = end_cnt0;
assign end_cnt1 = add_cnt1 && cnt1== TIMES2 - 1;

//边沿判断法
always @( posedge clk or negedge rst_n ) begin
    if(!rst_n)begin
        flag_add <= 0;
    end
    //下降沿判断，从1变到0，rx_uart_ff2存储的是之前的值
    else if(rx_uart_ff1==0 && rx_uart_ff2==1)begin
        flag_add <= 1;
    end
    else if(end_cnt1)begin
        flag_add <= 0;
    end    
end

//选择采样的值，选择中心区域采样
always @( posedge clk or negedge rst_n ) begin
    if(!rst_n)begin
        led <= 0;
    end
    else if(cnt0==TIMES/2 - 1 && flag_add && cnt1 > 0 && cnt1 < 4)begin
        led[cnt1 -1] <= rx_uart_ff2;
    end    
end
//cnt0==TIMES/2 - 1定义一个bit_flag
always @( posedge clk or negedge rst_n ) begin
    if(!rst_n)begin
        bit_flag <= 0;
    end
    else if(cnt0==TIMES/2 - 1 && flag_add && cnt1 > 0)begin
        bit_flag <= 1;
    end   
    else 
        bit_flag <= 0; 
end
//数据拼接
always @( posedge clk or negedge rst_n ) begin
    if(!rst_n) begin
        rx_data <= 0;
    end
    else    if(cnt1 >= 1 && cnt1 <= 8 && bit_flag == 1) begin
        rx_data <=  {rx_uart_ff2,rx_data[7:1]};
    end
    else    if(cnt1 == 9)
        rx_data <= 1;
end
//数据拼接结束标志位
always @( posedge clk or negedge rst_n ) begin
    if(!rst_n) begin
        rx_flag <= 0;
    end
    else    if(cnt1 == 8 && bit_flag == 1)
        rx_flag <= 1;
    else
        rx_flag <= 0;     
    end
//输出数据
always @( posedge clk or negedge rst_n ) begin
    if(!rst_n) begin
        out_data <= 0;
    end
    else    if(rx_flag == 1)
        out_data <= rx_data;
end
//输出数据标志位
always @( posedge clk or negedge rst_n ) begin
    if(!rst_n) begin
        out_flag <= 0;
    end
    else
        out_flag <= rx_flag;
end
//led0 H18
//led1 K17
//led2 E19 0-7的变化范围


    
endmodule