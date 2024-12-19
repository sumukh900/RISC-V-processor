// 32-bit Logical Operations Module for RISC-V Processor

module LogicalOperations32 (
    input  [31:0] A,      // First 32-bit operand
    input  [31:0] B,      // Second 32-bit operand
    input  [2:0] OpCode,  // Operation code (3 bits)
    output [31:0] Result  // 32-bit result
);
    // Operation code definitions
    // OpCode = 3'b000: AND
    // OpCode = 3'b001: OR
    // OpCode = 3'b010: XOR
    // OpCode = 3'b011: NOR
    // OpCode = 3'b100: NAND
    // OpCode = 3'b101: XNOR
    // OpCode = 3'b110: Logical Left Shift
    // OpCode = 3'b111: Logical Right Shift

    reg [31:0] result_reg;

    always @(*) begin
        case (OpCode)
            3'b000: result_reg = A & B;         // AND
            3'b001: result_reg = A | B;         // OR
            3'b010: result_reg = A ^ B;         // XOR
            3'b011: result_reg = ~(A | B);      // NOR
            3'b100: result_reg = ~(A & B);      // NAND
            3'b101: result_reg = ~(A ^ B);      // XNOR
            3'b110: result_reg = A << B[4:0];   // Logical left shift
            3'b111: result_reg = A >> B[4:0];   // Logical right shift
            default: result_reg = 32'b0;        // Default to zero for invalid OpCode
        endcase
    end

    assign Result = result_reg;

endmodule
