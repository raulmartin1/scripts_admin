
#Allocate executable
sudo cp -p monitoritzar_logs.sh /usr/local/bin/monitoritzar_logs.sh 2>&2 1>&1

# Copiem els fitxers del servei i el timer a la carpeta de systemd
sudo cp -p monitoritzar_logs.service /lib/systemd/system/monitoritzar_logs.service 2>&2 1>&1
sudo cp -p monitoritzar_logs.timer /lib/systemd/system/monitoritzar_logs.timer 2>&2 1>&1

# Comprova si existeix el soft link i el crea només si no existeix
sudo ln -s /lib/systemd/system/monitoritzar_logs.service /etc/systemd/system/monitoritzar_logs.service 2>/dev/null 1>&1 || echo "El soft link de monitoritzar_logs.service ja existeix" >&2
sudo ln -s /lib/systemd/system/monitoritzar_logs.timer /etc/systemd/system/monitoritzar_logs.timer 2>/dev/null 1>&1 || echo "El soft link de monitoritzar_logs.timer ja existeix" >&2

# Copiem el fitxer de configuració a la seva ubicació
sudo cp -p monitoritzar.conf /etc/monitoritzar.conf

# Refresquem systemd perquè detecti els nous serveis
sudo systemctl daemon-reload

# Iniciem el servei i el timer
sudo systemctl start monitoritzar_logs.service
sudo systemctl start monitoritzar_logs.timer

