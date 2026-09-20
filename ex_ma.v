module ex_ma_registers(
    input [31:0]pc_ex,
    input [31:0]inst_ex,
    input [31:0]alu_ex,
    input [31:0]rs2_ex,
    input RegWEn_ex,
    input BrEq,
    input BrLt,
    input load_stall,
    input MemRW_ex,
    input [1:0]WBsel_ex,
    input clk,
    input reset,
    input bj_flush,
    output reg [31:0]pc_ma,
    output reg [31:0]inst_ma,
    output reg [31:0]alu_ma,
    output reg [31:0]rs2_ma,
    output reg RegWEn_ma,
    output reg BrEq_ma,
    output reg BrLt_ma,
    output reg load_stall_ma,
    output reg MemRW_ma,
    output reg [1:0]WBsel_ma
);
    always @(posedge clk ) begin
        if (reset||bj_flush) begin
            pc_ma<=0;
            inst_ma<=0;
            alu_ma<=0;
            rs2_ma<=0;
            RegWEn_ma<=0;
            BrEq_ma<=0;
            BrLt_ma<=0;
            load_stall_ma<=0;
            MemRW_ma<=0;
            WBsel_ma<=0;
        end
        else begin
            pc_ma<=pc_ex;
            inst_ma<=inst_ex;
            alu_ma<=alu_ex;
            rs2_ma<=rs2_ex;
            RegWEn_ma<=RegWEn_ex;
            BrEq_ma<=BrEq;
            BrLt_ma<=BrLt;
            load_stall_ma<=load_stall;
            MemRW_ma<=MemRW_ex;
            WBsel_ma<=WBsel_ex;
        end
    end
    endmodule