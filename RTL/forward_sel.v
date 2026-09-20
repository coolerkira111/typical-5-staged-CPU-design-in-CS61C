module forward_sel(
    input [31:0] inst_ma,
    input [31:0] inst_ex,
    input [31:0] inst_wb,
    input RegWEn_ma,
    input RegWEn_wb,
    output forwardsel_rs1_ma,
    output forwardsel_rs2_ma,
    output forwardsel_rs1_wb,
    output forwardsel_rs2_wb
);
    wire [4:0]inst_ma_rd;
    wire [4:0]inst_ex_rs1;
    wire [4:0]inst_ex_rs2;
    wire [4:0]inst_wb_rd;
    assign inst_ma_rd=inst_ma[11:7];
    assign inst_wb_rd=inst_wb[11:7];
    assign inst_ex_rs1=inst_ex[19:15];
    assign inst_ex_rs2=inst_ex[24:20];
    assign forwardsel_rs1_ma=(inst_ma_rd)?((inst_ma_rd==inst_ex_rs1)&&RegWEn_ma):0;
    assign forwardsel_rs2_ma=(inst_ma_rd)?((inst_ma_rd==inst_ex_rs2)&&RegWEn_ma):0;
    assign forwardsel_rs1_wb=(inst_wb_rd)?((inst_wb_rd==inst_ex_rs1)&&RegWEn_wb):0;
    assign forwardsel_rs2_wb=(inst_wb_rd)?((inst_wb_rd==inst_ex_rs2)&&RegWEn_wb):0;
    endmodule

