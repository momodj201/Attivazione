# Appuntamenti - App iOS per la Gestione degli Appuntamenti

Un'applicazione iOS moderna e intuitiva per gestire i tuoi appuntamenti personali, sviluppata in SwiftUI.

## Funzionalità

### Home
- Visualizzazione degli appuntamenti di oggi
- Riepilogo degli appuntamenti in arrivo
- Statistiche rapide (appuntamenti oggi e totali in arrivo)
- Saluti personalizzati in base all'ora del giorno

### Lista Appuntamenti
- Visualizzazione completa di tutti gli appuntamenti
- Filtri per stato: Tutti, In arrivo, Passati, Oggi
- Filtri per categoria: Personale, Lavoro, Salute, Famiglia, Sociale, Altro
- Ricerca testuale per titolo, descrizione e luogo
- Eliminazione con swipe

### Calendario
- Vista calendario mensile
- Navigazione tra i mesi
- Indicatori visivi per i giorni con appuntamenti
- Selezione data per visualizzare gli appuntamenti

### Creazione Appuntamenti
- Titolo e descrizione
- Data e ora con picker nativo italiano
- Posizione/Luogo
- Categoria (6 categorie disponibili)
- Opzione promemoria

### Dettaglio Appuntamento
- Visualizzazione completa delle informazioni
- Modifica in-line
- Eliminazione con conferma

### Impostazioni
- Attivazione/disattivazione notifiche
- Configurazione tempo di preavviso promemoria
- Categoria predefinita
- Statistiche degli appuntamenti
- Caricamento dati di esempio
- Eliminazione di tutti i dati

## Categorie Disponibili

| Categoria | Icona | Colore |
|-----------|-------|--------|
| Personale | 👤 | Blu |
| Lavoro | 💼 | Arancione |
| Salute | ❤️ | Rosso |
| Famiglia | 🏠 | Verde |
| Sociale | 👥 | Viola |
| Altro | ⭐ | Grigio |

## Requisiti

- iOS 16.0 o successivo
- Xcode 15.0 o successivo
- Swift 5.9

## Installazione

1. Clona il repository
2. Apri `AppuntamentiApp.xcodeproj` in Xcode
3. Seleziona il tuo dispositivo o simulatore
4. Premi `Cmd + R` per compilare ed eseguire

## Struttura del Progetto

```
AppuntamentiApp/
├── AppuntamentiApp.swift          # Entry point dell'app
├── Models/
│   └── Appointment.swift          # Modello dati appuntamento
├── Services/
│   └── AppointmentStore.swift     # Gestione dati e persistenza
├── Views/
│   ├── ContentView.swift          # Tab view principale
│   ├── HomeView.swift             # Schermata home
│   ├── AppointmentListView.swift  # Lista appuntamenti
│   ├── AddAppointmentView.swift   # Form creazione
│   ├── AppointmentDetailView.swift # Dettaglio e modifica
│   ├── CalendarView.swift         # Vista calendario
│   ├── SettingsView.swift         # Impostazioni
│   └── Components/
│       └── AppointmentCard.swift  # Card appuntamento riutilizzabile
├── Assets.xcassets/               # Risorse grafiche
└── Info.plist                     # Configurazione app
```

## Persistenza Dati

I dati vengono salvati localmente usando `UserDefaults` con codifica JSON. Gli appuntamenti persistono tra le sessioni dell'app.

## Localizzazione

L'app è completamente localizzata in italiano:
- Date e orari nel formato italiano
- Nomi dei giorni e mesi in italiano
- Interfaccia utente in italiano

## Caratteristiche Tecniche

- **SwiftUI**: Framework UI moderno e dichiarativo
- **MVVM Architecture**: Separazione tra Model, View e ViewModel
- **Codable**: Serializzazione automatica dei dati
- **Environment Objects**: Condivisione dello stato tra le views
- **Combine**: Reattività e aggiornamenti automatici dell'UI

## Personalizzazione

### Aggiungere una nuova categoria

1. Aggiungi un nuovo caso in `AppointmentCategory` in `Appointment.swift`
2. Definisci `iconName` e `color` nei rispettivi switch
3. L'UI si aggiornerà automaticamente

### Modificare i colori

I colori sono definiti usando i colori di sistema di SwiftUI per supportare automaticamente la modalità chiara e scura.

## Licenza

Questo progetto è rilasciato sotto licenza MIT.

---

## Sviluppato da

<p align="center">
  <strong>DBM Informatica</strong><br>
  Soluzioni digitali per il tuo business
</p>

<p align="center">
  🌐 www.dbminformatica.it<br>
  ✉️ info@dbminformatica.it
</p>

---

© 2026 DBM Informatica. Tutti i diritti riservati.
