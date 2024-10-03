module seg7 (
    input logic [3:0] bin_in,    // 4-bit binary input
    input logic blank,           // Blank control signal
    input logic test,            // Test control signal
    output logic [6:0] seg_out   // 7-bit output for each segment
);

always_comb begin
    if (blank)
        seg_out = 7'b1111111;  // Turn off all segments (common cathode: '1' is off)
    else if (test)
        seg_out = 7'b0000000;  // Turn on all segments (common cathode: '0' is on)
    else
        case(bin_in)
            4'h0: seg_out = 7'b0000001; // '0'
            4'h1: seg_out = 7'b1001111; // '1'
            4'h2: seg_out = 7'b0010010; // '2'
            4'h3: seg_out = 7'b0000110; // '3'
            4'h4: seg_out = 7'b1001100; // '4'
            4'h5: seg_out = 7'b0100100; // '5'
            4'h6: seg_out = 7'b0100000; // '6'
            4'h7: seg_out = 7'b0001111; // '7'
            4'h8: seg_out = 7'b0000000; // '8'
            4'h9: seg_out = 7'b0000100; // '9'
            4'hA: seg_out = 7'b0001000; // 'A'
            4'hB: seg_out = 7'b1100000; // 'B'
            4'hC: seg_out = 7'b0110001; // 'C'
            4'hD: seg_out = 7'b1000010; // 'D'
            4'hE: seg_out = 7'b0110000; // 'E'
            4'hF: seg_out = 7'b0111000; // 'F'
            default: seg_out = 7'b1111111; // Turn off all segments
        endcase
end

endmodule
