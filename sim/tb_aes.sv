module tb_aes();

logic clk_i;
logic rst_i;
logic [127:0] axis_tdata_i;
logic         axis_tvalid_i;
logic         axis_tlast_i;
logic [127:0] axis_tdata_o;
logic         axis_tvalid_o;

int f_o;
`define DUT aes256_encrypt

initial begin
    clk_i = 1'b0;
    rst_i = 1'b1;
end

always begin
    #4ns clk_i <= !clk_i;
end

// Util function to flip bytes so they match the test vectors
function logic [0:127] flip_bytes(input logic [127:0] data_i);
    logic [127:0] temp;
    
    for (int i = 0; i < 128/8; i++) begin
        temp[(128/8-i-1)*8+7-:8] = data_i[i*8+7-:8];
    end

    return temp;
endfunction

initial begin
    f_o = $fopen("output.dat", "w");
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
    
    // while (`DUT.operation_counter <= 15-1) begin
    //     wait(axis_tvalid_o == 1'b1);
    //     $fwrite(f_o, "Operation: %d, State: %s: %x\n", `DUT.operation_counter, `DUT.next_state.name(), flip_bytes(axis_tdata_o));
    //     @(posedge clk_i);
    // end

    #1us;
    // assert(data_o == data_i) else $error("TX does not match RX");

    $fclose(f_o);
    $finish;
end

aes256_encrypt aes256_encrypt (
    .*
);

always_ff @(posedge clk_i) begin
    if (axis_tvalid_o == 1'b1) begin
        if (`DUT.state == `DUT.ADD_ROUNDKEY) begin
            $fwrite(f_o, "Operation: %d, State: %s: %x\n", `DUT.operation_counter, "KEY_SCHEDULE", flip_bytes(`DUT.get_round_key_group(`DUT.round_keys, `DUT.round_keys_counter)));
        end

        $fwrite(f_o, "Operation: %d, State: %s: %x\n", `DUT.operation_counter, `DUT.state.name(), flip_bytes(axis_tdata_o));
    end
end


endmodule
