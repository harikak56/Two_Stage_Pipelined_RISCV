
`timescale 1ns / 1ps

module STAGE2 (
    input  logic        clk,
    input  logic        reset,

    input  logic [31:0] pc_in,
    input  logic [31:0] instruction_in,

    // Branch and jump outputs to IF stage
    output logic        pc_redirect,
    output logic [31:0] redirect_target
);

    // Decoded instruction signals
    logic [4:0] rs1, rs2, rd;
    logic [6:0] opcode, fn7;
    logic [2:0] fn3;

    // Immediate
    logic [31:0] imm_out;

    // Register file
    logic [31:0] rs1_data, rs2_data;
    logic [31:0] wb_data;

    // Control signals
    logic reg_write, alu_src;
    logic mem_read, mem_write, mem_to_reg;
    logic branch, jump, jalr, lui, auipc;
    logic [1:0] alu_op;

    // ALU signals
    logic [3:0] alu_ctrl;
    logic [31:0] alu_a, alu_b;
    logic [31:0] alu_result;
    logic zero, less_than;

    // Memory
    logic [31:0] mem_data;

    // Branch
    logic branch_taken;

    // 1. Instruction Decoder
    instruction_decoder decoder (
        .instruction (instruction_in),
        .rs1         (rs1),
        .rs2         (rs2),
        .rd          (rd),
        .opcode      (opcode),
        .fn3         (fn3),
        .fn7         (fn7)
    );

    // 2. Main Control Unit
    control_unit control (
        .opcode      (opcode),
        .reg_write   (reg_write),
        .alu_src     (alu_src),
        .mem_read    (mem_read),
        .mem_write   (mem_write),
        .mem_to_reg  (mem_to_reg),
        .branch      (branch),
        .jump        (jump),
        .jalr        (jalr),
        .lui         (lui),
        .auipc       (auipc),
        .alu_op      (alu_op)
    );

    // 3. Immediate Generator
    imm_generator immediate (
        .instruction (instruction_in),
        .opcode      (opcode),
        .fn3         (fn3),
        .imm_out     (imm_out)
    );

    // 4. Register File
    reg_file registers (
        .clk        (clk),
        .reset      (reset),
        .rs1_sel    (rs1),
        .rs2_sel    (rs2),
        .rd_sel     (rd),
        .wb_data    (wb_data),
        .reg_write  (reg_write),
        .rs1_data   (rs1_data),
        .rs2_data   (rs2_data)
    );

    // 5. ALU Control
    alu_control alu_control_unit (
        .alu_op       (alu_op),
        .fn3          (fn3),
        .fn7          (fn7),
        .alu_control  (alu_ctrl)
    );

    // 6. ALU Input Selection
    assign alu_a = auipc ? pc_in : rs1_data;
    assign alu_b = alu_src ? imm_out : rs2_data;

    // 7. ALU
    alu arithmetic_unit (
        .a           (alu_a),
        .b           (alu_b),
        .alu_control (alu_ctrl),
        .result      (alu_result),
        .zero        (zero),
        .less_than   (less_than)
    );

    // 8. Data Memory
    data_memory memory (
        .clk        (clk),
        .reset      (reset),
        .mem_read   (mem_read),
        .mem_write  (mem_write),
        .address    (alu_result),
        .write_data (rs2_data),
        .read_data  (mem_data)
    );

    // 9. Branch Unit
    branch_unit branch_logic (
        .rs1_data    (rs1_data),
        .rs2_data    (rs2_data),
        .fn3         (fn3),
        .branch      (branch),
        .branch_taken(branch_taken)
    );

    // 10. Write-back selection
    always_comb begin

        if (lui)
            wb_data = imm_out;

        else if (jump)
            wb_data = pc_in + 32'd4;

        else if (mem_to_reg)
            wb_data = mem_data;

        else
            wb_data = alu_result;

    end

    // 11. Branch and Jump Target
    always_comb begin

        pc_redirect = jump || branch_taken;

        if (jalr)
            redirect_target = (rs1_data + imm_out) & 32'hFFFFFFFE;

        else
            redirect_target = pc_in + imm_out;

    end

endmodule
