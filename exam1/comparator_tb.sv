module comparator_tb (
    input logic [3:0] SW,       
    output logic [2:0] LEDR,     
    output logic [6:0] HEX0,    
    output logic [6:0] HEX2     
);

    logic A_eq_B, A_lt_B, A_gt_B;  
    logic [1:0] A, B;             

    assign A = SW[3:2];            
    assign B = SW[1:0];            

    comparator comp_inst (
        .A(A), 
        .B(B), 
        .A_eq_B(A_eq_B), 
        .A_lt_B(A_lt_B), 
        .A_gt_B(A_gt_B)
    );

    assign LEDR[2] = A_gt_B;        
    assign LEDR[1] = A_eq_B;        
    assign LEDR[0] = A_lt_B;        

    seg7 display_A (
        .bin_in({2'b00, A}),       
        .blank(1'b0), 
        .test(1'b0), 
        .seg_out(HEX0)             
    );

    seg7 display_B (
        .bin_in({2'b00, B}),       
        .blank(1'b0), 
        .test(1'b0), 
        .seg_out(HEX2)             
    );

endmodule
