module control (
    input logic CLK,
    input logic RESET,
    input logic [7:0] opcode,
    input logic ZFLG,
    input logic NFLG,

    output logic FETCH,
    output logic INC_PC,
    output logic LOAD_PC,
    output logic LOAD_IRU,
    output logic LOAD_IRL,
    output logic LOAD_AC,
    output logic STORE_MEM,
    // 新增对SP的操作信号和指令信号
    output logic LOAD_SP,    // 用于LOADSP指令：SP = IRL
    output logic SP_INC,     // SP自增
    output logic SP_DEC,     // SP自减
    output logic DO_PUSH,    // PUSH指令状态信号
    output logic DO_POP,     // POP指令状态信号
    output logic DO_JSR,     // JSR指令状态信号
    output logic DO_RTS,     // RTS指令状态信号
    output logic [3:0] STATE
);

    logic [3:0] state, state_next;
    logic [4:0] opcode5;

    assign opcode5 = opcode[4:0];

    parameter  START  = 4'd0,
               PrepU  = 4'd1,   
               FetchU = 4'd2,
               PrepL  = 4'd3,
               FetchL = 4'd4,
               Class1 = 4'd5,
               Class2 = 4'd6,
               Class3 = 4'd7,
               Class4 = 4'd8,
               Class5 = 4'd9,

               // 新增状态，对应新指令的执行阶段
               Class6 = 4'd10, // LOADSP执行
               Class7 = 4'd11, // PUSH执行(可能需多状态，此处简化)
               Class8 = 4'd12, // POP执行(可能需多状态，此处简化)
               Class9 = 4'd13, // JSR执行(可能需多状态)
               ClassA = 4'd14; // RTS执行(可能需多状态)

    always @(negedge CLK or posedge RESET)
        if (RESET)
            state <= START;
        else
            state <= state_next;

    // 初始化输出信号
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
    end

    always @(*) begin
        // 默认值复位
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
                    FETCH     = 1;
                    INC_PC    = 1;
                    LOAD_IRU  = 1;
                    // 判断指令类型
                    if (opcode5 == 5'h00 || opcode5 == 5'h04) begin  // NOP or CLR
                        state_next = Class1;               
                    end else begin
                        state_next = PrepL; 
                    end
                end

                PrepL: begin
                    FETCH = 1;
                    state_next = FetchL;   
                end

                FetchL: begin
                    FETCH     = 1;
                    INC_PC    = 1;
                    LOAD_IRL  = 1;
                    // 原有判断
                    if (opcode5 == 5'h02 || opcode5 == 5'h06 || opcode5 == 5'h08 || opcode5 == 5'h0E || opcode5 == 5'h0F) begin
                        state_next = Class2;   
                    end else if (opcode5 == 5'h01 || opcode5 == 5'h05 || opcode5 == 5'h07 || opcode5 == 5'h09 || opcode5 == 5'h0A || opcode5 == 5'h0B || opcode5 == 5'h0C || opcode5 == 5'h0D) begin     
                        state_next = Class3;   
                    end else if (opcode5 == 5'h03) begin // STORE                
                        state_next = Class4;               
                    end else if (opcode[7:0] == 8'h10 || opcode[7:0] == 8'h11 || opcode[7:0] == 8'h12 || opcode[7:0] == 8'h13 || opcode[7:0] == 8'h14) begin
                        state_next = Class5;               
                    end else begin
                        // 新增加指令判断 (根据题中给出的opcode hex)
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
                    LOAD_AC   = 1;
                    state_next = PrepU;              
                end

                Class3: begin
                    // Memory read cycle for load type
                    state_next = Class2;              
                end

                Class4: begin // STORE
                    STORE_MEM = 1;
                    state_next = PrepU;              
                end

                Class5: begin // Jump instructions
                    // Handle jumps (JUMP, JNEG, etc.)
                    case (opcode[4:0])
                        5'h10: LOAD_PC = 1;                      
                        5'h11: LOAD_PC = NFLG ? 1 : 0;           
                        5'h12: LOAD_PC = (~NFLG) ? 1 : 0;       
                        5'h13: LOAD_PC = ZFLG ? 1 : 0;          
                        5'h14: LOAD_PC = (~ZFLG) ? 1 : 0;       
                        default: LOAD_PC = 0;
                    endcase
                    state_next = PrepU;  
                end

                // 以下为新增指令状态 (根据要求在状态中给对应信号置1)

                Class6: begin // LOADSP value
                    LOAD_SP = 1; 
                    // SP <- IRL
                    state_next = PrepU;
                end

                Class7: begin // PUSH
                    // PUSH:
                    // SP = SP - 1; M[SP] = AC
                    DO_PUSH = 1;  
                    SP_DEC  = 1;   // 减SP
                    STORE_MEM = 1; // 将AC写入M[SP]
                    state_next = PrepU;
                end

                Class8: begin // POP
                    // POP:
                    // AC = M[SP]; SP = SP + 1
                    DO_POP   = 1;
                    LOAD_AC  = 1; // AC <- M[SP]
                    SP_INC   = 1; // SP = SP + 1
                    state_next = PrepU;
                end

                Class9: begin // JSR
                    // JSR address:
                    // SP = SP - 1; M[SP] = PC; PC = IRL
                    DO_JSR    = 1;
                    SP_DEC    = 1;
                    STORE_MEM = 1; // M[SP] = PC
                    LOAD_PC   = 1; // PC = IRL
                    state_next = PrepU;
                end

                ClassA: begin // RTS
                    // RTS:
                    // PC = M[SP]; SP = SP + 1
                    DO_RTS = 1;
                    LOAD_PC = 1; // PC <- M[SP]
                    SP_INC  = 1;
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
