import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appointmentStore: AppointmentStore
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            AppointmentListView()
                .tabItem {
                    Label("Appuntamenti", systemImage: "list.bullet")
                }
                .tag(1)
            
            CalendarView()
                .tabItem {
                    Label("Calendario", systemImage: "calendar")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Impostazioni", systemImage: "gear")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppointmentStore())
    }
}
