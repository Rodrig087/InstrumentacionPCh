#!/usr/bin/env python

#---------------------------------------------------------------------------#
# importa las librerias modbus
#---------------------------------------------------------------------------#
from pymodbus.server.async import StartTcpServer
from pymodbus.device import ModbusDeviceIdentification
from pymodbus.datastore import ModbusSequentialDataBlock
from pymodbus.datastore import ModbusSlaveContext, ModbusServerContext
from pymodbus.transaction import ModbusRtuFramer, ModbusAsciiFramer
#import RS485

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
    context = a[0]
    register = 3        #1:Entradas discretas, 2:Bobinas, 3:Registros de retencion, 4:Registros de entrada
    slave_id = 0x00     #El id de esclavo parece ser irrelevante

    address1 = 0       #Direccion a partir de la cual se almacenaran los datos
    values1 = context[slave_id].getValues(register, address1, count=2)        #count debe ser igual al numero de valores que se alamacenara en la tabla
    #values1[0] = RS485.Peticion(18,1,1)
    #values1[1] = RS485.Peticion(18,1,3)
    values1[0] = 1
	values1[1] = 2
	log.debug("Valores esclavo1: " + str(values1))
    context[slave_id].setValues(register, address1, values1)

    address2 = 10       #Direccion a partir de la cual se almacenaran los datos
    values2 = context[slave_id].getValues(register, address2, count=2)        #count debe ser igual al numero de valores que se alamacenara $
    values2[0] = 3
	values2[1] = 4
	#values2[0] = RS485.Peticion(18,2,1)
    #values2[1] = RS485.Peticion(18,2,2)
    log.debug("Valores esclavo2: " + str(values2))
    context[slave_id].setValues(register, address2, values2)

#---------------------------------------------------------------------------#
# inicializa el alamcenamiento de datos
#---------------------------------------------------------------------------#
store = ModbusSlaveContext(
    di = ModbusSequentialDataBlock(0, [0]*1),           #1 espacio de memoria reservado para las entradas discretas
    co = ModbusSequentialDataBlock(0, [0]*1),           #Reserva la memoria rellenando con el valor [n]
    hr = ModbusSequentialDataBlock(0, [0]*1000),        #1000 espacios de memoria reservados para los holding register
    ir = ModbusSequentialDataBlock(0, [0]*1))
context = ModbusServerContext(slaves=store, single=True)

#---------------------------------------------------------------------------#
# Corre el servidor
#---------------------------------------------------------------------------#
id=1

time = 5 # 5 seconds delay
loop = LoopingCall(f=Actualizar_datos, a=(context,))
loop.start(time, now=False) # initially delay by time
StartTcpServer(context, address=("192.168.0.101", 5020))
#StartTcpServer(context, address=("192.168.1.11", 5020))
