module MUX2to1 (d0, d1, sel, y);
    input wire d0, d1, sel;
    output wire y;  
    wire seln;  
    wire and_d0;    
    wire and_d1;  

    not u0 (seln, sel);
    and u1 (and_d0, seln, d0);
    and u2 (and_d1, sel, d1);
    or u3 (y, and_d0, and_d1);
endmodule

module MUX4to1 (d0, d1, d2, d3, sel, y);
    input wire d0, d1, d2, d3;   
    input wire [1:0] sel;        
    output wire y;               

    wire y0, y1;                 
    MUX2to1 mux0 (.d0(d0), .d1(d1), .sel(sel[0]), .y(y0));
    MUX2to1 mux1 (.d0(d2), .d1(d3), .sel(sel[0]), .y(y1));
    MUX2to1 mux2 (.d0(y0), .d1(y1), .sel(sel[1]), .y(y));
endmodule

module MUX16to1 (d, sel, y);
    input wire [15:0] d;         
    input wire [3:0] sel;        
    output wire y;               
    wire y0, y1, y2, y3;         

    MUX4to1 mux0 (.d0(d[0]), .d1(d[1]), .d2(d[2]), .d3(d[3]), .sel(sel[1:0]), .y(y0));
    MUX4to1 mux1 (.d0(d[4]), .d1(d[5]), .d2(d[6]), .d3(d[7]), .sel(sel[1:0]), .y(y1));
    MUX4to1 mux2 (.d0(d[8]), .d1(d[9]), .d2(d[10]), .d3(d[11]), .sel(sel[1:0]), .y(y2));
    MUX4to1 mux3 (.d0(d[12]), .d1(d[13]), .d2(d[14]), .d3(d[15]), .sel(sel[1:0]), .y(y3));
    MUX4to1 mux4 (.d0(y0), .d1(y1), .d2(y2), .d3(y3), .sel(sel[3:2]), .y(y));
endmodule

module MUX32BIT (
    input wire [31:0] d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15,
    input wire [3:0] sel,
    output wire [31:0] y
);
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : mux_gen
            MUX16to1 mux (
                .d({d15[i], d14[i], d13[i], d12[i], d11[i], d10[i], d9[i], d8[i], d7[i], d6[i], d5[i], d4[i], d3[i], d2[i], d1[i], d0[i]}),
                .sel(sel),
                .y(y[i])
            );
        end
    endgenerate
endmodule
