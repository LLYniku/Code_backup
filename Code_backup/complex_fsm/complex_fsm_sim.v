//~ `New testbench
`timescale  1ns / 1ps

module tb_complex_fsm;

// complex_fsm Parameters
parameter PERIOD = 20      ;
parameter IDLE  = 5'b00001;

// complex_fsm Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   pi_money_half                        = 0 ;
reg   pi_money_one                         = 0 ;
//声明随机数变量random，由于可乐机不能同时输入1元或者0.5元
reg   random_data                              ;
//让两个信号其中一个等于随机数的值，另一个取反即可，妙啊！

// complex_fsm Outputs
wire  po_cola                              ;
wire  po_money                             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

complex_fsm #(
    .IDLE ( IDLE ))
 u_complex_fsm (
    .clk                     ( clk             ),
    .rst_n                   ( rst_n           ),
    .pi_money_half           ( pi_money_half   ),
    .pi_money_one            ( pi_money_one    ),

    .po_cola                 ( po_cola         ),
    .po_money                ( po_money        )
);


//仿真中注意pi_money_half和pi_money_one不能同时为1
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        random_data <= 0;
    else
        random_data <= {$random} % 2;
end

//赋值两个投币信号
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        pi_money_half <= 0;
    else
        pi_money_half <= random_data;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        pi_money_one <= 0;
    else
        pi_money_one <= ~pi_money_half;
end

//复习系统变量，将实例化的变量赋值给state
wire [4:0]  state = u_complex_fsm.state;
wire [1:0]  pi_money = u_complex_fsm.pi_money;
//使用两个系统函数方便我们验证
initial begin
    $timeformat(-9,0,"ns",6);
    $monitor("@time %t: pi_money_half = %b,pi_money_one = %b,pi_money = %b,state = %b,po_cola = %b",$time,pi_money_half,pi_money_one,pi_money,state,po_cola);
end


endmodule