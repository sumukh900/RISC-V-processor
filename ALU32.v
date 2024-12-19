// Comprehensive 32-bit ALU for RISC-V Processor
module ALU32 (
    input  [31:0] A,           // First 32-bit operand
    input  [31:0] B,           // Second 32-bit operand
    input  [4:0]  ALUOp,       // Extended ALU Operation Code
    input         clk,         // Clock signal for division
    input         start_div,   // Start signal for division
    output [31:0] Result,      // ALU Result
    output [63:0] ExtendedResult, // For multiplication (64-bit)
    output        Zero,        // Zero flag
    output        Equal,       // Equality flag
    output        Greater,     // Greater than flag
    output        Less,        // Less than flag
    output        Overflow,    // Overflow flag
    output        DivReady     // Division ready flag
);
    // Extended ALU Operation Codes
    // 5'b00000: Addition
    // 5'b00001: Subtraction
    // 5'b00010: Multiplication
    // 5'b00011: Division
    // 5'b00100: Bitwise AND
    // 5'b00101: Bitwise OR
    // 5'b00110: Bitwise XOR
    // 5'b00111: Logical Left Shift
    // 5'b01000: Logical Right Shift
    // 5'b01001: Comparison (Equal)
    // 5'b01010: Comparison (Greater)
    // 5'b01011: Comparison (Less)

    // Wires for intermediate results
    wire [31:0] sum_wire;
    wire [63:0] mult_wire;
    wire [31:0] div_quotient_wire;
    wire [31:0] div_remainder_wire;
    wire [31:0] logical_result_wire;
    wire cout_wire;
    wire [31:0] b_complement;
    wire carry_in;

    // For subtraction, we use two's complement
    assign b_complement = ~B;
    assign carry_in = 1'b1;  // For two's complement subtraction

    // Instantiate modules
    LookAheadCarryAdder32 adder (
        .A(A),
        .B((ALUOp == 5'b00001) ? b_complement : B),
        .Cin((ALUOp == 5'b00001) ? carry_in : 1'b0),
        .Sum(sum_wire),
        .Cout(cout_wire)
    );

    BoothMultiplier32 multiplier (
        .A(A),
        .B(B),
        .Product(mult_wire)
    );

    Divider32 divider (
        .clk(clk),
        .start(start_div),
        .dividend(A),
        .divisor(B),
        .quotient(div_quotient_wire),
        .remainder(div_remainder_wire),
        .ready(DivReady)
    );

    Comparator32 comparator (
        .A(A),
        .B(B),
        .Equal(Equal),
        .Greater(Greater),
        .Less(Less)
    );

    LogicalOperations32 logical_ops (
        .A(A),
        .B(B),
        .OpCode(ALUOp[2:0]),
        .Result(logical_result_wire)
    );

    // Overflow detection for signed arithmetic
    wire overflow_detect = (A[31] ^ B[31]) & (A[31] ^ sum_wire[31]);

    // Result multiplexing
    reg [31:0] result_reg;
    reg [63:0] extended_result_reg;
    always @(*) begin
        case(ALUOp)
            5'b00000: begin // Addition
                result_reg = sum_wire;
                extended_result_reg = {32'b0, sum_wire};
            end
            5'b00001: begin // Subtraction
                result_reg = sum_wire;
                extended_result_reg = {32'b0, sum_wire};
            end
            5'b00010: begin // Multiplication
                result_reg = mult_wire[31:0];
                extended_result_reg = mult_wire;
            end
            5'b00011: begin // Division
                result_reg = div_quotient_wire;
                extended_result_reg = {div_remainder_wire, div_quotient_wire};
            end
            5'b00100: begin // Bitwise AND
                result_reg = logical_result_wire;
                extended_result_reg = {32'b0, logical_result_wire};
            end
            5'b00101: begin // Bitwise OR
                result_reg = logical_result_wire;
                extended_result_reg = {32'b0, logical_result_wire};
            end
            5'b00110: begin // Bitwise XOR
                result_reg = logical_result_wire;
                extended_result_reg = {32'b0, logical_result_wire};
            end
            5'b00111: begin // Logical Left Shift
                result_reg = logical_result_wire;
                extended_result_reg = {32'b0, logical_result_wire};
            end
            5'b01000: begin // Logical Right Shift
                result_reg = logical_result_wire;
                extended_result_reg = {32'b0, logical_result_wire};
            end
            5'b01001: begin // Comparison (Equal)
                result_reg = {31'b0, Equal};
                extended_result_reg = {63'b0, Equal};
            end
            5'b01010: begin // Comparison (Greater)
                result_reg = {31'b0, Greater};
                extended_result_reg = {63'b0, Greater};
            end
            5'b01011: begin // Comparison (Less)
                result_reg = {31'b0, Less};
                extended_result_reg = {63'b0, Less};
            end
            default: begin
                result_reg = 32'd0;
                extended_result_reg = 64'b0;
            end
        endcase
    end

    // Zero flag: check if result is zero
    assign Zero = (result_reg == 32'd0);

    // Overflow flag: only set for signed arithmetic operations
    assign Overflow = (ALUOp[4:1] == 4'b0000) ? overflow_detect : 1'b0;

    // Output assignments
    assign Result = result_reg;
    assign ExtendedResult = extended_result_reg;
endmodule