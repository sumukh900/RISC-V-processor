// 32-bit Comparator Module for RISC-V Processor

module Comparator32 (
    input  [31:0] A,       // First 32-bit operand
    input  [31:0] B,       // Second 32-bit operand
    output        Equal,   // Output: 1 if A == B, else 0
    output        Greater, // Output: 1 if A > B, else 0
    output        Less     // Output: 1 if A < B, else 0
);
    // Comparator logic
    assign Equal   = (A == B);    // Equality check
    assign Greater = (A > B);     // Greater than check
    assign Less    = (A < B);     // Less than check

endmodule
