#!/bin/bash

# Instalació del servei monitoritzar_logs

echo "Copiant monitoritzar_logs.sh a /usr/local/bin..."
sudo cp -p monitoritzar_logs.sh /usr/local/bin/monitoritzar_logs.sh 2>&2 1>&1
sudo chmod +x /usr/local/bin/monitoritzar_logs.sh

# Mou l'script d'inicialització a /etc/init.d/ i li dona permisos d'execució
echo "Instalant script d'inicialització SysV..."
sudo chmod 755 monitoritzar_logs_sysv
sudo cp -p monitoritzar_logs_sysv /etc/init.d/monitoritzar_logs_sysv 2>&2 1>&1
sudo chmod +x /etc/init.d/monitoritzar_logs_sysv

# Activa el servei perquè s'executi automàticament a l'inici del sistema
echo "Activant el servei perque s'executi automaticament a l'inici del sistema"
sudo update-rc.d monitoritzar_logs_sysv defaults

# Inicia el servei
echo "Iniciant el servei..."
sudo service monitoritzar_logs_sysv start

# Mostra l'estat del servei per confirmar que funciona correctament
echo "Estat del servei:"
sudo service monitoritzar_logs_sysv status | cat

# Atura el servei per verificar que es pot gestionar correctament
echo "Aturant el servei..."
sudo service monitoritzar_logs_sysv stop

echo "S'ha completat la instalacio"
