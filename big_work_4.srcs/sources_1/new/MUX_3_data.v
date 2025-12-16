// the last MUX_3
module MUX_3_data (
    input [1:0] s_data_write,
    input [31:0] pc_plus_4,
    input [31:0] alu_result,
    input [31:0] data_from_DM,

    output reg [31:0] write_to_GPR
);
    always @(*) begin
        case (s_data_write)
            2'b00: write_to_GPR = pc_plus_4;
            2'b01: write_to_GPR = alu_result;
            2'b10: write_to_GPR = data_from_DM;
            default: write_to_GPR = 32'hzzzz_zzzz;
        endcase
    end
    
endmodule