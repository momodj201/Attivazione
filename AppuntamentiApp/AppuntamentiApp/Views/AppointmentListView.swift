import SwiftUI

struct AppointmentListView: View {
    @EnvironmentObject var appointmentStore: AppointmentStore
    @State private var showingAddAppointment = false
    @State private var searchText = ""
    @State private var selectedFilter: FilterOption = .all
    @State private var selectedCategory: AppointmentCategory?
    
    enum FilterOption: String, CaseIterable {
        case all = "Tutti"
        case upcoming = "In arrivo"
        case past = "Passati"
        case today = "Oggi"
    }
    
    var filteredAppointments: [Appointment] {
        var appointments: [Appointment]
        
        switch selectedFilter {
        case .all:
            appointments = appointmentStore.appointments.sorted { $0.date < $1.date }
        case .upcoming:
            appointments = appointmentStore.upcomingAppointments
        case .past:
            appointments = appointmentStore.pastAppointments
        case .today:
            appointments = appointmentStore.todayAppointments
        }
        
        if let category = selectedCategory {
            appointments = appointments.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            appointments = appointments.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.location.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return appointments
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                filterPicker
                categoryFilter
                
                if filteredAppointments.isEmpty {
                    emptyView
                } else {
                    appointmentList
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Tutti gli Appuntamenti")
            .searchable(text: $searchText, prompt: "Cerca appuntamenti")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddAppointment = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddAppointment) {
                AddAppointmentView()
            }
        }
    }
    
    private var filterPicker: some View {
        Picker("Filtro", selection: $selectedFilter) {
            ForEach(FilterOption.allCases, id: \.self) { option in
                Text(option.rawValue).tag(option)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryFilterChip(
                    title: "Tutte",
                    isSelected: selectedCategory == nil,
                    color: .gray
                ) {
                    selectedCategory = nil
                }
                
                ForEach(AppointmentCategory.allCases, id: \.self) { category in
                    CategoryFilterChip(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        color: categoryColor(category)
                    ) {
                        selectedCategory = selectedCategory == category ? nil : category
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }
    
    private var appointmentList: some View {
        List {
            ForEach(filteredAppointments) { appointment in
                NavigationLink(destination: AppointmentDetailView(appointment: appointment)) {
                    AppointmentRow(appointment: appointment)
                }
            }
            .onDelete { indexSet in
                appointmentStore.delete(at: indexSet, from: filteredAppointments)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Nessun risultato")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Prova a modificare i filtri\no la ricerca")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func categoryColor(_ category: AppointmentCategory) -> Color {
        switch category {
        case .personal: return .blue
        case .work: return .orange
        case .health: return .red
        case .family: return .green
        case .social: return .purple
        case .other: return .gray
        }
    }
}

struct CategoryFilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? color : Color(.systemBackground))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.3), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

struct AppointmentRow: View {
    let appointment: Appointment
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(categoryColor)
                .frame(width: 10, height: 10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(appointment.title)
                    .font(.headline)
                    .foregroundColor(appointment.isPast ? .secondary : .primary)
                
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(appointment.formattedDate)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                
                if !appointment.location.isEmpty {
                    HStack {
                        Image(systemName: "location")
                            .font(.caption)
                        Text(appointment.location)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: appointment.category.iconName)
                .foregroundColor(categoryColor)
                .font(.title3)
        }
        .padding(.vertical, 4)
    }
    
    private var categoryColor: Color {
        switch appointment.category {
        case .personal: return .blue
        case .work: return .orange
        case .health: return .red
        case .family: return .green
        case .social: return .purple
        case .other: return .gray
        }
    }
}

struct AppointmentListView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentListView()
            .environmentObject(AppointmentStore())
    }
}
