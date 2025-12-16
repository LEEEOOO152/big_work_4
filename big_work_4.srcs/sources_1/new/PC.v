module PC(
    input clk,
    input rst,
    input [31:0] npc,
    output reg [31:0] pc
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 32'h0000_3000;
        end else begin
            pc <= npc;
        end
    end
endmodule