
`timescale 1ns / 1ps

module tb_two_stage_riscv;

    logic clk;
    logic reset;

    // DUT
    two_stage_riscv dut (
        .clk   (clk),
        .reset (reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin

        reset = 1;

        // Initialize instruction memory
        dut.instruction_fetch.instruction_mem.mem[0] = 32'h00500093; // ADDI x1, x0, 5
        dut.instruction_fetch.instruction_mem.mem[1] = 32'h00A00113; // ADDI x2, x0, 10
        dut.instruction_fetch.instruction_mem.mem[2] = 32'h002081B3; // ADD x3, x1, x2
        dut.instruction_fetch.instruction_mem.mem[3] = 32'h00302023; // SW x3, 0(x0)
        dut.instruction_fetch.instruction_mem.mem[4] = 32'h00002203; // LW x4, 0(x0)
        dut.instruction_fetch.instruction_mem.mem[5] = 32'h00120293; // ADDI x5, x4, 1

        // Hold reset
        repeat (2) @(posedge clk);
        #1 reset = 0;

        // Allow instructions to execute
        repeat (20) @(posedge clk);
        #1;

        // Display results
        $display("--------------------------------");
        $display(" RISC-V PROCESSOR TEST RESULTS");
        $display("--------------------------------");

        $display("x1 = %0d", dut.execution_stage.registers.rf[1]);
        $display("x2 = %0d", dut.execution_stage.registers.rf[2]);
        $display("x3 = %0d", dut.execution_stage.registers.rf[3]);
        $display("x4 = %0d", dut.execution_stage.registers.rf[4]);
        $display("x5 = %0d", dut.execution_stage.registers.rf[5]);

        $display("Memory[0] = %0d",
                 dut.execution_stage.memory.mem[0]);

        $display("--------------------------------");

        $finish;

    end

endmodule
