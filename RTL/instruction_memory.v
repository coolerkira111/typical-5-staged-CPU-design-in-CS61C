module instruction_mem(
    input [31:0]pc_if,
    output [31:0]inst_if
);
    reg [31:0] memory [0:1023];
    assign inst_if=memory[pc_if[11:2]];
endmodule
