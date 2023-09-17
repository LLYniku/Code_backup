module uart_tx (
    clk         ,
    rst_n       ,
    in_data     ,
    in_flag     ,
    tx_uart
);

    input       clk         ;
    input       rst_n       ;
    input [7:0] in_data     ;
    input       in_flag     ;
    output      tx_uart     ;

    parameter TIMES = 5208  ;
    parameter TIMES2 = 10   ; 
    
    reg [12:0]  cnt0        ;
    wire        add_cnt0    ;
    wire        end_cnt0    ;
    reg [3:0]   cnt1        ;   
    wire        add_cnt1    ;
    wire        end_cnt1    ;
    reg [7:0]   send_data   ;
    wire        in_flag     ;
    reg         send_flag   ;    
    reg         tx_uart     ;

//第一个计数器，用来产生5208个单位的周期，标记每一个字节的长度
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
assign add_cnt0 = send_flag;
assign end_cnt0 = add_cnt0 && cnt0== TIMES - 1;

//第二个计数器，产生长度为9的计数，对应起始位数据和终止位
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

//seng_flag跟随全程
always @( posedge clk or negedge rst_n ) begin
    if(!rst_n) begin
        send_flag <= 0;
    end
    else    if(in_flag) begin
        send_flag <=  1;
    end
    else  if(end_cnt1) begin
        send_flag <=  0;
    end 
    else
        send_flag <=  send_flag;
end

//send_data的赋值
always @( posedge clk or negedge rst_n ) begin
    if(!rst_n) begin
        send_data <= 0;
    end
    else    if(send_flag) begin
        send_data <=  in_data;
    end
    else  begin
        send_data <=  send_data;
    end
    
end

//数据拼接
always @( posedge clk or negedge rst_n ) begin
    if(!rst_n) begin
        tx_uart <= 1;//空闲状态
    end
    else    if(send_flag == 1) begin //case语句的使用
        case(cnt1)
            0   :tx_uart <= 0           ;
            1   :tx_uart <= send_data[0];
            2   :tx_uart <= send_data[1];
            3   :tx_uart <= send_data[2];
            4   :tx_uart <= send_data[3];
            5   :tx_uart <= send_data[4];
            6   :tx_uart <= send_data[5];
            7   :tx_uart <= send_data[6];
            8   :tx_uart <= send_data[7];
            9   :tx_uart <= 1           ;
            default tx_uart <= 1        ;
        endcase
    end
    
end
//按键操作send_flag T19 默认高电平一直发送数据

    
endmodule