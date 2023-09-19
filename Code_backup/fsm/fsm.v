//目标要求，实现买可乐状态机，根据波形图进行代码撰写
module fsm(
    clk         ,
    rst_n       ,
    pi_money    ,
    po_cola
);

input       clk     ;
input       rst_n   ;
input       pi_money;
output      po_cola ;

//定义state,使用独热码来进行状态定义，几位宽用几个状态,也可以使用二进制或者格雷码
parameter   IDLE    =   3'b001;
parameter   ONE     =   3'b010;
parameter   TWO     =   3'b100;

wire         clk        ;
wire         rst_n      ;
wire         pi_money   ;
reg          po_cola    ;
reg [2:0]    state      ;
//状态机学习过程
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state     <=      IDLE;
    end
    else  begin
        case(state)
            IDLE:if(pi_money == 1'b1)
                    state   <=  ONE ;
                 else
                    state   <=  IDLE;
            ONE:if(pi_money == 1'b1)
                    state   <=  TWO ;
                else
                    state   <=  ONE ;
            TWO:if(pi_money == 1'b1) begin
                    state   <=  IDLE;
                    // po_cola <=  1'b1;
                end
                else
                    state   <=  TWO ;
            default:state   <=  IDLE;
        endcase
    end
end

//输出信号单独一个always
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        po_cola     <=      1'b0;
    end    
    else    if(state == TWO && pi_money == 1'b1)
        po_cola     <=      1'b1;
    else
        po_cola     <=      1'b0;
end


endmodule