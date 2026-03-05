// Code your testbench here
// or`timescale 1ns/1ps

module tb_async_fifo;

reg wr_clk;
reg rd_clk;
reg rst;

reg wr_en;
reg rd_en;

reg [7:0] data_in;

wire [7:0] data_out;
wire full;
wire empty;

async_fifo_top dut(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

always #5 wr_clk = ~wr_clk;
always #7 rd_clk = ~rd_clk;

initial
begin
    wr_clk = 0;
    rd_clk = 0;
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    data_in = 0;

    #20 rst = 0;

    repeat(5)
    begin
        @(posedge wr_clk);
        wr_en = 1;
        data_in = data_in + 1;
    end

    wr_en = 0;

    repeat(5)
    begin
        @(posedge rd_clk);
        rd_en = 1;
    end

    rd_en = 0;

    #100 $finish;
end

endmodule browse Examples
