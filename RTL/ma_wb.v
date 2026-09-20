module ma_wb_register(
    input [31:0]result,
    input [31:0]inst_ma,
    input RegWEn_ma,
    input clk,
    input reset,
    output reg [31:0]result_wb,
    output reg [31:0]inst_wb,
    output reg RegWEn_wb
);
    always @(posedge clk ) begin
        if(reset) begin
            result_wb<=0;
            inst_wb<=0;
            RegWEn_wb<=0;
        end
        else begin
            result_wb<=result;
            inst_wb<=inst_ma;
            RegWEn_wb<=RegWEn_ma;
        end
    end
    endmodule