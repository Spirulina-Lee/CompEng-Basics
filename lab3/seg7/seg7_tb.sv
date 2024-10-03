module seg7_tb (
    input logic [7:0] SW,        // 8-bit data input from switches SW[7:0]
    input logic blank,           // Blank control signal (active high)
    input logic test,            // Test control signal (active high)
    output logic [6:0] HEX0,     // Output for display HEX0
    output logic [6:0] HEX1,     // Output for display HEX1
    output logic [6:0] HEX2,     // Output for display HEX2
    output logic [6:0] HEX3,     // Output for display HEX3
    output logic [6:0] HEX4,     // Output for display HEX4
    output logic [6:0] HEX5      // Output for display HEX5
);

    // Instantiate three dual_seg7 modules
    dual_seg7 display_unit0 (
        .bin_in(SW),
        .blank(blank),
        .test(test),
        .out1(HEX1),  // Connect to HEX1 (upper nibble)
        .out0(HEX0)   // Connect to HEX0 (lower nibble)
    );

    dual_seg7 display_unit1 (
        .bin_in(SW),
        .blank(blank),
        .test(test),
        .out1(HEX3),  // Connect to HEX3 (upper nibble)
        .out0(HEX2)   // Connect to HEX2 (lower nibble)
    );

    dual_seg7 display_unit2 (
        .bin_in(SW),
        .blank(blank),
        .test(test),
        .out1(HEX5),  // Connect to HEX5 (upper nibble)
        .out0(HEX4)   // Connect to HEX4 (lower nibble)
    );

endmodule
