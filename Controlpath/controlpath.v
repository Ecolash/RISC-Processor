module Control_Unit( opcode, func, LoadPC, ReadIM, LoadNPC, LoadIR, ReadRP, ReadRP2, WriteRP, LoadA, LoadB, ALUFunc,
    IMMsel, WMFC, LoadIMM, MUXALU1, MUXALU2, LoadALUOut, ReadDM, WriteDM, LoadLMD, MUXWB, MUXMOVE, HALT, clk, rst
);
    input [5:0] opcode;
    input [3:0] func;
    input clk, rst;

    output reg LoadPC, ReadIM, LoadNPC, LoadIR, ReadRP,ReadRP2;
    output reg WriteRP, LoadA, LoadB, IMMsel, WMFC, LoadIMM, MUXALU1, MUXALU2;
    output reg LoadALUOut, ReadDM, WriteDM, LoadLMD, MUXWB, HALT;
    output reg [3:0] ALUFunc;
    output reg [1:0] MUXMOVE;

    parameter 
        ALU   = 6'b000000,
        LUI   = 6'b111111,
        ADDI  = 6'b110000,
        SUBI  = 6'b110001,
        NOTI  = 6'b110010,
        SLLI  = 6'b110011,
        ANDI  = 6'b110100,
        ORI   = 6'b110101,
        SRLI  = 6'b110110,
        SRAI  = 6'b110111,
        XORI  = 6'b111000,
        NORI  = 6'b111001,
        LD    = 6'b000001,
        ST    = 6'b000010,
        MOVE  = 6'b000111,
        CMOV  = 6'b101010,
        BR    = 6'b000011,
        BMI   = 6'b000100,
        BPL   = 6'b000101,
        BZ    = 6'b000110,
        HALT_ = 6'b001000,
        NOP   = 6'b001001;

    reg [2:0] state, next;

    parameter 
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100,
        S5 = 3'b101,
        S6 = 3'b110;

    always @(posedge clk or posedge rst) begin
        if (rst) state <= S0;
        else state <= next;
    end

    always @(*) begin
        case (state)
            S0: next = S1;
            S1: next = S2;
            S2: next = S3;
            S3: next = S4;
            S4: next = S5;
            S5: next = S6;
            S6: next = S0;
            default: next = S0;
        endcase
    end

    always @(*) begin
        LoadPC = 0; ReadIM = 0; LoadNPC = 0; LoadIR = 0; ReadRP = 0;
        WriteRP = 0; LoadA = 0; LoadB = 0; IMMsel = 0; LoadIMM = 0; MUXALU1 = 0; MUXALU2 = 0;
        LoadALUOut = 0; ReadDM = 0; WriteDM = 0; LoadLMD = 0; MUXWB = 0; MUXMOVE = 0; HALT = 0;
        ALUFunc = 0;
        ReadRP2=0;

        case(state) 
            S0: begin
                if (opcode == HALT_) HALT <= 1;
                else begin LoadNPC <= 1; ReadIM <= 1; LoadIR <= 1; end
                end

            S1: begin
                if (opcode == HALT_) HALT <= 1;
                else begin LoadIR <= 1; end
                end

            S2: begin
                case(opcode)
                    ALU:    begin LoadA <= 1; LoadB <= 1; ReadRP <= 1; end
                    ADDI:   begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end
                    SUBI:   begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end
                    NOTI:   begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end
                    SLLI:   begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end
                    ANDI:   begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end
                    ORI:    begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end
                    SRLI:   begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end
                    SRAI:   begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end
                    XORI:   begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end
                    NORI:   begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end
                    LUI:    begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end
                    LD:     begin LoadA <= 1; ReadRP <= 1; LoadB <= 1; LoadIMM <= 1;  end
                    ST:     begin LoadA <= 1; ReadRP <= 1; LoadB <= 1; LoadIMM <= 1;  end
                    BR:     begin LoadIMM <= 1; IMMsel <= 1;  end
                    BPL:    begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end
                    BMI:    begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end
                    BZ:     begin LoadA <= 1; ReadRP <= 1; LoadIMM <= 1; end                    
                    MOVE:   begin LoadA <= 1; end
                    CMOV:   begin LoadA <= 1; LoadB <= 1; end
                    HALT_:  begin HALT <= 1; end
                endcase
                end

            S3: begin
                case(opcode)
                    ALU:    begin ALUFunc <= func; LoadALUOut <= 1; end
                    ADDI:   begin ALUFunc <= opcode[3:0]; MUXALU2 <= 1; LoadALUOut <= 1; end
                    SUBI:   begin ALUFunc <= opcode[3:0]; MUXALU2 <= 1; LoadALUOut <= 1; end
                    NOTI:   begin ALUFunc <= opcode[3:0]; MUXALU2 <= 1; LoadALUOut <= 1; end
                    SLLI:   begin ALUFunc <= opcode[3:0]; MUXALU2 <= 1; LoadALUOut <= 1; end
                    ANDI:   begin ALUFunc <= opcode[3:0]; MUXALU2 <= 1; LoadALUOut <= 1; end
                    ORI:    begin ALUFunc <= opcode[3:0]; MUXALU2 <= 1; LoadALUOut <= 1; end
                    SRLI:   begin ALUFunc <= opcode[3:0]; MUXALU2 <= 1; LoadALUOut <= 1; end
                    SRAI:   begin ALUFunc <= opcode[3:0]; MUXALU2 <= 1; LoadALUOut <= 1; end
                    XORI:   begin ALUFunc <= opcode[3:0]; MUXALU2 <= 1; LoadALUOut <= 1; end
                    NORI:   begin ALUFunc <= opcode[3:0]; MUXALU2 <= 1; LoadALUOut <= 1; end
                    LUI:    begin ALUFunc <= opcode[3:0]; MUXALU2 <= 1; LoadALUOut <= 1; end
                    LD:     begin MUXALU2 <= 1; LoadALUOut <= 1; end
                    ST:     begin MUXALU2 <= 1; LoadALUOut <= 1; end
                    BR:     begin LoadIMM <= 1; IMMsel <= 1; MUXALU1<=1; MUXALU2 <= 1; LoadALUOut <= 1; end
                    BPL:    begin MUXALU1 <= 1; MUXALU2 <= 1; LoadALUOut <= 1; end
                    BMI:    begin MUXALU1 <= 1; MUXALU2 <= 1; LoadALUOut <= 1; end
                    BZ:     begin MUXALU1 <= 1; MUXALU2 <= 1; LoadALUOut <= 1; end                    
                    MOVE:   begin LoadA <= 1; end
                    CMOV:   begin LoadA <= 1; LoadB <= 1; end
                    HALT_:  begin HALT <= 1; end
                endcase
            end

            S4: begin
                case(opcode)
                   LD:      begin  ReadDM<=1; WMFC <= 1; LoadPC <= 1; end
                   ST:      begin WriteDM <= 1; WMFC <= 1; LoadPC <= 1; end
                   HALT_:    begin HALT <= 1; end
                   default: begin LoadPC <= 1; end
                endcase
                end
                
            S5: begin
                case(opcode)
                   LD:      begin  LoadLMD <= 1; end
                   HALT_:    begin HALT <= 1; end
                endcase
                end
               
            S6: begin
                case(opcode)
                    ALU:    begin MUXWB <= 1; WriteRP <= 1; end
                    ADDI:   begin MUXWB <= 1; WriteRP <= 1; end
                    SUBI:   begin MUXWB <= 1; WriteRP <= 1; end
                    NOTI:   begin MUXWB <= 1; WriteRP <= 1; end
                    SLLI:   begin MUXWB <= 1; WriteRP <= 1; end
                    ANDI:   begin MUXWB <= 1; WriteRP <= 1; end
                    ORI:    begin MUXWB <= 1; WriteRP <= 1; end
                    SRLI:   begin MUXWB <= 1; WriteRP <= 1; end
                    SRAI:   begin MUXWB <= 1; WriteRP <= 1; end
                    XORI:   begin MUXWB <= 1; WriteRP <= 1; end
                    NORI:   begin MUXWB <= 1; WriteRP <= 1; end
                    LUI:    begin MUXWB <= 1; WriteRP <= 1; end
                    LD:     begin WriteRP <= 1;  end
                    MOVE:   begin MUXMOVE <= 2'b10; WriteRP <= 1;  end
                    CMOV:   begin MUXMOVE <= 2'b01; WriteRP <= 1;  end
                    HALT_:   begin HALT <= 1; end
                endcase
                end

        endcase
    end
endmodule

