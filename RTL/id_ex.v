module id_ex_registers(
    input [31:0]pc_id,
    input [31:0]inst_id,
    input [31:0]Read_Data_1,
    input [31:0]Read_Data_2,
    input [31:0]imm,
    input RegWEn,
    input BrUn,
    input Asel,
    input Bsel,
    input [3:0]ALU_sel,
    input MemRW,
    input [1:0]WBsel,
    input load_stall,
    input bj_flush,
    input reset,
    input clk,
    output reg [31:0]pc_ex,
    output reg [31:0]inst_ex,
    output reg [31:0]rs1_ex,
    output reg [31:0]rs2_ex,
    output reg [31:0]imm_ex,
    output reg RegWEn_ex,
    output reg BrUn_ex,
    output reg Asel_ex,
    output reg Bsel_ex,
    output reg [3:0]ALU_sel_ex,
    output reg MemRW_ex,
    output reg [1:0]WBsel_ex
);
    always @(posedge clk ) begin
        if(bj_flush||reset||load_stall) begin
            pc_ex<=0;
            inst_ex<=0;
            rs1_ex<=0;
            rs2_ex<=0;
            imm_ex<=0;
            RegWEn_ex<=0;
            BrUn_ex<=0;
            Asel_ex<=0;
            Bsel_ex<=0;
            ALU_sel_ex<=0;
            MemRW_ex<=0;
            WBsel_ex<=0;
        end
        else begin
            pc_ex<=pc_id;
            inst_ex<=inst_id;
            rs1_ex<=Read_Data_1;
            rs2_ex<=Read_Data_2;
            imm_ex<=imm;
            RegWEn_ex<=RegWEn;
            BrUn_ex<=BrUn;
            Asel_ex<=Asel;
            Bsel_ex<=Bsel;
            ALU_sel_ex<=ALU_sel;
            MemRW_ex<=MemRW;
            WBsel_ex<=WBsel;
        end
    end
    endmodule