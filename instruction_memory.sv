
`timescale 1ns / 1ps

module instruction_memory #(
    parameter DEPTH = 256
)(
    input  logic [31:0] address,
    output logic [31:0] instruction
);

    // Instruction memory: 256 words, 32 bits each
    logic [31:0] mem [0:DEPTH-1];

    // Convert byte address into word index
    logic [31:0] index;

    assign index = (address - 32'h80000000) >> 2;

    // Initialize memory with NOP instructions
    integer i;

    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = 32'h00000013;
    end

    // Asynchronous instruction read
    always_comb begin
        if (index < DEPTH)
            instruction = mem[index];
        else
            instruction = 32'h00000013;
    end

endmodule
