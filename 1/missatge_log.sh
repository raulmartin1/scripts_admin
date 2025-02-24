if [ $# -lt 2 ]; then
    echo "Error: Introdueix un nombre d'arguments correcte -> mayor que 2"
    echo "La estructura ha de ser la seguent: $0 <NIVELL> <MISSATGE>"
    exit 1
fi

nivell=$1
missatge="${@:2}"

nivell=$(echo "$nivell" | tr '[:lower:]' '[:upper:]')

if [[ "$nivell" != "INFO" && "$nivell" != "WARNING" && "$nivell" != "ERROR" ]]; then
    echo "Error: El nivell ha de ser INFO, WARNING o ERROR."
    exit 2
fi

if [ "$nivell" = "INFO" ]; then
	logger -p user.info "$missatge"
elif [ "$nivell" = "WARNING" ]; then
	logger -p user.warning "$missatge"
elif [ "$nivell" = "ERROR" ]; then
	logger -p user.err "$missatge"
fi

echo "El missatge escrit es: $missatge | Amb nivell: $nivell"

echo ""
echo "Comprovacio..."
if sudo journalctl -n 10 --no-pager | grep -q "$missatge"; then
    echo "S'ha rebut el missatge!"
    exit 0
else 
    echo "No s'ha pogut rebre el missatge"
    exit 3
fi
