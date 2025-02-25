#!/bin/bash

# Instalar el servei copia_seguretat.timer

sudo mkdir -p /usr/local/bin/directori_timer_test 2>/dev/null

echo "realització del test" | sudo tee /usr/local/bin/directori_timer_test/test > /dev/null

#Copiar el fitxer de configuració
sudo cp -p copia_seguretat.conf /etc/copia_seguretat.conf 2>/dev/null

#Copiar l'script executable
sudo cp -p copia_seguretat.sh /usr/local/bin/copia_seguretat.sh 2>/dev/null

#Copiar el servei i el timer
sudo cp -p copia_seguretat.service /lib/systemd/system/copia_seguretat.service 2>/dev/null
sudo cp -p copia_seguretat.timer /lib/systemd/system/copia_seguretat.timer 2>/dev/null

#Crear soft links
sudo ln -sf /lib/systemd/system/copia_seguretat.service /etc/systemd/system/copia_seguretat.service 2>/dev/null
sudo ln -sf /lib/systemd/system/copia_seguretat.timer /etc/systemd/system/copia_seguretat.timer 2>/dev/null

# Recàrrega systemd perquè reconegui el nou servei i timer
sudo systemctl daemon-reload

# Inicia el timer
sudo systemctl start copia_seguretat.timer

