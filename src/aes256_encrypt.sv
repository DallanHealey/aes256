module aes256_encrypt (
    input logic clk_i,
    input logic rst_i,

    input  logic [127:0] axis_tdata_i,
    input  logic         axis_tvalid_i,
    input  logic         axis_tlast_i,
    
    output logic [127:0] axis_tdata_o,
    output logic         axis_tvalid_o
);

`include "utils"

// Using key from here for testing: https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf#page=47
localparam logic [255:0] KEY        = 256'h1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
localparam logic [ 31:0] RCONN[0:6] = {32'h00000001, 32'h00000002, 32'h00000004, 32'h00000008, 32'h00000010, 32'h00000020, 32'h00000040};

localparam   NUM_ROUND_KEYS_NEEDED = 'd15;
logic [31:0] round_keys[0:NUM_ROUND_KEYS_NEEDED*4-1];
logic [31:0] next_round_keys[0:NUM_ROUND_KEYS_NEEDED*4-1];
int round_keys_counter;
int next_round_keys_counter;

int operation_counter;
int next_operation_counter;

logic [127:0] data_state;
logic [127:0] next_data_state;

typedef enum {
    GENERATE_ROUND, WAIT_FOR_VALID_DATA, ADD_ROUNDKEY, SUB_BYTES, SHIFT_ROWS, MIX_COLUMNS, DONE
} state_t;
state_t state, next_state;

always_ff @( posedge clk_i, posedge rst_i ) begin
    if (rst_i == 1'b1) begin
        state <= GENERATE_ROUND;
        round_keys_counter <= 0;
        data_state <= 128'h0;
        // round_keys <= {NUM_ROUND_KEYS_NEEDED*4-1{32'h00}};
        operation_counter <= 0;
        // axis_tdata_o <= 128'h0;
        // axis_tvalid_o <= 1'b0;
    end else begin
        state <= next_state;
        round_keys <= next_round_keys;
        round_keys_counter <= next_round_keys_counter;
        data_state <= next_data_state;
        operation_counter <= next_operation_counter;

        // axis_tdata_o <= data_state;
        // axis_tvalid_o <= 1'b1;
        // if (state == DONE) begin
        //     axis_tvalid_o <= 1'b0;
        // end
    end
end

assign axis_tdata_o = next_data_state;

always_comb begin
    next_state = state;
    next_round_keys = round_keys;
    next_round_keys_counter = round_keys_counter;
    next_data_state = data_state;
    next_operation_counter = operation_counter;
    axis_tvalid_o = 1'b1;

    unique case (state)
        GENERATE_ROUND : begin
            axis_tvalid_o = 1'b0;

            if (round_keys_counter == NUM_ROUND_KEYS_NEEDED*4-1) begin
                next_state = WAIT_FOR_VALID_DATA;
                next_round_keys_counter = 0;
            end else begin
                next_round_keys_counter = round_keys_counter + 1;
            end

            if (round_keys_counter < 8) begin
                next_round_keys[round_keys_counter] = KEY[round_keys_counter*32+31-:32];
            end else if (round_keys_counter >= 8 && round_keys_counter % 8 == 0) begin
                next_round_keys[round_keys_counter] = round_keys[round_keys_counter - 8] ^ sbox_f_32(rotword(round_keys[round_keys_counter - 1])) ^ RCONN[(round_keys_counter - 8) / 8];
            end else if (round_keys_counter >= 8 && round_keys_counter % 8 == 4) begin
                // N (length of key in 32-bit words) also needs to be greater than 6, which it is because we are doing AES256
                next_round_keys[round_keys_counter] = round_keys[round_keys_counter - 8] ^ sbox_f_32(round_keys[round_keys_counter - 1]);
            end else begin
                next_round_keys[round_keys_counter] = round_keys[round_keys_counter - 8] ^ round_keys[round_keys_counter - 1];
            end
        end

        WAIT_FOR_VALID_DATA : begin
            axis_tvalid_o = 1'b0;
            
            if (axis_tvalid_i == 1'b1) begin
                next_data_state = axis_tdata_i;
                next_state = ADD_ROUNDKEY;
            end
        end

        ADD_ROUNDKEY : begin
            if (operation_counter == NUM_ROUND_KEYS_NEEDED-1) begin
                next_state = DONE;
                next_operation_counter = 0;
            end else begin
                next_state = SUB_BYTES;
            end
            
            next_round_keys_counter = round_keys_counter + 4;
            if (operation_counter == 0) begin
                next_data_state = axis_tdata_i ^ get_round_key_group(round_keys, round_keys_counter);
            end else begin
                next_data_state = data_state ^ get_round_key_group(round_keys, round_keys_counter);
            end
        end

        SUB_BYTES : begin
            next_state = SHIFT_ROWS;
            next_data_state = sbox_f_128(data_state);
        end

        SHIFT_ROWS : begin
            next_data_state = shift_rows_128(data_state);
            
            if (operation_counter < NUM_ROUND_KEYS_NEEDED-2) begin
                next_state = MIX_COLUMNS;
                next_operation_counter = operation_counter + 1;
            end else begin
                next_state = ADD_ROUNDKEY;
                next_operation_counter = operation_counter + 1;
            end
        end

        MIX_COLUMNS : begin
            next_state = ADD_ROUNDKEY;
            next_data_state = {multiply_helper(data_state[127:96]), multiply_helper(data_state[95:64]), multiply_helper(data_state[63:32]), multiply_helper(data_state[31:0])};
        end

        DONE : begin
            axis_tvalid_o = 1'b0;
        end
    endcase
end

endmodule
