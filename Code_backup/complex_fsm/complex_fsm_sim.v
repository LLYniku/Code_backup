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
//�������������random�����ڿ��ֻ�����ͬʱ����1Ԫ����0.5Ԫ
reg   random_data                              ;
//�������ź�����һ�������������ֵ����һ��ȡ�����ɣ����

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


//������ע��pi_money_half��pi_money_one����ͬʱΪ1
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        random_data <= 0;
    else
        random_data <= {$random} % 2;
end

//��ֵ����Ͷ���ź�
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

//��ϰϵͳ��������ʵ�����ı�����ֵ��state
wire [4:0]  state = u_complex_fsm.state;
wire [1:0]  pi_money = u_complex_fsm.pi_money;
//ʹ������ϵͳ��������������֤
initial begin
    $timeformat(-9,0,"ns",6);
    $monitor("@time %t: pi_money_half = %b,pi_money_one = %b,pi_money = %b,state = %b,po_cola = %b",$time,pi_money_half,pi_money_one,pi_money,state,po_cola);
end


endmodule