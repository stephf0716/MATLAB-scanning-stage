# *********************************************************
# This program is a simple test of the oscilloscope
# It will also list all connected resources
# *********************************************************

# Import modules
# ---------------------------------------------------------
import serial
import string
import struct
import sys

# Initialize the Prior stage
# ---------------------------------------------------------
## Prior Stage
Prior = serial.Serial()
Prior.port = "COM1"
Prior.timeout = 0.1
print Prior 
Prior.open()
Prior.isOpen
print Prior

# Talk to Prior and print out the response
command_string = "YD1\r\n"
Prior.write(command_string)
line = Prior.readline()
print line

# Close the serial connection to the Prior stage
Prior.close()
Prior.isOpen()
