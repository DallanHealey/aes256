module aes256_decrypt (
    input logic clk_i,
    input logic rst_i,

    input  logic [7:0] data_i,
    output logic [7:0] data_o
);

`include "utils"

localparam logic [255:0] KEY = 256'hf4df1409a310982dd708613b072c351f81777d85f0ae732bbe71ca1510eb3d60;

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
