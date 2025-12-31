module mips(
    input clk,
    input rst
    );
    
    // decoder wires 
    (* DONT_TOUCH = "TRUE" *) wire [1:0] s_npc;
    (* DONT_TOUCH = "TRUE" *) wire [31:0] full_instr;
    (* DONT_TOUCH = "TRUE" *) wire reg_write;
    (* DONT_TOUCH = "TRUE" *) wire [1:0] s_num_write;
    (* DONT_TOUCH = "TRUE" *) wire s_b;
    (* DONT_TOUCH = "TRUE" *) wire [1:0] alu_op;
    (* DONT_TOUCH = "TRUE" *) wire mem_write;
    (* DONT_TOUCH = "TRUE" *) wire [1:0] s_data_write;
    // NPC wires
    (* DONT_TOUCH = "TRUE" *) wire zero;
    (* DONT_TOUCH = "TRUE" *) wire [31:0] pc;
    (* DONT_TOUCH = "TRUE" *) wire [31:0] npc;
    // PC wires (all done)
    // GPR wires
    (* DONT_TOUCH = "TRUE" *)wire [4:0] W_addr;
    (* DONT_TOUCH = "TRUE" *)wire [31:0] W_data ;
    (* DONT_TOUCH = "TRUE" *)wire [31:0] R_data_1;
    (* DONT_TOUCH = "TRUE" *)wire [31:0] R_data_2;
    // ALU wires
    (* DONT_TOUCH = "TRUE" *)wire [31:0] data_1 = R_data_1;// from GPR
    (* DONT_TOUCH = "TRUE" *)wire [31:0] data_2 = R_data_2;// from GPR
    (* DONT_TOUCH = "TRUE" *)wire [31:0] result;
    // DM wires
    (* DONT_TOUCH = "TRUE" *)wire [11:2] addr_dm = result[11:2];
    (* DONT_TOUCH = "TRUE" *)wire [31:0] W_data_dm = R_data_2;
    (* DONT_TOUCH = "TRUE" *)wire [31:0] R_data_dm;
    // IM wires
    (* DONT_TOUCH = "TRUE" *)wire [11:2] addr_im = pc[11:2];
    // MUX_3_data wires
    (* DONT_TOUCH = "TRUE" *) wire [31:0] pc_plus_4 = pc + 4;
    (* DONT_TOUCH = "TRUE" *) wire [31:0] alu_result = result;
    (* DONT_TOUCH = "TRUE" *) wire [31:0] write_to_GPR;
    assign W_data = write_to_GPR;
    
    (* DONT_TOUCH = "TRUE" *) wire [4:0] ins_20_16 = full_instr[20:16];
    (* DONT_TOUCH = "TRUE" *) wire [4:0] ins_25_21 = full_instr[25:21];
    (* DONT_TOUCH = "TRUE" *) wire [4:0] ins_15_11 = full_instr[15:11];
    (* DONT_TOUCH = "TRUE" *) wire [15:0] ins_15_0 = full_instr[15:0];
    (* DONT_TOUCH = "TRUE" *) wire [25:0] ins_25_0 = full_instr[25:0];

    

    // modules instantiation
    PC pc_inst(.clk(clk), .rst(rst), .npc(npc), .pc(pc));
    NPC npc_inst(.s_npc(s_npc), .zero(zero), .pc(pc), .offs_16(ins_15_0), .offs_26(ins_25_0), .reg_addr(R_data_1), .npc(npc));
    IM im_inst(.addr(addr_im), .instr(full_instr));
    decoder decoder_inst(.inst(full_instr), .s_npc(s_npc), .reg_write(reg_write), .s_num_write(s_num_write), .s_b(s_b), .alu_op(alu_op), .mem_write(mem_write), .s_data_write(s_data_write));
    GPR gpr_inst( .clk(clk),.rst(rst), .reg_write(reg_write),  .R_addr_1(ins_25_21), .R_addr_2(ins_20_16), .W_addr(W_addr), .W_data(W_data), .R_data_1(R_data_1), .R_data_2(R_data_2));
    ALU alu_inst(.alu_op(alu_op), .data_1(data_1), .data_2(data_2),.uint_16(ins_15_0),.int_16(ins_15_0) ,.s_b(s_b),.zero(zero), .result(result));
    DM dm_inst(.clk(clk), .addr(addr_dm), .W_data(W_data_dm), .mem_write(mem_write), .R_data(R_data_dm));
    MUX_3_data mux_3_data_inst(.s_data_write(s_data_write), .pc_plus_4(pc_plus_4), .alu_result(alu_result), .data_from_DM(R_data_dm), .write_to_GPR(write_to_GPR));
    MUX_3_num mux_3_num_inst(.s_num_write(s_num_write), .rt(ins_20_16), .rd(ins_15_11), .write_to_GPR(W_addr));

endmodule
