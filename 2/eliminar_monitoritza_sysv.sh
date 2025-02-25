# !/bin/bash

exec >/dev/null 2>&1

sudo service monitoritzar_logs_sysv stop		# es para el servei

sudo rm -rf /etc/init.d/monitoritzar_logs_sysv		# elimina el script d'inici

sudo rm -rf /usr/local/bin/monitoritzar_logs.sh		# elimina el script del executable

sudo update-rc.d monitoritzar_logs_sysv defaults	# Reestableix la configuració del servei
