`timescale 1ns / 1ps

module MUX2to1(input wire A, input wire B, input wire sel, output wire Y);
    assign Y = sel ? B : A;
endmodule

module SLL32(C, A, B);
    input [31:0] A, B;
    output [31:0] C;
    wire [31:0] stage[0:4];
    wire overlimit;
    or(overlimit, B[31:5]);
    genvar i, j;
    generate
        for (j = 0; j < 5; j = j + 1) begin : stages
            for (i = 0; i < 32; i = i + 1) begin : stage
                MUX2to1 M(
                    (j == 0) ? A[i] : stage[j-1][i], 
                    (i < (1 << j)) ? 1'b0 : (j == 0) ? A[i-(1<<j)] : stage[j-1][i-(1<<j)], 
                    B[j], 
                    stage[j][i]
                );
            end
        end
        for (i = 0; i < 32; i = i + 1) begin : final_stage
            MUX2to1 M(stage[4][i], 1'b0, overlimit, C[i]);
        end
    endgenerate
endmodule

module SRL32(C, A, B);
    input [31:0] A, B;
    output [31:0] C;
    wire [31:0] stage[0:4];
    wire overlimit;
    or(overlimit, B[31:5]);
    genvar i, j;
    generate
        for (j = 0; j < 5; j = j + 1) begin : stages
            for (i = 0; i < 32; i = i + 1) begin : stage
                MUX2to1 M(
                    (j == 0) ? A[31-i] : stage[j-1][31-i], 
                    (i < (1 << j)) ? 1'b0 : (j == 0) ? A[31-i+(1<<j)] : stage[j-1][31-i+(1<<j)], 
                    B[j], 
                    stage[j][31-i]
                );
            end
        end
        for (i = 0; i < 32; i = i + 1) begin : final_stage
            MUX2to1 M(1'b0, stage[4][31-i], overlimit, C[31-i]);
        end
    endgenerate
endmodule

module SRA32(C, A, B);
    input [31:0] A, B;
    output [31:0] C;
    wire [31:0] stage[0:4];
    wire overlimit;
    or(overlimit, B[31:5]);
    genvar i, j;
    generate
        for (j = 0; j < 5; j = j + 1) begin : stages
            for (i = 0; i < 32; i = i + 1) begin : stage
                MUX2to1 M(
                    (j == 0) ? A[31-i] : stage[j-1][31-i], 
                    (i < (1 << j)) ? A[31] : (j == 0) ? A[31-i+(1<<j)] : stage[j-1][31-i+(1<<j)], 
                    B[j], 
                    stage[j][31-i]
                );
            end
        end
        for (i = 0; i < 32; i = i + 1) begin : final_stage
            MUX2to1 M(A[31], stage[4][31-i], overlimit, C[31-i]);
        end
    endgenerate
endmodule
