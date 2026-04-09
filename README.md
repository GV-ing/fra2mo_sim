# 1. Struttura della Repository e Virtualizzazione (Docker)

La repository `fra2mo_sim` è progettata per offrire un ambiente di sviluppo isolato e riproducibile. L'obiettivo è garantire la piena portabilità della simulazione su qualsiasi sistema compatibile con Docker, eliminando i conflitti di dipendenze locali e facilitando il deploy finale sull'hardware reale.

## Architettura del Workspace

Il progetto segue una struttura modulare standard per la robotica moderna, divisa in due direttori principali:

* **`docker_scripts/`**: Contiene gli strumenti di automazione per la creazione e la gestione del sistema virtuale.
* **`src/`**: Il cuore del progetto, contenente il codice sorgente dei pacchetti ROS2 (URDF, algoritmi di navigazione, configurazioni dei sensori).

Questo approccio permette di mantenere il sistema operativo host pulito e di distribuire un "template" operativo identico per ogni sviluppatore del team.

## Funzionalità dei Docker Scripts

La cartella `docker_scripts` include una suite di script Bash che automatizzano l'intero ciclo di vita del container:

| File | Funzione |
| :--- | :--- |
| **`Dockerfile`** | Definisce l'immagine di base (Ubuntu 22.04 + ROS2 Humble), installa i driver per Gazebo Harmonic e mappa i pacchetti della cartella `src` nel workspace virtuale. |
| **`docker_build_image.sh`** | Esegue la costruzione dell'immagine Docker. Deve essere lanciato la prima volta o dopo ogni modifica al Dockerfile. |
| **`docker_run_container.sh`** | Istanzia il container. Configura l'inoltro dei segnali video (X11) per permettere l'apertura di GUI come Gazebo e RViz dall'interno del container. |
| **`docker_connect.sh`** | Permette di aprire sessioni terminali aggiuntive in un container già attivo. Indispensabile per il monitoraggio dei topic e l'esecuzione di comandi paralleli. |

## Standard Operativo e Vantaggi

L'uso dei container per il robot **fra2mo** non è solo una scelta di comodità, ma uno standard tecnico che offre:

1.  **Isolamento:** Ogni utente lavora con le stesse versioni di librerie (es. Nav2, Gazebo Harmonic), evitando il "funziona solo sul mio PC".
2.  **Facilità di Installazione:** La configurazione dell'ambiente richiede solo pochi comandi, riducendo i tempi di setup da ore a minuti.
3.  **Portabilità Hardware:** Permette un passaggio fluido dei pacchetti di controllo tra la workstation di simulazione e il **LattePanda** a bordo del robot reale.

---

### Istruzioni Rapide
Per avviare l'ambiente per la prima volta:

```bash
# Rendi eseguibili gli script
chmod +x docker_scripts/*.sh

# Costruisci l'immagine
./docker_scripts/docker_build_image.sh

# Avvia il container
./docker_scripts/docker_run_container.sh