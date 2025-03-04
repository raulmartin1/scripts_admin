#!/bin/bash

trap 'echo "Estadistiques del proces: " >> /var/log/consumidor.log; ps -p $$ -o pid,etime,%cpu,%mem >> /var/log/consumidor.log' SIGUSR1

#trap 'echo "Finalitzant proces per senyal SIGUSR2"; exit 0' SIGUSR2
trap 'echo ""; exit 0' SIGUSR2

# 4 processos en segon pla per consumir CPU
for i in {1..4}; do
    while true; do
        echo "$((12**99))" > /dev/null  # Calcul costos
    done &
done

# Consumir memòria afegint dades a un array
array=()
while true; do
    array+=( $(seq 1 1000000) )  # Omplir l'array amb numeros
    sleep 0.5  			# Evitar bloqueig total de la CPU
done
