`timescale 1ns / 1ps

module FULLADD1(sum, cout, A, B, cin);
    input A, B, cin;
    output sum, cout;
    wire sum1, c1, c2;

    xor G1 (sum1, A, B);
    xor G2 (sum, sum1, cin);

    and G3 (c1, A, B);
    and G4 (c2, sum1, cin);
    or  G5 (cout, c1, c2);
endmodule

module CLA_UNIT(G, P, Cin, Cout);
    input [7:0] G, P;
    input Cin;
    output [7:0] Cout;

    assign Cout[0] = Cin;
    assign Cout[1] = G[0] | (P[0] & Cin);
    assign Cout[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign Cout[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign Cout[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);
    assign Cout[5] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & G[0]) | (P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    assign Cout[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & G[1]) | (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    assign Cout[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & G[2]) | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
endmodule

module ADD8(sum, cout, A, B, cin);
    input [7:0] A, B;
    input cin;
    output [7:0] sum;
    output cout;

    wire [7:0] G, P; 
    wire [7:0] carry; 

    AND8 U1 (.C(G), .A(A), .B(B));
    XOR8 U2 (.C(P), .A(A), .B(B));
    CLA_UNIT CLAU (.G(G), .P(P), .Cin(cin), .Cout(carry));

    FULLADD1 FA0 (.sum(sum[0]), .cout(), .A(A[0]), .B(B[0]), .cin(cin));
    FULLADD1 FA1 (.sum(sum[1]), .cout(), .A(A[1]), .B(B[1]), .cin(carry[1]));
    FULLADD1 FA2 (.sum(sum[2]), .cout(), .A(A[2]), .B(B[2]), .cin(carry[2]));
    FULLADD1 FA3 (.sum(sum[3]), .cout(), .A(A[3]), .B(B[3]), .cin(carry[3]));
    FULLADD1 FA4 (.sum(sum[4]), .cout(), .A(A[4]), .B(B[4]), .cin(carry[4]));
    FULLADD1 FA5 (.sum(sum[5]), .cout(), .A(A[5]), .B(B[5]), .cin(carry[5]));
    FULLADD1 FA6 (.sum(sum[6]), .cout(), .A(A[6]), .B(B[6]), .cin(carry[6]));
    FULLADD1 FA7 (.sum(sum[7]), .cout(cout), .A(A[7]), .B(B[7]), .cin(carry[7]));

endmodule

module ADD32(A,B,C,cout);
    input [31:0] A,B;
    output [31:0] C;
    output cout;
    
    wire c1,c2,c3;
    ADD8 add1(.A(A[7:0]),.B(B[7:0]),.cin(1'b0),.cout(c1),.sum(C[7:0]));
    ADD8 add2(.A(A[15:8]),.B(B[15:8]),.cin(c1),.cout(c2),.sum(C[15:8]));
    ADD8 add3(.A(A[23:16]),.B(B[23:16]),.cin(c2),.cout(c3),.sum(C[23:16]));
    ADD8 add4(.A(A[31:24]),.B(B[31:24]),.cin(c3),.cout(cout),.sum(C[31:24]));
endmodule

module COMPOF2(input [31:0] in, output [31:0] out);
    wire[31:0] negated;
    wire carry;
    NOT32 n1(.C(negated),.A(in));
    ADD32 addder(.A(negated),.B(32'd1),.C(out),.cout(carry));
endmodule

module SUB32(input [31:0] A, B,output [31:0] diff,output borrow);
    wire[31:0] B_;
    COMPOF2 comp(.in(B),.out(B_));
    ADD32 adder(.A(A),.B(B_),.C(diff),.cout(borrow));
endmodule

module INCA32(input[31:0] A,output[31:0] C);
    wire cout;
    ADD32 adder(.A(A),.B(32'd4),.C(C),.cout(cout));
endmodule

module DECA32(input [31:0] A,output[31:0] C);
    wire borrow;
    SUB32 sub(.A(A),.B(32'd4),.diff(C),.borrow(borrow));
endmodule

