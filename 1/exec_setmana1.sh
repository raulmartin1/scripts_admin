echo "============================================"
echo "Joc de proves del script comprovar_paquet.sh"
echo "============================================"
echo "S'esborra primerament el paquet rsyslog per fer la comprovacio posteriorment"
echo "s" | sudo apt-get purge rsyslog >/dev/null

echo ""
echo "Test 1: Instalar el paquet rsyslog amb input incorrecte"
echo "z" | ./comprovar_paquet.sh rsyslog >/dev/null
result=$?
if [ $result -eq 6 ]; then
	echo "S'ha detectat l'entrada incorrecta -> CORRECTE!"
else
	echo "No s'ha executat com hauria -> INCORRECTE!"
fi

echo ""
echo "Test 2: Instalar el paquet rsyslog amb input n"
echo "n" | ./comprovar_paquet.sh rsyslog >/dev/null
result=$?
if [ $result -eq 5 ]; then
	echo "S'ha detectat l'entrada n -> CORRECTE!"
else
	echo "Entrada dectectada no n-> INCORRECTE!"
fi

echo ""
echo "Test 3: Instalar el paquet rsyslog amb input y"
echo "y" | ./comprovar_paquet.sh rsyslog >/dev/null
result=$?
if [ $result -eq 0 ]; then
	echo "S'ha detectat l'entrada s correctament"
	if dpkg -l | grep -q "rsyslog"; then
		echo "S'ha instalat -> CORRECTE!"
	else
		echo "No s'ha instalat -> INCORRECTE!"
	fi
else
	echo "No ha sigut possible la instalacio -> INCORRECTE!"
fi

echo ""
echo "Test 4: Instalar el paquet rsyslog quan ya esta instala per tant s'ha de actualitzar amb input incorrecte"
echo "z" | ./comprovar_paquet.sh rsyslog >/dev/null
result=$?
if [ $result -eq 4 ]; then
	echo "S'a detectat que hi ha actualitzacio pero input no esperat -> CORRECTE!"
else
	echo "No s'ha detectat la actualitzacio esperada -> INCORRECTE!"
fi

echo ""
echo "Test 5: Instalar el paquet rsyslog, que ya esta descarregat pero no es vol actualitzar, input n"
echo "n" | ./comprovar_paquet.sh rsyslog >/dev/null
result=$?
if [ $result -eq 3 ]; then
	echo "Paquet ja esta instalat pero input n -> CORRECTE!"
else
	echo "No s'ha trobat la actualitzacio correctament -> INCORRECTE!"
fi

echo ""
echo "Test 6: Instalar el paquet rsyslog pero com esta descarregats'actualitza amb input y"
echo "y" | ./comprovar_paquet.sh rsyslog >/dev/null
result=$?
if [ $result -eq 2 ]; then
	echo "Actualitza el paquet -> CORRECTE!"
else
	echo "No s'ha actualitzat -> INCORRECTE!"
fi

echo ""
echo "Es crida a un paquet que no existeix (7)"
./comprovar_paquet.sh noexisteix >/dev/null
result=$?
if [ $result -eq 7 ]; then
	echo "S'ha detectat que no existeix el paquet correctament"
else
	echo "No s'ha executat com hauria"
fi

echo ""
echo "============================================"
echo "Joc de proves del script monitoritzar_logs.sh"
echo "============================================"
echo ""
echo "Test 8: No se introdueix ningun argument per parametre"
./monitoritzar_logs.sh
if [ $? -eq 1 ]; then
	echo "S'ha detectat que no hi ha cap argument -> CORRECTE!"
else
	echo "No s'ha detectat que no hi ha arguments -> CORRECTE!"
fi

echo ""
echo "Test 9: Se li pasa un servei correcte per parametre"
./monitoritzar_logs.sh systemd-logind
if [ $? -eq 0 ]; then
	echo "S'ha trobat correctament el servei -> CORRECTE!"
else
	echo "No s'ha trobat el log -> INCORRECTE!"
fi

echo ""
echo "Test 10: Es pasa mes d'un servei per parametre"
./monitoritzar_logs.sh systemd redis systemd-networkd systemd-journald
if [ $? -eq 0 ]; then
	echo "S'han trobat correctament els serveis -> CORRECTE!"
else
	echo "No s'han trobat els logs -> INCORRECTE!"
fi

echo ""
echo "========================================="
echo "Joc de proves del script missatge_log.sh"
echo "========================================="
echo ""

echo "Test 11: ES pasa un missatge amb nivell ERROR"
./missatge_log.sh ERROR missatge de error
if [ "$?" -eq 0 ]; then
	echo "Missatge registrar en ERROR correcte -> CORRECTE!"
else
	echo "MIssatge ERROR no registrat -> INCORRECTE!"
fi

echo ""
echo "Test 12: ES pasa un missatge amb nivell ERROR en minuscules"
./missatge_log.sh error missatge de error 
if [ "$?" -eq 0 ]; then
	echo "Missatge registrar en ERROR correcte -> CORRECTE!"
else
	echo "MIssatge ERROR no registrat -> INCORRECTE!"
fi

echo ""
echo "Test 13: ES pasa un missatge amb nivell WARNING"
./missatge_log.sh WARNING missatge
if [ "$?" -eq 0 ]; then
	echo "Missatge registrar en WARNING correcte -> CORRECTE!"
else
	echo "Missatge WARNING no registrat -> INCORRECTE!"
fi

echo ""
echo "Test 14: ES pasa un missatge amb nivell INFO"
./missatge_log.sh INFO missatge
if [ "$?" -eq 0 ]; then
	echo "Missatge registrar en INFO correcte -> CORRECTE!"
else
	echo "Missatge INFO no registrat -> INCORRECTE!"
fi

echo ""
echo "Test 15: ES pasa un missatge amb nivell que no existeix"
./missatge_log.sh noexiste missatge
if [ "$?" -eq 2 ]; then
	echo "Nivell no existent -> CORRECTE!"
else
	echo "No s'ha detectat el nivell no existent -> INCORRECTE!"
fi

