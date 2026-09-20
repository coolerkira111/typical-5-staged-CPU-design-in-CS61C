module program_counter(
    input clk,
    input [31:0] alu_ma,
    input pc_sel,
    input load_stall,
    input reset,
    input bj_flush,
    input load_stall_ma,
    output reg [31:0] pc_if
);
    wire mux_sel;
    assign mux_sel=pc_sel&&(!load_stall_ma);
    always @(posedge clk) begin
        if (reset) begin
            pc_if<=32'b0;
        end
        else begin
            
            if (load_stall&&!bj_flush) begin
                pc_if<=pc_if;
            end
            else begin
                pc_if<=(mux_sel)?alu_ma:(pc_if+4);
            end
        end
    end
endmodule



