module aes256_encrypt (
    input logic clk_i,
    input logic rst_i,

    input  logic [7:0] axis_tdata_i,
    input  logic       axis_tvalid_i,
    input  logic       axis_tlast_i,
    output logic [7:0] axis_tdata_o
);

`include "SBOX"

localparam logic [255:0] KEY = 256'h112233445566778899AABBCCDDEEFF;

logic [127:0] data_storage_0;
logic [127:0] data_storage_1;
logic         data_storage_sel;

typedef enum {
    IDLE, ROUND
} state_t;
state_t state, next_state;

always_ff @( posedge clk_i, posedge rst_i ) begin
    if (rst_i == 1'b1) begin
        axis_tdata_o <= 8'h00;
        state <= IDLE;
        data_storage_0 <= 128'h0;
        data_storage_1 <= 128'h0;
        data_storage_sel <= 1'b0;
    end else begin
        state <= next_state;

        if (axis_tvalid_i == 1'b1) begin
            if (axis_tlast_i == 1'b1) begin
                data_storage_sel <= !data_storage_sel;
            end else begin
                if (data_storage_sel == 1'b0) begin
                    data_storage_0 <= {data_storage_0[120:0], axis_tdata_i};
                end else begin
                    data_storage_1 <= {data_storage_1[120:0], axis_tdata_i};
                end
            end
        end
    end
end

always_comb begin
    unique case (state)
        IDLE : begin
            next_state = IDLE;
        end

        ROUND : begin
            next_state = ROUND;
        end
    endcase
end

endmodule
