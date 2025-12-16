module ALU (
    input [1:0] alu_op,
    input [31:0] data_1, //rj,from GPR 
    input [31:0] data_2, //rk,from GPR 
    input [11:0] uint_12, // zero-extend
    input [11:0] int_12, // sign-extend

    input s_b,

    output reg [31:0] result,
    output zero
);
    reg [31:0] cal_1; // operand 1,rj
    reg [31:0] cal_2; // operand 2,rk or zero-extend uint_12 to OR
    reg [31:0] cal_3; // sign-extend int_12 to address calculation

    always @(*) begin
        cal_1 = data_1; 
    end

    always @(*) begin
        case (s_b)
            0: cal_2 = data_2;
            1: begin 
                cal_2 = {{20{1'b0}}, uint_12}; // zero-extend 
                cal_3 = {{20{int_12[11]}}, int_12}; // sign-extend
            end

        endcase
    end

    always @(*) begin
        case (alu_op)
            2'b00: result = cal_1 + cal_2; // addu
            2'b01: result = cal_1 - cal_2; // subu
            2'b10: result = cal_1 | cal_2; // ori
            2'b11: result = cal_1 + cal_3; // calculate lw,sw  addr
            default: result = 32'hzzzz_zzzz;
        endcase
    end

    assign zero = (result == 32'b0) ? 1'b1 : 1'b0; // equal then set 1
endmodule