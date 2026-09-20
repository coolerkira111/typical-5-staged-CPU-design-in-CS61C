module branch_comp(
    input [31:0]rs1_forwarded,
    input [31:0]rs2_forwarded,
    input BrUn,
    output reg BrEq,
    output reg BrLt
);
    always @(*) begin
        case(BrUn)
            1'b0: begin
                BrEq=(rs1_forwarded==rs2_forwarded);
                BrLt=($signed(rs1_forwarded)<$signed(rs2_forwarded));
            end
            1'b1: begin
                BrEq=(rs1_forwarded==rs2_forwarded);
                BrLt=(rs1_forwarded<rs2_forwarded);
            end
        endcase
    end
    endmodule