import serial
import binascii

port = serial.Serial("/dev/ttyAMA0", baudrate=9600, timeout=1.0)

def makeValue(highbyte, lowbyte):
      print int(highbyte, 16)*256 + int(lowbyte, 16)

while True:

      rcv = port.read(1)

      if rcv == chr(58):

         dato = port.read(6)
	 id=dato[0]
	 fcn=dato[1]
	 R1=dato[2]
	 R2=dato[3]

	 one = binascii.hexlify(R1)
	 two = binascii.hexlify(R2)
	 	
	 makeValue(one,two)	 

	
	 print "Dato:"
	
	 #print R
	 #print("".join([ch.encode("hex")  for line in R for ch in line]))
	 #print (ord(R)+5)
	 
