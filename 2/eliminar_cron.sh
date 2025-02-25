#!/bin/bash

#Redirigeix tots els errors i la sortida estàndard a /dev/null per una execució més neta
exec >/dev/null 2>&1

#Atura el servei i el timer abans de la desinstal·lació
sudo systemctl stop copia_seguretat.service
sudo systemctl stop copia_seguretat.timer

#Elimina l'script principal i la seva configuració
sudo rm -rf /usr/local/bin/copia_seguretat.sh
sudo rm -rf /etc/systemd/system/copia_seguretat.service
sudo rm -rf /etc/systemd/system/copia_seguretat.timer
sudo rm -rf /lib/systemd/system/copia_seguretat.service
sudo rm -rf /lib/systemd/system/copia_seguretat.timer

#Elimina directoris i fitxers de registre
sudo rm -rf /usr/local/bin/directori_timer_test
sudo rm -rf /var/log/copia_seguretat_std.log
sudo rm -rf /var/log/copia_seguretat_err.log

#Refresca la configuració de systemd
sudo systemctl daemon-reload

#Guarda i mostra els estats actuals
estat_servei=$(sudo systemctl status copia_seguretat.service)
estat_timer=$(sudo systemctl status copia_seguretat.timer)
echo "Estat del servei: $estat_servei"
echo "Estat del timer: $estat_timer"

#Elimina qualsevol arxiu comprimit .tgz generat per la còpia de seguretat
sudo rm -rf /usr/local/bin/*.tgz


