
`timescale 1ns / 1ps

module two_stage_riscv (
    input logic clk,
    input logic reset
);

    // IF Stage signals
    logic [31:0] if_pc;
    logic [31:0] if_instruction;

    // Pipeline register outputs
    logic [31:0] stage2_pc;
    logic [31:0] stage2_instruction;

    // Branch and jump signals
    logic        pc_redirect;
    logic [31:0] redirect_target;

    // Pipeline control
    logic flush;
    logic stall;

    assign flush = pc_redirect;
    assign stall = 1'b0;

    // 1. Instruction Fetch Stage
    IF instruction_fetch (
        .clk             (clk),
        .reset           (reset),
        .pc_redirect     (pc_redirect),
        .redirect_target (redirect_target),
        .pc_out          (if_pc),
        .instruction     (if_instruction)
    );

    // 2. IF/ID Pipeline Register
    pipeline_register pipeline_reg (
        .clk             (clk),
        .reset           (reset),
        .flush           (flush),
        .stall           (stall),
        .pc_in           (if_pc),
        .instruction_in  (if_instruction),
        .pc_out          (stage2_pc),
        .instruction_out (stage2_instruction)
    );

    // 3. Instruction Processing Stage
    STAGE2 execution_stage (
        .clk             (clk),
        .reset           (reset),
        .pc_in           (stage2_pc),
        .instruction_in  (stage2_instruction),
        .pc_redirect     (pc_redirect),
        .redirect_target (redirect_target)
    );

endmodule
