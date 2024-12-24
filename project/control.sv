module control(
    input  logic [7:0] opcode,      // 操作码
    input  logic       NFLAG,       // 负数标志
    input  logic       ZFLAG,       // 零标志
    input  logic       RESET,       // 复位信号，高电平有效
    input  logic       CLK,         // 时钟信号
    output logic [4:0] STATE,       // 当前状态
    output logic       LOAD_AC,     // 累加器加载信号
    output logic       LOAD_IRU,    // IR高位加载信号
    output logic       LOAD_IRL,    // IR低位加载信号
    output logic       LOAD_PC,     // 程序计数器加载信号
    output logic       INCR_PC,     // 程序计数器自增信号
    output logic       FETCH,       // 取指令信号
    output logic       STORE_MEM,   // 存储信号
    output logic       LOAD_SP,     // 堆栈指针加载信号
    output logic       DECR_SP,     // 堆栈指针减少信号
    output logic       INCR_SP,     // 堆栈指针增加信号
    output logic       FETCH_SP,    // 堆栈指针取数据信号
    output logic       FETCH_DATA,  // 数据取信号
    output logic       FETCH_AC_DATA // 累加器数据取信号
);

    typedef enum logic [4:0] {
        START, PREPU, FETCHU, PREPL, FETCHL, READM, STOREM, JUMP, SPL, SPDECR, SPM, SPR, SPLAC, SPINCE, PCMSP, SPRL, SPFETCH
    } statetype;
    
    statetype state, nextstate; // 当前状态和下一状态

    // 状态寄存器
    always_ff @(negedge CLK or posedge RESET)
        if (RESET)
            state <= START; // 复位到起始状态
        else
            state <= nextstate;

    // 下一状态逻辑
    always @(*) begin
        case (state)
            START:   nextstate = PREPU;
            PREPU:   nextstate = FETCHU;
            FETCHU:  nextstate = (opcode == 8'h04) ? START :
                                 (opcode == 8'h00) ? PREPU :
                                 (opcode == 8'h16) ? SPDECR :
                                 (opcode == 8'h17) ? SPR :
                                 (opcode == 8'h19) ? SPRL :
                                                     PREPL;
            PREPL:   nextstate = FETCHL;
            FETCHL:  case (opcode)
                        8'h01: nextstate = READM;
                        8'h02: nextstate = START;
                        8'h03: nextstate = STOREM;
                        8'h05: nextstate = READM;
                        8'h06: nextstate = START;
                        8'h07: nextstate = READM;
                        8'h08: nextstate = START;
                        8'h09: nextstate = READM;
                        8'h0a: nextstate = READM;
                        8'h0b: nextstate = READM;
                        8'h0c: nextstate = READM;
                        8'h0d: nextstate = READM;
                        8'h0e: nextstate = START;
                        8'h0f: nextstate = START;
                        8'h10: nextstate = JUMP;
                        8'h11: nextstate = JUMP;
                        8'h12: nextstate = JUMP;
                        8'h13: nextstate = JUMP;
                        8'h14: nextstate = JUMP;
                        8'h15: nextstate = SPL;
                        8'h18: nextstate = SPDECR;
                    endcase
            READM:   nextstate = START;
            STOREM:  nextstate = PREPU;
            JUMP:    nextstate = PREPU;
            SPL:     nextstate = PREPU;
            SPDECR:  nextstate = (opcode == 8'h16) ? SPM :
                                 (opcode == 8'h18) ? PCMSP :
                                                     PREPU;
            SPM:     nextstate = PREPU;
            SPR:     nextstate = SPLAC;
            SPLAC:   nextstate = PREPU;
            SPINCE:  nextstate = PREPU;
            PCMSP:   nextstate = JUMP;
            SPRL:    nextstate = SPFETCH;
            SPFETCH: nextstate = JUMP;
        endcase
    end

    // 输出逻辑
    assign FETCH         = (state == PREPU || state == FETCHU || state == PREPL || state == FETCHL);
    assign LOAD_IRU      = (state == FETCHU);
    assign LOAD_IRL      = (state == FETCHL || state == SPFETCH);
    assign INCR_PC       = (state == FETCHU || state == FETCHL);
    assign STATE         = state;
    assign LOAD_AC       = (state == START || state == SPLAC);
    assign STORE_MEM     = (state == STOREM || state == SPM || state == PCMSP);
    assign LOAD_PC       = (state == JUMP && ((opcode == 8'h10 || opcode == 8'h18 || opcode == 8'h19) || 
                     (opcode == 8'h11 && NFLAG) || (opcode == 8'h12 && (!NFLAG)) || 
                     (opcode == 8'h13 && ZFLAG) || (opcode == 8'h14 && (!ZFLAG))));
    assign LOAD_SP       = (state == SPL);
    assign DECR_SP       = (state == SPDECR);
    assign INCR_SP       = (state == SPINCE || state == SPFETCH || state == SPLAC);
    assign FETCH_SP      = (state == SPM || state == SPR || state == PCMSP || state == SPRL);
    assign FETCH_DATA    = (state == PCMSP);
    assign FETCH_AC_DATA = (state == SPLAC);

endmodule
