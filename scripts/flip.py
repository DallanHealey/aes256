#!/bin/python3

#
# Flip bytes
# Useful for anything that the AES spec uses because they are expecting byte 0 as start index but we handle data the other way
#

a = "E7D0CABA51B770CD04E160098CE05363"

a_flipped = ""
i = 0
while i < len(a):
    a_flipped = a[i:i+2] + a_flipped
    i += 2

print(a)
print(a_flipped)
