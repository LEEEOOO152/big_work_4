module mips(
    input clk,
    input rst
    );
    
    // decoder wires
    wire [31:0] full_instr;
    wire [1:0] s_npc;
    wire reg_write;
    wire [1:0] s_num_write;
    wire s_b;
    wire [1:0] alu_op;
    wire mem_write;
    wire [1:0] s_data_write;
    // NPC wires
    wire zero;
    wire [31:0] pc;
    wire [31:0] npc;
    // PC wires (all done)
    // GPR wires
    wire [4:0] W_addr;
    wire [31:0] W_data ;
    wire [31:0] R_data_1;
    wire [31:0] R_data_2;
    // ALU wires
    wire [31:0] data_1 = R_data_1;// from GPR
    wire [31:0] data_2 = R_data_2;// from GPR
    wire [31:0] result;
    // DM wires
    wire [11:2] addr_dm = result[11:2];//#################
    wire [31:0] W_data_dm = R_data_2;
    wire [31:0] R_data_dm;
    // IM wires
    wire [11:2] addr_im = pc[11:2];
    // MUX_3_data wires
    wire [31:0] pc_plus_4 = pc + 4;
    wire [31:0] alu_result = result;
    wire [31:0] write_to_GPR;
    assign W_data = write_to_GPR;
    // MUX_3_num wires
    
    // modules instantiation
    PC pc_inst(.clk(clk), .rst(rst), .npc(npc), .pc(pc));
    NPC npc_inst(.s_npc(s_npc), .zero(zero), .pc(pc), .offs_16(full_instr[15:0]), .offs_26(full_instr[25:0]), .reg_addr(R_data_1), .npc(npc));
    IM im_inst(.addr(addr_im), .instr(full_instr));
    decoder decoder_inst(.inst(full_instr), .s_npc(s_npc), .reg_write(reg_write), .s_num_write(s_num_write), .s_b(s_b), .alu_op(alu_op), .mem_write(mem_write), .s_data_write(s_data_write));
    GPR gpr_inst( .clk(clk), .reg_write(reg_write),  .R_addr_1(full_instr[25:21]), .R_addr_2(full_instr[20:16]), .W_addr(W_addr), .W_data(W_data), .R_data_1(R_data_1), .R_data_2(R_data_2));
    ALU alu_inst(.alu_op(alu_op), .data_1(data_1), .data_2(data_2),.uint_16(full_instr[15:0]),.int_16(full_instr[15:0]) ,.s_b(s_b),.zero(zero), .result(result));
    DM dm_inst(.clk(clk), .addr(addr_dm), .W_data(W_data_dm), .mem_write(mem_write), .R_data(R_data_dm));
    MUX_3_data mux_3_data_inst(.s_data_write(s_data_write), .pc_plus_4(pc_plus_4), .alu_result(alu_result), .data_from_DM(R_data_dm), .write_to_GPR(write_to_GPR));
    MUX_3_num mux_3_num_inst(.s_num_write(s_num_write), .rt(full_instr[20:16]), .rd(full_instr[15:11]), .write_to_GPR(W_addr));

endmodule
