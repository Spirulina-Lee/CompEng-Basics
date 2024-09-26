module and2in_tb(input logic [1:0] SW, output logic [0:0] LEDR);
     and2in and2in_1(.a(SW[0]), .b(SW [1]), .y(LEDR[0]));
endmodule