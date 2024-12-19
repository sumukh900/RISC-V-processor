module RISCVProcessor (
    input  wire        clk,           // Clock signal
    input  wire        reset,         // Reset signal
    output wire [31:0] pc_out,        // Program counter output
    output wire [31:0] alu_result,    // ALU result (for debugging)
    output wire [31:0] data_out       // Data output (for debugging)
);

 wire [31:0] pc_next;
 wire [31:0] current_pc;
 wire [31:0] instruction;
  // Control signals from Control Unit
    wire        reg_write_en;
    wire [4:0]  rs1, rs2, rd;
    wire [4:0]  alu_op;
    wire        start_div;
    wire [31:0] alu_operand_a;
    wire [31:0] alu_operand_b;
    wire        mem_write_en;
    wire [31:0] mem_addr;
    wire [31:0] mem_write_data;

    // Register File signals
    wire [31:0] reg_rdata1;
    wire [31:0] reg_rdata2;
    
    // ALU signals
    wire [31:0] alu_result_wire;
    wire [63:0] alu_extended_result;
    wire        alu_zero;
    wire        alu_equal;
    wire        alu_greater;
    wire        alu_less;
    wire        alu_overflow;
    wire        div_ready;

    // Memory signals
    wire [31:0] mem_rdata;

    // Program Counter
    reg [31:0] pc;
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'h0;
        else
            pc <= pc_next;
    end

    // Simple PC increment (could be enhanced with branch/jump logic)
    assign pc_next = pc + 4;
    assign pc_out = pc;
    
    InstructionMemory imem (
        .pc(pc_out),
        .instruction(instruction)
    );

     // Control Unit instantiation
    ControlUnit32 control_unit (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .div_ready(div_ready),
        .reg_write_en(reg_write_en),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .alu_op(alu_op),
        .start_div(start_div),
        .alu_operand_a(alu_operand_a),
        .alu_operand_b(alu_operand_b),
        .mem_write_en(mem_write_en),
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data)
    );

    // Register File instantiation
    RegisterFile32 register_file (
        .clk(clk),
        .we(reg_write_en),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wdata(alu_result_wire), // Write ALU result back to register
        .rdata1(reg_rdata1),
        .rdata2(reg_rdata2)
    );

    // ALU instantiation
    ALU32 alu (
        .A(reg_rdata1),
        .B(reg_rdata2),
        .ALUOp(alu_op),
        .clk(clk),
        .start_div(start_div),
        .Result(alu_result_wire),
        .ExtendedResult(alu_extended_result),
        .Zero(alu_zero),
        .Equal(alu_equal),
        .Greater(alu_greater),
        .Less(alu_less),
        .Overflow(alu_overflow),
        .DivReady(div_ready)
    );

    // Data Memory instantiation
    SRAM32 data_memory (
        .clk(clk),
        .we(mem_write_en),
        .addr(mem_addr),
        .wdata(mem_write_data),
        .rdata(mem_rdata)
    );

    // Output assignments
    assign alu_result = alu_result_wire;
    assign data_out = mem_rdata;

endmodule