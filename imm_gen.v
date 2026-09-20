module imm_gen(
    input [31:0]inst_id,
    input [2:0]ImmSel,
    output reg [31:0]imm
);
    always @(*) begin
        case(ImmSel)
            3'b000: imm={{20{inst_id[31]}},inst_id[31:20]};
            3'b001: imm={{20{inst_id[31]}}, inst_id[31:25], inst_id[11:7]};
            3'b010: imm={{19{inst_id[31]}}, inst_id[31], inst_id[7], inst_id[30:25], inst_id[11:8], 1'b0};
            3'b011: imm={inst_id[31:12], 12'b0};
            3'b100: imm={{11{inst_id[31]}}, inst_id[31], inst_id[19:12], inst_id[20], inst_id[30:21], 1'b0};
        endcase
    end
    endmodule
    