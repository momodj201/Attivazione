import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appointmentStore: AppointmentStore
    @State private var showingClearAlert = false
    @State private var showingSampleDataAlert = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("defaultCategory") private var defaultCategory = AppointmentCategory.personal.rawValue
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Notifiche")) {
                    Toggle(isOn: $notificationsEnabled) {
                        HStack {
                            settingsIcon("bell.fill", color: .red)
                            Text("Abilita notifiche")
                        }
                    }
                    
                    if notificationsEnabled {
                        NavigationLink {
                            NotificationSettingsView()
                        } label: {
                            HStack {
                                settingsIcon("bell.badge", color: .orange)
                                Text("Impostazioni notifiche")
                            }
                        }
                    }
                }
                
                Section(header: Text("Preferenze")) {
                    Picker(selection: $defaultCategory) {
                        ForEach(AppointmentCategory.allCases, id: \.rawValue) { category in
                            HStack {
                                Image(systemName: category.iconName)
                                Text(category.rawValue)
                            }
                            .tag(category.rawValue)
                        }
                    } label: {
                        HStack {
                            settingsIcon("tag.fill", color: .blue)
                            Text("Categoria predefinita")
                        }
                    }
                }
                
                Section(header: Text("Dati")) {
                    Button(action: { showingSampleDataAlert = true }) {
                        HStack {
                            settingsIcon("wand.and.stars", color: .purple)
                            Text("Carica dati di esempio")
                            Spacer()
                        }
                    }
                    .foregroundColor(.primary)
                    
                    Button(action: { showingClearAlert = true }) {
                        HStack {
                            settingsIcon("trash.fill", color: .red)
                            Text("Elimina tutti gli appuntamenti")
                            Spacer()
                        }
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("Statistiche")) {
                    HStack {
                        settingsIcon("chart.bar.fill", color: .green)
                        Text("Totale appuntamenti")
                        Spacer()
                        Text("\(appointmentStore.appointments.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        settingsIcon("calendar.badge.clock", color: .blue)
                        Text("In arrivo")
                        Spacer()
                        Text("\(appointmentStore.upcomingAppointments.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        settingsIcon("checkmark.circle.fill", color: .gray)
                        Text("Passati")
                        Spacer()
                        Text("\(appointmentStore.pastAppointments.count)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Informazioni")) {
                    HStack {
                        settingsIcon("info.circle.fill", color: .blue)
                        Text("Versione")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    NavigationLink {
                        AboutView()
                    } label: {
                        HStack {
                            settingsIcon("questionmark.circle.fill", color: .teal)
                            Text("Informazioni sull'app")
                        }
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        DBMLogoCompact()
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Impostazioni")
            .alert("Elimina Tutti", isPresented: $showingClearAlert) {
                Button("Annulla", role: .cancel) { }
                Button("Elimina", role: .destructive) {
                    clearAllAppointments()
                }
            } message: {
                Text("Sei sicuro di voler eliminare tutti gli appuntamenti? Questa azione non può essere annullata.")
            }
            .alert("Carica Dati di Esempio", isPresented: $showingSampleDataAlert) {
                Button("Annulla", role: .cancel) { }
                Button("Carica") {
                    appointmentStore.addSampleData()
                }
            } message: {
                Text("Verranno aggiunti alcuni appuntamenti di esempio per provare l'app.")
            }
        }
    }
    
    private func settingsIcon(_ name: String, color: Color) -> some View {
        Image(systemName: name)
            .foregroundColor(.white)
            .frame(width: 28, height: 28)
            .background(color)
            .cornerRadius(6)
    }
    
    private func clearAllAppointments() {
        for appointment in appointmentStore.appointments {
            appointmentStore.delete(appointment)
        }
    }
}

struct NotificationSettingsView: View {
    @AppStorage("reminderTime") private var reminderTime = 30
    
    var body: some View {
        List {
            Section(header: Text("Tempo di preavviso")) {
                Picker("Minuti prima", selection: $reminderTime) {
                    Text("5 minuti").tag(5)
                    Text("10 minuti").tag(10)
                    Text("15 minuti").tag(15)
                    Text("30 minuti").tag(30)
                    Text("1 ora").tag(60)
                    Text("2 ore").tag(120)
                    Text("1 giorno").tag(1440)
                }
            }
            
            Section(footer: Text("Riceverai una notifica prima di ogni appuntamento con promemoria attivato.")) {
                EmptyView()
            }
        }
        .navigationTitle("Notifiche")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Appuntamenti")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Versione 1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    DBMLogoBadge()
                }
                .padding(.top, 40)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Funzionalità")
                        .font(.headline)
                    
                    FeatureRow(icon: "plus.circle.fill", color: .blue, title: "Crea appuntamenti", description: "Aggiungi facilmente nuovi appuntamenti con titolo, data, luogo e categoria")
                    
                    FeatureRow(icon: "calendar", color: .orange, title: "Vista calendario", description: "Visualizza tutti i tuoi appuntamenti in una comoda vista calendario")
                    
                    FeatureRow(icon: "bell.fill", color: .red, title: "Promemoria", description: "Ricevi notifiche per non dimenticare mai un appuntamento importante")
                    
                    FeatureRow(icon: "tag.fill", color: .purple, title: "Categorie", description: "Organizza i tuoi appuntamenti per categoria: lavoro, salute, famiglia e altro")
                    
                    FeatureRow(icon: "magnifyingglass", color: .green, title: "Ricerca", description: "Trova rapidamente i tuoi appuntamenti con la funzione di ricerca")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                VStack(spacing: 20) {
                    Divider()
                        .padding(.horizontal)
                    
                    Text("Sviluppato da")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    DBMLogoView(size: .medium)
                    
                    VStack(spacing: 4) {
                        Text("www.dbminformatica.it")
                            .font(.footnote)
                            .foregroundColor(.blue)
                        
                        Text("info@dbminformatica.it")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Informazioni")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(color)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppointmentStore())
    }
}

// MARK: - DBM Logo Components

struct DBMLogoView: View {
    var size: LogoSize = .medium
    var showTagline: Bool = true
    
    enum LogoSize {
        case small, medium, large, extraLarge
        
        var imageSize: CGFloat {
            switch self {
            case .small: return 60
            case .medium: return 100
            case .large: return 150
            case .extraLarge: return 200
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 18
            case .medium: return 28
            case .large: return 42
            case .extraLarge: return 56
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 24
            case .medium: return 40
            case .large: return 60
            case .extraLarge: return 80
            }
        }
        
        var spacing: CGFloat {
            switch self {
            case .small: return 4
            case .medium: return 8
            case .large: return 12
            case .extraLarge: return 16
            }
        }
    }
    
    var body: some View {
        VStack(spacing: size.spacing) {
            HStack(spacing: size.spacing) {
                ZStack {
                    RoundedRectangle(cornerRadius: size.iconSize / 5)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue, Color.blue.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: size.iconSize, height: size.iconSize)
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "desktopcomputer")
                        .font(.system(size: size.iconSize * 0.5, weight: .medium))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("DBM")
                        .font(.system(size: size.fontSize, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("informatica")
                        .font(.system(size: size.fontSize * 0.5, weight: .medium, design: .rounded))
                        .foregroundColor(.blue)
                }
            }
            
            if showTagline && size != .small {
                Text("Soluzioni digitali per il tuo business")
                    .font(.system(size: size.fontSize * 0.35, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct DBMLogoCompact: View {
    var body: some View {
        HStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)
                
                Image(systemName: "desktopcomputer")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Text("DBM")
                .font(.system(size: 16, weight: .bold, design: .rounded))
            + Text(" informatica")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.blue)
        }
    }
}

struct DBMLogoBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.seal.fill")
                .font(.caption2)
                .foregroundColor(.blue)
            
            Text("by DBM informatica")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}
