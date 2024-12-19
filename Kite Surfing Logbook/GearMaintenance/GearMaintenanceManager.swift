import Foundation

class GearMaintenanceManager: ObservableObject {
    @Published var maintenanceLogs: [GearMaintenance] = []

    private let userDefaultsKey = "gearMaintenanceLogs"

    init() {
        loadMaintenanceLogs()
        if maintenanceLogs.isEmpty {
            loadSampleData()
        }
    }

    // Create or Update a Gear Maintenance Log
    func saveMaintenanceLog(_ maintenanceLog: GearMaintenance) {
        if let index = maintenanceLogs.firstIndex(where: { $0.id == maintenanceLog.id }) {
            maintenanceLogs[index] = maintenanceLog
        } else {
            maintenanceLogs.append(maintenanceLog)
        }
        saveToUserDefaults()
    }

    // Delete a Gear Maintenance Log
    func deleteMaintenanceLog(at offsets: IndexSet) {
        maintenanceLogs.remove(atOffsets: offsets)
        saveToUserDefaults()
    }

    // Load Gear Maintenance Logs from UserDefaults
    private func loadMaintenanceLogs() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let decoded = try? JSONDecoder().decode([GearMaintenance].self, from: data) {
                maintenanceLogs = decoded
            }
        }
    }

    // Save Gear Maintenance Logs to UserDefaults
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(maintenanceLogs) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    // Load Sample Data
    private func loadSampleData() {
        let sampleLogs = [
            GearMaintenance(
                name: "Kite Bladder Replacement",
                gearType: "Kite",
                description: "Replaced the leading edge bladder.",
                maintenanceDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
                nextCheckDate: Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
                performedBy: "Kite Repair Shop",
                notes: "Tested and works perfectly."
            ),
            GearMaintenance(
                name: "Board Fin Repair",
                gearType: "Board",
                description: "Repaired a broken fin.",
                maintenanceDate: Calendar.current.date(byAdding: .day, value: -20, to: Date())!,
                nextCheckDate: Calendar.current.date(byAdding: .month, value: 3, to: Date())!,
                performedBy: "Self",
                notes: "Reinforced with epoxy."
            ),
            GearMaintenance(
                name: "Bar Lines Check",
                gearType: "Bar/Lines",
                description: "Checked lines for wear and tear.",
                maintenanceDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                nextCheckDate: Calendar.current.date(byAdding: .weekOfYear, value: 2, to: Date())!,
                performedBy: "Self",
                notes: "Lines are in good condition."
            ),
            GearMaintenance(
                name: "Harness Stitch Repair",
                gearType: "Harness",
                description: "Repaired stitching on the harness.",
                maintenanceDate: Calendar.current.date(byAdding: .day, value: -15, to: Date())!,
                nextCheckDate: Calendar.current.date(byAdding: .month, value: 2, to: Date())!,
                performedBy: "Local Shop",
                notes: "Stitching reinforced, looks solid."
            )
        ]

        maintenanceLogs = sampleLogs
        saveToUserDefaults()
    }
}
