module load_stall_unit(
    input [31:0]inst_ex,
    input [31:0]inst_id,
    output load_stall
);
    wire [6:0]inst_ex_opcode;
    wire [6:0]inst_id_opcode;
    wire [4:0]inst_id_rs1;
    wire [4:0]inst_id_rs2;
    wire [4:0]inst_ex_rd;
    assign inst_ex_opcode=inst_ex[6:0];
    assign inst_id_opcode=inst_id[6:0];
    assign inst_id_rs1=inst_id[19:15];
    assign inst_id_rs2=inst_id[24:20];
    assign inst_ex_rd=inst_ex[11:7];
    assign load_stall=(inst_ex_opcode==7'h03)&&((inst_id_rs1==inst_ex_rd)||((inst_id_rs2==inst_ex_rd)&&((inst_id_opcode==7'h33)||(inst_id_opcode==7'h23)||(inst_id_opcode==7'h63))));
endmodule