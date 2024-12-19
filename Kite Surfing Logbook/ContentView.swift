

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SessionLogsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Session Logs")
                }

            KiteInventoryView()
                .tabItem {
                    Image(systemName: "paperplane")
                    Text("Kite Inventory")
                }

            GearMaintenanceView()
                .tabItem {
                    Image(systemName: "wrench")
                    Text("Gear Maintenance")
                }

            WindConditionsView()
                .tabItem {
                    Image(systemName: "wind")
                    Text("Wind Conditions")
                }

            AchievementsView()
                .tabItem {
                    Image(systemName: "star")
                    Text("Achievements")
                }
        }
    }
}
