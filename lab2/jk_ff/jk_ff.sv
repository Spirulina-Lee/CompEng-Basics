module jk_ff (
    input  logic j,
    input  logic k,
    input  logic clk,
    input  logic reset, // 使用低电平有效复位
    output logic q
);
    always_ff @(negedge clk or negedge reset) begin
        if (!reset) begin
            q <= 1'b0;
        end
        else begin
            if (j & ~k) begin
                q <= 1'b1;
            end
            else if (~j & k) begin
                q <= 1'b0;
            end
            else if (j & k) begin
                q <= ~q;
            end
            else begin
                q <= q; // 保持当前状态
            end
        end
    end
endmodule