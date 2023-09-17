module global_sim;  
//20ns为一个周期,可以在vscode中自动生成！
parameter  CYCLE = 20;
//input为reg，output为wire
reg        clk       ;
reg        rst_n     ;
reg        rx_uart   ;
wire [1:0] led       ;

uart sim(
    clk     (clk),
    rst_n   (rst_n),
    rx_uart (rx_uart),
    led     (led)
);

initial begin
    clk = 0;
    forever#(CYCLE/2) begin//一半的时钟周期
        clk = ~clk;
    end
end

initial begin
    #1;
    rst_n = 0;
    #(10*CYCLE);
    rst_n = 1;
end
endmodule