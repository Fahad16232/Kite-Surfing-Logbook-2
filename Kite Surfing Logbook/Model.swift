
import Foundation

struct SessionLog: Identifiable, Codable {
    var id = UUID()
    var name: String // New field for the session name
    var date: Date
    var location: String
    var windSpeed: Double
    var windDirection: String
    var kiteSize: String
    var boardType: String
    var tricksPerformed: [String]
    var duration: Int
    var notes: String
    var waterConditions: String
    var tide: String
    var sessionRating: Int
    var distanceCovered: Double
    var gearCondition: String
}


struct Kite: Identifiable, Codable {
    var id = UUID()
    var name: String // New field for the kite name
    var brand: String
    var model: String
    var size: String // e.g., "9m", "12m"
    var year: Int
    var condition: String // Options: "New", "Good", "Fair", "Needs Repair"
    var lastUsedDate: Date
    var notes: String
}


struct GearMaintenance: Identifiable, Codable {
    var id = UUID()
    var name: String // New field for maintenance name
    var gearType: String // Options: "Kite", "Board", "Bar/Lines", "Harness"
    var description: String // Description of repair or maintenance
    var maintenanceDate: Date
    var nextCheckDate: Date
    var performedBy: String // e.g., self or shop name
    var notes: String
}


struct WindCondition: Identifiable, Codable {
    var id = UUID()
    var name: String // New field for forecast name
    var location: String
    var forecastDate: Date
    var windSpeed: Double // in knots
    var windDirection: String // e.g., N, NE, S, SW, etc.
    var notes: String
}

struct Achievement: Identifiable, Codable {
    var id = UUID()
    var title: String
    var category: String // New field for achievement category
    var description: String
    var dateAchieved: Date
    var personalBestValue: String // e.g., "Highest Jump: 10m", "Longest Session: 3 hours"
    var notes: String
}

