#!/usr/bin/env python
'''
Pymodbus Server con actualizacion del hilo
--------------------------------------------------------------------------

Este es un ejemplo para tener un subproceso de fondo actualizando el contexto 
mientras el servidor esta funcionando. 
Esto tambien se puede hacer con un hilo de python ::

    from threading import Thread

    thread = Thread(target=updating_writer, args=(context,))
    thread.start()
'''
#---------------------------------------------------------------------------# 
# importa las librerias modbus
#---------------------------------------------------------------------------# 
from pymodbus.server.async import StartTcpServer
from pymodbus.device import ModbusDeviceIdentification
from pymodbus.datastore import ModbusSequentialDataBlock
from pymodbus.datastore import ModbusSlaveContext, ModbusServerContext
from pymodbus.transaction import ModbusRtuFramer, ModbusAsciiFramer

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
def updating_writer(a):
    ''' Un proceso de trabajo que se ejecuta de vez en cuando 
	y actualiza los valores en vivo del contexto. 
	Cabe senalar que existe una condicion de carrera para la actualizacion.

    :param arguments: The input arguments to the call
    '''
    log.debug("Actualizando el contexto")
    context  = a[0]
    register = 3
    slave_id = 0x00
    address  = 0x00
    values   = context[slave_id].getValues(register, address, count=8)

    # humidity, temperature = (56,21)
    
    # Note that sometimes you won't get a reading and
    # the results will be null (because Linux can't
    # guarantee the timing of calls to read the sensor).  
    # If this happens try again!
    #if humidity is None or temperature is None:
	#print 'Temp={0:0.1f}*  Humidity={1:0.1f}%'.format(temperature, humidity)
    #if humidity is None or temperature is None:
	#humidity, temperature = (0, 0)

    #print 'Temp={0:0.1f}*  Humidity={1:0.1f}%'.format(temperature, humidity)
    #values   = [v + 1 for v in values]
    
    values[0] = 10
    values[1] = 11
    values[2] = 12
    values[3] = 13
    values[4] = 14

    log.debug("nuevos valores: " + str(values))
    context[slave_id].setValues(register, address, values)

#---------------------------------------------------------------------------# 
# initialize your data store
#---------------------------------------------------------------------------# 
store = ModbusSlaveContext(
    di = ModbusSequentialDataBlock(0, [1]*100),
    co = ModbusSequentialDataBlock(0, [2]*100),
    hr = ModbusSequentialDataBlock(0, [3]*100),
    ir = ModbusSequentialDataBlock(0, [4]*100))
context = ModbusServerContext(slaves=store, single=True)

#---------------------------------------------------------------------------# 
# initialize the server information
#---------------------------------------------------------------------------# 
identity = ModbusDeviceIdentification()
identity.VendorName  = 'pymodbus'
identity.ProductCode = 'PM'
identity.VendorUrl   = 'http://github.com/bashwork/pymodbus/'
identity.ProductName = 'pymodbus Server'
identity.ModelName   = 'pymodbus Server'
identity.MajorMinorRevision = '1.0'

#---------------------------------------------------------------------------# 
# run the server you want
#---------------------------------------------------------------------------# 
time = 5 # 5 seconds delay
loop = LoopingCall(f=updating_writer, a=(context,))
loop.start(time, now=False) # initially delay by time
StartTcpServer(context, identity=identity, address=("192.168.1.11", 5020))
