# *********************************************************
# Relative Stage Movement
#
# Stephanie Fung 2015
# *********************************************************

# Import modules.
# ---------------------------------------------------------
import visa
import string
import struct
import sys
import serial

# =========================================================
# Initialize Newark:
# =========================================================
def NewmarkInit():
    # set units to micron -- 25 steps = 1 micron
    Newmark.write('AA;UU25,25;')

# =========================================================
# Newmark Move Relative function:
# =========================================================
def moveRel(axis,distance):
    if axis == 'x' or axis == 'X':
        Newmark.write('AX;MR' + str(distance) + ';GO;')
    if axis == 'z' or axis == 'Z':
        Newmark.write('AY;MR' + str(distance) + ';GO;')

# =========================================================
# Main program:
# =========================================================
# Initialize the stage
## Newmark Stage
Newmark = serial.Serial()
Newmark.port = "COM6"
#Newmark.close()
Newmark.timeout = 0.1
print Newmark
Newmark.open()
Newmark.isOpen
NewmarkInit()

## Move position
moveRel('z',0)
# negative moves UP, positive moves DOWN
moveRel('x',0)
# negative moves LEFT, positive moves RIGHT

# Close the serial connection to the Newmark stage
Newmark.close()
Newmark.isOpen()

print "End of program."
