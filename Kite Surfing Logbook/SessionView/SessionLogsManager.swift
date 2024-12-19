import Foundation

class SessionLogsManager: ObservableObject {
    @Published var sessionLogs: [SessionLog] = []
    
    private let userDefaultsKey = "sessionLogs"
    
    init() {
        loadSessionLogs()
        if sessionLogs.isEmpty {
            loadSampleData()
        }
    }
    
    // Create or Update a Session Log
    func saveSessionLog(_ sessionLog: SessionLog) {
        if let index = sessionLogs.firstIndex(where: { $0.id == sessionLog.id }) {
            sessionLogs[index] = sessionLog
        } else {
            sessionLogs.append(sessionLog)
        }
        saveToUserDefaults()
    }
    
    // Delete a Session Log
    func deleteSessionLog(at offsets: IndexSet) {
        sessionLogs.remove(atOffsets: offsets)
        saveToUserDefaults()
    }
    
    // Load Session Logs from UserDefaults
    private func loadSessionLogs() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let decoded = try? JSONDecoder().decode([SessionLog].self, from: data) {
                sessionLogs = decoded
            }
        }
    }
    
    // Save Session Logs to UserDefaults
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(sessionLogs) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    // Load Sample Data
    private func loadSampleData() {
        let sampleLogs = [
            SessionLog(
                name: "Sunset Ride",
                date: Date(),
                location: "Hawaii Beach",
                windSpeed: 18.5,
                windDirection: "NE",
                kiteSize: "9m",
                boardType: "Twin Tip",
                tricksPerformed: ["Backroll", "Frontroll"],
                duration: 90,
                notes: "Perfect conditions for jumps!",
                waterConditions: "Choppy",
                tide: "Mid",
                sessionRating: 5,
                distanceCovered: 15.0,
                gearCondition: "Good"
            ),
            SessionLog(
                name: "Morning Wave Session",
                date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
                location: "California Coast",
                windSpeed: 20.0,
                windDirection: "SW",
                kiteSize: "12m",
                boardType: "Surfboard",
                tricksPerformed: ["Wave Ride"],
                duration: 120,
                notes: "Great wave riding session.",
                waterConditions: "Waves",
                tide: "High",
                sessionRating: 4,
                distanceCovered: 20.0,
                gearCondition: "Good"
            ),
            SessionLog(
                name: "Foiling Fun",
                date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!,
                location: "Florida Keys",
                windSpeed: 15.0,
                windDirection: "N",
                kiteSize: "10m",
                boardType: "Foil Board",
                tricksPerformed: ["Foiling"],
                duration: 60,
                notes: "Smooth foiling session.",
                waterConditions: "Flat",
                tide: "Low",
                sessionRating: 5,
                distanceCovered: 10.5,
                gearCondition: "New"
            ),
            SessionLog(
                name: "Windy Challenge",
                date: Calendar.current.date(byAdding: .day, value: -21, to: Date())!,
                location: "Cape Town",
                windSpeed: 25.0,
                windDirection: "SE",
                kiteSize: "8m",
                boardType: "Twin Tip",
                tricksPerformed: ["Mega Loop"],
                duration: 75,
                notes: "Challenging winds but fun!",
                waterConditions: "Choppy",
                tide: "Mid",
                sessionRating: 4,
                distanceCovered: 18.0,
                gearCondition: "Needs Repair"
            )
        ]
        
        sessionLogs = sampleLogs
        saveToUserDefaults()
    }
}
