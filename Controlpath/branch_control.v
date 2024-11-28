module branch_control(opcode,pcsel,in);
    input[31:0] in;
    input[5:0] opcode;
    output reg pcsel;
    
    always @(*) begin
        case(opcode) 
            6'b000011: pcsel<=1'b1;
            6'b000100: begin if(in[31]==1'b1)begin    
                            pcsel<=1'b1;
                       end else begin
                            pcsel<=1'b0;
                       end
                      end
            6'b000101: begin if(in[31]==1'b0)begin    
                            pcsel<=1'b1;
                       end else begin
                            pcsel<=1'b0;
                       end
                      end
            6'b000110: begin if(in==32'd0)begin    
                            pcsel<=1'b1;
                       end else begin
                            pcsel<=1'b0;
                       end
                      end
            default: pcsel<=1'b0;
       endcase 
    end
endmodule
