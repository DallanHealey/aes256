/*
Rijndael Forward S-box (https://en.wikipedia.org/wiki/Rijndael_S-box#Forward_S-box)
    00  01  02  03  04  05  06  07  08  09  0a  0b  0c  0d  0e  0f
00  63  7c  77  7b  f2  6b  6f  c5  30  01  67  2b  fe  d7  ab  76
10  ca  82  c9  7d  fa  59  47  f0  ad  d4  a2  af  9c  a4  72  c0
20  b7  fd  93  26  36  3f  f7  cc  34  a5  e5  f1  71  d8  31  15
30  04  c7  23  c3  18  96  05  9a  07  12  80  e2  eb  27  b2  75
40  09  83  2c  1a  1b  6e  5a  a0  52  3b  d6  b3  29  e3  2f  84
50  53  d1  00  ed  20  fc  b1  5b  6a  cb  be  39  4a  4c  58  cf
60  d0  ef  aa  fb  43  4d  33  85  45  f9  02  7f  50  3c  9f  a8
70  51  a3  40  8f  92  9d  38  f5  bc  b6  da  21  10  ff  f3  d2
80  cd  0c  13  ec  5f  97  44  17  c4  a7  7e  3d  64  5d  19  73
90  60  81  4f  dc  22  2a  90  88  46  ee  b8  14  de  5e  0b  db
a0  e0  32  3a  0a  49  06  24  5c  c2  d3  ac  62  91  95  e4  79
b0  e7  c8  37  6d  8d  d5  4e  a9  6c  56  f4  ea  65  7a  ae  08
c0  ba  78  25  2e  1c  a6  b4  c6  e8  dd  74  1f  4b  bd  8b  8a
d0  70  3e  b5  66  48  03  f6  0e  61  35  57  b9  86  c1  1d  9e
e0  e1  f8  98  11  69  d9  8e  94  9b  1e  87  e9  ce  55  28  df
f0  8c  a1  89  0d  bf  e6  42  68  41  99  2d  0f  b0  54  bb  16
*/
localparam logic [0:15][0:15][7:0] SBOX_FORWARD = {{
    {8'h63, 8'h7c, 8'h77, 8'h7b, 8'hf2, 8'h6b, 8'h6f, 8'hc5, 8'h30, 8'h01, 8'h67, 8'h2b, 8'hfe, 8'hd7, 8'hab, 8'h76},
    {8'hca, 8'h82, 8'hc9, 8'h7d, 8'hfa, 8'h59, 8'h47, 8'hf0, 8'had, 8'hd4, 8'ha2, 8'haf, 8'h9c, 8'ha4, 8'h72, 8'hc0},
    {8'hb7, 8'hfd, 8'h93, 8'h26, 8'h36, 8'h3f, 8'hf7, 8'hcc, 8'h34, 8'ha5, 8'he5, 8'hf1, 8'h71, 8'hd8, 8'h31, 8'h15},
    {8'h04, 8'hc7, 8'h23, 8'hc3, 8'h18, 8'h96, 8'h05, 8'h9a, 8'h07, 8'h12, 8'h80, 8'he2, 8'heb, 8'h27, 8'hb2, 8'h75},
    {8'h09, 8'h83, 8'h2c, 8'h1a, 8'h1b, 8'h6e, 8'h5a, 8'ha0, 8'h52, 8'h3b, 8'hd6, 8'hb3, 8'h29, 8'he3, 8'h2f, 8'h84},
    {8'h53, 8'hd1, 8'h00, 8'hed, 8'h20, 8'hfc, 8'hb1, 8'h5b, 8'h6a, 8'hcb, 8'hbe, 8'h39, 8'h4a, 8'h4c, 8'h58, 8'hcf},
    {8'hd0, 8'hef, 8'haa, 8'hfb, 8'h43, 8'h4d, 8'h33, 8'h85, 8'h45, 8'hf9, 8'h02, 8'h7f, 8'h50, 8'h3c, 8'h9f, 8'ha8},
    {8'h51, 8'ha3, 8'h40, 8'h8f, 8'h92, 8'h9d, 8'h38, 8'hf5, 8'hbc, 8'hb6, 8'hda, 8'h21, 8'h10, 8'hff, 8'hf3, 8'hd2},
    {8'hcd, 8'h0c, 8'h13, 8'hec, 8'h5f, 8'h97, 8'h44, 8'h17, 8'hc4, 8'ha7, 8'h7e, 8'h3d, 8'h64, 8'h5d, 8'h19, 8'h73},
    {8'h60, 8'h81, 8'h4f, 8'hdc, 8'h22, 8'h2a, 8'h90, 8'h88, 8'h46, 8'hee, 8'hb8, 8'h14, 8'hde, 8'h5e, 8'h0b, 8'hdb},
    {8'he0, 8'h32, 8'h3a, 8'h0a, 8'h49, 8'h06, 8'h24, 8'h5c, 8'hc2, 8'hd3, 8'hac, 8'h62, 8'h91, 8'h95, 8'he4, 8'h79},
    {8'he7, 8'hc8, 8'h37, 8'h6d, 8'h8d, 8'hd5, 8'h4e, 8'ha9, 8'h6c, 8'h56, 8'hf4, 8'hea, 8'h65, 8'h7a, 8'hae, 8'h08},
    {8'hba, 8'h78, 8'h25, 8'h2e, 8'h1c, 8'ha6, 8'hb4, 8'hc6, 8'he8, 8'hdd, 8'h74, 8'h1f, 8'h4b, 8'hbd, 8'h8b, 8'h8a},
    {8'h70, 8'h3e, 8'hb5, 8'h66, 8'h48, 8'h03, 8'hf6, 8'h0e, 8'h61, 8'h35, 8'h57, 8'hb9, 8'h86, 8'hc1, 8'h1d, 8'h9e},
    {8'he1, 8'hf8, 8'h98, 8'h11, 8'h69, 8'hd9, 8'h8e, 8'h94, 8'h9b, 8'h1e, 8'h87, 8'he9, 8'hce, 8'h55, 8'h28, 8'hdf},
    {8'h8c, 8'ha1, 8'h89, 8'h0d, 8'hbf, 8'he6, 8'h42, 8'h68, 8'h41, 8'h99, 8'h2d, 8'h0f, 8'hb0, 8'h54, 8'hbb, 8'h16}
}};


