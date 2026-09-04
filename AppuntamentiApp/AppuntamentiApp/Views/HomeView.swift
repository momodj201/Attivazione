import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appointmentStore: AppointmentStore
    @State private var showingAddAppointment = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    
                    if !appointmentStore.todayAppointments.isEmpty {
                        todaySection
                    }
                    
                    upcomingSection
                    
                    if appointmentStore.appointments.isEmpty {
                        emptyStateView
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Appuntamenti")
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
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(currentDateString)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(greetingMessage)
                .font(.title)
                .fontWeight(.bold)
            
            HStack(spacing: 20) {
                StatCard(
                    title: "Oggi",
                    count: appointmentStore.todayAppointments.count,
                    icon: "sun.max.fill",
                    color: .orange
                )
                
                StatCard(
                    title: "In arrivo",
                    count: appointmentStore.upcomingAppointments.count,
                    icon: "calendar",
                    color: .blue
                )
            }
        }
    }
    
    private var todaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Oggi", icon: "sun.max.fill")
            
            ForEach(appointmentStore.todayAppointments) { appointment in
                NavigationLink(destination: AppointmentDetailView(appointment: appointment)) {
                    AppointmentCard(appointment: appointment, isCompact: false)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Prossimi appuntamenti", icon: "calendar.badge.clock")
            
            if appointmentStore.upcomingAppointments.isEmpty {
                Text("Nessun appuntamento in programma")
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
            } else {
                ForEach(appointmentStore.upcomingAppointments.prefix(5)) { appointment in
                    NavigationLink(destination: AppointmentDetailView(appointment: appointment)) {
                        AppointmentCard(appointment: appointment, isCompact: true)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.blue.opacity(0.5))
            
            Text("Nessun appuntamento")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tocca il pulsante + per aggiungere\nil tuo primo appuntamento")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: { showingAddAppointment = true }) {
                Label("Aggiungi Appuntamento", systemImage: "plus")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter.string(from: Date()).capitalized
    }
    
    private var greetingMessage: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "Buongiorno! ☀️"
        case 12..<18:
            return "Buon pomeriggio! 🌤"
        case 18..<22:
            return "Buonasera! 🌙"
        default:
            return "Buonanotte! 🌟"
        }
    }
}

struct StatCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
                Text("\(count)")
                    .font(.title)
                    .fontWeight(.bold)
            }
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppointmentStore())
    }
}
