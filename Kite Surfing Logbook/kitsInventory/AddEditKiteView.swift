import SwiftUI

struct AddEditKiteView: View {
    @ObservedObject var manager: KiteInventoryManager
    @Environment(\.presentationMode) var presentationMode

    var kite: Kite? = nil

    @State private var name = ""
    @State private var brand = ""
    @State private var model = ""
    @State private var size = ""
    @State private var year = ""
    @State private var condition = "New"
    @State private var notes = ""

    let conditionOptions = ["New", "Good", "Fair", "Needs Repair"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Kite Name")) {
                    TextField("Enter kite name", text: $name)
                }

                Section(header: Text("Kite Details")) {
                    TextField("Brand", text: $brand)
                    TextField("Model", text: $model)
                    TextField("Size (e.g., 9m)", text: $size)
                    TextField("Year", text: $year)
                        .keyboardType(.numberPad)
                    Picker("Condition", selection: $condition) {
                        ForEach(conditionOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                }

                Section(header: Text("Notes")) {
                    TextField("Notes", text: $notes)
                }
            }
            .navigationTitle(kite == nil ? "Add Kite" : "Edit Kite")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveKite()
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
            if let kite = kite {
                name = kite.name
                brand = kite.brand
                model = kite.model
                size = kite.size
                year = "\(kite.year)"
                condition = kite.condition
                notes = kite.notes
            }
        }
    }

    func saveKite() {
        let yearValue = Int(year) ?? 0

        let newKite = Kite(
            id: kite?.id ?? UUID(),
            name: name,
            brand: brand,
            model: model,
            size: size,
            year: yearValue,
            condition: condition,
            lastUsedDate: Date(),
            notes: notes
        )

        manager.saveKite(newKite)
        presentationMode.wrappedValue.dismiss()
    }
}
