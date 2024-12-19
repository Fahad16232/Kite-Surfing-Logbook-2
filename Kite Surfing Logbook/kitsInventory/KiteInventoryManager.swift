import Foundation

class KiteInventoryManager: ObservableObject {
    @Published var kites: [Kite] = []
    
    private let userDefaultsKey = "kiteInventory"
    
    init() {
        loadKites()
        if kites.isEmpty {
            loadSampleData()
        }
    }
    
    // Create or Update a Kite
    func saveKite(_ kite: Kite) {
        if let index = kites.firstIndex(where: { $0.id == kite.id }) {
            kites[index] = kite
        } else {
            kites.append(kite)
        }
        saveToUserDefaults()
    }
    
    // Delete a Kite
    func deleteKite(at offsets: IndexSet) {
        kites.remove(atOffsets: offsets)
        saveToUserDefaults()
    }
    
    // Load Kites from UserDefaults
    private func loadKites() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let decoded = try? JSONDecoder().decode([Kite].self, from: data) {
                kites = decoded
            }
        }
    }
    
    // Save Kites to UserDefaults
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(kites) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    // Load Sample Data
    private func loadSampleData() {
        let sampleKites = [
            Kite(
                name: "Wave Master",
                brand: "Cabrinha",
                model: "Drifter",
                size: "9m",
                year: 2022,
                condition: "Good",
                lastUsedDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                notes: "Great for wave riding."
            ),
            Kite(
                name: "Speed Demon",
                brand: "Duotone",
                model: "Evo",
                size: "12m",
                year: 2021,
                condition: "New",
                lastUsedDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
                notes: "Excellent all-around kite."
            ),
            Kite(
                name: "Freestyle Pro",
                brand: "Naish",
                model: "Pivot",
                size: "10m",
                year: 2023,
                condition: "Fair",
                lastUsedDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                notes: "Needs a minor repair on the leading edge."
            ),
            Kite(
                name: "Light Wind Hero",
                brand: "Slingshot",
                model: "Rally",
                size: "14m",
                year: 2020,
                condition: "Needs Repair",
                lastUsedDate: Calendar.current.date(byAdding: .day, value: -30, to: Date())!,
                notes: "Great for light wind sessions, but needs a patch."
            )
        ]
        
        kites = sampleKites
        saveToUserDefaults()
    }
}
