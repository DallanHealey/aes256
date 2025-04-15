module tb_aes();

logic clk_i;
logic rst_i;
logic [127:0] axis_tdata_i;
logic         axis_tvalid_i;
logic         axis_tlast_i;
logic [127:0] axis_tdata_o;

initial begin
    clk_i = 1'b0;
    rst_i = 1'b1;
end

always begin
    #4ns clk_i <= !clk_i;
end

initial begin
    $dumpfile("vsim.fst");
    $dumpvars(0, tb_aes);

    axis_tdata_i = 128'h0;
    axis_tvalid_i = 1'b0;
    axis_tlast_i = 1'b0;

    #1us;
    @(posedge clk_i);
    rst_i = 1'b0;

    #1us;

    @(posedge clk_i);
    axis_tdata_i = 128'hffeeddccbbaa99887766554433221100;
    axis_tvalid_i = 1'b1;
    
    #1us;
    // assert(data_o == data_i) else $error("TX does not match RX");

    $finish;
end

aes256_encrypt aes256_encrypt (
    .*
);

endmodule
