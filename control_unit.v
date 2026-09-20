module control_unit(
    input [31:0] inst_id,
    input [31:0] inst_ma,
    input BrEq_ma,
    input BrLt_ma,
    output reg pc_sel,
    output reg RegWEn,
    output reg [2:0]ImmSel,
    output reg Asel,
    output reg Bsel,
    output reg [3:0]ALU_sel,
    output reg MemRW,
    output reg [1:0]WBsel,
    output reg BrUn
);
    wire [6:0]opcode;
    wire [2:0]funct3;
    wire [6:0]funct7;
    wire [6:0]inst_ma_opcode;
    wire [2:0]inst_ma_funct3;
    assign opcode=inst_id[6:0];
    assign funct3=inst_id[14:12];
    assign funct7=inst_id[31:25];
    assign inst_ma_opcode=inst_ma[6:0];
    assign inst_ma_funct3=inst_ma[14:12];
    reg branch_taken;
    always @(*) begin
        case(opcode)
            7'b0110011: begin
                RegWEn=1;
                Asel=0;
                Bsel=0;
                MemRW=0;
                WBsel=2'b00;
                case(funct3)
                    3'b000: begin
                        if (funct7 == 7'b0000001)
                            ALU_sel = 4'b1000;       // MUL
                        else if (funct7 == 7'b0100000)
                            ALU_sel = 4'b1100;       // SUB
                        else
                            ALU_sel = 4'b0000;       // ADD
                    end

                    3'b101: begin
                        if (funct7==7'b0000000) begin
                            ALU_sel=4'b0101;
                        end
                        else begin
                            ALU_sel=4'b1101;
                        end
                    end
                    default: ALU_sel={1'b0,funct3};
                endcase
            end

            7'b0010011: begin
                RegWEn=1;
                Asel=0;
                Bsel=1;
                MemRW=0;
                WBsel=2'b00;
                ImmSel=3'b000;
                case(funct3)
                    default: ALU_sel={1'b0,funct3};
                    3'b101: begin
                        if(funct7==7'b0100000) begin
                            ALU_sel=1101;
                        end
                        else begin
                            ALU_sel=0101;
                        end
                    end
                endcase
            end

            7'b0000011: begin
                RegWEn=1;
                Asel=0;
                Bsel=1;
                MemRW=0;
                WBsel=2'b01;
                ImmSel=3'b000;
                ALU_sel=4'b0000;
            end

            7'b0100011: begin
                RegWEn=0;
                Asel=0;
                Bsel=1;
                MemRW=1;
                WBsel=2'b01;
                ImmSel=3'b001;
                ALU_sel=4'b0000;
            end

            7'b1100011: begin
                RegWEn=0;
                Asel=1;
                Bsel=1;
                MemRW=0;
                WBsel=2'b01;
                ImmSel=3'b010;
                ALU_sel=4'b0000;
                BrUn=funct3[1];
            end

            7'b1101111: begin
                RegWEn=1;
                Asel=1;
                Bsel=1;
                MemRW=0;
                WBsel=2'b10;
                ImmSel=3'b100;
                ALU_sel=4'b0000;
            end

            7'b1100111: begin
                RegWEn=1;
                Asel=0;
                Bsel=1;
                MemRW=0;
                WBsel=2'b10;
                ImmSel=3'b000;
                ALU_sel=4'b0000;
            end

            7'b0110111: begin
                RegWEn=1;
                Asel=0;
                Bsel=1;
                MemRW=0;
                WBsel=2'b00;
                ImmSel=3'b011;
                ALU_sel=4'b1111;
            end

            7'b0010111: begin
                RegWEn=1;
                Asel=1;
                Bsel=1;
                MemRW=0;
                WBsel=2'b00;
                ImmSel=3'b011;
                ALU_sel=4'b0000;
            end

            default: begin
                RegWEn=0;
                Asel=0;
                Bsel=0;
                MemRW=0;
                WBsel=2'b00;
                ImmSel=3'b000;
                ALU_sel=4'b0000;
                BrUn=0;
            end
        endcase
        case(inst_ma_opcode)
            7'b1100011: begin
                case(inst_ma_funct3[2])
                    1'b0: branch_taken=(BrEq_ma^inst_ma_funct3[0]);
                    1'b1: branch_taken=(BrLt_ma^inst_ma_funct3[0]);
                endcase
                pc_sel=branch_taken;
            end
            7'b1101111: pc_sel=1;
            7'b1100111: pc_sel=1;
            default: pc_sel=0;
        endcase
    end
    endmodule