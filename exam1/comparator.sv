module comparator (
    input logic [1:0] A,      
    input logic [1:0] B,     
    output logic A_eq_B,      
    output logic A_lt_B,     
    output logic A_gt_B        
);

    always_comb begin
        A_eq_B = (A == B);     
        A_lt_B = (A < B);       
        A_gt_B = (A > B);       
    end

endmodule
