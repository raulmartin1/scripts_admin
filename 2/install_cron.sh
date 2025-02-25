#!/bin/bash

# Instal·la un script perquè s'executi automàticament amb `crontab` cada dia a les 08:00

script_dest="/usr/local/bin/copia_seguretat.sh"
directori_test="/usr/local/bin/directori_timer_test"
log_err="/var/log/copia_seguretat_err.log"
log_out="/var/log/copia_seguretat_std.log"
cron_job="0 8 * * * $script_dest $directori_test 2> $log_err 1> $log_out"

#Dona permisos d'execució a l'script
chmod u+x copia_seguretat.sh

#Copia l'script i el fitxer de configuració a les ubicacions correctes
sudo cp -p copia_seguretat.sh "$script_dest" 2>&2 1>&1

#Crea un directori de prova i un fitxer de test
sudo mkdir -p "$directori_test"
echo "realització del test" | sudo tee "$directori_test/test" > /dev/null

#Copia el fitxer de configuració
sudo cp -p copia_seguretat.in /etc/copia_seguretat.in 2>/dev/null 1>&1

#Guarda el crontab actual en un fitxer temporal
sudo crontab -l 2>/dev/null > crontab_temp

#Comprova si la tasca ja existeix; si no, l’afegeix
grep -Fq "$script_dest" crontab_temp || echo "$cron_job" >> crontab_temp

#Carrega el nou crontab
sudo crontab crontab_temp
sudo rm crontab_temp

echo "Instalacio completada: copia_seguretat.sh s'executarà cada dia a les 08:00."

