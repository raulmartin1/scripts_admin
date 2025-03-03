# 📁 Segona Setmana: Boot i Serveis (systemd i SysV)  

Aquest directori conté els scripts i configuracions per gestionar serveis amb **systemd, SysV i cron**.  

## ✅ Tasques  

### ⚙️ Tasca 4: Configurar un servei amb systemd  
- `monitoritzar_logs.service`: Executa `monitoritzar_logs.sh` cada 5 minuts.  
- `install_monitoritza.sh`: Instal·la i prova el servei.  
- `exec_setmana2.sh`: Automatitza la instal·lació i proves.  

### 🖥️ Tasca 5: Configurar SysV init per gestionar un servei  
- `/etc/init.d/monitoritzar_logs`: Permet gestionar `monitoritzar_logs.sh` amb SysV.  
- Configura l'inici automàtic i afegeix la instal·lació a `exec_setmana2.sh`.  

### 📆 Tasca 6: Automatitzar còpies de seguretat  
- `install_cron.sh`: Programa `copia_seguretat.sh` a les 08:00 amb cron.  
- `install_timer.sh`: Configura un **systemd timer** per executar la còpia a les 22:00.  
- Modifica els scripts per verificar que cron i systemd funcionen correctament.  

## 🚀 Execució  
Executa totes les proves amb:  
```bash
./exec_setmana2.sh
