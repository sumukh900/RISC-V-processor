module RISCVProcessor_tb;
    reg clk;
    reg reset;
    wire [31:0] pc_out;
    wire [31:0] alu_result;
    wire [31:0] data_out;

    // Instantiate the processor
    RISCVProcessor processor (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .alu_result(alu_result),
        .data_out(data_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize
        reset = 1;
        #10;
        reset = 0;

        // Run for enough cycles to execute all instructions
        #200;  // Adjust time as needed

        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t reset=%b pc=%h instr=%h alu_result=%h",
                 $time, reset, pc_out, processor.instruction, alu_result);
    end
endmodule