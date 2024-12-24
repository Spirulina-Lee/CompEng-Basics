module ir(
    input  logic [7:0] data_in,    // 输入数据
    input  logic       clk,        // 时钟信号
    input  logic       reset,      // 复位信号，高电平有效
    input  logic       load_flag,  // 加载控制信号
    output logic [7:0] data_out    // 输出数据
);

    always @(posedge clk or posedge reset)
        if (reset)
            data_out <= 8'b0;      // 复位时，输出清零
        else if (load_flag)
            data_out <= data_in;   // 加载输入数据到输出
        else
            data_out <= data_out;  // 保持当前值

endmodule
