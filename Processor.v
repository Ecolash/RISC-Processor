module processor_top(output [31:0] regval, input clk, input rst,input[3:0] reg_select);

    wire [3:0] func;
    wire [5:0] opcode;
    wire [31:0] A_out;
    wire sign;
    wire LoadPC;
    wire PCSel;
    wire ReadIM;
    wire LoadNPC;
    wire LoadIR;
    wire ReadRP1;
    wire ReadRP2;
    wire WriteRP;
    wire LoadA;
    wire LoadB;
    wire IMMsel;
    wire LoadIMM;
    wire MUXALU1;
    wire MUXALU2;
    wire [3:0] ALUFunc;
    wire LoadALUOut;
    wire ReadDM;
    wire WriteDM;
    wire LoadLMD;
    wire MUXWB;
    wire [1:0] MUXMOVE;
    wire HALT;

    datapath dp(
        .func(func),
        .opcode(opcode),
        .regval(regval),
        .A_out(A_out),
        .sign(sign),
        .LoadPC(LoadPC),
        .PCSel(PCSel),
        .ReadIM(ReadIM),
        .LoadNPC(LoadNPC),
        .LoadIR(LoadIR),
        .ReadRP1(ReadRP1),
        .ReadRP2(ReadRP2),
        .WriteRP(WriteRP),
        .LoadA(LoadA),
        .LoadB(LoadB),
        .IMMsel(IMMsel),
        .LoadIMM(LoadIMM),
        .MUXALU1(MUXALU1),
        .MUXALU2(MUXALU2),
        .ALUFunc(ALUFunc),
        .LoadALUOut(LoadALUOut),
        .ReadDM(ReadDM),
        .WriteDM(WriteDM),
        .LoadLMD(LoadLMD),
        .MUXWB(MUXWB),
        .MUXMOVE(MUXMOVE),
        .clk(clk),
        .rst(rst),
        .reg_select(reg_select)
    );

    Control_Unit cu(
        .opcode(opcode),
        .func(func),
        .LoadPC(LoadPC),
        .ReadIM(ReadIM),
        .LoadNPC(LoadNPC),
        .LoadIR(LoadIR),
        .ReadRP(ReadRP1),
        .ReadRP2(ReadRP2),
        .WriteRP(WriteRP),
        .LoadA(LoadA),
        .LoadB(LoadB),
        .ALUFunc(ALUFunc),
        .IMMsel(IMMsel),
        .WMFC(),
        .LoadIMM(LoadIMM),
        .MUXALU1(MUXALU1),
        .MUXALU2(MUXALU2),
        .LoadALUOut(LoadALUOut),
        .ReadDM(ReadDM),
        .WriteDM(WriteDM),
        .LoadLMD(LoadLMD),
        .MUXWB(MUXWB),
        .MUXMOVE(MUXMOVE),
        .HALT(HALT),
        .clk(clk),
        .rst(rst)
    );

    branch_control bc(
        .opcode(opcode),
        .pcsel(PCSel),
        .in(A_out)
    );

endmodule