module ControlUnit32 (
    input  wire        clk,           // Clock signal
    input  wire        reset,         // Reset signal
    input  wire [31:0] instruction,   // Instruction from instruction memory
    input  wire        div_ready,     // Division operation ready flag from ALU

    // Register File Control Signals
    output wire        reg_write_en,  // Register write enable
    output wire [4:0]  rs1,           // Source register 1
    output wire [4:0]  rs2,           // Source register 2
    output wire [4:0]  rd,            // Destination register

    // ALU Control Signals
    output wire [4:0]  alu_op,        // ALU operation selector
    output wire        start_div,     // Start division operation
    output wire [31:0] alu_operand_a, // First ALU operand
    output wire [31:0] alu_operand_b, // Second ALU operand

    // Memory Control Signals
    output wire        mem_write_en,  // Memory write enable
    output wire [31:0] mem_addr,      // Memory address
    output wire [31:0] mem_write_data // Data to write to memory

    // Additional processor state outputs can be added here
);
    // RISC-V Instruction Opcode Definitions
    localparam R_TYPE = 7'b0110011;  // Register-Register operations
    localparam I_TYPE = 7'b0010011;  // Immediate arithmetic and logic
    localparam LOAD   = 7'b0000011;  // Load instructions
    localparam STORE  = 7'b0100011;  // Store instructions

    // Instruction field extraction
    wire [6:0]  opcode = instruction[6:0];
    wire [2:0]  funct3  = instruction[14:12];
    wire [6:0]  funct7  = instruction[31:25];

    // Register addresses
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd  = instruction[11:7];

    // Control Unit State Machine
    reg [2:0] current_state;
    reg [2:0] next_state;

    // State definitions
    localparam 
        FETCH    = 3'b000,
        DECODE   = 3'b001,
        EXECUTE  = 3'b010,
        MEMORY   = 3'b011,
        WRITEBACK = 3'b100;

    // State Transition Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= FETCH;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State and Control Logic
    always @(*) begin
        // Default control signal values
        reg_write_en = 1'b0;
        mem_write_en = 1'b0;
        start_div = 1'b0;
        alu_op = 5'b00000;  // Default to ADD

        case (current_state)
            FETCH: begin
                next_state = DECODE;
            end

            DECODE: begin
                next_state = EXECUTE;
            end

            EXECUTE: begin
                case (opcode)
                    R_TYPE: begin
                        // R-type instruction ALU operations
                        case ({funct7, funct3})
                            10'b0000000_000: alu_op = 5'b00000;  // ADD
                            10'b0100000_000: alu_op = 5'b00001;  // SUB
                            10'b0000000_111: alu_op = 5'b00100;  // AND
                            10'b0000000_110: alu_op = 5'b00101;  // OR
                            10'b0000000_100: alu_op = 5'b00110;  // XOR
                            10'b0000000_001: alu_op = 5'b00111;  // SLL
                            10'b0000000_101: alu_op = 5'b01000;  // SRL
                        endcase
                    end

                    I_TYPE: begin
                        // I-type arithmetic and logic operations
                        case (funct3)
                            3'b000: alu_op = 5'b00000;  // ADDI
                            3'b111: alu_op = 5'b00100;  // ANDI
                            3'b110: alu_op = 5'b00101;  // ORI
                            3'b100: alu_op = 5'b00110;  // XORI
                        endcase
                    end

                    LOAD: begin
                        // For LOAD, ALU used to calculate memory address
                        alu_op = 5'b00000;  // ADD for address calculation
                    end

                    STORE: begin
                        // For STORE, ALU used to calculate memory address
                        alu_op = 5'b00000;  // ADD for address calculation
                    end
                endcase

                next_state = MEMORY;
            end

            MEMORY: begin
                case (opcode)
                    LOAD: begin
                        // Prepare for memory read
                        mem_addr = alu_operand_a;
                    end

                    STORE: begin
                        // Prepare for memory write
                        mem_addr = alu_operand_a;
                        mem_write_data = alu_operand_b;
                        mem_write_en = 1'b1;
                    end
                endcase

                next_state = WRITEBACK;
            end

            WRITEBACK: begin
                case (opcode)
                    R_TYPE, I_TYPE: begin
                        // Write ALU result back to register
                        reg_write_en = 1'b1;
                    end

                    LOAD: begin
                        // Write memory data to register
                        reg_write_en = 1'b1;
                    end
                endcase

                next_state = FETCH;
            end

            default: next_state = FETCH;
        endcase
    end

    // Operand Selection Logic
    assign alu_operand_a = (current_state == EXECUTE) ? rdata1 : 32'b0;
    assign alu_operand_b = (current_state == EXECUTE) ? 
        ((opcode == I_TYPE) ? {{20{instruction[31]}}, instruction[31:20]} : rdata2) : 32'b0;

endmodule