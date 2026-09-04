import SwiftUI

@main
struct AppuntamentiApp: App {
    @StateObject private var appointmentStore = AppointmentStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appointmentStore)
        }
    }
}
