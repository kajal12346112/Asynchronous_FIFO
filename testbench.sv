`timescale 1ns/1ps

module async_fifo_tb;

parameter DATA_WIDTH = 8;
parameter ADDR_SIZE  = 3;

reg wr_clk, rd_clk, rst;
reg wr_en, rd_en;
reg [DATA_WIDTH-1:0] wdata;

wire [DATA_WIDTH-1:0] rdata;
wire full, empty;

// Instantiate FIFO
async_fifo_top #(DATA_WIDTH, ADDR_SIZE) DUT (
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .wdata(wdata),
    .rdata(rdata),
    .full(full),
    .empty(empty)
);

# 🔹 Clock Generation (Different Frequencies)
initial begin
    wr_clk = 0;
    forever #5 wr_clk = ~wr_clk;   // 100 MHz
end

initial begin
    rd_clk = 0;
    forever #7 rd_clk = ~rd_clk;   // ~71 MHz
end

# 🔹 Reset
initial begin
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    wdata = 0;
    #20;
    rst = 0;
end

# 🔹 Write Task
task write_data(input [7:0] data);
begin
    @(posedge wr_clk);
    if (!full) begin
        wr_en = 1;
        wdata = data;
    end else begin
        wr_en = 0;
    end
end
endtask

# 🔹 Read Task
task read_data;
begin
    @(posedge rd_clk);
    if (!empty)
        rd_en = 1;
    else
        rd_en = 0;
end
endtask

# 🔹 Stimulus
integer i;

initial begin
    // Wait for reset
    @(negedge rst);

    // -----------------------------
    // WRITE PHASE
    // -----------------------------
    $display("---- WRITE PHASE ----");
    for (i = 0; i < 10; i = i + 1) begin
        write_data(i);
    end
    wr_en = 0;

    #50;

    // -----------------------------
    // READ PHASE
    // -----------------------------
    $display("---- READ PHASE ----");
    for (i = 0; i < 10; i = i + 1) begin
        read_data();
    end
    rd_en = 0;

    #50;

    // -----------------------------
    // SIMULTANEOUS READ/WRITE
    // -----------------------------
    $display("---- SIMULTANEOUS PHASE ----");
    fork
        begin
            for (i = 10; i < 20; i = i + 1)
                write_data(i);
            wr_en = 0;
        end
        begin
            #20;
            for (i = 0; i < 10; i = i + 1)
                read_data();
            rd_en = 0;
        end
    join

    #100;

    $display("Simulation Finished");
    $stop;
end

# 🔹 Monitor Signals
initial begin
    $monitor("Time=%0t | wr_en=%b rd_en=%b | wdata=%0d rdata=%0d | full=%b empty=%b",
              $time, wr_en, rd_en, wdata, rdata, full, empty);
end

endmodule
