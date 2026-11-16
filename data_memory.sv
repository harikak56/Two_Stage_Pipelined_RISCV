
`timescale 1ns / 1ps

module data_memory #(
    parameter DEPTH = 256
)(
    input  logic        clk,
    input  logic        reset,

    input  logic        mem_read,
    input  logic        mem_write,

    input  logic [31:0] address,
    input  logic [31:0] write_data,

    output logic [31:0] read_data
);

    logic [31:0] mem [0:DEPTH-1];

    integer i;

    // Initialize memory
    always_ff @(posedge clk or posedge reset) begin

        if (reset) begin
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= 32'b0;
        end

        else if (mem_write && (address[9:2] < DEPTH)) begin
            mem[address[9:2]] <= write_data;
        end

    end

    // Asynchronous memory read
    always_comb begin

        if (mem_read && (address[9:2] < DEPTH))
            read_data = mem[address[9:2]];
        else
            read_data = 32'b0;

    end

endmodule
