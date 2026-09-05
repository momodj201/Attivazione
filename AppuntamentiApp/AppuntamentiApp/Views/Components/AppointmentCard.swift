import SwiftUI

struct AppointmentCard: View {
    let appointment: Appointment
    let isCompact: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            categoryIndicator
            
            VStack(alignment: .leading, spacing: 6) {
                Text(appointment.title)
                    .font(isCompact ? .subheadline : .headline)
                    .fontWeight(.semibold)
                    .foregroundColor(appointment.isPast ? .secondary : .primary)
                    .lineLimit(1)
                
                HStack(spacing: 12) {
                    Label(appointment.formattedTime, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if !appointment.location.isEmpty && !isCompact {
                        Label(appointment.location, systemImage: "location")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                if !isCompact && !appointment.description.isEmpty {
                    Text(appointment.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Image(systemName: appointment.category.iconName)
                    .foregroundColor(categoryColor)
                
                if appointment.reminderEnabled {
                    Image(systemName: "bell.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var categoryIndicator: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(categoryColor)
            .frame(width: 4)
            .frame(maxHeight: .infinity)
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

struct AppointmentCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AppointmentCard(
                appointment: Appointment(
                    title: "Visita medica",
                    description: "Controllo annuale dal dottore",
                    date: Date(),
                    location: "Studio Medico Rossi",
                    reminderEnabled: true,
                    category: .health
                ),
                isCompact: false
            )
            
            AppointmentCard(
                appointment: Appointment(
                    title: "Riunione di lavoro",
                    date: Date(),
                    location: "Ufficio",
                    category: .work
                ),
                isCompact: true
            )
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}
