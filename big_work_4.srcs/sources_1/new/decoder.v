// translate instructions
module decoder (
    input [31:0] inst,

    output reg [1:0] s_npc,
    output reg reg_write,
    output reg [1:0] s_num_write,
    output reg s_b,
    output reg [1:0] alu_op,
    output reg mem_write,
    output reg [1:0] s_data_write
);
    wire [5:0] op;
    wire [5:0] func;

    assign op = inst[31:26];
    assign func = inst[5:0];

    always @(*) begin
        // Default values
        s_npc = 2'b11; 
        reg_write = 1'b0;
        s_num_write = 2'bzz;
        s_b = 1'b0;
        alu_op = 2'bzz;
        mem_write = 1'b0;
        s_data_write = 2'b01;

        case (op)
            6'b000000: begin // R-type
                case (func)
                    6'b100001: begin // addu
                        s_npc = 2'b11;
                        reg_write = 1'b1;
                        s_num_write = 2'b01;
                        s_b = 1'b0;
                        alu_op = 2'b00;
                        mem_write = 1'b0;
                        s_data_write = 2'b01;
                    end
                    6'b100011: begin // subu
                        s_npc = 2'b11;
                        reg_write = 1'b1;
                        s_num_write = 2'b01;
                        s_b = 1'b0;
                        alu_op = 2'b01;
                        mem_write = 1'b0;
                        s_data_write = 2'b01;
                    end
                endcase
            end

            6'b001101: begin // ori
                s_npc = 2'b11;
                reg_write = 1'b1;
                s_num_write = 2'b00;
                s_b = 1'b1;
                alu_op = 2'b10;
                mem_write = 1'b0;
                s_data_write = 2'b01;
            end

            6'b100011: begin // lw
                s_npc = 2'b11;
                reg_write = 1'b1;
                s_num_write = 2'b00;
                s_b = 1'b1;
                alu_op = 2'b11;
                mem_write = 1'b0;
                s_data_write = 2'b10;
            end

            6'b101011: begin // sw
                s_npc = 2'b11;
                reg_write = 1'b0;
                s_num_write = 2'bzz;
                s_b = 1'b1;
                alu_op = 2'b11;
                mem_write = 1'b1;
                s_data_write = 2'b01; // Don't care
            end

            6'b000100: begin // beq
                s_npc = 2'b00;
                reg_write = 1'b0;
                s_num_write = 2'bzz;
                s_b = 1'b0;
                alu_op = 2'bzz;
                mem_write = 1'b0;
                s_data_write = 2'b01;
            end
            
            6'b000011: begin // jal
                s_npc = 2'b10;
                reg_write = 1'b1;
                s_num_write = 2'b10;
                s_b = 1'b0;
                alu_op = 2'bzz;
                mem_write = 1'b0;
                s_data_write = 2'b00;
            end
        endcase
    end
endmodule