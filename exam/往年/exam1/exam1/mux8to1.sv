//EE 310 Fundamentals of Computer Engineering
//Assignment: exam1
//Author: Cheng Anzhe
//Module Name: mux8to1
//Module Function: realize 8-to-1 multiplexer 
//**************************************************************************************

//Module Declaration
module mux8to1(input logic [2:0] sel, input logic [7:0] D,input logic en,
               output logic Y);
	
always_comb
if(en==0) Y=0;
else
case(sel)
0:                  Y=D[0];    
1:                  Y=D[1];    
2:                  Y=D[2];    
3:                  Y=D[3];    
4:                  Y=D[4];    
5:                  Y=D[5];    
6:                  Y=D[6];    
7:                  Y=D[7];
default:            Y=0;
endcase    
endmodule