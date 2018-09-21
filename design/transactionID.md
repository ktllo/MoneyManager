# Transaction ID format
The transaction ID consists of 3 parts:
* A 64 bit UNIX-timestamp in milliseconds.
* A 56 bit unique node identifier
* A 8 bit constant 0 (0x00)

The whole identifier are recorded in base16 format, which the total length of the transaction ID is 32 bytes

## Sub-transaction ID
The Sub-transaction ID consists of 3 parts:
* The first 120bit of the transaction ID as above, which consists
  * A 64 bit UNIX-timestamp in milliseconds.
  * A 56 bit unique node identifier
* A 8 bit number counting from 1

The whole identifier are recorded in base16 format, which the total length of the transaction ID is 32 bytes

# Recommanded format for the unique node identifier
## For Servers
The first 8 bit of the identifier is 0 (0x00), followed by the MAC address of the server.

The MAC address should be replaced by a random number if the same server having more then 1 instance of the Money Manager running.
## For Android device
The last 56 bit of the device ID.
