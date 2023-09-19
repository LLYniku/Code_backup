`timescale  1ns / 1ps

module tb_fsm;

// fsm Parameters
parameter PERIOD = 20    ;
parameter IDLE  = 3'b001;
parameter ONE   = 3'b010;
parameter TWO   = 3'b100;

// fsm Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   pi_money                             = 0 ;

// fsm Outputs
wire  po_cola                              ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

fsm #(
    .IDLE ( IDLE ),
    .ONE  ( ONE  ),
    .TWO  ( TWO  ))
 u_fsm (
    .clk                     ( clk        ),
    .rst_n                   ( rst_n      ),
    .pi_money                ( pi_money   ),

    .po_cola                 ( po_cola    )
);

//产生投币信号，使用随机信号
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pi_money    <=  1'b1;
    end
    else    
        pi_money    <=  {$random}%2   ; 
end

//复习系统变量，将实例化的变量赋值给state
wire [2:0]  state = u_fsm.state;
//使用两个系统函数方便我们验证
initial begin
    $timeformat(-9,0,"ns",6);
    $monitor("@time %t: pi_money = %b,state = %b,po_cola = %b",$time,pi_money,state,po_cola);
end


endmodule