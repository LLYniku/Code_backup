//计数器
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
//时序



//异步时钟同步化-两个触发器
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

//边沿检测
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