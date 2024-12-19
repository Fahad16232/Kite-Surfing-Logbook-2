import SwiftUI

struct AddEditMaintenanceView: View {
    @ObservedObject var manager: GearMaintenanceManager
    @Environment(\.presentationMode) var presentationMode

    var maintenanceLog: GearMaintenance? = nil

    @State private var name = ""
    @State private var gearType = "Kite"
    @State private var description = ""
    @State private var maintenanceDate = Date()
    @State private var nextCheckDate = Date()
    @State private var performedBy = ""
    @State private var notes = ""

    let gearTypeOptions = ["Kite", "Board", "Bar/Lines", "Harness"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Maintenance Name")) {
                    TextField("Enter maintenance name", text: $name)
                }

                Section(header: Text("Gear Maintenance Details")) {
                    Picker("Gear Type", selection: $gearType) {
                        ForEach(gearTypeOptions, id: \.self) { type in
                            Text(type)
                        }
                    }
                    DatePicker("Maintenance Date", selection: $maintenanceDate, displayedComponents: .date)
                    DatePicker("Next Check Date", selection: $nextCheckDate, in: maintenanceDate..., displayedComponents: .date)
                    TextField("Performed By", text: $performedBy)
                    TextField("Description", text: $description)
                }

                Section(header: Text("Notes")) {
                    TextField("Notes", text: $notes)
                }
            }
            .navigationTitle(maintenanceLog == nil ? "Add Maintenance" : "Edit Maintenance")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveMaintenanceLog()
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
            if let log = maintenanceLog {
                name = log.name
                gearType = log.gearType
                description = log.description
                maintenanceDate = log.maintenanceDate
                nextCheckDate = log.nextCheckDate
                performedBy = log.performedBy
                notes = log.notes
            }
        }
    }

    func saveMaintenanceLog() {
        let newLog = GearMaintenance(
            id: maintenanceLog?.id ?? UUID(),
            name: name,
            gearType: gearType,
            description: description,
            maintenanceDate: maintenanceDate,
            nextCheckDate: nextCheckDate,
            performedBy: performedBy,
            notes: notes
        )

        manager.saveMaintenanceLog(newLog)
        presentationMode.wrappedValue.dismiss()
    }
}
