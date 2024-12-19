import Foundation

class WindConditionsManager: ObservableObject {
    @Published var windConditions: [WindCondition] = []
    
    private let userDefaultsKey = "windConditions"
    
    init() {
        loadWindConditions()
        if windConditions.isEmpty {
            loadSampleData()
        }
    }
    
    // Create or Update a Wind Condition
    func saveWindCondition(_ condition: WindCondition) {
        if let index = windConditions.firstIndex(where: { $0.id == condition.id }) {
            windConditions[index] = condition
        } else {
            windConditions.append(condition)
        }
        saveToUserDefaults()
    }
    
    // Delete a Wind Condition
    func deleteWindCondition(at offsets: IndexSet) {
        windConditions.remove(atOffsets: offsets)
        saveToUserDefaults()
    }
    
    // Load Wind Conditions from UserDefaults
    private func loadWindConditions() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let decoded = try? JSONDecoder().decode([WindCondition].self, from: data) {
                windConditions = decoded
            }
        }
    }
    
    // Save Wind Conditions to UserDefaults
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(windConditions) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    // Load Sample Data
    private func loadSampleData() {
        let sampleConditions = [
            WindCondition(
                name: "Morning Breeze",
                location: "Hawaii Beach",
                forecastDate: Date(),
                windSpeed: 15.0,
                windDirection: "NE",
                notes: "Ideal for a morning ride."
            ),
            WindCondition(
                name: "Evening Gusts",
                location: "California Coast",
                forecastDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                windSpeed: 20.5,
                windDirection: "SW",
                notes: "Strong winds expected in the evening."
            ),
            WindCondition(
                name: "Calm Afternoon",
                location: "Florida Keys",
                forecastDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                windSpeed: 10.0,
                windDirection: "N",
                notes: "Light winds, suitable for foiling."
            ),
            WindCondition(
                name: "Stormy Conditions",
                location: "Cape Town",
                forecastDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
                windSpeed: 30.0,
                windDirection: "SE",
                notes: "Challenging conditions with gusts up to 35 knots."
            )
        ]
        
        windConditions = sampleConditions
        saveToUserDefaults()
    }
}
