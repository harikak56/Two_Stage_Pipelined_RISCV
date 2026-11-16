
`timescale 1ns / 1ps

module alu_control (
    input  logic [1:0] alu_op,
    input  logic [2:0] fn3,
    input  logic [6:0] fn7,

    output logic [3:0] alu_control
);

    always_comb begin

        case (alu_op)

            // Load and Store: ADD
            2'b00: alu_control = 4'b0000;

            // Branch: SUB
            2'b01: alu_control = 4'b0001;

            // R-type and I-type ALU instructions
            2'b10: begin

                case (fn3)

                    3'b000: begin
                        if (fn7 == 7'b0100000)
                            alu_control = 4'b0001; // SUB
                        else
                            alu_control = 4'b0000; // ADD
                    end

                    3'b001: alu_control = 4'b0101; // SLL
                    3'b010: alu_control = 4'b1000; // SLT
                    3'b011: alu_control = 4'b1001; // SLTU
                    3'b100: alu_control = 4'b0100; // XOR
                    3'b101: begin
                        if (fn7 == 7'b0100000)
                            alu_control = 4'b0111; // SRA
                        else
                            alu_control = 4'b0110; // SRL
                    end

                    3'b110: alu_control = 4'b0011; // OR
                    3'b111: alu_control = 4'b0010; // AND

                    default: alu_control = 4'b0000;

                endcase

            end

            default: alu_control = 4'b0000;

        endcase

    end

endmodule
