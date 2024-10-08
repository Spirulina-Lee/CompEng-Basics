module pc (
    input logic clk,             // 时钟信号
    input logic reset,           // 复位信号，高电平时将PC清零
    input logic load,            // 加载信号，高电平时加载新值到PC
    input logic inc,             // 自增信号，高电平时PC加1
    input logic [7:0] pc_in,     // 加载的新PC值
    output logic [7:0] pc_out    // 当前PC值输出
);

    // PC寄存器行为
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 8'b0;      // 当复位信号有效时，将PC清零
        end
        else if (load) begin
            pc_out <= pc_in;     // 当加载信号有效时，将pc_in值加载到PC
        end
        else if (inc) begin
            pc_out <= pc_out + 1; // 当自增信号有效时，PC加1
        end
    end

endmodule
