

Roadmap e Task Manager: App Cloud Storage Unificata

Questo documento suddivide lo sviluppo dell'app in piccoli step azionabili. Usa le caselle di controllo per tracciare i progressi.
Stack: Flutter (Dart) + Go (Rclone) + C FFI.

Fase 1: Setup Iniziale e Progettazione 🛠️

Obiettivo: Preparare gli strumenti e l'architettura di base.

[x] Installare l'SDK di Flutter e verificare con flutter doctor.

[x] Installare Go e i tool di compilazione C/C++ (GCC/Clang).

[x] Creare il nuovo progetto Flutter: flutter create cloud_unify.

[x] Creare una cartella go_backend nella root del progetto Flutter.

[x] Inizializzare il modulo Go: cd go_backend && go mod init cloud_unify_core.

[x] Disegnare i wireframe dell'interfaccia (Home, File Browser, Impostazioni, Transfer Manager).

[x] Aggiungere le dipendenze base in pubspec.yaml (es. flutter_riverpod, go_router, ffi, path_provider).

Fase 2: Il Motore Go (Rclone Wrapper) 🐹

Obiettivo: Creare una libreria condivisa in Go che esponga le funzioni di rclone a C.

[x] Creare il file main.go nella cartella go_backend.

[x] Importare C e i pacchetti github.com/rclone/rclone/fs necessari (selezionare solo i backend desiderati per ridurre le dimensioni).

[x] Scrivere la funzione Go esportata //export InitRclone per caricare le configurazioni.

[x] Scrivere la funzione Go esportata //export ListRemotes per ottenere i cloud configurati (ritorna JSON).

[x] Scrivere la funzione Go esportata //export ListDirectory (accetta nome remote e percorso, ritorna JSON dei file).

[x] Scrivere le funzioni Go esportate per le operazioni CRUD: CopyFile, DeleteFile, MakeDir.

[x] Compilare il codice Go come libreria C-shared per desktop (es. per Linux: go build -o librclone_wrapper.so -buildmode=c-shared main.go).

Fase 3: Il Ponte FFI (Flutter 🤝 Go) 🌉

Obiettivo: Far parlare Dart con la libreria Go tramite FFI.

[x] Aggiungere il pacchetto ffigen come dev_dependency in Flutter.

[x] Creare il file di configurazione ffigen.yaml puntando al file .h generato da Go.

[x] Eseguire dart run ffigen per generare automaticamente il file rclone_bindings.dart.

[x] Creare un servizio Dart (RcloneService.dart) che usa dart:ffi per caricare il file .so / .dylib / .dll.

[x] Scrivere un test di base: chiamare InitRclone() da Flutter e stampare il risultato nella console per confermare che il ponte funziona.

Fase 4: Autenticazione e Sicurezza (Il file di Configurazione) 🔒

Obiettivo: Gestire i token cloud in modo sicuro senza scriverli in chiaro.

[x] Aggiungere il pacchetto flutter_secure_storage a Flutter.

[x] Progettare la logica per salvare il contenuto del file rclone.conf nel Keychain (iOS) / Keystore (Android).

[x] Modificare il wrapper Go per accettare la configurazione come stringa dalla memoria (da Flutter) anziché leggere un file locale.

[x] Implementare il flusso OAuth2 in Flutter (es. tramite app_links o url_launcher): intercettare il token dal browser e passarlo a Go per la configurazione iniziale di un nuovo Cloud.

Fase 5: Interfaccia Utente (UI) con Flutter 🎨

Obiettivo: Costruire le schermate dell'app.

[x] Configurazione Stato: Impostare i provider (es. Riverpod) per gestire lo stato del file system corrente.

[x] Schermata Home: Lista dei provider cloud collegati (Google Drive, Dropbox, ecc.) con i pulsanti per aggiungerne di nuovi.

[x] File Explorer UI:

[x] Implementare la lista/griglia per mostrare cartelle e file.

[x] Aggiungere le icone appropriate in base all'estensione del file.

[x] Creare la barra di navigazione "Breadcrumbs" (es. Home > Lavoro > Progetti).

[x] Pull-to-refresh per aggiornare la directory.

[x] Menu contestuale: Click destro (Desktop) o Long-press (Mobile) per Rinominare, Eliminare, Scaricare, Condividere.

Fase 6: Trasferimenti e Code 🔄

Obiettivo: Gestire upload/download con barre di progresso.

[x] Implementare una funzione Go esportata //export GetTransferProgress che restituisce lo stato attuale (byte trasferiti, velocità, ETA).

[x] In Flutter, creare un TransferManager che interroga periodicamente il progresso tramite FFI o utilizza dei callback C.

[x] Creare un pannello a scomparsa (Bottom Sheet o Side Panel) nell'UI che mostra i download e gli upload attivi.

[x] Integrare file_picker per selezionare file locali da caricare sul cloud.

[x] Gestire le operazioni di "Copia-Incolla" tra un provider cloud e l'altro (Rclone lo fa in automatico in modo efficiente!).

Fase 7: Ottimizzazione Cross-Platform e Background 📱💻

Obiettivo: Fare in modo che compili per tutte le piattaforme e che le copie non si interrompano.

[x] Desktop: Aggiornare i file CMakeLists.txt (Linux/Windows) per includere la libreria Go compilata durante la build di Flutter.

[x] Mobile (Android): Usare NDK e configurare build.gradle per compilare il codice Go per le architetture ARM (tramite script bash o gomobile).

[x] Mobile (iOS): Configurare XCode per includere la libreria .a di Go e gli header.

[x] Background: Aggiungere flutter_background_service (Android) e i Background Tasks nativi (iOS) per mantenere i trasferimenti attivi ad app chiusa.

Fase 8: Testing e Rilascio 🚀

Obiettivo: Rendere l'app stabile e distribuirla al pubblico.

[x] Scrivere test unitari per il wrapper Go.

[x] Scrivere test per il servizio FFI in Dart.

[x] Gestire i casi d'uso critici: perdita di connessione, spazio in esaurimento, token revocati.

[ ] Tradurre l'app (Localizzazione I18n).

[ ] Preparare gli asset per gli store (Icone, Screenshot).

[ ] Pubblicare il codice sorgente su GitHub/GitLab (FOSS).

[ ] Compilare e inviare a F-Droid, Google Play Store, Apple App Store, Flathub e Microsoft Store.