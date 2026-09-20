module flush_unit(
    input [31:0]inst_ma,
    input load_stall_ma,
    input pc_sel,
    output bj_flush
);
    wire [6:0]inst_ma_opcode;
    assign inst_ma_opcode=inst_ma[6:0];
    wire jump;
    assign jump=(inst_ma_opcode==7'h67)||(inst_ma_opcode==7'h6f);
    assign bj_flush=(jump)||(pc_sel&&!load_stall_ma);
endmodule