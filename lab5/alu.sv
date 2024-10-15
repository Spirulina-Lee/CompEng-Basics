module alu (
    input logic signed [7:0] AC,         // 累加器输入 (signed)
    input logic signed [7:0] MDR,        // 存储数据寄存器输入 (signed)
    input logic [4:0] opcode,            // 操作码输入（5位宽，支持21条指令）
    input logic signed [7:0] value,      // 立即数输入 (signed)
    output logic signed [7:0] Z,         // ALU输出 (signed)
    output logic ZFLG,                   // 零标志输出
    output logic NFLG                    // 负数标志输出
);

    // always_comb block for ALU operations
    always_comb begin
        // Default assignment to prevent latches
        Z = 8'b0;  // 默认情况下，Z被赋值为0

        // ALU操作逻辑
        case (opcode)
            5'b00000: Z = AC;                          // NOP (保持AC)
            5'b00001: Z = MDR;                         // LOAD address
            5'b00010: Z = value;                       // LOADI value
            5'b00011: /* STORE operation (handled by control logic) */;
            5'b00100: Z = 8'b0;                        // CLR (清零)
            5'b00101: Z = AC + MDR;                    // ADD address
            5'b00110: Z = AC + value;                  // ADDI value
            5'b00111: Z = AC - MDR;                    // SUBT address
            5'b01000: Z = AC - value;                  // SUBTI value
            5'b01001: Z = 8'b0 - MDR;                  // NEG address
            5'b01010: Z = ~MDR;                        // NOT address
            5'b01011: Z = AC & MDR;                    // AND address
            5'b01100: Z = AC | MDR;                    // OR address
            5'b01101: Z = AC ^ MDR;                    // XOR address
            5'b01110: Z = AC <<< value[2:0];           // SHL value (左移，使用算术移位)
            5'b01111: Z = AC >>> value[2:0];           // SHR value (右移，使用算术移位)
            5'b10000: /* JUMP operation (handled by control logic) */;
            5'b10001: /* JNEG operation (handled by control logic) */;
            5'b10010: /* JPOSZ operation (handled by control logic) */;
            5'b10011: /* JZERO operation (handled by control logic) */;
            5'b10100: /* JNZER operation (handled by control logic) */;
            default: Z = AC;                           // 未定义操作码，执行NOP
        endcase

        // 设置标志位
        ZFLG = (Z == 8'b0);   // 当Z为0时，ZFLG标志置位
        NFLG = Z[7];          // 当Z为负时（最高位为1），NFLG标志置位
    end

endmodule
