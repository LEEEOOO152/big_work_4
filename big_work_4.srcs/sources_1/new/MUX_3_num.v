module MUX_3_num (
    input [1:0] s_num_write,
    input [4:0] rt,
    input [4:0] rd,

    output reg [4:0] write_to_GPR
);
    always @(*) begin
        case (s_num_write)
            2'b00: write_to_GPR = rt; // ori
            2'b01: write_to_GPR = rd; // addu, subu
            2'b10: write_to_GPR = 5'b11111; // jal
            default: write_to_GPR = 5'bzzzzz; // undefined
        endcase
    end
    
endmodule