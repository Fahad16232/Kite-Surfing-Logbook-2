import SwiftUI

import SwiftUI

struct AddEditSessionView: View {
    @ObservedObject var manager: SessionLogsManager
    @Environment(\.presentationMode) var presentationMode
    
    var sessionLog: SessionLog? = nil

    @State private var name = ""
    @State private var date = Date()
    @State private var location = ""
    @State private var windSpeed = ""
    @State private var windDirection = ""
    @State private var kiteSize = ""
    @State private var boardType = ""
    @State private var tricksPerformed = ""
    @State private var duration = ""
    @State private var waterConditions = "Flat"
    @State private var tide = "Low"
    @State private var sessionRating = 3
    @State private var distanceCovered = ""
    @State private var gearCondition = "Good"
    @State private var notes = ""

    let waterConditionsOptions = ["Flat", "Choppy", "Waves"]
    let tideOptions = ["Low", "Mid", "High"]
    let gearConditionOptions = ["Good", "Needs Repair"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Session Name")) {
                    TextField("Enter a name for your session", text: $name)
                }

                Section(header: Text("Session Details")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Location", text: $location)
                    TextField("Wind Speed (knots)", text: $windSpeed)
                        .keyboardType(.decimalPad)
                    TextField("Wind Direction (e.g., N, NE, SW)", text: $windDirection)
                    TextField("Kite Size (e.g., 9m)", text: $kiteSize)
                    TextField("Board Type (e.g., Twin Tip)", text: $boardType)
                    TextField("Tricks Performed (comma-separated)", text: $tricksPerformed)
                    TextField("Duration (minutes)", text: $duration)
                        .keyboardType(.numberPad)
                    TextField("Distance Covered (km)", text: $distanceCovered)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Conditions")) {
                    Picker("Water Conditions", selection: $waterConditions) {
                        ForEach(waterConditionsOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Tide", selection: $tide) {
                        ForEach(tideOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Gear Condition", selection: $gearCondition) {
                        ForEach(gearConditionOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    Stepper("Session Rating: \(sessionRating)", value: $sessionRating, in: 1...5)
                }
                
                Section(header: Text("Notes")) {
                    TextField("Add any notes or reflections", text: $notes)
                }
            }
            .navigationTitle(sessionLog == nil ? "Add Session" : "Edit Session")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSession()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let log = sessionLog {
                name = log.name
                date = log.date
                location = log.location
                windSpeed = "\(log.windSpeed)"
                windDirection = log.windDirection
                kiteSize = log.kiteSize
                boardType = log.boardType
                tricksPerformed = log.tricksPerformed.joined(separator: ", ")
                duration = "\(log.duration)"
                waterConditions = log.waterConditions
                tide = log.tide
                sessionRating = log.sessionRating
                distanceCovered = "\(log.distanceCovered)"
                gearCondition = log.gearCondition
                notes = log.notes
            }
        }
    }

    func saveSession() {
        let windSpeedValue = Double(windSpeed) ?? 0.0
        let durationValue = Int(duration) ?? 0
        let tricksArray = tricksPerformed.components(separatedBy: ", ").filter { !$0.isEmpty }
        let distanceValue = Double(distanceCovered) ?? 0.0

        let newLog = SessionLog(
            id: sessionLog?.id ?? UUID(),
            name: name,
            date: date,
            location: location,
            windSpeed: windSpeedValue,
            windDirection: windDirection,
            kiteSize: kiteSize,
            boardType: boardType,
            tricksPerformed: tricksArray,
            duration: durationValue,
            notes: notes,
            waterConditions: waterConditions,
            tide: tide,
            sessionRating: sessionRating,
            distanceCovered: distanceValue,
            gearCondition: gearCondition
        )
        
        manager.saveSessionLog(newLog)
        presentationMode.wrappedValue.dismiss()
    }
}

