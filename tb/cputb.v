`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2026 05:12:04 AM
// Design Name: 
// Module Name: cputb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cputb(
    );
    reg clk;
    reg reset;

    wire [31:0] imem_addr;
    wire [31:0] imem_rdata;

    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    wire        dmem_we;
    wire [2:0]  dmem_funct3;
    wire [31:0] dmem_rdata;
    integer i;
    cpu dut (
        .clk         (clk),
        .reset       (reset),

        .imem_addr   (imem_addr),
        .imem_rdata  (imem_rdata),

        .dmem_addr   (dmem_addr),
        .dmem_wdata  (dmem_wdata),
        .dmem_we     (dmem_we),
        .dmem_funct3 (dmem_funct3),
        .dmem_rdata  (dmem_rdata)
    );
    instruction_mem u_imem (
    .pc_if   (imem_addr),
    .inst_if (imem_rdata)
    );
    data_memory u_dmem (
    .clk        (clk),
    .addr       (dmem_addr),
    .write_data (dmem_wdata),
    .MemRW      (dmem_we),
    .funct3     (dmem_funct3),
    .read_data  (dmem_rdata)
    );
    initial begin
        for (i=0;i<1024;i=i+1) begin
            u_imem.memory[i] = 32'h00000013;
        end
        for (i = 0; i < 4096; i = i + 1) begin
            u_dmem.data_mem[i] = 8'h00;
        end
        u_imem.memory[0] = 32'h00500093; // addi x1, x0, 5
        u_imem.memory[1] = 32'h00700113; // addi x2, x0, 7
        u_imem.memory[2] = 32'h002081b3; // add  x3, x1, x2
        u_imem.memory[3] = 32'h00302023; // sw x3, 0(x0)
        u_imem.memory[4] = 32'h00002203; // lw x4, 0(x0)
        u_imem.memory[5] = 32'h001202b3; // add x5, x4, x1
    end
    initial begin
        @(negedge reset);
        repeat (20) @(posedge clk);
        #1;
        $display("x1 = %0d", dut.u_Reg_file.registers[1]);
        $display("x2 = %0d", dut.u_Reg_file.registers[2]);
        $display("x3 = %0d", dut.u_Reg_file.registers[3]);
        $display("x4 = %0d", dut.u_Reg_file.registers[4]);
        $display("x5 = %0d", dut.u_Reg_file.registers[5]);
    end




    initial begin
        clk=1'b0;
        forever begin
            #5;
            clk=~clk;
        end
    end
    initial begin
        reset=1'b1;
        forever begin
            repeat (3) @(posedge clk);
            @(negedge clk);
            reset=1'b0;
        end
    end

endmodule
