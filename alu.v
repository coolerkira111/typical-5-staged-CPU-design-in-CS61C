module alu(
    input [31:0]A,
    input [31:0]B,
    input [3:0] ALU_sel,
    output reg [31:0] alu_ex
);
    reg [63:0] mulresult;
    reg [63:0] signed_mulresult;
    always @(*) begin
        mulresult=A*B;
        signed_mulresult=$signed(A)*$signed(B);
        case(ALU_sel)
            4'b0000: alu_ex=A+B;
            4'b0001: alu_ex=A<<B[4:0];
            4'b0010: alu_ex=($signed(A)<$signed(B));
            4'b0100: alu_ex=A^B;
            4'b0101: alu_ex=A>>B[4:0];
            4'b0110: alu_ex=A|B;
            4'b0111: alu_ex=A&B;
            4'b1000: alu_ex=mulresult[31:0];
            4'b1001: alu_ex=signed_mulresult[63:32];
            4'b1011: alu_ex=mulresult[63:32];
            4'b1100: alu_ex=(A-B);
            4'b1101: alu_ex=$signed(A)>>>B[4:0];
            4'b0011: alu_ex = (A < B) ? 32'd1 : 32'd0;
            4'b1111: alu_ex=B;
        endcase
    end
    endmodule