import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var appointmentStore: AppointmentStore
    @State private var selectedDate = Date()
    @State private var showingAddAppointment = false
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                calendarHeader
                
                calendarGrid
                
                Divider()
                
                appointmentsForSelectedDate
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Calendario")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddAppointment = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Oggi") {
                        withAnimation {
                            selectedDate = Date()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddAppointment) {
                AddAppointmentView()
            }
        }
    }
    
    private var calendarHeader: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            HStack {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
    }
    
    private var calendarGrid: some View {
        let days = generateDaysInMonth()
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(days, id: \.self) { date in
                if let date = date {
                    CalendarDayCell(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isToday: calendar.isDateInToday(date),
                        hasAppointments: !appointmentStore.appointmentsForDate(date).isEmpty,
                        appointmentCount: appointmentStore.appointmentsForDate(date).count
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedDate = date
                        }
                    }
                } else {
                    Color.clear
                        .frame(height: 44)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom)
        .background(Color(.systemBackground))
    }
    
    private var appointmentsForSelectedDate: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(selectedDateString)
                    .font(.headline)
                
                Spacer()
                
                Text("\(appointmentStore.appointmentsForDate(selectedDate).count) appuntamenti")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.top)
            
            let dayAppointments = appointmentStore.appointmentsForDate(selectedDate)
            
            if dayAppointments.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("Nessun appuntamento")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button("Aggiungi") {
                        showingAddAppointment = true
                    }
                    .font(.subheadline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(dayAppointments) { appointment in
                            NavigationLink(destination: AppointmentDetailView(appointment: appointment)) {
                                AppointmentCard(appointment: appointment, isCompact: true)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    private var monthYearString: String {
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: selectedDate).capitalized
    }
    
    private var selectedDateString: String {
        dateFormatter.dateFormat = "EEEE d MMMM"
        return dateFormatter.string(from: selectedDate).capitalized
    }
    
    private var weekdaySymbols: [String] {
        let symbols = calendar.shortWeekdaySymbols
        let firstWeekday = calendar.firstWeekday
        return Array(symbols[firstWeekday-1..<symbols.count]) + Array(symbols[0..<firstWeekday-1])
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: selectedDate) {
            withAnimation {
                selectedDate = newDate
            }
        }
    }
    
    private func generateDaysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        var days: [Date?] = []
        var currentDate = monthFirstWeek.start
        
        let firstWeekday = calendar.firstWeekday
        let weekdayOfFirst = calendar.component(.weekday, from: monthInterval.start)
        let offset = (weekdayOfFirst - firstWeekday + 7) % 7
        
        for _ in 0..<offset {
            days.append(nil)
        }
        
        while currentDate < monthInterval.end {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return days
    }
}

struct CalendarDayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasAppointments: Bool
    let appointmentCount: Int
    let action: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.system(size: 16, weight: isSelected || isToday ? .semibold : .regular))
                    .foregroundColor(textColor)
                
                if hasAppointments {
                    HStack(spacing: 2) {
                        ForEach(0..<min(appointmentCount, 3), id: \.self) { _ in
                            Circle()
                                .fill(isSelected ? .white : .blue)
                                .frame(width: 5, height: 5)
                        }
                    }
                } else {
                    Color.clear
                        .frame(height: 5)
                }
            }
            .frame(width: 44, height: 44)
            .background(backgroundColor)
            .cornerRadius(10)
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        } else if isToday {
            return .blue
        } else {
            return .primary
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .blue
        } else if isToday {
            return .blue.opacity(0.15)
        } else {
            return .clear
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(AppointmentStore())
    }
}
