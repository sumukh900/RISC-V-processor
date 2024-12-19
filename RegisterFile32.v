// 32-bit Register File for RISC-V Processor

module RegisterFile32 (
    input             clk,         // Clock signal
    input             we,          // Write enable
    input      [4:0]  rs1,         // Read register 1 address
    input      [4:0]  rs2,         // Read register 2 address
    input      [4:0]  rd,          // Write register address
    input      [31:0] wdata,       // Write data
    output reg [31:0] rdata1,      // Read data 1
    output reg [31:0] rdata2       // Read data 2
);
    // Define 32 registers, each 32 bits wide
    reg [31:0] registers [31:0];

    // Initialize all registers to zero
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end

    // Read operation (combinational logic)
    always @(*) begin
        rdata1 = registers[rs1];
        rdata2 = registers[rs2];
    end

    // Write operation (synchronous with clock)
    always @(posedge clk) begin
        if (we && rd != 5'b0) begin
            registers[rd] <= wdata; // Write to register (except x0, which is always zero)
        end
    end

endmodule
