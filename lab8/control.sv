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
               Class5 = 4'd9;

    always @(negedge CLK or posedge RESET)
        if (RESET)
            state <= START;
        else
            state <= state_next;

    initial begin
        FETCH     = 0;
        INC_PC    = 0;
        LOAD_PC   = 0;
        LOAD_IRU  = 0;
        LOAD_IRL  = 0;
        LOAD_AC   = 0;
        STORE_MEM = 0;
    end

    always @(*) begin
        if (RESET) begin
            FETCH     = 0;
            INC_PC    = 0;
            LOAD_PC   = 0;
            LOAD_IRU  = 0;
            LOAD_IRL  = 0;
            LOAD_AC   = 0;
            STORE_MEM = 0;
            state_next = Class1;   
        end else begin
            case (state)
                START: begin
                    FETCH     = 0;
                    INC_PC    = 0;
                    LOAD_PC   = 0;
                    LOAD_IRU  = 0;
                    LOAD_IRL  = 0;
                    LOAD_AC   = 0;
                    STORE_MEM = 0;
                    state_next = PrepU;
                end  
                PrepU: begin
                    FETCH     = 1;
                    INC_PC    = 0;
                    LOAD_PC   = 0;
                    LOAD_IRU  = 0;
                    LOAD_IRL  = 0;
                    LOAD_AC   = 0;
                    STORE_MEM = 0;
                    state_next = FetchU;
                end
                FetchU: begin
						      FETCH     = 1;
                        INC_PC    = 1;
                        LOAD_PC   = 0;
                        LOAD_IRU  = 1;
                        LOAD_IRL  = 0;
                        LOAD_AC   = 0;
                        STORE_MEM = 0;
                    if (opcode5 == 5'h00 || opcode5 == 5'h04) begin  // NOP or CLR                  
                        state_next = Class1;               
                    end else begin       
                        state_next = PrepL; 
                    end 
                end 
                PrepL: begin
                    FETCH     = 1;
                    INC_PC    = 0;
                    LOAD_PC   = 0;
                    LOAD_IRU  = 0;
                    LOAD_IRL  = 0;
                    LOAD_AC   = 0;
                    STORE_MEM = 0;
                    state_next = FetchL;   
                end
                FetchL: begin
								FETCH     = 1;
                        INC_PC    = 1;
                        LOAD_PC   = 0;
                        LOAD_IRU  = 0;
                        LOAD_IRL  = 1;
                        LOAD_AC   = 0;
                        STORE_MEM = 0;
                    if (opcode5 == 5'h02 || opcode5 == 5'h06 || opcode5 == 5'h08 || opcode5 == 5'h0E || opcode5 == 5'h0F) begin
                        state_next = Class2;   
                    end else if (opcode5 == 5'h01 || opcode5 == 5'h05 || opcode5 == 5'h07 || opcode5 == 5'h09 || opcode5 == 5'h0A || opcode5 == 5'h0B || opcode5 == 5'h0C || opcode5 == 5'h0D) begin     
                        state_next = Class3;   
                    end else if (opcode5 == 5'h03) begin // STORE                
                        state_next = Class4;               
                    end else begin
                        state_next = Class5;               
                    end     
                end
                Class1: begin
                    FETCH     = 0;
                    INC_PC    = 0;
                    LOAD_PC   = 0;
                    LOAD_IRU  = 0;
                    LOAD_IRL  = 0;
						  LOAD_AC = 1;
						  STORE_MEM = 0;
                    state_next = PrepU;              
                end
                Class2: begin
                    FETCH     = 0;
                    INC_PC    = 0;
                    LOAD_PC   = 0;
                    LOAD_IRU  = 0;
                    LOAD_IRL  = 0;
                    LOAD_AC   = 1;
                    STORE_MEM = 0;
                    state_next = PrepU;              
                end
                Class3: begin
                    FETCH     = 0;  // Initiate memory read from address in IRL
                    INC_PC    = 0;
                    LOAD_PC   = 0;
                    LOAD_IRU  = 0;
                    LOAD_IRL  = 0;
                    LOAD_AC   = 0;
                    STORE_MEM = 0;
                    state_next = Class2;              
                end
                Class4: begin // STORE
                    FETCH     = 0;
                    INC_PC    = 0;
                    LOAD_PC   = 0;
                    LOAD_IRU  = 0;
                    LOAD_IRL  = 0;
                    LOAD_AC   = 0;
                    STORE_MEM = 1;
                    state_next = PrepU;              
                end
                Class5: begin // Jumps
                    FETCH     = 0;
                    INC_PC    = 0;
                    LOAD_IRU  = 0;
                    LOAD_IRL  = 0;
                    LOAD_AC   = 0;
                    STORE_MEM = 0;
                    // Handle different jump instructions
                    case (opcode)
                        5'h10: LOAD_PC = 1;                      // JUMP
                        5'h11: LOAD_PC = NFLG ? 1 : 0;           // JNEG
                        5'h12: LOAD_PC = (~NFLG) ? 1 : 0;        // JPOSZ
                        5'h13: LOAD_PC = ZFLG ? 1 : 0;           // JZERO
                        5'h14: LOAD_PC = (~ZFLG) ? 1 : 0;        // JNZER
                        default: LOAD_PC = 0;
                    endcase
                    state_next = PrepU;  
                end
                default: begin
                    FETCH     = 0;
                    INC_PC    = 0;
                    LOAD_PC   = 0;
                    LOAD_IRU  = 0;
                    LOAD_IRL  = 0;
                    LOAD_AC   = 0;
                    STORE_MEM = 0;
                    state_next = START;               
                end 
            endcase
        end
    end

    assign STATE = state;

endmodule
