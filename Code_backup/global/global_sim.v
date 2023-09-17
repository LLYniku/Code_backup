module global_sim;  
//20nsΪһ������,������vscode���Զ����ɣ�
parameter  CYCLE = 20;
//inputΪreg��outputΪwire
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
    forever#(CYCLE/2) begin//һ���ʱ������
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