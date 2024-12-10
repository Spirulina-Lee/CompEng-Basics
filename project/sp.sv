module sp (
    input logic clk,
    input logic reset,
    input logic LOAD_SP,
    input logic SP_INC,
    input logic SP_DEC,
    input logic [7:0] sp_in,   // 来自IRL或其他信号，用于LOAD_SP时
    output logic [7:0] sp_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sp_out <= 8'hFF; // 初始化SP指向内存高地址（示例）
        end else begin
            if (LOAD_SP)
                sp_out <= sp_in;
            else if (SP_INC)
                sp_out <= sp_out + 8'd1;
            else if (SP_DEC)
                sp_out <= sp_out - 8'd1;
            // 如果同时给多个信号为1，需要根据需求调整优先级
        end
    end
endmodule
