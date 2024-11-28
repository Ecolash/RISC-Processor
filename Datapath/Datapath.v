module datapath(
    output [3:0] func,
    output [5:0] opcode,
    output [31:0] regval,
    output [31:0] A_out,
    output sign,
    input LoadPC,
    input PCSel,
    input ReadIM,
    input LoadNPC,
    input LoadIR,
    input ReadRP1,
    input ReadRP2,
    input WriteRP,
    input LoadA,
    input LoadB,
    input IMMsel,
    input LoadIMM,
    input MUXALU1,
    input MUXALU2,
    input [3:0] ALUFunc,
    input LoadALUOut,
    input ReadDM,
    input WriteDM,
    input LoadLMD,
    input MUXWB,
    input [1:0] MUXMOVE,
    input clk,
    input rst,
    input [3:0] reg_select
);

    wire [31:0] PC_in, PC_out, NPC_in, NPC_out, IR_in, IR_out, A_in, B_in, B_out, Imm_in, Imm_out, ALUin1, ALUin2, ALUout, DM_in, DM_out, LMD_out, write_back, move_in, regbank_write;
    wire [3:0] i9_6, i13_10, i17_14;
    wire [17:0] i17_0;
    wire [25:0] i25_0;
    wire [31:0] signextend18to32;
    wire [31:0] signextend26to32;
    wire [31:0] reg_data_out;

    assign regval = (reg_select == 4'd0) ? ALUout : reg_data_out;

    PIPO PC(.d_out(PC_out), .d_in(PC_in), .ld(LoadPC), .clk(clk), .rst(rst));
    PC_adder addpc(.d_in(PC_out), .d_out(NPC_in));
    PIPO NPC(.d_out(NPC_out), .d_in(NPC_in), .ld(LoadNPC), .clk(clk), .rst(rst));
    inst_mem INSTRMEM(.clk(clk), .addr(PC_out), .data(IR_in), .read(ReadIM));
    PIPO IR(.d_out(IR_out), .d_in(IR_in), .ld(LoadIR), .clk(clk), .rst(rst));

    assign opcode = IR_out[31:26];
    assign func = IR_out[3:0];
    assign i9_6 = IR_out[25:22];
    assign i13_10 = (opcode == 6'b000010) ? IR_out[25:22] : IR_out[21:18];
    assign i17_14 = (opcode == 6'b000010) ? IR_out[21:18] : IR_out[17:14];
    assign i17_0 = IR_out[17:0];
    assign i25_0 = IR_out[25:0];

    reg_bank RB(
        .reg_select(reg_select),
        .read_data1(A_in),
        .read_data2(B_in),
        .write_data(regbank_write),
        .read_port1(i13_10),
        .read_port2(i17_14),
        .write_port(i9_6),
        .clk(clk),
        .read(1'b1),
        .write(WriteRP),
        .reg_data_select(reg_data_out),
        .reset(rst)
    );

    sign_extend_18 SIGNEX18TO32(.d_in(i17_0), .d_out(signextend18to32));
    sign_extend_26 SIGNEX26TO32(.d_in(i25_0), .d_out(signextend26to32));
    mux_32b_2to1 MUXIMM(.out(Imm_in), .in0(signextend18to32), .in1(signextend26to32), .sel(IMMsel));

    PIPO IMM(.d_out(Imm_out), .d_in(Imm_in), .ld(LoadIMM), .clk(clk), .rst(rst));
    PIPO A(.d_out(A_out), .d_in(A_in), .ld(LoadA), .clk(clk), .rst(rst));
    PIPO B(.d_out(B_out), .d_in(B_in), .ld(LoadB), .clk(clk), .rst(rst));

    mux_32b_2to1 MuxALU1(.out(ALUin1), .in1(NPC_out), .in0(A_out), .sel(MUXALU1));
    mux_32b_2to1 MuxALU2(.out(ALUin2), .in1(Imm_out), .in0(B_out), .sel(MUXALU2));

    ALU32 ALU(.alu_func(ALUFunc), .A(ALUin1), .B(ALUin2), .Y(ALUout), .sign(sign));

    PIPO ALUOUT(.d_out(DM_in), .d_in(ALUout), .ld(LoadALUOut), .clk(clk), .rst(rst));
    data_mem DATAMEM(.clk(clk), .addr(DM_in), .write_data(B_out), .read_data(DM_out), .we(WriteDM));

    mux_32b_2to1 MUXPC(.out(PC_in), .in0(NPC_out), .in1(DM_in), .sel(PCSel));

    PIPO LMD(.d_out(LMD_out), .d_in(DM_out), .ld(LoadLMD), .clk(clk), .rst(rst));
    mux_32b_2to1 MuxWB(.out(write_back), .in1(DM_in), .in0(LMD_out), .sel(MUXWB));
    mux_32b_2to1 MuxAB(.out(move_in), .in1(A_out), .in0(B_out), .sel(sign));
    mux_32b_4to1 MuxMOVE(.out(regbank_write), .in0(write_back), .in1(move_in), .in2(A_out), .in3(Imm_out), .sel(MUXMOVE));

endmodule
