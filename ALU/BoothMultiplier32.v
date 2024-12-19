// 32-bit Booth Multiplier for RISC-V Processor

module BoothMultiplier32 (
    input  [31:0] A,   // Multiplicand (32-bit)
    input  [31:0] B,   // Multiplier (32-bit)
    output [63:0] Product // 64-bit Product
);
    reg [63:0] P;       // Partial product register
    reg [31:0] M;       // Copy of multiplicand
    reg [31:0] Q;       // Copy of multiplier
    reg Q_1;            // Previous bit of multiplier
    integer i;

    always @(*) begin
        // Initialize
        P = 64'b0;
        M = A;
        Q = B;
        Q_1 = 1'b0;

        // Booth's Algorithm Iteration
        for (i = 0; i < 32; i = i + 1) begin
            case ({Q[0], Q_1})
                2'b01: P[63:32] = P[63:32] + M; // Add multiplicand
                2'b10: P[63:32] = P[63:32] - M; // Subtract multiplicand
                default: ; // No operation
            endcase

            // Arithmetic right shift
            {P, Q_1} = {P[63], P, Q};
            Q = {P[0], Q[31:1]};
        end
    end

    // Assign final product
    assign Product = P;

endmodule
