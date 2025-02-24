#!/bin/bash
if [ $# -eq 0 ]; then
	echo "Error: No has especificat cap servei"
	exit 1
fi

for servei in "$@"; do
	echo "Errors mes recents del servei $servei"
	sudo journalctl -u "$servei" -p err --no-pager #-u per buscar per servei i -p filtrar per error
	echo ""
done
exit 0
