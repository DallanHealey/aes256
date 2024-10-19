module aes256_decrypt (
    input logic clk_i,
    input logic rst_i,

    input  logic [7:0] data_i,
    output logic [7:0] data_o
);

`include "SBOX"

localparam logic [255:0] KEY = 256'h112233445566778899AABBCCDDEEFF;

typedef enum {
    IDLE, ROUND
} state_t;
state_t state, next_state;

always_ff @( posedge clk_i, posedge rst_i ) begin
    if (rst_i == 1'b1) begin
        data_o <= 8'h00;
        state <= IDLE;
    end else begin
        state <= next_state;
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
