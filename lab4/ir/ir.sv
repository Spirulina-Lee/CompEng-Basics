module ir (
    input logic clk,            // 时钟信号
    input logic reset,          // 复位信号
    input logic load_iru,       // 加载IRU寄存器控制信号
    input logic load_irl,       // 加载IRL寄存器控制信号
    input logic [7:0] mdr_data, // MDR数据总线输入
    output logic [7:0] ir_upper, // IR上寄存器输出
    output logic [7:0] ir_lower  // IR下寄存器输出
);

    // 寄存器行为描述
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            ir_upper <= 8'b0;   // 复位时，清空上寄存器
            ir_lower <= 8'b0;   // 复位时，清空下寄存器
        end
        else begin
            if (load_iru && !load_irl) begin
                ir_upper <= mdr_data;  // 加载到上寄存器
            end
            else if (load_irl && !load_iru) begin
                ir_lower <= mdr_data;  // 加载到下寄存器
            end
            // 如果load_iru和load_irl都为高电平或低电平，寄存器保持不变
        end
    end

endmodule
