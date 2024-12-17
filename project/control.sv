module control (
    input  logic CLK,
    input  logic RESET,
    input  logic [7:0] opcode,
    input  logic ZFLG,
    input  logic NFLG,

    // 原有控制信号
    output logic FETCH,
    output logic INC_PC,
    output logic LOAD_PC,
    output logic LOAD_IRU,
    output logic LOAD_IRL,
    output logic LOAD_AC,
    output logic STORE_MEM,

    // 新增控制信号：SP控制及指令标志
    output logic LOAD_SP,
    output logic SP_INC,
    output logic SP_DEC,
    output logic DO_PUSH,
    output logic DO_POP,
    output logic DO_JSR,
    output logic DO_RTS,
    output logic SP_ADDR,

    // 新增控制信号：数据路径选择信号
    // AC_SRC=0: AC从ALU_result输入；AC_SRC=1: AC从RAM_out输入
    output logic AC_SRC,
    // PC_SRC=0: PC从IRL输入；PC_SRC=1: PC从RAM_out输入
    output logic PC_SRC,
    // MEM_IN_SRC=0: RAM写入数据来自AC_out；1: 来自PC_out
    output logic MEM_IN_SRC,

    // 状态机输出 (4位够用，表示0~15)
    output logic [3:0] STATE
);

    logic [3:0] state, state_next;

    // 定义状态（4位）
    parameter [3:0] START  = 4'd0,
                    PrepU  = 4'd1,
                    FetchU = 4'd2,
                    PrepL  = 4'd3,
                    FetchL = 4'd4,
                    Class1 = 4'd5,
                    Class2 = 4'd6,
                    Class3 = 4'd7,
                    Class4 = 4'd8,
                    Class5 = 4'd9,
                    Class6 = 4'd10, // LOADSP
                    Class7 = 4'd11, // PUSH
                    Class8 = 4'd12, // POP阶段1
                    Class9 = 4'd13, // JSR
                    ClassA = 4'd14, // RTS阶段1
                    ClassB = 4'd15; // POP/RTS第2阶段（从M[SP]读数据）

    always @(negedge CLK or posedge RESET) begin
        if (RESET)
            state <= START;
        else
            state <= state_next;
    end

    initial begin
        FETCH     = 0;
        INC_PC    = 0;
        LOAD_PC   = 0;
        LOAD_IRU  = 0;
        LOAD_IRL  = 0;
        LOAD_AC   = 0;
        STORE_MEM = 0;
        LOAD_SP   = 0;
        SP_INC    = 0;
        SP_DEC    = 0;
        DO_PUSH   = 0;
        DO_POP    = 0;
        DO_JSR    = 0;
        DO_RTS    = 0;
        SP_ADDR   = 0;
        AC_SRC    = 0;
        PC_SRC    = 0;
        MEM_IN_SRC= 0;
    end

    always @(*) begin
        // 默认值清零，每个周期重新赋值
        FETCH     = 0;
        INC_PC    = 0;
        LOAD_PC   = 0;
        LOAD_IRU  = 0;
        LOAD_IRL  = 0;
        LOAD_AC   = 0;
        STORE_MEM = 0;
        LOAD_SP   = 0;
        SP_INC    = 0;
        SP_DEC    = 0;
        DO_PUSH   = 0;
        DO_POP    = 0;
        DO_JSR    = 0;
        DO_RTS    = 0;
        SP_ADDR   = 0;
        AC_SRC    = 0; // 默认AC从ALU_result取值
        PC_SRC    = 0; // 默认PC从IRL取值
        MEM_IN_SRC= 0; // 默认RAM写入数据来自AC_out

        if (RESET) begin
            state_next = Class1; 
        end else begin
            case (state)
                START: begin
                    state_next = PrepU;
                end

                PrepU: begin
                    FETCH     = 1;
                    state_next = FetchU;
                end

                FetchU: begin
                    // 取上半字节
                    FETCH     = 1;
                    INC_PC    = 1;
                    LOAD_IRU  = 1;
                    // 判断opcode是否NOP(0x00)或CLR(0x04)等无操作数单字节指令
                    if (opcode == 8'h00 || opcode == 8'h04) begin
                        // NOP or CLR
                        state_next = Class1;               
                    end else begin
                        state_next = PrepL; 
                    end
                end

                PrepL: begin
                    // 准备取下半字节
                    FETCH = 1;
                    state_next = FetchL;   
                end

                FetchL: begin
                    // 取下半字节（IRL）
                    FETCH     = 1;
                    INC_PC    = 1;
                    LOAD_IRL  = 1;

                    // 根据已知指令集进行分类判断
                    // 示例：假设0x02,0x06,0x08,0x0E,0x0F是立即数运算类指令 -> Class2
                    //       0x01,0x05,0x07,0x09,0x0A,0x0B,0x0C,0x0D为存取内存类 -> Class3
                    //       0x03是STORE -> Class4
                    //       0x10-0x14是JUMP类 -> Class5
                    //       0x15 LOADSP, 0x16 PUSH, 0x17 POP, 0x18 JSR, 0x19 RTS
                    if (opcode == 8'h02 || opcode == 8'h06 || opcode == 8'h08 || opcode == 8'h0E || opcode == 8'h0F) begin
                        state_next = Class2;   
                    end else if (opcode == 8'h01 || opcode == 8'h05 || opcode == 8'h07 ||
                                 opcode == 8'h09 || opcode == 8'h0A || opcode == 8'h0B ||
                                 opcode == 8'h0C || opcode == 8'h0D) begin
                        state_next = Class3;   
                    end else if (opcode == 8'h03) begin // STORE                
                        state_next = Class4;               
                    end else if (opcode >= 8'h10 && opcode <= 8'h14) begin
                        // JUMP系列指令
                        state_next = Class5;               
                    end else begin
                        // 新指令判断 (LOADSP=0x15, PUSH=0x16, POP=0x17, JSR=0x18, RTS=0x19)
                        case (opcode)
                            8'h15: state_next = Class6; // LOADSP
                            8'h16: state_next = Class7; // PUSH
                            8'h17: state_next = Class8; // POP
                            8'h18: state_next = Class9; // JSR
                            8'h19: state_next = ClassA; // RTS
                            default: state_next = START;
                        endcase
                    end     
                end

                Class1: begin
                    LOAD_AC = 1;
                    state_next = PrepU;              
                end

                Class2: begin
                    // 立即数运算类：最终LOAD_AC
                    LOAD_AC   = 1;
                    state_next = PrepU;              
                end

                Class3: begin
                    // Load type memory read cycle
                    state_next = Class2;              
                end

                Class4: begin // STORE指令
                    STORE_MEM = 1; // 写AC到地址=IRL
                    state_next = PrepU;              
                end

                Class5: begin // JUMP系列指令 (0x10~0x14)
                    // opcode低5位判断指令类型，这里直接使用低5位(0x10~0x14)
                    // 如果你的指令与低5位无关，请直接用opcode全8位判断
                    case (opcode)
                        8'h10: LOAD_PC = 1;                      
                        8'h11: LOAD_PC = NFLG ? 1 : 0;           
                        8'h12: LOAD_PC = (~NFLG) ? 1 : 0;       
                        8'h13: LOAD_PC = ZFLG ? 1 : 0;          
                        8'h14: LOAD_PC = (~ZFLG) ? 1 : 0;       
                        default: LOAD_PC = 0;
                    endcase
                    state_next = PrepU;  
                end

                Class6: begin // LOADSP: SP = IRL
                    LOAD_SP = 1; 
                    state_next = PrepU;
                end

                Class7: begin // PUSH: SP=SP-1; M[SP]=AC
                    DO_PUSH   = 1;
                    SP_DEC    = 1;
                    SP_ADDR   = 1; 
                    STORE_MEM = 1; // 写AC到M[SP]
                    MEM_IN_SRC= 0; // 来自AC_out
                    state_next = PrepU;
                end

                Class8: begin // POP (第一阶段): M[SP] -> AC,需要先给出SP地址，再读下一周期
                    DO_POP  = 1;
                    SP_ADDR = 1;
                    // 下个状态ClassB中再LOAD_AC和SP_INC
                    state_next = ClassB;
                end

                Class9: begin // JSR: SP=SP-1; M[SP]=PC; PC=IRL
                    DO_JSR    = 1;
                    SP_DEC    = 1;
                    SP_ADDR   = 1;
                    STORE_MEM = 1;
                    MEM_IN_SRC= 1; // 写入M[SP]的数据来自PC_out
                    LOAD_PC   = 1; // PC=IRL
                    state_next = PrepU;
                end

                ClassA: begin // RTS (第一阶段): M[SP]->PC,需要先给出SP地址
                    DO_RTS  = 1;
                    SP_ADDR = 1;
                    // 下个状态ClassB中再LOAD_PC和SP_INC
                    state_next = ClassB;
                end

                ClassB: begin
                    // 通用第二阶段：读取M[SP]后的处理
                    // 若POP: AC = M[SP], SP=SP+1
                    // 若RTS: PC = M[SP], SP=SP+1
                    if (opcode == 8'h17) begin // POP
                        LOAD_AC = 1;
                        SP_INC  = 1;
                        AC_SRC  = 1; // AC从RAM_out取值
                    end else if (opcode == 8'h19) begin // RTS
                        LOAD_PC = 1;
                        SP_INC  = 1;
                        PC_SRC  = 1; // PC从RAM_out取值
                    end
                    state_next = PrepU;
                end

                default: begin
                    state_next = START;               
                end
            endcase
        end
    end

    assign STATE = state;

endmodule
