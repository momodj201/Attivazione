import SwiftUI

struct AppointmentDetailView: View {
    @EnvironmentObject var appointmentStore: AppointmentStore
    @Environment(\.dismiss) var dismiss
    
    let appointment: Appointment
    
    @State private var isEditing = false
    @State private var showingDeleteAlert = false
    
    @State private var editedTitle: String = ""
    @State private var editedDescription: String = ""
    @State private var editedDate: Date = Date()
    @State private var editedLocation: String = ""
    @State private var editedReminderEnabled: Bool = false
    @State private var editedCategory: AppointmentCategory = .personal
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerCard
                
                if isEditing {
                    editForm
                } else {
                    detailsCard
                    
                    if !appointment.description.isEmpty {
                        descriptionCard
                    }
                    
                    actionsCard
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(isEditing ? "Modifica" : "Dettagli")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Salva") {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                } else {
                    Menu {
                        Button(action: { startEditing() }) {
                            Label("Modifica", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: { showingDeleteAlert = true }) {
                            Label("Elimina", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            
            if isEditing {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annulla") {
                        isEditing = false
                    }
                }
            }
        }
        .alert("Elimina Appuntamento", isPresented: $showingDeleteAlert) {
            Button("Annulla", role: .cancel) { }
            Button("Elimina", role: .destructive) {
                deleteAppointment()
            }
        } message: {
            Text("Sei sicuro di voler eliminare questo appuntamento? L'azione non può essere annullata.")
        }
    }
    
    private var headerCard: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.15))
                    .frame(width: 80, height: 80)
                
                Image(systemName: appointment.category.iconName)
                    .font(.system(size: 35))
                    .foregroundColor(categoryColor)
            }
            
            Text(isEditing ? editedTitle : appointment.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            HStack {
                Label(
                    isEditing ? editedCategory.rawValue : appointment.category.rawValue,
                    systemImage: isEditing ? editedCategory.iconName : appointment.category.iconName
                )
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(categoryColor)
                .cornerRadius(16)
            }
            
            if appointment.isPast && !isEditing {
                Label("Passato", systemImage: "clock.badge.checkmark")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            DetailRow(
                icon: "calendar",
                title: "Data",
                value: appointment.formattedDateOnly,
                color: .blue
            )
            
            Divider()
            
            DetailRow(
                icon: "clock",
                title: "Ora",
                value: appointment.formattedTime,
                color: .orange
            )
            
            if !appointment.location.isEmpty {
                Divider()
                
                DetailRow(
                    icon: "location.fill",
                    title: "Luogo",
                    value: appointment.location,
                    color: .green
                )
            }
            
            Divider()
            
            DetailRow(
                icon: appointment.reminderEnabled ? "bell.fill" : "bell.slash",
                title: "Promemoria",
                value: appointment.reminderEnabled ? "Attivo" : "Disattivato",
                color: appointment.reminderEnabled ? .orange : .gray
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "text.alignleft")
                    .foregroundColor(.purple)
                Text("Note")
                    .font(.headline)
            }
            
            Text(appointment.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var editForm: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Titolo")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Titolo", text: $editedTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Descrizione")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Descrizione", text: $editedDescription, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3...6)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Data e Ora")
                    .font(.caption)
                    .foregroundColor(.secondary)
                DatePicker(
                    "",
                    selection: $editedDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "it_IT"))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Luogo")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Luogo", text: $editedLocation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Categoria")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Picker("Categoria", selection: $editedCategory) {
                    ForEach(AppointmentCategory.allCases, id: \.self) { cat in
                        HStack {
                            Image(systemName: cat.iconName)
                            Text(cat.rawValue)
                        }
                        .tag(cat)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Toggle(isOn: $editedReminderEnabled) {
                HStack {
                    Image(systemName: "bell.fill")
                        .foregroundColor(.orange)
                    Text("Promemoria")
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var actionsCard: some View {
        VStack(spacing: 12) {
            Button(action: { startEditing() }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Modifica Appuntamento")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Elimina Appuntamento")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.1))
                .foregroundColor(.red)
                .cornerRadius(12)
            }
        }
    }
    
    private var categoryColor: Color {
        let cat = isEditing ? editedCategory : appointment.category
        switch cat {
        case .personal: return .blue
        case .work: return .orange
        case .health: return .red
        case .family: return .green
        case .social: return .purple
        case .other: return .gray
        }
    }
    
    private func startEditing() {
        editedTitle = appointment.title
        editedDescription = appointment.description
        editedDate = appointment.date
        editedLocation = appointment.location
        editedReminderEnabled = appointment.reminderEnabled
        editedCategory = appointment.category
        isEditing = true
    }
    
    private func saveChanges() {
        var updatedAppointment = appointment
        updatedAppointment.title = editedTitle
        updatedAppointment.description = editedDescription
        updatedAppointment.date = editedDate
        updatedAppointment.location = editedLocation
        updatedAppointment.reminderEnabled = editedReminderEnabled
        updatedAppointment.category = editedCategory
        
        appointmentStore.update(updatedAppointment)
        isEditing = false
    }
    
    private func deleteAppointment() {
        appointmentStore.delete(appointment)
        dismiss()
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
            }
            
            Spacer()
        }
    }
}

struct AppointmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppointmentDetailView(
                appointment: Appointment(
                    title: "Visita medica",
                    description: "Controllo annuale dal dottore",
                    date: Date(),
                    location: "Studio Medico Rossi",
                    reminderEnabled: true,
                    category: .health
                )
            )
            .environmentObject(AppointmentStore())
        }
    }
}
