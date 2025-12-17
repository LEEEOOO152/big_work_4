// translate instructions
module decoder (
    input [31:0] inst,

    output [1:0] s_npc,
    output reg_write,
    output [1:0] s_num_write,
    output s_b,
    output [1:0] alu_op,
    output mem_write,
    output [1:0] s_data_write
);
    wire [5:0] op;
    wire [5:0] func;

    assign op = inst[31:26];
    assign func = inst[5:0];

    // NPC control
    assign s_npc = (op == 6'b000100) ? 2'b00 : // beq
                   (op == 6'b000011) ? 2'b10 : // jal
                     2'b11; // normal,先不管reg_addr

    // GPR control
    assign reg_write = (op == 6'b000011) ? 1'b1 : // jal , write pc + 4 to GPR
                       (op == 6'b000100) ? 1'b0 : // beq no write
                       (op == 6'b101011) ? 1'b0 : // sw no write
                       (op == 6'b100011) ? 1'b1 : // lw write
                       (op == 6'b000000) ? 1'b1 : // addu, subu write
                       (op == 6'b001101) ? 1'b1 : // ori , write to rt
                         1'b0; // default no write

    // s_sum_write
    assign s_num_write = (op == 6'b000000) ? 2'b01 : // addu,subu
                        (op == 6'b001101 || op == 6'b100011) ? 2'b00 : // ori, lw , write to rt
                         (op == 6'b000011) ? 2'b10 :// jal , write to gpr[31]
                         2'bzz; // illegal

    // s_b
    assign s_b = (op == 6'b101011 || op == 6'b100011 || op == 6'b001101) ? 1'b1 :  // sw,lw,ori ,ALU 接收来自extended imm
                    1'b0;      // 正常就读取gpr的data_2
    // alu_op
    assign alu_op = (op == 6'b000000 && func == 6'b100001) ? 2'b00 : // addu
                     (op == 6'b000000 && func == 6'b100011) ? 2'b01 : // subu
                     (op == 6'b001101) ? 2'b10 : // ori
                     (op == 6'b101011 || op == 6'b100011) ? 2'b11 : // sw,lw address calculate
                      2'bzz; // illegal

    // mem_write
    assign mem_write = (op == 6'b101011) ? 1'b1 : // sw
                       1'b0; // default no write

    // s_data_write
    assign s_data_write = (op == 6'b000011) ? 2'b00 : // jal , write pc + 4 to GPR
                          (op == 6'b100011) ? 2'b10 : // lw , write data from DM to GPR
                           2'b01; // default: alu_result to GPR
endmodule