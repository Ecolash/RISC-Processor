`timescale 1ns / 1ps

module AND8(C, A, B);
    input [31:0] A;
    input [31:0] B;
    output [31:0] C;

    and G0 (C[0], A[0], B[0]);
    and G1 (C[1], A[1], B[1]);
    and G2 (C[2], A[2], B[2]);
    and G3 (C[3], A[3], B[3]);
    and G4 (C[4], A[4], B[4]);
    and G5 (C[5], A[5], B[5]);
    and G6 (C[6], A[6], B[6]);
    and G7 (C[7], A[7], B[7]);
endmodule

module AND32(C, A, B);
    input [31:0] A;
    input [31:0] B;
    output [31:0] C;

    AND8 G0 (C[7:0],   A[7:0],   B[7:0]);
    AND8 G1 (C[15:8],  A[15:8],  B[15:8]);
    AND8 G2 (C[23:16], A[23:16], B[23:16]);
    AND8 G3 (C[31:24], A[31:24], B[31:24]);
endmodule

module OR8(C, A, B);
    input [7:0] A;
    input [7:0] B;
    output [7:0] C;

    or G0 (C[0], A[0], B[0]);
    or G1 (C[1], A[1], B[1]);
    or G2 (C[2], A[2], B[2]);
    or G3 (C[3], A[3], B[3]);
    or G4 (C[4], A[4], B[4]);
    or G5 (C[5], A[5], B[5]);
    or G6 (C[6], A[6], B[6]);
    or G7 (C[7], A[7], B[7]);
endmodule

module OR32(C, A, B);
    input [31:0] A;
    input [31:0] B;
    output [31:0] C;

    OR8 G0 (C[7:0],   A[7:0],   B[7:0]);
    OR8 G1 (C[15:8],  A[15:8],  B[15:8]);
    OR8 G2 (C[23:16], A[23:16], B[23:16]);
    OR8 G3 (C[31:24], A[31:24], B[31:24]);

endmodule

module NOT8(C, A);
    input [7:0] A;
    output [7:0] C;

    not G0 (C[0], A[0]);
    not G1 (C[1], A[1]);
    not G2 (C[2], A[2]);
    not G3 (C[3], A[3]);
    not G4 (C[4], A[4]);
    not G5 (C[5], A[5]);
    not G6 (C[6], A[6]);
    not G7 (C[7], A[7]);
endmodule

module NOT32(C, A);
    input [31:0] A;
    output [31:0] C;

    NOT8 G0 (C[7:0],   A[7:0]);
    NOT8 G1 (C[15:8],  A[15:8]);
    NOT8 G2 (C[23:16], A[23:16]);
    NOT8 G3 (C[31:24], A[31:24]);
endmodule

module XOR8(C, A, B);
    input [7:0] A;
    input [7:0] B;
    output [7:0] C;

    xor G0 (C[0], A[0], B[0]);
    xor G1 (C[1], A[1], B[1]);
    xor G2 (C[2], A[2], B[2]);
    xor G3 (C[3], A[3], B[3]);
    xor G4 (C[4], A[4], B[4]);
    xor G5 (C[5], A[5], B[5]);
    xor G6 (C[6], A[6], B[6]);
    xor G7 (C[7], A[7], B[7]);
endmodule

module XOR32(C, A, B);
    input [31:0] A;
    input [31:0] B;
    output [31:0] C;

    XOR8 G0 (C[7:0],   A[7:0],   B[7:0]);
    XOR8 G1 (C[15:8],  A[15:8],  B[15:8]);
    XOR8 G2 (C[23:16], A[23:16], B[23:16]);
    XOR8 G3 (C[31:24], A[31:24], B[31:24]);
endmodule

module NOR8(C, A, B);
    input [7:0] A;
    input [7:0] B;
    output [7:0] C;

    nor (C[0], A[0], B[0]);
    nor (C[1], A[1], B[1]);
    nor (C[2], A[2], B[2]);
    nor (C[3], A[3], B[3]);
    nor (C[4], A[4], B[4]);
    nor (C[5], A[5], B[5]);
    nor (C[6], A[6], B[6]);
    nor (C[7], A[7], B[7]);
endmodule

module NOR32(C, A, B);
    input [31:0] A;
    input [31:0] B;
    output [31:0] C;

    NOR8 G0 (C[7:0],   A[7:0],   B[7:0]);
    NOR8 G1 (C[15:8],  A[15:8],  B[15:8]);
    NOR8 G2 (C[23:16], A[23:16], B[23:16]);
    NOR8 G3 (C[31:24], A[31:24], B[31:24]);
endmodule
