import SwiftUI

struct AddAppointmentView: View {
    @EnvironmentObject var appointmentStore: AppointmentStore
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var location = ""
    @State private var reminderEnabled = false
    @State private var category: AppointmentCategory = .personal
    
    @State private var showingValidationAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informazioni Principali")) {
                    TextField("Titolo *", text: $title)
                        .textContentType(.name)
                    
                    TextField("Descrizione", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("Data e Ora")) {
                    DatePicker(
                        "Data e Ora",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .environment(\.locale, Locale(identifier: "it_IT"))
                }
                
                Section(header: Text("Luogo")) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                        TextField("Inserisci luogo", text: $location)
                    }
                }
                
                Section(header: Text("Categoria")) {
                    Picker("Categoria", selection: $category) {
                        ForEach(AppointmentCategory.allCases, id: \.self) { cat in
                            HStack {
                                Image(systemName: cat.iconName)
                                Text(cat.rawValue)
                            }
                            .tag(cat)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Promemoria")) {
                    Toggle(isOn: $reminderEnabled) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.orange)
                            Text("Attiva promemoria")
                        }
                    }
                    
                    if reminderEnabled {
                        Text("Riceverai una notifica 30 minuti prima dell'appuntamento")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button(action: saveAppointment) {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                            Text("Salva Appuntamento")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("Nuovo Appuntamento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annulla") {
                        dismiss()
                    }
                }
            }
            .alert("Titolo Richiesto", isPresented: $showingValidationAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Inserisci un titolo per l'appuntamento")
            }
        }
    }
    
    private func saveAppointment() {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showingValidationAlert = true
            return
        }
        
        let newAppointment = Appointment(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            date: date,
            location: location.trimmingCharacters(in: .whitespacesAndNewlines),
            reminderEnabled: reminderEnabled,
            category: category
        )
        
        appointmentStore.add(newAppointment)
        dismiss()
    }
}

struct AddAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        AddAppointmentView()
            .environmentObject(AppointmentStore())
    }
}
