#!/bin/bash
if [ $# -eq 0 ]; then
	echo "Error: No has especificat cap servei"
	exit 1
fi

for servei in "$@"; do
	echo "Errors mes recents del servei $servei"
	sudo journalctl -u "$servei" -p err --no-pager #-u per buscar per servei i -p filtrar per error
	echo ""
	
	if [ -z "$(pgrep -x "$servei")" ]; then
		logger -p user.err "El servei $servei no està en execucio, es reiniciarà automaticament"
		echo "Reinciant servei "$servei" ..." 
		echo ""
		sudo systemctl restart "$servei"
	fi
	
done

exit 0


