#!/bin/bash
# Tests per comprovar el funcionament correcte de la instal·lació i desinstal·lació dels serveis

# Neteja inicial per assegurar que els serveis no estan instal·lats abans de començar
./eliminar_monitoritza.sh
./eliminar_monitoritza_sysv.sh
./eliminar_cron.sh

# Funció bàsica per executar proves
comanda() {
  descripcio=$1
  ordre=$2
  correcte=$3
  incorrecte=$4

  echo "$descripcio"
  eval "$ordre" && echo "$correcte" || echo "$incorrecte"
}

echo "================RESULTATS DELS TESTOS TASCA 1 ================= "
# Tests per install_monitoritza.sh
comanda "1) Instal·lació inicial sense errors" \
  "./install_monitoritza.sh 2> errors.log 1> output.log && [ ! -s errors.log ]" \
  "CORRECTE!" "INCORRECTE!"

rm -f errors.log output.log

comanda "2) Comprovació de la instal·lació" \
  "sudo systemctl list-unit-files | grep -q monitoritzar_logs.service" \
  "CORRECTE!" "INCORRECTE!"

missatge_esperat="El soft link de monitoritzar_logs.service ja existeix
El soft link de monitoritzar_logs.timer ja existeix"

comanda "3) Instal·lació repetida, es comprova que genera avís" \
  "./install_monitoritza.sh 2> errors.log 1> output.log && grep -Fxq \"$missatge_esperat\" errors.log" \
  "CORRECTE!" "INCORRECTE!"

rm -f errors.log output.log

comanda "4) Eliminació i verificació del servei" \
  "./eliminar_monitoritza.sh && ! sudo systemctl list-units | grep -q monitoritzar_logs.service" \
  "INCORRECTE!" "CORRECTE!"

echo "================RESULTATS DELS TESTOS TASCA 2 ================= "
# Tests per install_monitoritza_sysv.sh
comanda "5) Instal·lació inicial en SysV sense errors" \
  "./install_monitoritza_sysv.sh 2> errors.log 1> output.log && [ ! -s errors.log ]" \
  "CORRECTE!" "INCORRECTE!"

rm -f errors.log output.log

comanda "6) Comprovació del servei en SysV" \
  "sudo service --status-all | grep -q monitoritzar_logs_sys" \
  "CORRECTE!" "INCORRECTE!"

comanda "7) Eliminació del servei en SysV i verificació" \
  "./eliminar_monitoritza_sysv.sh && ! sudo service --status-all | grep -q monitoritzar_logs_sys" \
  "INCORRECTE!" "CORRECTE!"

echo "================RESULTATS DELS TESTOS TASCA 3 ================= "
comanda "8) Creació i verificació de crontab" \
  "./install_cron.sh && sudo crontab -l | grep -Fxq '0 8 * * * /usr/local/bin/copia_seguretat.sh /usr/local/bin/directori_timer_test 2> /var/log/copia_seguretat_err.log 1> /var/log/copia_seguretat_std.log'" \
  "CORRECTE!" "INCORRECTE!"
  
comanda "9) Creació i verificació del timer" \
  "./install_timer.sh && sudo systemctl list-units | grep -q copia_seguretat.timer" \
  "CORRECTE!" "INCORRECTE!"
  
sudo systemctl start copia_seguretat.service

comanda "10) Comprovació de l'arxiu d'errors (esta buit)" \
  "[ ! -s /var/log/copia_seguretat_err.log ]" \
  "INCORRECTE!" "CORRECTE!"

