#!/usr/bin/env python

#---------------------------------------------------------------------------# 
# importa las librerias modbus
#---------------------------------------------------------------------------# 
from pymodbus.server.async import StartTcpServer
from pymodbus.device import ModbusDeviceIdentification
from pymodbus.datastore import ModbusSequentialDataBlock
from pymodbus.datastore import ModbusSlaveContext, ModbusServerContext
from pymodbus.transaction import ModbusRtuFramer, ModbusAsciiFramer
import RS485

#---------------------------------------------------------------------------# 
# importa las librerias twisted 
#---------------------------------------------------------------------------# 
from twisted.internet.task import LoopingCall

#---------------------------------------------------------------------------# 
# configura el servicio logging
#---------------------------------------------------------------------------# 
import logging
logging.basicConfig()
log = logging.getLogger()
log.setLevel(logging.DEBUG)

#---------------------------------------------------------------------------# 
# define el proceso de devolucion de llamada
#---------------------------------------------------------------------------# 
def Actualizar_datos(a):
    log.debug("Actualizando datos")
    context  = a[0]
    register = 3	#1:Entradas discretas, 2:Bobinas, 3:Registros de retencion, 4:Registros de entrada
    slave_id = 0x00	#El id de esclavo parece ser irrelevante

    address1  = 0	#Direccion a partir de la cual se almacenaran los datos  
    values1   = context[slave_id].getValues(register, address1, count=6)	#count debe ser igual al numero de valores que se alamacenara en la tabla
    values1[0] = RS485.Peticion(18,1,1,1)	#Solicita el dato de Nivel
    values1[1] = RS485.Peticion(18,1,2,2)	#Solicita el dato de Caudal
    values1[2] = RS485.Peticion(18,1,2,3)       #Solicita el dato de Distancia
    values1[3] = RS485.Peticion(18,1,2,4)       #Solicita el dato de TOF
    values1[4] = RS485.Peticion(18,1,2,5)       #Solicita el dato de Temperatura
    values1[5] = RS485.Peticion(18,1,2,6)       #Solicita el dato de Altura
#    values1[0] = 50
#    values1[1] = 965
#    values1[2] = 100
#    values1[3] = 1987
#    values1[4] = 21
#    values1[5] = 275       
    log.debug("Valores esclavo1: " + str(values1))
    context[slave_id].setValues(register, address1, values1)   
 
    address2  = 10       #Direccion a partir de la cual se almacenaran los datos  
    values2   = context[slave_id].getValues(register, address2, count=2)        #count debe ser igual al numero de valores que se alamacenara $
    values2[0] = RS485.Peticion(18,2,2,1)	#Solicita el dato de Temperatura
    values2[1] = RS485.Peticion(18,2,2,2)	#solicita el dato de Humedad
#    values2[0] = 21
#    values2[1] = 55  
    log.debug("Valores esclavo2: " + str(values2))
    context[slave_id].setValues(register, address2, values2)

#---------------------------------------------------------------------------# 
# inicializa el almacenamiento de datos
#---------------------------------------------------------------------------# 
store = ModbusSlaveContext(
    di = ModbusSequentialDataBlock(0, [0]*1),		#1 espacio de memoria reservado para las entradas discretas
    co = ModbusSequentialDataBlock(0, [0]*1),		#Reserva la memoria rellenando con el valor [n]
    hr = ModbusSequentialDataBlock(0, [0]*1000),	#1000 espacios de memoria reservados para los holding register
    ir = ModbusSequentialDataBlock(0, [0]*1))
context = ModbusServerContext(slaves=store, single=True)

#---------------------------------------------------------------------------# 
# Corre el servidor
#---------------------------------------------------------------------------# 
id=1

time = 5 # 5 seconds delay
loop = LoopingCall(f=Actualizar_datos, a=(context,))
loop.start(time, now=False) # initially delay by time
StartTcpServer(context, address=("192.168.0.101", 502))
#StartTcpServer(context, address=("192.168.1.11", 5020))
