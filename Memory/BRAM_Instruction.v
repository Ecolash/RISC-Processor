module inst_mem #(parameter WIDTH=32)(
    input  clk,
    input read,
    input [WIDTH-1:0] addr,  
    output  [WIDTH-1:0] data
);
    blk_mem_gen_0 inst_mem_bram (
        .clka(clk),
        .addra(addr),
        .dina(32'd0),
        .douta(data),
        .ena(read),  
        .wea(1'b0)
    );
endmodule