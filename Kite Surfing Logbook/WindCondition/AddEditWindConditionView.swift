import SwiftUI

struct AddEditWindConditionView: View {
    @ObservedObject var manager: WindConditionsManager
    @Environment(\.presentationMode) var presentationMode

    var windCondition: WindCondition? = nil

    @State private var name = ""
    @State private var location = ""
    @State private var forecastDate = Date()
    @State private var windSpeed = ""
    @State private var windDirection = ""
    @State private var notes = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Forecast Name")) {
                    TextField("Enter forecast name", text: $name)
                }

                Section(header: Text("Wind Condition Details")) {
                    TextField("Location", text: $location)
                    DatePicker("Forecast Date", selection: $forecastDate, displayedComponents: .date)
                    TextField("Wind Speed (knots)", text: $windSpeed)
                        .keyboardType(.decimalPad)
                    TextField("Wind Direction (e.g., N, SW)", text: $windDirection)
                }

                Section(header: Text("Notes")) {
                    TextField("Notes", text: $notes)
                }
            }
            .navigationTitle(windCondition == nil ? "Add Forecast" : "Edit Forecast")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveWindCondition()
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
            if let condition = windCondition {
                name = condition.name
                location = condition.location
                forecastDate = condition.forecastDate
                windSpeed = "\(condition.windSpeed)"
                windDirection = condition.windDirection
                notes = condition.notes
            }
        }
    }

    func saveWindCondition() {
        let windSpeedValue = Double(windSpeed) ?? 0.0

        let newCondition = WindCondition(
            id: windCondition?.id ?? UUID(),
            name: name,
            location: location,
            forecastDate: forecastDate,
            windSpeed: windSpeedValue,
            windDirection: windDirection,
            notes: notes
        )

        manager.saveWindCondition(newCondition)
        presentationMode.wrappedValue.dismiss()
    }
}
