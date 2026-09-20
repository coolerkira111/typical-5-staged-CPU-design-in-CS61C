module cpu (
    input  clk,
    input  reset,

    // Instruction Memory
    output [31:0] imem_addr,
    input  [31:0] imem_rdata,

    // Data Memory
    output [31:0] dmem_addr,
    output [31:0] dmem_wdata,
    output        dmem_we,
    output [2:0]  dmem_funct3,
    input  [31:0] dmem_rdata
);

    wire [31:0] pc_if, inst_if;
    wire [31:0] pc_id, inst_id, imm;
    wire [31:0] Read_Data_1, Read_Data_2;
    wire [4:0] inst_id_rs1, inst_id_rs2, inst_wb_rd;
    wire [2:0] ImmSel;
    wire RegWEn, BrUn, Asel, Bsel, MemRW;
    wire [3:0] ALU_sel;
    wire [1:0] WBsel;

    wire [31:0] pc_ex, inst_ex, rs1_ex, rs2_ex, imm_ex;
    wire RegWEn_ex, BrUn_ex, Asel_ex, Bsel_ex, MemRW_ex;
    wire [3:0] ALU_sel_ex;
    wire [1:0] WBsel_ex;
    wire [31:0] rs1_forwarded, rs2_forwarded, A, B, alu_ex;
    wire BrEq, BrLt;

    wire [31:0] pc_ma, inst_ma, alu_ma, rs2_ma;
    wire RegWEn_ma, BrEq_ma, BrLt_ma, MemRW_ma;
    wire [1:0] WBsel_ma;
    wire [31:0] read_data, result;

    wire [31:0] result_wb, inst_wb;
    wire RegWEn_wb;
    wire forwardsel_rs1_ma, forwardsel_rs2_ma;
    wire forwardsel_rs1_wb, forwardsel_rs2_wb;
    wire pc_sel, load_stall, load_stall_ma, bj_flush;

    program_counter u_program_counter(
        .clk           (clk           ),
        .alu_ma        (alu_ma        ),
        .pc_sel        (pc_sel        ),
        .load_stall    (load_stall    ),
        .reset         (reset),
        .bj_flush      (bj_flush),
        .load_stall_ma (load_stall_ma ),
        .pc_if         (pc_if         )
    );
    assign imem_addr=pc_if;
    assign inst_if=imem_rdata;
    if_id_registers u_if_id_registers(
        .pc_if      (pc_if      ),
        .inst_if    (inst_if    ),
        .load_stall (load_stall ),
        .bj_flush   (bj_flush   ),
        .clk        (clk        ),
        .reset      (reset      ),
        .pc_id      (pc_id      ),
        .inst_id    (inst_id    )
    );


    imm_gen u_imm_gen(
        .inst_id (inst_id ),
        .ImmSel  (ImmSel  ),
        .imm     (imm     )
    );
    
    control_unit u_control_unit(
        .inst_id (inst_id ),
        .inst_ma (inst_ma ),
        .BrEq_ma (BrEq_ma ),
        .BrLt_ma (BrLt_ma ),
        .pc_sel  (pc_sel  ),
        .RegWEn  (RegWEn  ),
        .ImmSel  (ImmSel  ),
        .Asel    (Asel    ),
        .Bsel    (Bsel    ),
        .ALU_sel (ALU_sel ),
        .MemRW   (MemRW   ),
        .WBsel   (WBsel   ),
        .BrUn    (BrUn)
    );
    assign inst_id_rs1=inst_id[19:15];
    assign inst_id_rs2=inst_id[24:20];
    assign inst_wb_rd=inst_wb[11:7];
    Reg_file u_Reg_file(
        .rs1         (inst_id_rs1 ),
        .rs2         (inst_id_rs2 ),
        .rd          (inst_wb_rd  ),
        .Write_Data  (result_wb   ),
        .RegWEn      (RegWEn_wb   ),
        .clk         (clk         ),
        .reset       (reset),
        .Read_Data_1 (Read_Data_1 ),
        .Read_Data_2 (Read_Data_2 )
    );

    id_ex_registers u_id_ex_registers(
        .pc_id       (pc_id       ),
        .inst_id     (inst_id     ),
        .Read_Data_1 (Read_Data_1 ),
        .Read_Data_2 (Read_Data_2 ),
        .imm         (imm         ),
        .RegWEn      (RegWEn      ),
        .BrUn        (BrUn        ),
        .Asel        (Asel        ),
        .Bsel        (Bsel        ),
        .ALU_sel     (ALU_sel     ),
        .MemRW       (MemRW       ),
        .WBsel       (WBsel       ),
        .load_stall  (load_stall  ),
        .bj_flush    (bj_flush    ),
        .reset       (reset       ),
        .clk         (clk         ),
        .pc_ex       (pc_ex       ),
        .inst_ex     (inst_ex     ),
        .rs1_ex      (rs1_ex      ),
        .rs2_ex      (rs2_ex      ),
        .imm_ex      (imm_ex      ),
        .RegWEn_ex   (RegWEn_ex   ),
        .BrUn_ex     (BrUn_ex     ),
        .Asel_ex     (Asel_ex     ),
        .Bsel_ex     (Bsel_ex     ),
        .ALU_sel_ex  (ALU_sel_ex  ),
        .MemRW_ex    (MemRW_ex    ),
        .WBsel_ex    (WBsel_ex    )
    );

    branch_comp u_branch_comp(
        .rs1_forwarded (rs1_forwarded ),
        .rs2_forwarded (rs2_forwarded ),
        .BrUn          (BrUn_ex       ),
        .BrEq          (BrEq          ),
        .BrLt          (BrLt          )
    );
    assign rs1_forwarded=(forwardsel_rs1_ma)?alu_ma:((forwardsel_rs1_wb)?result_wb:rs1_ex);
    assign rs2_forwarded=(forwardsel_rs2_ma)?alu_ma:((forwardsel_rs2_wb)?result_wb:rs2_ex);
    assign A=(Asel_ex)?pc_ex:rs1_forwarded;
    assign B=(Bsel_ex)?imm_ex:rs2_forwarded;
    alu u_alu(
        .A       (A       ),
        .B       (B       ),
        .ALU_sel (ALU_sel_ex),
        .alu_ex  (alu_ex  )
    );
    
    ex_ma_registers u_ex_ma_registers(
        .pc_ex         (pc_ex         ),
        .inst_ex       (inst_ex       ),
        .alu_ex        (alu_ex        ),
        .rs2_ex        (rs2_forwarded ),
        .RegWEn_ex     (RegWEn_ex     ),
        .BrEq          (BrEq          ),
        .BrLt          (BrLt          ),
        .load_stall    (load_stall    ),
        .MemRW_ex      (MemRW_ex      ),
        .WBsel_ex      (WBsel_ex      ),
        .clk           (clk           ),
        .bj_flush     (bj_flush),
        .reset         (reset         ),
        .pc_ma         (pc_ma         ),
        .inst_ma       (inst_ma       ),
        .alu_ma        (alu_ma        ),
        .rs2_ma        (rs2_ma        ),
        .RegWEn_ma     (RegWEn_ma     ),
        .BrEq_ma       (BrEq_ma       ),
        .BrLt_ma       (BrLt_ma       ),
        .load_stall_ma (load_stall_ma ),
        .MemRW_ma      (MemRW_ma      ),
        .WBsel_ma      (WBsel_ma      )
    );
    assign result=(WBsel_ma[1])?(pc_ma+4):((!WBsel_ma[0])?alu_ma:read_data);
    assign dmem_addr=alu_ma;
    assign dmem_wdata=rs2_ma;
    assign read_data=dmem_rdata;
    assign dmem_we=MemRW_ma;
    assign dmem_funct3=inst_ma[14:12];
    ma_wb_register u_ma_wb_register(
        .result    (result    ),
        .inst_ma   (inst_ma   ),
        .RegWEn_ma (RegWEn_ma ),
        .clk       (clk       ),
        .reset     (reset     ),
        .result_wb (result_wb ),
        .inst_wb   (inst_wb   ),
        .RegWEn_wb (RegWEn_wb )
    );

    forward_sel u_forward_sel(
        .inst_ma           (inst_ma           ),
        .inst_ex           (inst_ex           ),
        .inst_wb           (inst_wb           ),
        .RegWEn_ma         (RegWEn_ma         ),
        .RegWEn_wb         (RegWEn_wb         ),
        .forwardsel_rs1_ma (forwardsel_rs1_ma ),
        .forwardsel_rs2_ma (forwardsel_rs2_ma ),
        .forwardsel_rs1_wb (forwardsel_rs1_wb ),
        .forwardsel_rs2_wb (forwardsel_rs2_wb )
    );

    flush_unit u_flush_unit(
        .inst_ma       (inst_ma       ),
        .load_stall_ma (load_stall_ma ),
        .pc_sel        (pc_sel        ),
        .bj_flush      (bj_flush      )
    );

    load_stall_unit u_load_stall_unit(
        .inst_ex    (inst_ex    ),
        .inst_id    (inst_id    ),
        .load_stall (load_stall )
    );
endmodule
    
    
    
    
    
    
    
    
    
    

