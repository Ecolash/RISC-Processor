module clock_div(clk_out,clk_in,reset);
	input clk_in;
	input reset;
	output clk_out;
    reg [18:0] counter;
	assign clk_out = counter[18];
	always @(negedge clk_in or posedge reset)
    begin
        if(reset) counter = 19'b0;
        else counter = counter + 1;
    end
endmodule

module wrapper_processor(in, out, reset, clk);
    input[3:0] in;
    output reg [15:0] out;
    input reset, clk;
    wire new_clk;
    wire [31:0] ALUout;

    clock_div clock(new_clk, clk, reset);
    processor_top processor(ALUout, new_clk, reset,in);
    always @(posedge new_clk or posedge reset) begin
        if (reset) out <= 16'b0;
        else out <= ALUout[15:0];
    end
endmodule
