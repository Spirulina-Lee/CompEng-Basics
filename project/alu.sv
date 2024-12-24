module alu(
    input  logic [7:0] AC,        // 累加器输入
    input  logic [7:0] MDR,       // 数据寄存器输入
    input  logic [7:0] opcode,    // 操作码
    input  logic [7:0] value,     // 操作数
    output logic [7:0] Z,         // 运算结果
    output logic       ZFLAG,     // 零标志
    output logic       NFLAG      // 负标志
);

    always @(*)
        case (opcode)
            8'h01: Z = MDR;                 // 直接取MDR值
            8'h02: Z = value;               // 直接取操作数
            8'h04: Z = 8'b0;                // 清零
            8'h05: Z = AC + MDR;            // 加法
            8'h06: Z = AC + value;          // 加操作数
            8'h07: Z = AC - MDR;            // 减法
            8'h08: Z = AC - value;          // 减操作数
            8'h09: Z = 8'b0 - MDR;          // 求负
            8'h0a: Z = ~MDR;                // 取反
            8'h0b: Z = AC & MDR;            // 按位与
            8'h0c: Z = AC | MDR;            // 按位或
            8'h0d: Z = AC ^ MDR;            // 按位异或
            8'h0e: Z = AC << value[2:0];    // 左移操作
            8'h0f: Z = AC >> value[2:0];    // 右移操作
            default: Z = 8'b0;              // 默认清零
        endcase

    always @(*) begin
        if (AC >= 8'h80) begin
            NFLAG = 1'b1;                   // 负数标志
            ZFLAG = 1'b0;
        end else if (AC == 8'b0) begin
            ZFLAG = 1'b1;                   // 零标志
            NFLAG = 1'b0;
        end else begin
            NFLAG = 1'b0;                   // 无负数，无零
            ZFLAG = 1'b0;
        end
    end

endmodule
