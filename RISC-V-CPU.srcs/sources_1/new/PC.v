`timescale 1ns / 1ps

module pc_module(
  input             clk_i,
  input             rst_i,
  
  input      [31:0] imm_I_i,
  input      [31:0] imm_J_i,
  input      [31:0] imm_B_i,
  
  input      [31:0] rf_rd1_i,
  
  input             jal_i,
  input             jalr_i,
  input             branch_i,
  input             alu_flag_i,
  
  output reg [31:0] pc_o
);
  
  wire        cond_jmp = alu_flag_i && branch_i;
  wire        jmp_rel  = jal_i      || cond_jmp;
  
  wire [31:0] jmp_rel_addr = branch_i ? imm_B_i      : imm_J_i;
  wire [31:0] rel_addr     = jmp_rel  ? jmp_rel_addr : 32'd4;
   
  wire [31:0] new_pc_rel   = pc_o       + rel_addr;
  wire [31:0] new_pc_imm   = rf_rd1_i + imm_I_i;
  
  wire [31:0] new_pc = jalr_i ? new_pc_imm : new_pc_rel;
  
  always @( posedge clk_i or posedge rst_i ) begin
    if ( rst_i )
      pc_o <= 32'd0;
    else
      pc_o <= new_pc;
  end

endmodule
