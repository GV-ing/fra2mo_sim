# Fra2mo_sim
## Struttura della Repository e Virtualizzazione (Docker)

La repository `fra2mo_sim` è progettata per offrire un ambiente di sviluppo isolato e riproducibile. L'obiettivo è garantire la piena portabilità della simulazione su qualsiasi sistema compatibile con Docker, eliminando i conflitti di dipendenze locali e facilitando il deploy finale sull'hardware reale.

### Architettura del Workspace

Il progetto segue una struttura modulare standard per la robotica moderna, divisa in due direttori principali:

* **`docker_scripts/`**: Contiene gli strumenti di automazione per la creazione e la gestione del sistema virtuale.
* **`src/`**: Il cuore del progetto, contenente il codice sorgente dei pacchetti ROS2 (URDF, algoritmi di navigazione, configurazioni dei sensori).

Questo approccio permette di mantenere il sistema operativo host pulito e di distribuire un "template" operativo identico per ogni sviluppatore del team.

### Funzionalità dei Docker Scripts

La cartella `docker_scripts` include una suite di script Bash che automatizzano l'intero ciclo di vita del container:

| File | Funzione |
| :--- | :--- |
| **`Dockerfile`** | Definisce l'immagine di base (Ubuntu 22.04 + ROS2 Humble), installa i driver per Gazebo Harmonic e mappa i pacchetti della cartella `src` nel workspace virtuale. |
| **`docker_build_image.sh`** | Esegue la costruzione dell'immagine Docker. Deve essere lanciato la prima volta o dopo ogni modifica al Dockerfile. |
| **`docker_run_container.sh`** | Istanzia il container. Configura l'inoltro dei segnali video (X11) per permettere l'apertura di GUI come Gazebo e RViz dall'interno del container. |
| **`docker_connect.sh`** | Permette di aprire sessioni terminali aggiuntive in un container già attivo. Indispensabile per il monitoraggio dei topic e l'esecuzione di comandi paralleli. |

### Standard Operativo e Vantaggi

L'uso dei container per il robot **fra2mo** non è solo una scelta di comodità, ma uno standard tecnico che offre:

1.  **Isolamento:** Ogni utente lavora con le stesse versioni di librerie (es. Nav2, Gazebo Harmonic), evitando il "funziona solo sul mio PC".
2.  **Facilità di Installazione:** La configurazione dell'ambiente richiede solo pochi comandi, riducendo i tempi di setup da ore a minuti.
3.  **Portabilità Hardware:** Permette un passaggio fluido dei pacchetti di controllo tra la workstation di simulazione e il **LattePanda** a bordo del robot reale.

---

#### Istruzioni Rapide
Per avviare l'ambiente per la prima volta:

```bash
# Rendi eseguibili gli script
chmod +x docker_scripts/*.sh

# Costruisci l'immagine
./docker_scripts/docker_build_image.sh

# Avvia il container
./docker_scripts/docker_run_container.sh
```

## La Cartella `src`

La cartella `src` ospita i pacchetti ROS2 fondamentali per l'ecosistema **fra2mo**. L'architettura è divisa in due moduli principali che separano la modellizzazione fisica del robot dalle sue capacità algoritmiche.

### fra2mo_description
Questo pacchetto definisce l'identità fisica e visiva del robot. È il componente responsabile della generazione del modello URDF/Xacro, dell'integrazione dei sensori e della configurazione degli ambienti di simulazione in **Gazebo Harmonic**.

#### Struttura del Pacchetto:
* **`urdf/`**: Contiene i file Xacro che descrivono la cinematica differenziale, i link e i giunti (joints) del robot. Il file principale richiama macro specifiche per motori e sensori.
* **`meshes/`** & **`models/`**: Includono i file geometrici (STL/DAE) del corpo del robot, dei sensori (Lidar, D435) e degli asset statici dell'ambiente di simulazione.
* **`worlds/`**: Contiene i file `.sdf` che definiscono il mondo virtuale (es. `leonardo_race_field.sdf`), includendo parametri fisici come gravità e illuminazione.
* **`launch/`**: Script Python per l'avvio coordinato dei nodi. Gestiscono l'esecuzione di `robot_state_publisher`, il caricamento del mondo in Gazebo e l'apertura di RViz.
* **`conf/`**: Ospita i file `.rviz`, che memorizzano i settaggi della GUI (visualizzazione trasformate TF, PointCloud, LaserScan) per un avvio immediato.
* **`src/`**: Destinata ai nodi custom (Python/C++). Un esempio è il nodo per la conversione dei comandi Joypad in messaggi `cmd_vel`.
* **`CMakeLists.txt` & `package.xml`**: File di build e metadati essenziali per la compilazione tramite `colcon` e la gestione delle dipendenze ROS2.

### fra2mo_navigation
Questo pacchetto implementa lo stack di navigazione e gli algoritmi di percezione spaziale.


#### Struttura del Pacchetto:
* **`maps/`**: Contiene i file delle mappe generate tramite SLAM.
* **`launch/`**: Script Python per l'avvio coordinato dei nodi. Contiene i file di lancio per le funzionalità SLAM e AMCL.
* **`conf/`**: Ospita il file di configurazione per Nav2, permette di definire tutti i parametri necessari per la navigazione autonoma e le funzionalità SLAM e AMCL.
* **`CMakeLists.txt` & `package.xml`**: File di build e metadati essenziali per la compilazione tramite `colcon` e la gestione delle dipendenze ROS2.
#### Funzionalità Principali:
* **SLAM (Simultaneous Localization and Mapping)**: Permette al robot di mappare un ambiente ignoto utilizzando i dati del Lidar e dell'odometria.
* **AMCL (Adaptive Monte Carlo Localization)**: Gestisce la localizzazione probabilistica del robot all'interno di una mappa precedentemente acquisita.
* **Nav2 Integration**: Configura i controller e i planner per la navigazione autonoma, permettendo al robot di calcolare percorsi ottimi ed evitare ostacoli dinamici.

---

### Nota Tecnica: Standard ROS2
Entrambi i pacchetti seguono lo standard di build `ament_cmake` o `ament_python`, garantendo che, dopo l'esecuzione del comando `colcon build`, tutti gli asset (mesh, launch files, urdf) siano correttamente installati nel `vostro_workspace/install/` e pronti per essere eseguiti.
