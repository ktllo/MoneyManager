# Transaction ID format
The transaction ID consists of 3 parts:
* A 64 bit UNIX-timestamp in milliseconds.
* A 48 bit MAC address of the machine
* A 8 bit random bumber
* A 8 bit constant 0 (0x00)

The whole identifier are recorded in base16 format, which the total length of the transaction ID is 32 bytes

## Sub-transaction ID
The Sub-transaction ID consists of 3 parts:
* The first 120bit of the transaction ID as above, which consists
** A 64 bit UNIX-timestamp in milliseconds.
** A 48 bit MAC address of the machine
** A 8 bit random bumber
* A 8 bit number counting from 1

The whole identifier are recorded in base16 format, which the total length of the transaction ID is 32 bytes