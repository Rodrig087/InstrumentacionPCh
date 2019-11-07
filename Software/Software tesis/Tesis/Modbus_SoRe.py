#!/usr/bin/env phyton
from pymodbus.client.sync import ModbusTcpClient as ModbusClient

#---------------------------------------------------------------------------# 
# configure the client logging
#---------------------------------------------------------------------------# 
import logging
logging.basicConfig()
log = logging.getLogger()
log.setLevel(logging.DEBUG)

#assing modbus server connection
#cliente = ModbusClient(host='192.168.0.101',port=502)
cliente = ModbusClient(host = '192.168.1.112',port=502)
cliente.connect()

#send write command to modbus server
write_value = input ("Valor a escribir: ")
write_register = 0
cliente.write_register(write_register, write_value)
print 'Salida: ', write_value

#send read command to modbus server
#read_register = 0
#read_qty = 1
#rr = cliente.read_holding_registers(read_register, read_qty)
#print 'Entrada: ',rr.getRegister(0)

#Cierra la conexion
cliente.close()
