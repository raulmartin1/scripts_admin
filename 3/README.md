# 📁 Tercera Setmana: Processos

Aquest directori conté els scripts i configuracions per monitoritzar i gestionar processos, prioritzar tasques, controlar senyals i administrar recursos amb **cgroups** i **systemd**.

## ✅ Tasques

### 🔍 Tasca 7: Monitoritzar processos amb scripts  
- `monitoritzar_logs.sh`: Ara també verifica si els processos dels serveis especificats per paràmetre estan en execució.  
- Si un servei no s'està executant, es registra un missatge al log i es reinicia automàticament.  
- `exec_setmana3.sh`: Executa la instal·lació i el joc de proves per monitoritzar processos.  

### ⚙️ Tasca 8: Canviar prioritats i gestionar processos  
- `copia_seguretat.sh` s'executa amb una prioritat baixa (`nice -n 19`).  
- Es comprova el consum de CPU amb `top` i el temps d'execució amb `time`.  
- Si no es detecten canvis, es carrega el processador amb tasques exigents.  
- La prioritat es modifica en temps d'execució amb `renice`, i s'analitza l'impacte en el sistema.  
- `exec_setmana3.sh`: Modificat per executar i comprovar els temps obtinguts en el joc de proves.  

### 🚦 Tasca 9: Control de processos amb signals  
- `comprovar_paquet.sh`: Ara es pot interrompre amb `SIGINT` (`Ctrl+C`), mostrant un missatge abans de sortir.  
- `copia_seguretat.sh`: Implementa `SIGUSR1` per mostrar el progrés de la còpia.  
- Es llança l’script en segon pla i se li envia el senyal per comprovar que respon correctament.  
- `exec_setmana3.sh`: Modificat per executar i comprovar els jocs de proves amb senyals.  

### 🔧 Tasca 10: Gestió de recursos amb cgroups i systemd  
- `consumidor.sh`: Script que consumeix **CPU** i **memòria**, activat des d'un servei.  
  - Respon a `SIGUSR1` informant del temps, CPU i memòria consumits.  
  - Es tanca amb `SIGUSR2`, mostrant un missatge de sortida.  
- `consumidor.service`: Servei que activa `consumidor.sh` i el reinicia si falla.  
- Configuració del servei per limitar:  
  - **CPU** al **50%**  
  - **Memòria** a **512MB**  
- Monitorització de l’ús de recursos i efectes d'excedir els límits.  
- `exec_setmana3.sh`: Automatitza tot el procés:  
  - Crea el fitxer de configuració del servei.  
  - Configura els límits de CPU i memòria.  
  - Inicia el servei i mostra informació sobre l’ús de recursos.  

## 🚀 Execució  
Executa totes les proves amb:  
```bash
./exec_setmana3.sh
