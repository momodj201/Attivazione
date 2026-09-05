import Foundation

struct Appointment: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var description: String
    var date: Date
    var location: String
    var reminderEnabled: Bool
    var category: AppointmentCategory
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        date: Date,
        location: String = "",
        reminderEnabled: Bool = false,
        category: AppointmentCategory = .personal
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.location = location
        self.reminderEnabled = reminderEnabled
        self.category = category
    }
    
    var isUpcoming: Bool {
        date > Date()
    }
    
    var isPast: Bool {
        date < Date()
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var formattedDateOnly: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

enum AppointmentCategory: String, Codable, CaseIterable {
    case personal = "Personale"
    case work = "Lavoro"
    case health = "Salute"
    case family = "Famiglia"
    case social = "Sociale"
    case other = "Altro"
    
    var iconName: String {
        switch self {
        case .personal: return "person.fill"
        case .work: return "briefcase.fill"
        case .health: return "heart.fill"
        case .family: return "house.fill"
        case .social: return "person.3.fill"
        case .other: return "star.fill"
        }
    }
    
    var color: String {
        switch self {
        case .personal: return "blue"
        case .work: return "orange"
        case .health: return "red"
        case .family: return "green"
        case .social: return "purple"
        case .other: return "gray"
        }
    }
}
