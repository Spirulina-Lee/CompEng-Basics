module monitor_tb (input logic [1:0] KEY,
   input logic [0:0] SW,
   output logic [0:0] LEDR);
   monitor monitor_test(KEY[1:0], 
   SW[0],
   LEDR[0]);
endmodule
