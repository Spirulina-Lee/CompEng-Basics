module control (
    input logic [7:0] opcode,
    input logic NFLG,
    input logic ZFLG,
    input logic RESET,
    input logic CLK,
    output logic [3:0] STATE,
    output logic LOAD_AC,
    output logic LOAD_IRU,
    output logic LOAD_IRL,
    output logic LOAD_PC,
    output logic INC_PC,
    output logic FETCH,
    output logic STORE_MEM,
    output logic MEM_READ,
    output logic MEM_WRITE
);

    // 定义操作码
    localparam NOP    = 5'b00000;
    localparam LOAD   = 5'b00001;
    localparam LOADI  = 5'b00010;
    localparam STORE  = 5'b00011;
    localparam CLR    = 5'b00100;
    localparam ADD    = 5'b00101;
    localparam ADDI   = 5'b00110;
    localparam SUBT   = 5'b00111;
    localparam SUBTI  = 5'b01000;
    localparam NEG    = 5'b01001;
    localparam NOT    = 5'b01010;
    localparam AND    = 5'b01011;
    localparam OR     = 5'b01100;
    localparam XOR    = 5'b01101;
    localparam SHL    = 5'b01110;
    localparam SHR    = 5'b01111;
    localparam JUMP   = 5'b10000;
    localparam JNEG   = 5'b10001;
    localparam JPOSZ  = 5'b10010;
    localparam JZERO  = 5'b10011;
    localparam JNZER  = 5'b10100;

    typedef enum logic [3:0] {
        Start       = 4'b0000,
        PrepU       = 4'b0001,
        FetchU      = 4'b0010,
        PrepL       = 4'b0011,
        FetchL      = 4'b0100,
        Class1      = 4'b0101,
        Class2      = 4'b0110,
        Class3_Prep = 4'b0111, // 新增状态：准备读取内存
        Class3_Exec = 4'b1000, // 新增状态：执行内存读取后的操作
        Class4      = 4'b1001,
        Class5      = 4'b1010
    } STATE_TYPE;

    STATE_TYPE current_state, next_state;

    always_ff @(negedge CLK or posedge RESET) begin
        if (RESET) 
            current_state <= Start; 
        else 
            current_state <= next_state; 
    end

    always_comb begin
        // 默认情况下，所有控制信号为 0
        LOAD_AC    = 1'b0;
        LOAD_IRU   = 1'b0;
        LOAD_IRL   = 1'b0;
        LOAD_PC    = 1'b0;
        INC_PC     = 1'b0;
        FETCH      = 1'b0;
        STORE_MEM  = 1'b0;
        MEM_READ   = 1'b0;
        MEM_WRITE  = 1'b0;

        next_state = current_state;  // 默认保持当前状态

        case (current_state)
            Start: begin
                LOAD_PC = 1'b1;
                next_state = PrepU;
            end

            PrepU: begin
                FETCH = 1'b1;
                next_state = FetchU;
            end

            FetchU: begin
                LOAD_IRU = 1'b1;
                INC_PC = 1'b1;
                // 在 FetchU 后解码 opcode，决定下一个状态
                if (opcode[4:0] == NOP || opcode[4:0] == CLR) begin
                    next_state = Class1;
                end else begin
                    next_state = PrepL;
                end
            end

            PrepL: begin
                FETCH = 1'b1;
                next_state = FetchL;
            end

            FetchL: begin
                LOAD_IRL = 1'b1;
                INC_PC = 1'b1;
                // 在 FetchL 后解码 opcode，决定下一个状态
                unique case (opcode[4:0])
                    LOADI, ADDI, SUBTI, SHL, SHR: begin
                        next_state = Class2;
                    end

                    LOAD, ADD, SUBT, NEG, NOT, AND, OR, XOR: begin
                        next_state = Class3_Prep;
                    end

                    STORE: begin
                        next_state = Class4;
                    end

                    JUMP, JNEG, JPOSZ, JZERO, JNZER: begin
                        next_state = Class5;
                    end

                    default: begin
                        next_state = Start;  // 未定义的操作码，重置
                    end
                endcase
            end

            Class1: begin
                if (opcode[4:0] == CLR) begin
                    LOAD_AC = 1'b1;  // AC <= 0，由 ALU 实现
                end
                // NOP 不需要任何操作
                next_state = PrepU;  // 返回取指阶段
            end

            Class2: begin
                LOAD_AC = 1'b1;  // 将 Z 存入 AC，保存结果
                next_state = PrepU;
            end

            // 修改后的 Class3，拆分为两个状态
            Class3_Prep: begin
                // 准备从内存读取数据
                MEM_READ = 1'b1;  // 启用内存读取
                // 在此周期中，地址（address）已经被设置为 IRL
                next_state = Class3_Exec;
            end

            Class3_Exec: begin
                // 等待内存读取完成，然后将 ALU 的结果存入 AC
                LOAD_AC = 1'b1;  // 将 Z 存入 AC，保存结果
                next_state = PrepU;
            end

            Class4: begin
                // 准备写入内存
                MEM_WRITE = 1'b1;
                STORE_MEM = 1'b1;  // 使能内存写操作
                next_state = PrepU;
            end

            Class5: begin
                // 根据条件决定是否跳转
                if ( (opcode[4:0] == JUMP) ||
                     (opcode[4:0] == JNEG  && NFLG) ||
                     (opcode[4:0] == JPOSZ && !NFLG) ||
                     (opcode[4:0] == JZERO && ZFLG) ||
                     (opcode[4:0] == JNZER && !ZFLG) ) begin
                    LOAD_PC = 1'b1;  // 将 IRL 加载到 PC
                end
                next_state = PrepU;
            end

            default: begin
                next_state = Start;
            end
        endcase
    end

    assign STATE = current_state;

endmodule
