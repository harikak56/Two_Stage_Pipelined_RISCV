
`timescale 1ns / 1ps

module IF (
    input  logic        clk,
    input  logic        reset,

    // Branch and jump control from Stage 2
    input  logic        pc_redirect,
    input  logic [31:0] redirect_target,

    // Outputs to pipeline register
    output logic [31:0] pc_out,
    output logic [31:0] instruction
);

    logic [31:0] next_pc;

    // Select next PC
    assign next_pc = pc_redirect ? redirect_target : pc_out + 32'd4;

    // Program Counter
    pc program_counter (
        .clk     (clk),
        .reset   (reset),
        .next_pc (next_pc),
        .pc_out  (pc_out)
    );

    // Instruction Memory
    instruction_memory instruction_mem (
        .address     (pc_out),
        .instruction (instruction)
    );

endmodule
