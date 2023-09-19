module complex_fsm (
    clk             ,
    rst_n           ,
    pi_money_half   ,
    pi_money_one    ,
    po_cola         ,
    po_money 
);

input       clk             ;
input       rst_n           ;
input       pi_money_half   ;
input       pi_money_one    ;
output      po_cola         ;
output      po_money        ;

wire        clk             ;
wire        rst_n           ;
wire        pi_money_half   ;
wire        pi_money_one    ;
reg         po_cola         ;
reg         po_money        ;
//这里使用微拼接的方式对pi_money进行赋值，由于pi_money是实时改变的，所以使用assign赋值
reg [4:0]   state           ;
// reg [1:0]   pi_money        ;
wire [1:0]  pi_money        ;

//定义state和pi_money的状态（已优化）
parameter   IDLE     = 5'b00001    ,
            HALF     = 5'b00010    ,
            ONE      = 5'b00100    ,
            ONE_HALF = 5'b01000    ,
            TWO      = 5'b10000    ;

//设计输入金钱时pi_money的状态 注意：1块钱和5毛钱不能同时输入，仿真要注意（已优化）
// always @(posedge clk or negedge rst_n) begin
//     if(!rst_n)
//         pi_money <= 0;
//     else    if(pi_money_half == 1)
//         pi_money <= 2'b01;
//     else    if(pi_money_one  == 1)
//         pi_money <= 2'b10;
//     else
//         pi_money <= 0;
// end

//设计状态机
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state     <=      IDLE;
    end
    else  begin
        case(state)
            IDLE:if(pi_money == 2'b01)
                    state   <=  HALF    ;
                 else   if(pi_money == 2'b10)
                    state   <=  ONE     ;
                 else
                    state   <=  IDLE    ;    
            HALF:if(pi_money == 2'b01)
                    state   <=  ONE ;
                else    if(pi_money == 2'b10)
                    state   <=  ONE_HALF ;
                else
                    state   <=  HALF;
            ONE:if(pi_money == 2'b01)
                    state   <=  ONE_HALF ;
                else    if(pi_money == 2'b10)
                    state   <=  TWO ;
                else
                    state   <=  ONE;
            ONE_HALF:if(pi_money == 2'b01)
                    state   <=  TWO ;
                else    if(pi_money == 2'b10)
                    state   <=  IDLE ;
                else
                    state   <=  ONE_HALF;
            TWO:if(pi_money == 2'b01)
                    state   <=  IDLE ;
                else    if(pi_money == 2'b10)
                    state   <=  IDLE ;
                else
                    state   <=  TWO;
            default:state   <=  IDLE;
        endcase
    end
end


//判断pi_money的值决定是否找钱
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        po_money <= 0;
    //找钱
    else    if(state == TWO      && pi_money == 2'b10)
        po_money <= 1;
    else
        po_money <= 0;
end

//判断pi_money的值决定是否给可乐
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        po_cola <= 0;
    else    if(state == ONE_HALF && pi_money == 2'b10)
        po_cola <= 1;
    else    if(state == TWO      && pi_money == 2'b01)
        po_cola <= 1;
    //找钱
    else    if(state == TWO      && pi_money == 2'b10)
        po_cola <= 1;
    else
        po_cola <= 0;
end

//定义pi_money的值
assign pi_money = {pi_money_one,pi_money_half};

endmodule //complex_fsm