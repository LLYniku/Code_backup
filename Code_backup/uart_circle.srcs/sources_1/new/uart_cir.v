module uart_cir (
    clk         ,
    rst_n       ,
    rx_uart     ,
    tx_uart     ,
    led
);

input   clk         ;
input   rst_n       ;
input   rx_uart     ;
output  tx_uart     ;
output [2:0]    led ;

    wire    rx_flag     ;
    wire [7:0] rx_data  ;

uart_rx  u_uart (
    .clk                     ( clk             ),
    .rst_n                   ( rst_n           ),
    .rx_uart                 ( rx_uart         ),

    .led                     ( led      [2:0]  ),
    .out_data                ( rx_data  [7:0]  ),
    .out_flag                ( rx_flag         )
);

uart_tx u_uart_tx (
    .clk                     ( clk            ),
    .rst_n                   ( rst_n          ),
    .in_data                 ( rx_data  [7:0] ),
    .in_flag                 ( rx_flag        ),

    .tx_uart                 ( tx_uart        )
);

endmodule //uart_cir