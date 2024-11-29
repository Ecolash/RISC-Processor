module reg_bank(
    input [31:0] write_data,
    input clk,
    input reset,
    input [3:0] reg_select,
    input [3:0] write_port,
    input [3:0] read_port1,
    input [3:0] read_port2,
    input read,
    input write,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2,
    output [31:0] reg_data_select
);

    reg [31:0] bank[15:0]; 
    assign reg_data_select = bank[reg_select];

    always @(negedge clk or posedge reset) begin
        if (reset) begin
            read_data1 <= 32'b0;
            read_data2 <= 32'b0;
        end else if (read == 1'b1) begin
            read_data1 <= bank[read_port1];
            read_data2 <= bank[read_port2];
        end else begin
            read_data1 <= read_data1;
            read_data2 <= read_data2;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bank[0] <= {28'b0, 4'b0000};
            bank[1] <= {28'b0, 4'b0000};
            bank[2] <= {28'b0, 2'b0010};
            bank[3] <= {28'b0, 4'b0011};
            bank[4] <= {28'b0, 4'b0100};
            bank[5] <= {28'b0, 4'b0101};
            bank[6] <= {28'b0, 4'b0110};
            bank[7] <= {28'b0, 4'b0111};
            bank[8] <= {28'b0, 4'b1000};
            bank[9] <= {28'b0, 4'b1001};
            bank[10] <= {28'b0, 4'b1010};
            bank[11] <= {28'b0, 4'b1011};
            bank[12] <= {28'b0, 4'b1100};
            bank[13] <= {28'b0, 4'b1101};
            bank[14] <= {28'b0, 4'b1110};
            bank[15] <= {28'b0, 4'b1111};
        end else if (write == 1'b1) begin
            bank[write_port] <= write_data;
        end else begin
            bank[0] <= bank[0];
            bank[1] <= bank[1];
            bank[2] <= bank[2];
            bank[3] <= bank[3];
            bank[4] <= bank[4];
            bank[5] <= bank[5];
            bank[6] <= bank[6];
            bank[7] <= bank[7];
            bank[8] <= bank[8];
            bank[9] <= bank[9];
            bank[10] <= bank[10];
            bank[11] <= bank[11];
            bank[12] <= bank[12];
            bank[13] <= bank[13];
            bank[14] <= bank[14];
            bank[15] <= bank[15];
        end
    end

endmodule