/*
Rijndael Inverse S-box (https://en.wikipedia.org/wiki/Rijndael_S-box#Inverse_S-box)
    00  01  02  03  04  05  06  07  08  09  0a  0b  0c  0d  0e  0f
00  52  09  6a  d5  30  36  a5  38  bf  40  a3  9e  81  f3  d7  fb
10  7c  e3  39  82  9b  2f  ff  87  34  8e  43  44  c4  de  e9  cb
20  54  7b  94  32  a6  c2  23  3d  ee  4c  95  0b  42  fa  c3  4e
30  08  2e  a1  66  28  d9  24  b2  76  5b  a2  49  6d  8b  d1  25
40  72  f8  f6  64  86  68  98  16  d4  a4  5c  cc  5d  65  b6  92
50  6c  70  48  50  fd  ed  b9  da  5e  15  46  57  a7  8d  9d  84
60  90  d8  ab  00  8c  bc  d3  0a  f7  e4  58  05  b8  b3  45  06
70  d0  2c  1e  8f  ca  3f  0f  02  c1  af  bd  03  01  13  8a  6b
80  3a  91  11  41  4f  67  dc  ea  97  f2  cf  ce  f0  b4  e6  73
90  96  ac  74  22  e7  ad  35  85  e2  f9  37  e8  1c  75  df  6e
a0  47  f1  1a  71  1d  29  c5  89  6f  b7  62  0e  aa  18  be  1b
b0  fc  56  3e  4b  c6  d2  79  20  9a  db  c0  fe  78  cd  5a  f4
c0  1f  dd  a8  33  88  07  c7  31  b1  12  10  59  27  80  ec  5f
d0  60  51  7f  a9  19  b5  4a  0d  2d  e5  7a  9f  93  c9  9c  ef
e0  a0  e0  3b  4d  ae  2a  f5  b0  c8  eb  bb  3c  83  53  99  61
f0  17  2b  04  7e  ba  77  d6  26  e1  69  14  63  55  21  0c  7d
*/
localparam logic [0:15][0:15][7:0] SBOX_INVERSE = {{
    {8'h52, 8'h09, 8'h6a, 8'hd5, 8'h30, 8'h36, 8'ha5, 8'h38, 8'hbf, 8'h40, 8'ha3, 8'h9e, 8'h81, 8'hf3, 8'hd7, 8'hfb},
    {8'h7c, 8'he3, 8'h39, 8'h82, 8'h9b, 8'h2f, 8'hff, 8'h87, 8'h34, 8'h8e, 8'h43, 8'h44, 8'hc4, 8'hde, 8'he9, 8'hcb},
    {8'h54, 8'h7b, 8'h94, 8'h32, 8'ha6, 8'hc2, 8'h23, 8'h3d, 8'hee, 8'h4c, 8'h95, 8'h0b, 8'h42, 8'hfa, 8'hc3, 8'h4e},
    {8'h08, 8'h2e, 8'ha1, 8'h66, 8'h28, 8'hd9, 8'h24, 8'hb2, 8'h76, 8'h5b, 8'ha2, 8'h49, 8'h6d, 8'h8b, 8'hd1, 8'h25},
    {8'h72, 8'hf8, 8'hf6, 8'h64, 8'h86, 8'h68, 8'h98, 8'h16, 8'hd4, 8'ha4, 8'h5c, 8'hcc, 8'h5d, 8'h65, 8'hb6, 8'h92},
    {8'h6c, 8'h70, 8'h48, 8'h50, 8'hfd, 8'hed, 8'hb9, 8'hda, 8'h5e, 8'h15, 8'h46, 8'h57, 8'ha7, 8'h8d, 8'h9d, 8'h84},
    {8'h90, 8'hd8, 8'hab, 8'h00, 8'h8c, 8'hbc, 8'hd3, 8'h0a, 8'hf7, 8'he4, 8'h58, 8'h05, 8'hb8, 8'hb3, 8'h45, 8'h06},
    {8'hd0, 8'h2c, 8'h1e, 8'h8f, 8'hca, 8'h3f, 8'h0f, 8'h02, 8'hc1, 8'haf, 8'hbd, 8'h03, 8'h01, 8'h13, 8'h8a, 8'h6b},
    {8'h3a, 8'h91, 8'h11, 8'h41, 8'h4f, 8'h67, 8'hdc, 8'hea, 8'h97, 8'hf2, 8'hcf, 8'hce, 8'hf0, 8'hb4, 8'he6, 8'h73},
    {8'h96, 8'hac, 8'h74, 8'h22, 8'he7, 8'had, 8'h35, 8'h85, 8'he2, 8'hf9, 8'h37, 8'he8, 8'h1c, 8'h75, 8'hdf, 8'h6e},
    {8'h47, 8'hf1, 8'h1a, 8'h71, 8'h1d, 8'h29, 8'hc5, 8'h89, 8'h6f, 8'hb7, 8'h62, 8'h0e, 8'haa, 8'h18, 8'hbe, 8'h1b},
    {8'hfc, 8'h56, 8'h3e, 8'h4b, 8'hc6, 8'hd2, 8'h79, 8'h20, 8'h9a, 8'hdb, 8'hc0, 8'hfe, 8'h78, 8'hcd, 8'h5a, 8'hf4},
    {8'h1f, 8'hdd, 8'ha8, 8'h33, 8'h88, 8'h07, 8'hc7, 8'h31, 8'hb1, 8'h12, 8'h10, 8'h59, 8'h27, 8'h80, 8'hec, 8'h5f},
    {8'h60, 8'h51, 8'h7f, 8'ha9, 8'h19, 8'hb5, 8'h4a, 8'h0d, 8'h2d, 8'he5, 8'h7a, 8'h9f, 8'h93, 8'hc9, 8'h9c, 8'hef},
    {8'ha0, 8'he0, 8'h3b, 8'h4d, 8'hae, 8'h2a, 8'hf5, 8'hb0, 8'hc8, 8'heb, 8'hbb, 8'h3c, 8'h83, 8'h53, 8'h99, 8'h61},
    {8'h17, 8'h2b, 8'h04, 8'h7e, 8'hba, 8'h77, 8'hd6, 8'h26, 8'he1, 8'h69, 8'h14, 8'h63, 8'h55, 8'h21, 8'h0c, 8'h7d}
}};
