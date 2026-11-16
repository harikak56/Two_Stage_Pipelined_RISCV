
`timescale 1ns / 1ps

module pipeline_register (
    input  logic        clk,
    input  logic        reset,

    // Control inputs
    input  logic        flush,
    input  logic        stall,

    // Inputs from IF stage
    input  logic [31:0] pc_in,
    input  logic [31:0] instruction_in,

    // Outputs to Stage 2
    output logic [31:0] pc_out,
    output logic [31:0] instruction_out
);

    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin
            pc_out          <= 32'b0;
            instruction_out <= 32'h00000013;
        end

        else if (flush) begin
            pc_out          <= 32'b0;
            instruction_out <= 32'h00000013;
        end

        else if (!stall) begin
            pc_out          <= pc_in;
            instruction_out <= instruction_in;
        end

    end

endmodule
