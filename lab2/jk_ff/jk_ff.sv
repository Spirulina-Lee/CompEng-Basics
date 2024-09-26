module jk_ff(
    input j,
    input k,
    input clk,
    input reset,
    output reg q
    );
    always @(posedge clk or posedge reset)
    begin
        if(reset)
            q <= 1'b0;
        else
        begin
            if(j & ~k)
                q <= 1'b1;
            else if(~j & k)
                q <= 1'b0;
        end
    end
endmodule