module Reg_file(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] Write_Data,
    input RegWEn,
    input clk,
    input reset,
    output reg [31:0]Read_Data_1,
    output reg [31:0]Read_Data_2
);
    reg [31:0] registers [31:0];
    integer i;
    always @(*) begin
        Read_Data_1=((rd==rs1)&&RegWEn&&rs1)?Write_Data:((rs1)?registers[rs1]:0);
        Read_Data_2=((rd==rs2)&&RegWEn&&rs2)?Write_Data:((rs2)?registers[rs2]:0);
    end

    always @(posedge clk ) begin

        if (reset) begin
            for(i=0;i<32;i=i+1) begin
                registers[i]<=0;
            end
        end
        else begin
            if (RegWEn) begin
                if (rd) begin
                    registers[rd]<=Write_Data;
                end
            end
        end
    end
    endmodule