#!/bin/bash
err=0

# Capturar SIGINT (Ctrl+C) i mostrar un missatge abans de sortir
trap "echo 'Procés interromput'; exit" SIGINT

if [ $# -eq 0 ]; then
	echo "Error: NO has especificat cap paquet" >&2
	exit 1
fi

for arg in "$@"; do
    res=$(apt-cache search "$arg")
    if [ -n "$res" ]; then        	# mira si la variable no es vacia
    echo "Paquet => $arg"
    	
        if dpkg -l | grep -q "$arg"; then
            echo "Vols actualitzar-lo (y/n) ?"
            read resposta
            if [ "$resposta" = "y" ]; then
		    echo "Actuatlitzant paquet: $arg"
		    sudo apt-get install --only-upgrade -y "$arg" >&2    #-y confirmar automaticament
		    echo "Paquet $arg actualitzat"
		    let err=2
            elif [ "$resposta" = "n" ]; then
            	    echo "Paquet $arg no actualitzat"
            	    let err=3
            else 
            	    echo "Entrada no reconeguda de (y/n) en l'actualitzacio del paquet $arg" >&2
            	    let err=4
            fi
        else
            echo "Vols descarregar-lo (y/n) ?"
            read resposta
            if [ "$resposta" = "y" ]; then
		    echo "Descarregant paquet: $arg"
		    sudo apt install -y "$arg" >&2
		    echo "Paquet $arg descarregat"
		    let err=0
	    elif [ "$resposta" = "n" ]; then
            	    echo "Paquet $arg no descarregat"
            	    let err=5
            else 
            	   echo "Entrada no reconeguda de (y/n) en la descarrega del paquet $arg" >&2
            	   let err=6
            fi
        fi
    else 
    	echo "Paquet $arg no existeix" >&2
    	let err=7
    fi
done

exit $err
