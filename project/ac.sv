module ac(
    input  logic       LOAD_AC,  // 累加器加载控制信号
    input  logic       clk,      // 时钟信号
    input  logic signed [7:0] Z, // ALU输出结果
    output logic signed [7:0] AC // 累加器值
);

    always_ff @(posedge clk)
        if (LOAD_AC)
            AC <= Z;             // 加载ALU结果到累加器

endmodule
