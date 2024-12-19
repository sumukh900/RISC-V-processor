// 32-bit SRAM Module for RISC-V Processor

module SRAM32 (
    input             clk,       // Clock signal
    input             we,        // Write enable (1 for write, 0 for read)
    input      [31:0] addr,      // Address bus (word addressable)
    input      [31:0] wdata,     // Write data
    output reg [31:0] rdata      // Read data
);
    // Define memory array (word-addressable, 1024 words of 32 bits each)
    reg [31:0] memory [0:1023];

    always @(posedge clk) begin
        if (we) begin
            // Write operation
            memory[addr] <= wdata;
        end else begin
            // Read operation
            rdata <= memory[addr];
        end
    end

endmodule
