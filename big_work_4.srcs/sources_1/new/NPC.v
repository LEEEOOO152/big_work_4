module NPC(
    input [1:0] s_npc,  // select npc
    input zero, // from ALU zero flag
    input [31:0] pc,
    input [15:0] offs_16, // beq offset
    input [25:0] offs_26, // jump b offset
    input [31:0] reg_addr, // jump register address

    output reg [31:0] npc // next pc
    );
    always @(*) begin
        case (s_npc)
            2'b00: case (zero) // jump if equal
                0: npc = pc + 4; // not equal
                1: npc = pc + {{14{offs_16[15]}}, offs_16, 2'b00}; // equal
            endcase

            2'b01: npc = reg_addr; // Register jump########
            2'b10: npc = pc + {{4{offs_26[25]}}, offs_26, 2'b00}; // jump b,无条件
            2'b11: npc = pc + 4; // normal
            
        endcase
    end
    
endmodule