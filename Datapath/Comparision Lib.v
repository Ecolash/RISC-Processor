`timescale 1ns / 1ps

module ADD2BIT (
    input [1:0] A,
    input [1:0] B,
    input cin,
    output [1:0] sum,
    output cout
);
    wire c1;
    FULLADD1 FA1 (
        .A(A[0]),
        .B(B[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(c1)
    );

    FULLADD1 FA2 (
        .A(A[1]),
        .B(B[1]),
        .cin(c1),
        .sum(sum[1]),
        .cout(cout)
    );
endmodule

module ADD3BIT (
    input [2:0] A,
    input [2:0] B,
    input cin,
    output [2:0] sum,
    output cout
);
    wire c1, c2;
    FULLADD1 FA1 (
        .A(A[0]),
        .B(B[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(c1)
    );

    FULLADD1 FA2 (
        .A(A[1]),
        .B(B[1]),
        .cin(c1),
        .sum(sum[1]),
        .cout(c2)
    );

    FULLADD1 FA3 (
        .A(A[2]),
        .B(B[2]),
        .cin(c2),
        .sum(sum[2]),
        .cout(cout)
    );
endmodule

module HAM8(
    input [7:0] A,
    output [7:0] weight
);
    wire [1:0] sum_stage1;
    wire [1:0] sum_stage2;
    wire [1:0] sum_stage3;
    
    wire carry_stage3;
    wire[2:0] sum_stage4;
    wire[2:0] sum_final;
    wire carry_final;
    
    FULLADD1 FA1 (.A(A[7]), .B(A[6]), .cin(A[5]), .sum(sum_stage1[0]), .cout(sum_stage1[1]));
    FULLADD1 FA2 (.A(A[4]), .B(A[3]), .cin(A[2]), .sum(sum_stage2[0]), .cout(sum_stage2[1]));
    ADD2BIT add1(.A(sum_stage1),.B(sum_stage2),.cin(A[1]),.sum(sum_stage3),.cout(carry_stage3));
    assign sum_stage4={carry_stage3,sum_stage3};
   
    ADD3BIT add2(.A(sum_stage4),.B(3'b000),.cin(A[0]),.sum(sum_final),.cout(carry_final));
    assign weight = {4'b0000,carry_final,sum_final};
endmodule

module HAM_32(input[31:0] A, output [7:0] weight);
    wire[7:0] w1,w2,w3,w4;
    wire[7:0] s1,s2;
    
    HAM8 H1(A[7:0], w1);
    HAM8 H2(A[15:8],w2);
    HAM8 H3(A[23:16],w3);
    HAM8 H4(A[31:24],w4);
    
    wire c1,c2,c3;
    ADD8 A1(.A(w1),.B(w2),.cin(0),.cout(c1),.sum(s1));
    ADD8 A2(.A(s1),.B(w3),.cin(c1),.cout(c2),.sum(s2));
    ADD8 A3(.A(s2),.B(w4),.cin(c2),.cout(c3),.sum(weight));
endmodule


module LUI32(input[31:0] A,output[31:0] out);
 assign out={A[31:16],{16{1'b0}}};
endmodule

module SLT32(input[31:0]A,B,output[31:0] out);
 wire[31:0]res;
 wire borrow;
 SUB32 sub(A,B,res,borrow);
 assign out={{31{1'b0}},res[31]};


endmodule

module SGT32(input[31:0]A,B,output[31:0] out);
 wire[31:0]res;
 wire borrow;
 SUB32 sub(A,B,res,borrow);
 assign out={{31{1'b0}},res[31]};
endmodule