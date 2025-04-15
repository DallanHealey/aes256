module aes256_encrypt (
    input logic clk_i,
    input logic rst_i,

    input  logic [127:0] axis_tdata_i,
    input  logic         axis_tvalid_i,
    input  logic         axis_tlast_i,
    output logic [127:0] axis_tdata_o
);

`include "SBOX"

// Using key from here for testing: https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf#page=35
localparam logic [255:0] KEY = 256'hf4df1409a310982dd708613b072c351f81777d85f0ae732bbe71ca1510eb3d60;
localparam logic [31:0] rconn[0:6] = {32'h00000001, 32'h00000002, 32'h00000004, 32'h00000008, 32'h00000010, 32'h00000020, 32'h00000040};

localparam NUM_ROUND_KEYS_NEEDED = 'd15;
logic [31:0] round_keys[0:NUM_ROUND_KEYS_NEEDED*4-1];
logic [31:0] next_round_keys[0:NUM_ROUND_KEYS_NEEDED*4-1];
int round_keys_counter;
int next_round_keys_counter;

typedef enum {
    IDLE, ROUND
} state_t;
state_t state, next_state;

always_ff @( posedge clk_i, posedge rst_i ) begin
    if (rst_i == 1'b1) begin
        axis_tdata_o <= 128'h00;
        state <= IDLE;
        round_keys_counter <= 0;
        // round_keys <= {NUM_ROUND_KEYS_NEEDED*4-1{32'h00}};
    end else begin
        state <= next_state;
        round_keys <= next_round_keys;
        round_keys_counter <= next_round_keys_counter;
    end
end


logic [7:0] test;
always_comb begin
    next_round_keys = round_keys;
    next_round_keys_counter = round_keys_counter;

    unique case (state)
        IDLE : begin
            next_state = ROUND;
        end

        ROUND : begin
            next_state = ROUND;
            next_round_keys_counter = round_keys_counter + 1;

            if (round_keys_counter < 8) begin
                next_round_keys[round_keys_counter] = KEY[round_keys_counter*32+31-:32];
            end else if (round_keys_counter < 16) begin
                if (round_keys_counter == 8) begin
                    next_round_keys[round_keys_counter] = round_keys[round_keys_counter-8] ^ ({SBOX_FORWARD[round_keys[round_keys_counter-1][7:4]][round_keys[round_keys_counter-1][3:0]],
                                                                                                SBOX_FORWARD[round_keys[round_keys_counter-1][31:28]][round_keys[round_keys_counter-1][27:24]],
                                                                                                SBOX_FORWARD[round_keys[round_keys_counter-1][23:20]][round_keys[round_keys_counter-1][19:16]],
                                                                                                SBOX_FORWARD[round_keys[round_keys_counter-1][15:12]][round_keys[round_keys_counter-1][11:8]]})
                                                                                           ^ rconn[round_keys_counter-8];
                end else begin
                    next_round_keys[round_keys_counter] = round_keys[round_keys_counter-8] ^ ({SBOX_FORWARD[round_keys[round_keys_counter-1][7:4]][round_keys[round_keys_counter-1][3:0]],
                                                                                                SBOX_FORWARD[round_keys[round_keys_counter-1][31:28]][round_keys[round_keys_counter-1][27:24]],
                                                                                                SBOX_FORWARD[round_keys[round_keys_counter-1][23:20]][round_keys[round_keys_counter-1][19:16]],
                                                                                                SBOX_FORWARD[round_keys[round_keys_counter-1][15:12]][round_keys[round_keys_counter-1][11:8]]});
                end
            end
        end
    endcase
end

endmodule
