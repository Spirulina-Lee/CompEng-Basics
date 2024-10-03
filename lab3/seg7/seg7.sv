module seg7_tb (
    input logic [9:0] SW,        // 10-bit data input from switches SW[9:0]
    output logic [6:0] HEX0,     // Output for display HEX0
    output logic [6:0] HEX1,     // Output for display HEX1
    output logic [6:0] HEX2,     // Output for display HEX2
    output logic [6:0] HEX3,     // Output for display HEX3
    output logic [6:0] HEX4,     // Output for display HEX4
    output logic [6:0] HEX5      // Output for display HEX5
);

    // Instantiate three dual_seg7 modules
    dual_seg7 display_unit0 (
        .bin_in(SW[7:0]),   // Only the 8 LSB are used for display data
        .blank(SW[8]),      // Blank control signal connected to SW8
        .test(SW[9]),       // Test control signal connected to SW9
        .out1(HEX1),        // Connect to HEX1 (upper nibble)
        .out0(HEX0)         // Connect to HEX0 (lower nibble)
    );

    dual_seg7 display_unit1 (
        .bin_in(SW[7:0]),   // Reuse the same 8 LSB for other displays
        .blank(SW[8]),      // Shared blank signal
        .test(SW[9]),       // Shared test signal
        .out1(HEX3),        // Connect to HEX3 (upper nibble)
        .out0(HEX2)         // Connect to HEX2 (lower nibble)
    );

    dual_seg7 display_unit2 (
        .bin_in(SW[7:0]),   // Consistent data input for uniformity
        .blank(SW[8]),      // Blank affecting all displays equally
        .test(SW[9]),       // Test affecting all displays equally
        .out1(HEX5),        // Connect to HEX5 (upper nibble)
        .out0(HEX4)         // Connect to HEX4 (lower nibble)
    );

endmodule
