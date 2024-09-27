module jk_ff_tb (
    input logic [1:0] SW,   // SW[0] - J, SW[1] - K
    input logic [1:0] KEY,  // KEY[0] - clk, KEY[1] - reset
    output logic [0:0] LEDR // LEDR[0] - Q
);
    // 实例化 JK 触发器
    jk_ff jk_ff_1 (
        .j(SW[0]),          // J 输入
        .k(SW[1]),          // K 输入
        .clk(KEY[0]),       // 时钟信号
        .reset(KEY[1]),     // 复位信号
        .q(LEDR[0])         // 输出 Q
    );
endmodule
