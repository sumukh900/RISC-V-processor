module InstructionMemory (
    input  wire [31:0] pc,
    output reg  [31:0] instruction
);
    reg [31:0] instr_mem [0:1023]; // 1024 words of instruction memory

    // Read instruction (combinational)
    always @(*) begin
        instruction = instr_mem[pc[11:2]]; // Word-aligned access
    end

    // Initialize with test instructions
    initial begin
        // Test addition
        instr_mem[0] = 32'h00100093;  // addi x1, x0, 1
        instr_mem[1] = 32'h00200113;  // addi x2, x0, 2
        instr_mem[2] = 32'h002081b3;  // add x3, x1, x2
        
        // Test subtraction
        instr_mem[3] = 32'h402081b3;  // sub x3, x1, x2
        
        // Test AND, OR, XOR
        instr_mem[4] = 32'h0020f193;  // andi x3, x1, 2
        instr_mem[5] = 32'h0020e193;  // ori x3, x1, 2
        instr_mem[6] = 32'h0020c193;  // xori x3, x1, 2
        
        // Test load/store
        instr_mem[7] = 32'h00002203;  // lw x4, 0(x0)
        instr_mem[8] = 32'h00402023;  // sw x4, 0(x0)
    end
endmodule