
/**
 * 32K 16-bit RAM where the the program to run is stored. 
 * It's a ROM in nand2tetris.
 */
 
module instruction_memory(
    output reg [15:0] q,
    input [15:0] d,
    input [12:0] write_address, read_address,
    input we, clk
);
    (* ramstyle = "M9K" *)
    reg [15:0] mem [32767:0] /* synthesis ram_init_file = "program.mif" */; // 32K 16-bit RAM
    
    always @ (posedge clk) begin
        if (we)
            mem[write_address] <= d;
        q <= mem[read_address]; // q doesn't get d in this clock cycle
    end
    
endmodule