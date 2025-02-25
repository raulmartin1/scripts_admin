#!/bin/bash

# ES REALITZA LA DESINSTALACIO DEL SERVEI monitoritzar_logs

exec >/dev/null 2>&1  

sudo systemctl stop monitoritzar_logs.service   		# Atura el servei
sudo systemctl disable monitoritzar_logs.service   		# Impedeix que s'inici automàticament

sudo systemctl stop monitoritzar_logs.timer   			# Atura el timer associat al servei

sudo rm -rf /usr/local/bin/monitoritzar_logs.sh  	 	# Esborra l'script principal del servei
sudo rm -rf /var/log/monitoritzar_logs.log  		 	# Elimina el fitxer de registre principal

sudo rm -f /etc/monitoritzar.conf   			 	# Esborra l'arxiu de configuració del servei

sudo rm -rf /lib/systemd/system/monitoritzar_logs.service 	# Esborra el servei de la ubicació predeterminada
sudo rm -rf /lib/systemd/system/monitoritzar_logs.timer   	# Esborra el timer de la ubicació predeterminada

sudo rm -rf /etc/systemd/system/monitoritzar_logs.service
sudo rm -rf /etc/systemd/system/monitoritzar_logs.timer 

sudo rm -rf /var/log/monitoritzar_logs_std.log   		# Esborra els registres de sortida
sudo rm -rf /var/log/monitoritzar_logs_err.log  		# Esborra els registres d'error del servei

sudo systemctl daemon-reload   					# Actualitza systemd

estat_servei=$(sudo systemctl status monitoritzar_logs.service)  
estat_timer=$(sudo systemctl status monitoritzar_logs.timer)  

#echo "\nEstat actual del servei: $estat_servei"
#echo "\nEstat actual del timer: $estat_timer"

