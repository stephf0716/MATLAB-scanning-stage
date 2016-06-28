import serial
import string
import sys

# Global variables (booleans: 0 = False, 1 = True).
# ---------------------------------------------------------
debug = 0

#Initialize the devices
ser = serial.Serial()
ser.port = "COM6"
ser.timeout = 0.1
print ser

ser.open()
print ser.isOpen()  # prints True if opened successfully

# check for the units for each axis
ser.write('AA;UU25,25;')
ser.write('AX;')
ser.write('?UU;')
print(ser.readall())

ser.write('AY;')
ser.write('?UU;')
print(ser.readall())

ser.close()
print ser.isOpen()  # prints False if connection closed successfully

