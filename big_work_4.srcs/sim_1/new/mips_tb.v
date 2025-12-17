module mips_tb();
    
   reg clk, rst;
    
   mips U_MIPS(
      .clk(clk), .rst(rst)
   );
    
   initial begin
      // 使用绝对路径以确保能找到文件
      $readmemh( "e:/vivado/big_work_4/big_work_4.srcs/sources_1/new/code.txt" , U_MIPS.im_inst.RAM ) ;
      $monitor("PC = 0x%8X, IR = 0x%8X", U_MIPS.pc, U_MIPS.full_instr ); 
      clk = 1 ;
      rst = 0 ;
      #5 ;
      rst = 1 ;
      #20 ;
      rst = 0 ;
   end
   
   always
	   #(50) clk = ~clk;
   
endmodule
