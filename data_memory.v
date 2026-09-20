module data_memory(
    input clk,
    input [31:0]addr,
    input [31:0]write_data,
    input MemRW,
    input [2:0]funct3,
    output reg [31:0]read_data
);
    reg [7:0] data_mem [4095:0];
    always @(*) begin
        case(funct3)
            3'b000: read_data={{24{data_mem[addr][7]}},data_mem[addr]};
            3'b001: read_data={{16{data_mem[addr+1][7]}},data_mem[addr+1],data_mem[addr]};
            3'b010: read_data={data_mem[addr+3],data_mem[addr+2],data_mem[addr+1],data_mem[addr]};
            3'b100: read_data={{24{1'b0}},data_mem[addr]};
            3'b101: read_data={{16{1'b0}},data_mem[addr+1],data_mem[addr]};
        endcase
    end

    always @(posedge clk ) begin
        if (MemRW) begin //need taking care of
            case(funct3)
                3'b000: data_mem[addr]<=write_data[7:0];
                3'b001: {data_mem[addr+1],data_mem[addr]}<=write_data[15:0];
                3'b010: {data_mem[addr+3],data_mem[addr+2],data_mem[addr+1],data_mem[addr]}<=write_data;
            endcase
        end
    end
    endmodule