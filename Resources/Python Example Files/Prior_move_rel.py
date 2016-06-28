# *********************************************************
# Relative Stage Movement
# 
# Stephanie Fung 2014
# *********************************************************

# Import modules.
# ---------------------------------------------------------
import visa
import string
import struct
import sys
import serial 

# =========================================================
# Initialize Prior:
# =========================================================
def PriorInit():
    # set units to 1 micron
    # need to verify this
    command_prior = "RES,s,1.0\r\n"
    Prior.write(command_prior)
    line = Prior.readline()
    print line

# =========================================================
# Prior Move Relative function:
# =========================================================
def moveRel(axis,distance):
    if axis == 'x' or axis == 'X':
        command_prior = "GR," + str(distance) + ",0,0\r\n"
        Prior.write(command_prior)
    if axis == 'y' or axis == 'Y':
        command_prior = "GR,0," + str(distance) + ",0\r\n"
        Prior.write(command_prior)

# =========================================================
# Main program:
# =========================================================
## Prior Stage
Prior = serial.Serial()
Prior.port = "COM1"
Prior.timeout = 0.1
print Prior 
Prior.open()
Prior.isOpen
PriorInit()

## Move position
moveRel('x',10000)
moveRel('y',0)

# Close the serial connection to the Prior stage
Prior.close()
Prior.isOpen()

print "End of program."
