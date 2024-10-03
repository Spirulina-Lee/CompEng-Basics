module dual_seg7 (
    input logic [7:0] bin_in,    // 8位二进制输入
    input logic blank,           // 熄灭控制信号（高电平有效）
    input logic test,            // 测试控制信号（高电平有效）
    output logic [6:0] out1,     // 第一个段显示的7位输出
    output logic [6:0] out0      // 第二个段显示的7位输出
);

    // 实例化上半字节
    seg7 seg_upper (
        .bin_in(bin_in[7:4]),    // 连接上半字节
        .blank(blank),           // 连接熄灭信号
        .test(test),             // 连接测试信号
        .seg_out(out1)           // 连接到out1
    );

    // 实例化下半字节
    seg7 seg_lower (
        .bin_in(bin_in[3:0]),    // 连接下半字节
        .blank(blank),           // 连接熄灭信号
        .test(test),             // 连接测试信号
        .seg_out(out0)           // 连接到out0
    );

endmodule
