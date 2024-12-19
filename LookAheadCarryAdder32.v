// 32-bit Look-Ahead Carry Adder (LCA)

module LookAheadCarryAdder32 (
    input  [31:0] A,   // First 32-bit input
    input  [31:0] B,   // Second 32-bit input
    input         Cin, // Carry input
    output [31:0] Sum, // 32-bit sum output
    output        Cout // Final carry output
);
    // Generate and propagate signals
    wire [31:0] G, P; // Generate and propagate signals
    wire [31:0] C;    // Carry signals

    // Assign generate and propagate signals
    assign G = A & B;  // Generate: G = A * B
    assign P = A ^ B;  // Propagate: P = A XOR B

    // Calculate carry signals using look-ahead logic
    assign C[0] = Cin;
    genvar i;
    generate
        for (i = 1; i <= 31; i = i + 1) begin
            assign C[i] = G[i-1] | (P[i-1] & C[i-1]);
        end
    endgenerate

    // Final carry-out
    assign Cout = G[31] | (P[31] & C[31]);

    // Calculate sum bits
    assign Sum = P ^ C;

endmodule
