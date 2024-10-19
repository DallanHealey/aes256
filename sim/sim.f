-j 24
--binary
tb_aes.sv
+incdir+"../src/"
../src/aes256_encrypt.sv
../src/aes256_decrypt.sv


+incdir+/mnt/g/Applications/Efinity/2024.1/sim_models/verilog
efx_add.v
efx_comb4.v
efx_dpram_5k.v
efx_dpram10.v
efx_dsp12.v
efx_dsp24.v
efx_dsp48.v
efx_ff.v
efx_gbufce.v
efx_lut4.v
efx_mult.v
efx_ram_5k.v
efx_ram_10k.v
efx_ram10.v
efx_srl8.v
--trace-fst
--assert
--timing
-Wall
-Wno-DECLFILENAME
-Wno-GENUNNAMED
-Wno-fatal

--top tb_aes