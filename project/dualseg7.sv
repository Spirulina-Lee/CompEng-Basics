/*
	name:Xiangyu Dou
	Lab Number:Lab3
	module name : dualseg7
	function: This is instantiated using the seg7 module
*/
module dualseg7 (input logic blank, test,
	             input logic [7:0] datain,
	             
				 output logic [6:0] disp0, disp1);
				 
     seg7 leftdisp (blank, test, datain[7:4], disp1);
     seg7 rightdisp (blank,test, datain[3:0], disp0);
	 
endmodule
