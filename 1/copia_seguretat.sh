#!/bin/bash

if [ "$#" -eq 0 ]; then 
    echo "Error: Introdueix algun argument" >&2 
    exit 1
fi

data_copia=$(date +"%Y%m%d_%H%M%S")
fitxer_copia="copia"${data_copia}".tgz"

for dir in "$@"; do 
  if [ -d "$dir" ]; then  						# Comprova si és un directori valid
    llista_directoris+=("$dir")  						# Afegir el directori a la llista de directoris a fer còpia de seguretat

    echo "Informacio fitxers al directori: $dir" >&1
    find "$dir" -exec stat --format="%A %U %G %x %y %z %n" {} \;  	# Mostrar permisos, propietari, grup , dates (creacio modificació i acces)
  else
    echo "El directori: "$dir" no és valid" >&2  
  fi
done

if [ "${#llista_directoris[@]}" -eq 0 ]; then  					# Comprova si hi ha directoris vàlids per fer còpia de seguretat
  echo "Error: No hi ha directoris valids per fer la còpia de seguretat" >&2 
  exit 1  # Finalitza el script amb un codi d'error
fi

tar czpf "${fitxer_copia}" "${@}" >&1 >&2

