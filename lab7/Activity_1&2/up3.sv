module up3 (
    input logic [7:0] pc,              // 程序计数器（PC）输入
    input logic [7:0] addr_value,      // 地址或值总线输入
    input logic FETCH,                 // 控制信号：决定地址来源
    output logic [7:0] address         // 输出地址总线
);

    always_comb begin
        if (FETCH)
            address = pc;              // FETCH = 1 时，地址来源于 PC
        else
            address = addr_value;      // FETCH = 0 时，地址来源于 addr/value
    end

endmodule
