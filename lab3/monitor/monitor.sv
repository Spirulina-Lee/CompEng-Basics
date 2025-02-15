module monitor (input logic [1:0] push_in,    
		     input logic switch_in, 
                output logic status);
   always @(switch_in, push_in) // could also use always_comb
     if(switch_in & (push_in[0]^push_in[1])) status=1;
	else status =0;
endmodule
