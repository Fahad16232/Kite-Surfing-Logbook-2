import Foundation

class AchievementsManager: ObservableObject {
    @Published var achievements: [Achievement] = []
    
    private let userDefaultsKey = "achievements"
    
    init() {
        loadAchievements()
        if achievements.isEmpty {
            loadSampleData()
        }
    }
    
    // Create or Update an Achievement
    func saveAchievement(_ achievement: Achievement) {
        if let index = achievements.firstIndex(where: { $0.id == achievement.id }) {
            achievements[index] = achievement
        } else {
            achievements.append(achievement)
        }
        saveToUserDefaults()
    }
    
    // Delete an Achievement
    func deleteAchievement(at offsets: IndexSet) {
        achievements.remove(atOffsets: offsets)
        saveToUserDefaults()
    }
    
    // Load Achievements from UserDefaults
    private func loadAchievements() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
                achievements = decoded
            }
        }
    }
    
    // Save Achievements to UserDefaults
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    // Load Sample Data
    private func loadSampleData() {
        let sampleAchievements = [
            Achievement(
                title: "Highest Jump",
                category: "Personal Best",
                description: "Achieved a new height record during a windy session.",
                dateAchieved: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
                personalBestValue: "Highest Jump: 15m",
                notes: "The wind conditions were perfect for jumping high!"
            ),
            Achievement(
                title: "Longest Session",
                category: "Endurance",
                description: "Completed a 4-hour long kitesurfing session.",
                dateAchieved: Calendar.current.date(byAdding: .day, value: -20, to: Date())!,
                personalBestValue: "Longest Session: 4 hours",
                notes: "Felt exhausted but accomplished!"
            ),
            Achievement(
                title: "Wave Riding Competition",
                category: "Competition",
                description: "Won 2nd place in the local wave riding competition.",
                dateAchieved: Calendar.current.date(byAdding: .day, value: -30, to: Date())!,
                personalBestValue: "2nd Place",
                notes: "Great experience competing with other talented riders."
            ),
            Achievement(
                title: "First Foiling Session",
                category: "Milestone",
                description: "Successfully completed my first foiling session.",
                dateAchieved: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                personalBestValue: "First Foil Ride",
                notes: "A bit tricky at first, but super fun once I got the hang of it!"
            )
        ]
        
        achievements = sampleAchievements
        saveToUserDefaults()
    }
}
