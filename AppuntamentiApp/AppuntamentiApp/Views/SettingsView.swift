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
