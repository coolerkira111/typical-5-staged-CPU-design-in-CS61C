module if_id_registers(
    input [31:0]pc_if,
    input [31:0]inst_if,
    input load_stall,
    input bj_flush,
    input clk,
    input reset,
    output reg [31:0]pc_id,
    output reg [31:0]inst_id
);
    always @(posedge clk ) begin
        if (bj_flush||reset) begin
            pc_id<=0;
            inst_id<=0;
        end
        else begin
            if (!load_stall) begin
                pc_id<=pc_if;
                inst_id<=inst_if;
            end
            else begin
                pc_id<=pc_id;
                inst_id<=inst_id;
            end
        end
    end
    endmodule