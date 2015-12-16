/**
 * The Hack CPU (Central Processing unit), consisting of an ALU,
 * two registers named A and D, and a program counter named PC.
 * The CPU is designed to fetch and execute instructions written in 
 * the Hack machine language. 
 
 * In particular, functions as follows:
 * Executes the inputted instruction according to the Hack machine 
 * language specification. 
 * The D and A in the language specification
 * refer to CPU-resident registers, 
 * while M refers to the external memory location addressed by A,
 * i.e. to Memory[A]. 
 * The inM input holds the value of this location. 
 *
 * If the current instruction needs 
 * to write a value to M, the value is placed in outM, the address 
 * of the target location is placed in the addressM output, and the 
 * writeM control bit is asserted. (When writeM==0, any value may 
 * appear in outM). 
 * The outM and writeM outputs are combinational: 
 * they are affected instantaneously by the execution of the current 
 * instruction. The addressM and pc outputs are clocked: although they 
 * are affected by the execution of the current instruction, they commit 
 * to their new values only in the next time step. If reset==1 then the 
 * CPU jumps to address 0 (i.e. pc is set to 0 in next time step) rather 
 * than to the address resulting from executing the current instruction. 
 *
 *
 *  IN  inM[16],         // M value input  (M = contents of RAM[A])
 *      instruction[16], // Instruction for execution
 *      reset;           // Signals whether to re-start the current
 *                       // program (reset==1) or continue executing
 *                       // the current program (reset==0).
 *
 *  OUT outM[16],        // M value output
 *      writeM,          // Write to M? 
 *      addressM[15],    // Address in data memory (of M)
 *      pc[15];          // address of next instruction
 */

module cpu (
    input clk,
    input reset,
    input [15:0] inM,
    input [15:0] instruction,

    output [15:0] outM,
    output writeM,
    output [14:0] addressM,
    output [14:0] pc
);

    reg [15:0] DRegister = 16'b0;
    reg [15:0] ARegister = 16'b0;
    
    reg [14:0] r_addressM = 1'b0;
    reg [15:0] r_outM = 1'b0;
    reg r_writeM;
    
    reg pc_inc = 0;
    reg pc_load = 0;
    reg [15:0] pc_in = 0;
    wire [15:0] pc_out;
    
    reg [15:0] alu_y;
    wire [15:0] alu_out;
    wire alu_zr, alu_ng;

    assign pc = pc_out[14:0];
    
    assign outM = alu_out; 
    assign writeM = r_writeM;
    assign addressM = r_addressM;
    
    
    program_counter program_counter_inst (
        .clk(clk),
        .reset(reset),
        .inc(pc_inc),
        .load(pc_load),
        .in(pc_in),
        .out(pc_out)
    );
    

    alu alu_inst(
        .x(DRegister),
        .y(alu_y),
        .zx(instruction[11]),
        .nx(instruction[10]),
        .zy(instruction[9]),
        .ny(instruction[8]),
        .f(instruction[7]),
        .no(instruction[6]),
        .out(alu_out),
        .zr(alu_zr),
        .ng(alu_ng)
    );
    
    always @(posedge clk) begin
        pc_inc <= !pc_inc; // 2 clock cycles per instruction
        
        r_addressM <= ARegister;
    
        // If MSB of instruction == 0 then the A register must be set with the 15 bit remaining value.
        if (instruction[15] == 0) begin
            // A instruction
            ARegister <= {1'b0, instruction[14:0]};
            //r_addressM <= ARegister;
        end else begin
            // C instruction
            
            // Alu_y input: If bit[12], the "a" bit is 1 then use M (inM) otherwise use A register content.
            if (instruction[12] == 1) begin
                alu_y <= inM;
            end else begin
                alu_y <= ARegister;
            end
            
            // if instruction[5] == store ALU out (outM) in A
            if (instruction[5] == 1) begin
                ARegister <= alu_out;
            end

            // If bit[4] "d2" is 1 then store ALU out (outM) in the D register
            if (instruction[4] == 1) begin
                DRegister <= alu_out;
            end
            
            // if d3 (instruction[3]) == 1 then write to M
            if (instruction[3] == 1) begin
                r_writeM <= 1'b1;
                
            end else begin
                r_writeM <= 1'b0;
                
            end
            
        end
    end 
    

endmodule
