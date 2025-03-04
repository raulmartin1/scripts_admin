#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Pasa algun directori com argument"
    echo "Pots utiltizar la carpeta prova que hi ha la direccio actual"
    exit 1
fi


echo "================ JOC DE PROVES TASCA 7 ==================="
servei="apache2"
sudo systemctl stop "$servei"
sleep 1
./monitoritzar_logs2.sh "$servei"
sleep 1

# Comprovar si s'ha escrit al log que el servei no estava en execució
echo "Comprovant logs..."
sudo journalctl -n 10 --no-pager | grep -q "$servei no està en execucio" && echo "CORRECTE: El servei ha estat detectat i loggejat" || echo "INCORRECTE: No s'ha detectat el servei"

# Comprovar si s'ha reiniciat el servei
echo "Comprovant si s'ha reiniciat el servei..."
sudo systemctl is-active --quiet "$servei" && echo "CORRECTE: El servei s'ha reiniciat" || echo "CORRECTE: El servei no s'ha reiniciat"


echo "================ JOC DE PROVES TASCA 8 ==================="

#Executar copia_seguretat2.sh amb `nice -n 19 i mesurar el temps
echo "Executant copia_seguretat2.sh amb nice -n 19 i mesurant temps..."
time nice -n 19 ./copia_seguretat2.sh "$1" > /dev/null 2>&1 &

sleep 5  # Donar més temps perquè `tar` es llanci i guardi el seu PID

#Capturar el PID de `tar`
echo ""
if [ -f /tmp/tar_backup.pid ]; then
    tar_pid=$(cat /tmp/tar_backup.pid)
    echo "El procés de còpia (tar) està en execució amb PID: $tar_pid."
else
    echo "No s'ha trobat el PID de tar. Potser el procés ja ha acabat."
    exit 1
fi

echo ""
#Comprovar la prioritat NICE abans del canvi
ni_value_before=$(ps -o ni= -p $tar_pid)
echo "Abans del canvi: El procés $tar_pid (tar) té una prioritat NICE de: $ni_value_before"

echo "Buscant el procés a 'top' abans del canvi..."
top -b -n 1 | grep "$tar_pid"


echo ""
#Augmentar la prioritat amb `renice`
echo "Augmentant la prioritat del procés..."
sudo renice -n -5 -p $tar_pid

echo ""
#Comprovar la prioritat NICE després del canvi
ni_value_after=$(ps -o ni= -p $tar_pid)
echo "Després del canvi: El procés $tar_pid (tar) té una prioritat NICE de: $ni_value_after"

#Buscar el procés a `top` amb `grep`
echo "Buscant el procés a 'top' després del canvi..."
top -b -n 1 | grep "$tar_pid"

echo ""


echo "================ JOC DE PROVES TASCA 9 ==================="

echo "1) PROVA DE SENYAL SIGINT"


# Executar comprovar_paquet.sh en segon pla
echo "Executant comprovar_paquet.sh amb un paquet fictici..."
( ./comprovar_paquet2.sh paquet_inventat > /dev/null 2>&1; sleep 5 ) &

pid=$!

# Esperar uns segons i enviar SIGINT
sleep 2
echo "Enviant SIGINT al procés $pid..."
kill -SIGINT $pid

# Esperar que el procés acabi
wait $pid
exit_status=$?

# Verificar si l'script ha capturat correctament SIGINT (130 es la salida correcta de SIGINT)
if [ $exit_status -eq 130 ]; then
    echo "CORRECTE!: S'HA CAPTURAT CORRECTAMENT LA SENYAL SIGINT"
else
    echo "INCORRECTE!: NO S'HA CAPTURAT LA SENYAL SIGINT"
fi

echo ""

echo "2) PROVA DE SENYAL SIGURSR1 "
# Executar copia_seguretat.sh en segon pla
echo "Executant copia_seguretat.sh amb el directori 'prova'..."
./copia_seguretat2.sh "$1" > /dev/null 2>&1 &  

# Capturar el PID del procés `tar`
echo ""
if [ -f /tmp/tar_backup.pid ]; then
    tar_pid=$(cat /tmp/tar_backup.pid)
    echo "El procés de còpia (tar) està en execució amb PID: $tar_pid."
else
    echo "No s'ha trobat el PID de tar. Potser el procés ja ha acabat."
    exit 1
fi



# Enviar senyal SIGUSR1 per comprovar el progrés
echo ""
if ps -p $tar_pid > /dev/null 2>&1; then
    echo "Enviant senyal SIGUSR1 al procés $tar_pid per mostrar el progrés de la còpia..."
    kill -SIGUSR1 $tar_pid
else
    echo "El procés de còpia ja ha finalitzat abans de poder enviar SIGUSR1."
    exit 1
fi

# Mostrar les últimes línies del registre de progrés
echo -e "\nProgrés final de la còpia:"
tail -n 10 /tmp/tar_progress.log

echo ""

echo "================ JOC DE PROVES TASCA 10 ==================="
service="consumidor.service"

sudo cp /home/GSX/$service /etc/systemd/system/$service
sudo chmod +x /etc/systemd/system/$service
sudo systemctl daemon-reload

echo "Aturant i reiniciant servei"
sudo systemctl stop $service
sleep 2
sudo systemctl restart $service
sleep 2

systemctl is-active --quiet $service
if [[ $? -ne 0 ]]; then
	echo "INCORRECTE: El servei no esta actiu!"
else
	echo "CORRECTE: El servei esta actiu!"
fi

echo "Comprovant els limits de CPU i memòria..."
cpu_limit=$(systemctl show $service --property=CPUWeight | cut -d= -f2)
mem_limit=$(systemctl show $service --property=MemoryMax | cut -d= -f2)

if [[ "$cpu_limit" != "50" ]]; then
	echo "INCORRECTE: El limit de CPU no es de 50%"
else
	echo "CORRECTE: El limit de CPU esta configurat correctament a 50%"
fi

if [[ "$mem_limit" != "536870912" ]]; then # 512 MB en bytes
	echo "INCORRECTE: El limit de Memoria no es de 512MB"
else
	echo "CORRECTE: El limit de Memoria esta configurat correctament a 512MB"
fi


# Enviar senyals SIGUSR1 i SIGUSR2 per comprovar la resposta

pid=$(pgrep -f consumidor.sh)
echo "Enviant senyal SIGUSR1 per obtenir estadistiques..."
sudo kill -SIGUSR1 $pid
sleep 3
tail -n 5 /var/log/consumidor.log
sudo bash -c "echo '' > /var/log/consumidor.log"
sleep 1

echo "Enviant senyal SIGUSR2 per finalitzar el procés..."
sudo kill -SIGUSR2 $pid > /dev/null 2>&1

sleep 6
echo "Esperant 6 segons a que es reinici el servei"
#Comprovar si el procés es reinicia automaticament
nuevo_pid=$(pgrep -f consumidor.sh)
if [[ -z "$nuevo_pid" ]]; then
    echo "INCORRECTE: El proces no s'ha reiniciat automaticament despres de SIGUSR2!"
else
    echo "CORRECTE: El proces s'ha reiniciat automaticament amb PID"
fi


exit 0

