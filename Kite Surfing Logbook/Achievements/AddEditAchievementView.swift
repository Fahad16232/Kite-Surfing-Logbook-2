import SwiftUI

struct AddEditAchievementView: View {
    @ObservedObject var manager: AchievementsManager
    @Environment(\.presentationMode) var presentationMode

    var achievement: Achievement? = nil

    @State private var title = ""
    @State private var category = "Personal Best"
    @State private var description = ""
    @State private var dateAchieved = Date()
    @State private var personalBestValue = ""
    @State private var notes = ""

    let categoryOptions = ["Personal Best", "Competition", "Milestone", "Other"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Achievement Details")) {
                    TextField("Title", text: $title)
                    Picker("Category", selection: $category) {
                        ForEach(categoryOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    DatePicker("Date Achieved", selection: $dateAchieved, displayedComponents: .date)
                    TextField("Personal Best (e.g., Highest Jump: 10m)", text: $personalBestValue)
                    TextField("Description", text: $description)
                }

                Section(header: Text("Notes")) {
                    TextField("Notes", text: $notes)
                }
            }
            .navigationTitle(achievement == nil ? "Add Achievement" : "Edit Achievement")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveAchievement()
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
            if let achievement = achievement {
                title = achievement.title
                category = achievement.category
                description = achievement.description
                dateAchieved = achievement.dateAchieved
                personalBestValue = achievement.personalBestValue
                notes = achievement.notes
            }
        }
    }

    func saveAchievement() {
        guard !title.isEmpty, !personalBestValue.isEmpty else {
            return
        }

        let newAchievement = Achievement(
            id: achievement?.id ?? UUID(),
            title: title,
            category: category,
            description: description,
            dateAchieved: dateAchieved,
            personalBestValue: personalBestValue,
            notes: notes
        )

        manager.saveAchievement(newAchievement)
        presentationMode.wrappedValue.dismiss()
    }
}
