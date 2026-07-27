---
trigger: always_on
---


# MangaFlow - Contesto del Progetto

Questo documento serve come punto di riferimento (contesto) per gli agenti IA e gli sviluppatori che lavorano al progetto MangaFlow. Contiene le linee guida architetturali, gli obiettivi del progetto e le funzionalità da implementare.

## 1. Obiettivo Globale e Visione
MangaFlow è un'applicazione Flutter nata con lo scopo di **gamificare la lettura dei manga cartacei**. L'obiettivo è incentivare l'utente a leggere allontanandolo dallo smartphone, premiandolo con punti esperienza (EXP) e progressione di livello in base al tempo reale passato a leggere a telefono capovolto.
**NOTA BENE: Questo è un Progetto Universitario.** Di conseguenza, la logica deve rimanere estremamente chiara, ben commentata e separata (Clean Architecture basica). Evitare categoricamente l'over-engineering (no librerie complesse non richieste, no astrazioni estreme se non creano valore aggiunto). La semplicità, la leggibilità e il rispetto delle consegne (MUST HAVE) vincono sempre sulla complessità.

## 2. Architettura e Tecnologie Core
*   **Framework:** Flutter (versione SDK ^3.11.1)
*   **State Management:** Riverpod (`flutter_riverpod`). Utilizzato per sincronizzare in tempo reale la modalità Focus, il Database e il Profilo.
*   **Storage Locale:** SQLite (`sqflite`). Utilizzato per persistere i dati dei manga, l'account, i punti EXP e le statistiche.
*   **Sensori:** `proximity_sensor` e `sensors_plus` per rilevare l'orientamento e lo stato del telefono.
*   **Struttura delle Cartelle:** L'app adotta un approccio "Feature-First". Tutto il codice è suddiviso in domini funzionali dentro la cartella `lib/features/`:
    *   `library`: Logica e UI per la libreria manga.
    *   `focus_dojo`: Logica e UI per il timer e la rilevazione sensoriale.
    *   `profile`: Logica e UI per l'account utente, livello, exp e statistiche.

---

## 3. RoadMap e Milestones

### MUST HAVE (Requisiti Essenziali)
Queste sono le fondamenta del progetto che devono essere implementate per prime in modo solido e robusto.

1.  **Gestione Libreria Base (SQLite)**
    *   **Database:** Creazione tabella `Manga` con i campi: `Titolo`, `Autore`, `Volume attuale`, `URL copertina`.
    *   **UI:** Visualizzazione a griglia dei manga salvati.
    *   **Funzionalità:** Form per l'aggiunta puramente manuale dei manga alla propria collezione.

2.  **Focus Mode "Context-Aware" (Dojo)**
    *   **Concetto:** Schermata con un timer di sessione, attivata prima di iniziare a leggere.
    *   **Integrazione Sensori:** Utilizzare `sensors_plus` (accelerometro per posizionamento asse Z) e `proximity_sensor` (rilevamento vicinanza tavolo) per capire quando il telefono è appoggiato a faccia in giù.
    *   **Logica del Timer:** 
        *   Telefono faccia in giù: il timer avanza e accumula EXP.
        *   Telefono sollevato: il timer va in pausa automaticamente.
    *   **Gestione Background/Standby:** Il sistema DEVE essere robusto se l'OS riduce in background l'app o spegne lo schermo. **Usare i timestamp** (orario inizio - orario fine) per calcolare la durata anziché affidarsi a un ticker continuo che l'OS potrebbe terminare.

3.  **Profilo Utente Base**
    *   **UI e Dati:** Schermata riassuntiva che interroga il DB per estrarre il totale degli EXP accumulati.
    *   **Meccanica Gdr:** Calcolo automatico del "Livello" utente in base alle soglie di EXP raggiunte.

4.  **Gestore di Stato (Riverpod)**
    *   Predisporre un flusso reattivo affinché all'accumulo di exp nel Dojo, il profilo e il database si aggiornino in tempo reale.

---

### SHOULD HAVE (Feature Avanzate per "Voti Extra")
Queste funzionalità aggiungono lustro all'applicazione. Vanno affrontate a base completata.

1.  **Animazione Custom (Liquid Container)**
    *   Utilizzare un `CustomPainter` nella schermata del Focus Mode (Dojo).
    *   L'animazione deve rappresentare un'onda fluida (effetto "liquido") che sale riempiendo lo schermo in proporzione alla percentuale di completamento dell'obiettivo di lettura impostato.

2.  **Location Services (Loot Spots)**
    *   **Integrazione Mappa:** Utilizzare pacchetti come `google_maps_flutter` o `flutter_map` (se si preferisce un approccio OpenSource) implementando la rilevazione del GPS utente.
    *   **Gamification Geofencing:** Creare mock di 1-2 luoghi di interesse limitrofi ("fumetterie").
    *   **Check-in:** Se l'utente si trova fisicamente in prossimità del Loot Spot, può fare un check-in per sbloccare un bonus di esperienza aggiuntiva.

---

## 4. Idee Aggiuntive per il Focus Dojo
Il Dojo è il cuore della gamification. Oltre al timer puro e ai sensori, l'area può essere arricchita con elementi che restituiscano un senso di progressione:
*   **Vetrina dei Badge/Trofei:** Un'area per mostrare achievement sbloccati (es: "Lettore Notturno", "Maratoneta", "Otaku Principiante").
*   **Streak e Combo:** Contatore di giorni consecutivi di lettura.
*   **Scelta del "Compagno di Lettura":** Selezionare quale manga della Libreria si sta leggendo prima di avviare il timer per tenere traccia delle statistiche di lettura per specifica opera.

## 5. Note sullo Stile (UI)
*L'implementazione logica ha la priorità assoluta.* Tuttavia, lo sviluppo delle UI deve seguire, laddove possibile, i principi di design e la modularità definiti nel workflow `/workflow_ui_redesign`, focalizzandosi su un'architettura "pulita" dei Widget.
