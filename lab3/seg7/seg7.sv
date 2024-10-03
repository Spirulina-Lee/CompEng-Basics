module seg7 (
    input logic [3:0] bin_in,    // 4-bit binary input
    input logic blank,           // Blank control signal (active high)
    input logic test,            // Test control signal (active high)
    output logic [6:0] seg_out   // 7-bit output for each segment
);

always_comb begin
    if (blank)
        seg_out = 7'b1111111;  // Turn off all segments (0 to light up, high to turn off)
    else if (test)
        seg_out = 7'b0000000;  // Turn on all segments
    else
        case(bin_in)  // Select output based on input value
            4'h0: seg_out = 7'b1000000; // '0'
            4'h1: seg_out = 7'b1111001; // '1'
            4'h2: seg_out = 7'b0100100; // '2'
            4'h3: seg_out = 7'b0110000; // '3'
            4'h4: seg_out = 7'b0011001; // '4'
            4'h5: seg_out = 7'b0010010; // '5'
            4'h6: seg_out = 7'b0000010; // '6'
            4'h7: seg_out = 7'b1111000; // '7'
            4'h8: seg_out = 7'b0000000; // '8'
            4'h9: seg_out = 7'b0010000; // '9'
            4'hA: seg_out = 7'b0100000; // 'A'
            4'hB: seg_out = 7'b0000011; // 'B'
            4'hC: seg_out = 7'b0100111; // 'C'
            4'hD: seg_out = 7'b0100001; // 'D'
            4'hE: seg_out = 7'b0000100; // 'E'
            4'hF: seg_out = 7'b0001110; // 'F'
        endcase
end

endmodule
