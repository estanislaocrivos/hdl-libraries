module tb_fifo;

    parameter int DW = 8;
    parameter int D  = 8;

    logic            clk, rst_n;
    logic            wr_en, rd_en;
    logic [DW-1:0]   wr_data, rd_data;
    logic            full, empty;

    fifo #(.DATA_WIDTH(DW), .DEPTH(D)) dut (.*);

    always #5 clk = ~clk;

    task write(input logic [DW-1:0] data);
        @(posedge clk);
        wr_en = 1; wr_data = data;
        @(posedge clk);
        wr_en = 0;
    endtask

    task read();
        @(posedge clk);
        rd_en = 1;
        @(posedge clk);
        rd_en = 0;
    endtask

    initial begin
        $dumpfile("tb_fifo.vcd");
        $dumpvars(0, tb_fifo);

        clk = 0; rst_n = 0;
        wr_en = 0; rd_en = 0; wr_data = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;

        write(8'hAA);
        write(8'hBB);
        write(8'hCC);

        read(); $display("rd_data = %0h (esperado AA)", rd_data);
        read(); $display("rd_data = %0h (esperado BB)", rd_data);
        read(); $display("rd_data = %0h (esperado CC)", rd_data);

        $display("empty = %0b (esperado 1)", empty);
        $finish;
    end

endmodule
