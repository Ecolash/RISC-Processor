module data_mem #(parameter WIDTH=32)(
    input wire clk,
    input wire [WIDTH-1:0] addr,  // Address for data access
    input wire [WIDTH-1:0] write_data,  // Data to write
    input wire we,                      // Write enablea
    output wire [WIDTH-1:0] read_data  // Data read from memory
);
    blk_mem_gen_1 data_mem_bram (
        .clka(clk),
        .addra(addr),
        .dina(write_data),
        .douta(read_data),
        .ena(1'b1),  // Enable the BRAM
        .wea(we)     // Control write enable for data memory
    );
endmodule

