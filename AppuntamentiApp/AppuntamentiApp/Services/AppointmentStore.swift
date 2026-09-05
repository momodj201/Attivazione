import Foundation
import SwiftUI

class AppointmentStore: ObservableObject {
    @Published var appointments: [Appointment] = []
    
    private let saveKey = "SavedAppointments"
    
    init() {
        loadAppointments()
    }
    
    var upcomingAppointments: [Appointment] {
        appointments
            .filter { $0.isUpcoming }
            .sorted { $0.date < $1.date }
    }
    
    var pastAppointments: [Appointment] {
        appointments
            .filter { $0.isPast }
            .sorted { $0.date > $1.date }
    }
    
    var todayAppointments: [Appointment] {
        appointments
            .filter { $0.isToday }
            .sorted { $0.date < $1.date }
    }
    
    func appointmentsForDate(_ date: Date) -> [Appointment] {
        appointments.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.date < $1.date }
    }
    
    func appointmentsByCategory(_ category: AppointmentCategory) -> [Appointment] {
        appointments.filter { $0.category == category }
            .sorted { $0.date < $1.date }
    }
    
    func add(_ appointment: Appointment) {
        appointments.append(appointment)
        saveAppointments()
    }
    
    func update(_ appointment: Appointment) {
        if let index = appointments.firstIndex(where: { $0.id == appointment.id }) {
            appointments[index] = appointment
            saveAppointments()
        }
    }
    
    func delete(_ appointment: Appointment) {
        appointments.removeAll { $0.id == appointment.id }
        saveAppointments()
    }
    
    func delete(at offsets: IndexSet, from list: [Appointment]) {
        for index in offsets {
            let appointment = list[index]
            delete(appointment)
        }
    }
    
    private func saveAppointments() {
        if let encoded = try? JSONEncoder().encode(appointments) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadAppointments() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Appointment].self, from: data) {
            appointments = decoded
        }
    }
    
    func addSampleData() {
        let sampleAppointments = [
            Appointment(
                title: "Visita medica",
                description: "Controllo annuale dal dottore",
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                location: "Studio Medico Rossi",
                reminderEnabled: true,
                category: .health
            ),
            Appointment(
                title: "Riunione di lavoro",
                description: "Presentazione del nuovo progetto",
                date: Calendar.current.date(byAdding: .hour, value: 3, to: Date())!,
                location: "Ufficio - Sala Conferenze",
                reminderEnabled: true,
                category: .work
            ),
            Appointment(
                title: "Cena con amici",
                description: "Festeggiare il compleanno di Marco",
                date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
                location: "Ristorante Da Luigi",
                reminderEnabled: false,
                category: .social
            ),
            Appointment(
                title: "Dentista",
                description: "Pulizia denti semestrale",
                date: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
                location: "Studio Dentistico Bianchi",
                reminderEnabled: true,
                category: .health
            ),
            Appointment(
                title: "Pranzo in famiglia",
                date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
                location: "Casa dei genitori",
                category: .family
            )
        ]
        
        for appointment in sampleAppointments {
            if !appointments.contains(where: { $0.title == appointment.title }) {
                add(appointment)
            }
        }
    }
}
