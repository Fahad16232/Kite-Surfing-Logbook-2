import SwiftUI

struct GearMaintenanceView: View {
    @ObservedObject var manager = GearMaintenanceManager()
    @State private var showingAddMaintenanceView = false
    @State private var searchText = ""

    var filteredLogs: [GearMaintenance] {
        if searchText.isEmpty {
            return manager.maintenanceLogs
        } else {
            return manager.maintenanceLogs.filter { log in
                log.name.lowercased().contains(searchText.lowercased()) ||
                log.gearType.lowercased().contains(searchText.lowercased()) ||
                log.performedBy.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Search bar
                    SearchBar(text: $searchText, placeholder: "Search by name, gear type, or performed by")
                        .padding(.horizontal)

                    if manager.maintenanceLogs.isEmpty {
                        // Empty state view
                        VStack {
                            Image(systemName: "wrench")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray.opacity(0.6))
                            Text("No Maintenance Logs Yet")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                    } else {
                        List {
                            ForEach(filteredLogs) { log in
                                NavigationLink(destination: AddEditMaintenanceView(manager: manager, maintenanceLog: log)) {
                                    maintenanceRow(log: log)
                                }
                                .listRowBackground(Color.white.opacity(0.7))
                                .cornerRadius(12)
                                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                                .padding(.vertical, 5)
                            }
                            .onDelete(perform: manager.deleteMaintenanceLog)
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }
                }
            }
            .navigationTitle("Gear Maintenance")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddMaintenanceView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddMaintenanceView) {
                AddEditMaintenanceView(manager: manager)
            }
        }
    }

    // Card-styled row view for each maintenance log
    func maintenanceRow(log: GearMaintenance) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(log.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            Text("\(log.gearType) Maintenance")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text("Maintenance Date: \(log.maintenanceDate, style: .date)")
                    .font(.subheadline)
            }

            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(.gray)
                Text("Next Check: \(log.nextCheckDate, style: .date)")
                    .font(.subheadline)
            }

            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                Text("Performed By: \(log.performedBy)")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}
