# Guida Installazione - App Appuntamenti

## Metodo 1: Creazione Progetto in Xcode (Consigliato)

### Passo 1: Crea un nuovo progetto
1. Apri **Xcode**
2. Clicca su **File → New → Project...**
3. Seleziona **iOS → App**
4. Clicca **Next**

### Passo 2: Configura il progetto
- **Product Name:** `AppuntamentiApp`
- **Team:** Seleziona il tuo team (o None)
- **Organization Identifier:** `com.dbminformatica`
- **Interface:** `SwiftUI`
- **Language:** `Swift`
- **Storage:** `None`
- Clicca **Next** e scegli dove salvare

### Passo 3: Elimina i file di default
Nel Navigator di Xcode, elimina:
- `ContentView.swift` (quello creato automaticamente)

### Passo 4: Aggiungi i file sorgente
1. Clicca destro sulla cartella `AppuntamentiApp` nel Navigator
2. Seleziona **Add Files to "AppuntamentiApp"...**
3. Naviga alla cartella del repository scaricato
4. Seleziona TUTTI i file dalla cartella `AppuntamentiApp/AppuntamentiApp/`:
   - `AppuntamentiApp.swift`
   - Cartella `Models/`
   - Cartella `Services/`
   - Cartella `Views/`
5. Assicurati che **"Copy items if needed"** sia selezionato
6. Clicca **Add**

### Passo 5: Aggiungi gli Assets
1. Nel Navigator, clicca su `Assets.xcassets`
2. Trascina i contenuti della cartella `Assets.xcassets` del repository:
   - `AccentColor.colorset`
   - `AppIcon.appiconset`
   - `DBMLogo.imageset`

### Passo 6: Compila e Esegui
1. Seleziona un simulatore iPhone (es. iPhone 15)
2. Premi **Cmd + R** per compilare e eseguire

---

## Metodo 2: Script Automatico (per utenti avanzati)

Esegui questo comando nel Terminale sul tuo Mac:

```bash
cd /percorso/dove/hai/scaricato/il/repo

# Crea il progetto con swift package
mkdir -p AppuntamentiApp.xcodeproj
cd AppuntamentiApp

# Genera il progetto Xcode
swift package init --type executable --name AppuntamentiApp
swift package generate-xcodeproj
```

---

## Struttura File da Copiare

```
AppuntamentiApp/
├── AppuntamentiApp.swift          ← Entry point
├── Models/
│   └── Appointment.swift          ← Modello dati
├── Services/
│   └── AppointmentStore.swift     ← Gestione dati
├── Views/
│   ├── ContentView.swift
│   ├── HomeView.swift
│   ├── AppointmentListView.swift
│   ├── AddAppointmentView.swift
│   ├── AppointmentDetailView.swift
│   ├── CalendarView.swift
│   ├── SettingsView.swift
│   └── Components/
│       ├── AppointmentCard.swift
│       └── DBMLogoView.swift
└── Assets.xcassets/
    ├── AccentColor.colorset/
    ├── AppIcon.appiconset/
    └── DBMLogo.imageset/
```

---

## Risoluzione Problemi

### Errore: "No such module 'SwiftUI'"
- Assicurati che il deployment target sia iOS 16.0 o superiore
- Vai su **Project Settings → General → Minimum Deployments** e imposta iOS 16.0

### Errore: "@main attribute"
- Assicurati di aver eliminato il `ContentView.swift` di default
- Verifica che `AppuntamentiApp.swift` sia incluso nel target

### Errore con Assets
- Verifica che le immagini siano nella cartella corretta
- Ricompila con **Cmd + Shift + K** (Clean) poi **Cmd + B** (Build)

---

© 2026 DBM Informatica
