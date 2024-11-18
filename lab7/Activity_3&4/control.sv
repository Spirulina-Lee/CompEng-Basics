module control (
    input logic [7:0] opcode,
    input logic NFLG,
    input logic ZFLG,
    input logic RESET,
    input logic CLK,
    output logic [2:0] STATE,
    output logic LOAD_AC,
    output logic LOAD_IRU,
    output logic LOAD_IRL,
    output logic LOAD_PC,
    output logic INC_PC,
    output logic FETCH,
    output logic STORE_MEM
);

    typedef enum logic [2:0] {
        Start  = 3'b000,
        PrepU  = 3'b001,
        FetchU = 3'b010,
        PrepL  = 3'b011,
        FetchL = 3'b100
    } STATE_TYPE;

    STATE_TYPE current_state, next_state;

    always_ff @(negedge CLK or posedge RESET) begin
        if (RESET) 
            current_state <= Start; 
        else 
            current_state <= next_state; 
    end

    always_comb begin
        LOAD_AC = 1'b0;
        LOAD_IRU = 1'b0;
        LOAD_IRL = 1'b0;
        LOAD_PC = 1'b0;
        INC_PC = 1'b0;
        FETCH = 1'b0;
        STORE_MEM = 1'b0;

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
                next_state = PrepL;
            end
            PrepL: begin
                FETCH = 1'b1;
                next_state = FetchL;
            end
            FetchL: begin
                LOAD_IRL = 1'b1;
                INC_PC = 1'b1;
                next_state = PrepU;
            end
            default: begin
                next_state = Start;
            end
        endcase
    end

    assign STATE = current_state;

endmodule
