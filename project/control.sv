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
    output logic LOAD_SP,
    output logic SP_INC,
    output logic SP_DEC,
    output logic DO_PUSH,
    output logic DO_POP,
    output logic DO_JSR,
    output logic DO_RTS,
    output logic SP_ADDR,
    output logic [4:0] STATE // 从4位改为5位
);

    logic [4:0] state, state_next;  // state也改用5位
    logic [4:0] opcode5;

    assign opcode5 = opcode[4:0];

    // 使用5位定义状态，留出更多空间
    parameter [4:0] START  = 5'd0,
                    PrepU  = 5'd1,   
                    FetchU = 5'd2,
                    PrepL  = 5'd3,
                    FetchL = 5'd4,
                    Class1 = 5'd5,
                    Class2 = 5'd6,
                    Class3 = 5'd7,
                    Class4 = 5'd8,
                    Class5 = 5'd9,
                    Class6 = 5'd10, // LOADSP
                    Class7 = 5'd11, // PUSH
                    Class8 = 5'd12, // POP阶段1
                    Class9 = 5'd13, // JSR
                    ClassA = 5'd14, // RTS阶段1
                    ClassB = 5'd15; // 通用读出第二阶段

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
    end

    always @(*) begin
        // 默认值清零
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
                    // 原有指令分类逻辑
                    if (opcode5 == 5'h02 || opcode5 == 5'h06 || opcode5 == 5'h08 || opcode5 == 5'h0E || opcode5 == 5'h0F) begin
                        state_next = Class2;   
                    end else if (opcode5 == 5'h01 || opcode5 == 5'h05 || opcode5 == 5'h07 || opcode5 == 5'h09 || opcode5 == 5'h0A || opcode5 == 5'h0B || opcode5 == 5'h0C || opcode5 == 5'h0D) begin     
                        state_next = Class3;   
                    end else if (opcode5 == 5'h03) begin // STORE                
                        state_next = Class4;               
                    end else if (opcode[7:0] >= 8'h10 && opcode[7:0] <= 8'h14) begin
                        state_next = Class5;               
                    end else begin
                        // 新指令判断
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
                    state_next = Class2;              
                end

                Class4: begin // STORE
                    STORE_MEM = 1;
                    state_next = PrepU;              
                end

                Class5: begin // Jump instructions
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

                Class6: begin // LOADSP: SP = IRL
                    LOAD_SP = 1; 
                    state_next = PrepU;
                end

                Class7: begin // PUSH: SP=SP-1; M[SP]=AC
                    DO_PUSH   = 1;
                    SP_DEC    = 1;
                    SP_ADDR   = 1; 
                    STORE_MEM = 1;
                    state_next = PrepU;
                end

                Class8: begin // POP: 第1阶段, 给RAM地址
                    DO_POP  = 1;
                    SP_ADDR = 1;
                    // 下一个状态读数据
                    state_next = ClassB;
                end

                Class9: begin // JSR: SP=SP-1; M[SP]=PC; PC=IRL
                    DO_JSR    = 1;
                    SP_DEC    = 1;
                    SP_ADDR   = 1;
                    STORE_MEM = 1;
                    LOAD_PC   = 1;
                    state_next = PrepU;
                end

                ClassA: begin // RTS: 第1阶段, 给RAM地址
                    DO_RTS  = 1;
                    SP_ADDR = 1;
                    state_next = ClassB;
                end

                ClassB: begin
                    // 第二阶段，根据opcode确认是POP还是RTS
                    case (opcode)
                        8'h17: begin // POP
                            LOAD_AC = 1;
                            SP_INC  = 1;
                        end
                        8'h19: begin // RTS
                            LOAD_PC = 1;
                            SP_INC  = 1;
                        end
                        default: begin
                            // 非预期情况
                        end
                    endcase
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
