// 32-bit Divider for RISC-V Processor using SRT Division Algorithm

module Divider32 (
    input             clk,         // Clock signal
    input             start,       // Start signal to begin division
    input      [31:0] dividend,    // 32-bit dividend
    input      [31:0] divisor,     // 32-bit divisor
    output reg [31:0] quotient,    // 32-bit quotient
    output reg [31:0] remainder,   // 32-bit remainder
    output reg        ready        // Signal indicating division completion
);
    // Internal registers
    reg [63:0] partial_remainder; // Double-width partial remainder
    reg [31:0] temp_quotient;     // Temporary quotient
    reg [5:0]  count;             // Iteration counter

    reg division_active;          // Indicates if division is in progress

    // Initialize outputs and internal registers
    initial begin
        quotient          = 32'b0;
        remainder         = 32'b0;
        ready             = 1'b0;
        partial_remainder = 64'b0;
        temp_quotient     = 32'b0;
        count             = 6'b0;
        division_active   = 1'b0;
    end

    always @(posedge clk) begin
        if (start && !division_active) begin
            // Start division process
            division_active   <= 1'b1;
            ready             <= 1'b0;
            partial_remainder <= {32'b0, dividend}; // Initialize partial remainder
            temp_quotient     <= 32'b0;
            count             <= 6'd32;            // Set counter for 32 iterations
        end else if (division_active) begin
            // Perform one step of SRT division
            if (partial_remainder[63:32] >= divisor) begin
                partial_remainder <= {partial_remainder[62:0], 1'b0} - {divisor, 32'b0};
                temp_quotient    <= {temp_quotient[30:0], 1'b1};
            end else begin
                partial_remainder <= {partial_remainder[62:0], 1'b0};
                temp_quotient    <= {temp_quotient[30:0], 1'b0};
            end

            // Decrement counter
            count <= count - 1;

            // Check if division is complete
            if (count == 0) begin
                division_active <= 1'b0;
                quotient        <= temp_quotient;
                remainder       <= partial_remainder[63:32];
                ready           <= 1'b1;
            end
        end
    end

endmodule
