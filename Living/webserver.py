from bottle import route, run, response, request
from json import dumps
import subprocess

PATH = '/etc/network/interfaces' 

def change_timezone(timezone):
	#timezone ej: America/Los_Angeles
	subprocess.call(['ln','-sf','/usr/share/zoneinfo/{0}'.format(timezone),'/etc/localtime'], shell=True)

def create_file(ssid, password):
	#===================================================================================
	# ACA HACE UN MONTON DE OPERACIONES DEL OS Y LAS CONF DEL WIFI. NO ES IMPORTANTE
	#===================================================================================
	print "Rebooting system..."
	subprocess.call(['reboot'], shell=True)

@route('/', method='GET')
def index_get():
	response.content_type = 'application/json'
	return dumps({'LivingHub':'connected'})

@route ('/', method='POST')
def index_post():
	response.content_type = 'application/json'
	try:
		ssid = request.json['ssid'] # EL STRING CON EL NOMBRE DEL WIFI DE LA PERSONA  
		password = request.json['password'] # EL STRING CON EL PASSWORD DEL WIFI DE LA PERSONA
		timezone = request.json['timezone'] # EL TIMEZONE ej: America/Los_Angeles DEL LUGAR DONDE ESTA EL HUB
		create_file(ssid,password)
		return dumps({'ok':'Rebooting system...'})
	except:
		return dumps({'ERROR':102,'error_message':'ERROR_CHANGING_WIFI_DATA'})

if __name__ == "__main__":
    run(host='0.0.0.0', port=8080, debug=True)
