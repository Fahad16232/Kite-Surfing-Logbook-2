import SwiftUI

struct AchievementsView: View {
    @ObservedObject var manager = AchievementsManager()
    @State private var showingAddAchievementView = false
    @State private var searchText = ""

    var filteredAchievements: [Achievement] {
        if searchText.isEmpty {
            return manager.achievements
        } else {
            return manager.achievements.filter { achievement in
                achievement.title.lowercased().contains(searchText.lowercased()) ||
                achievement.category.lowercased().contains(searchText.lowercased()) ||
                achievement.personalBestValue.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Search bar
                    SearchBar(text: $searchText, placeholder: "Search by title, category, or personal best")
                        .padding(.horizontal)

                    if manager.achievements.isEmpty {
                        // Empty state view
                        VStack {
                            Image(systemName: "star")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray.opacity(0.6))
                            Text("No Achievements Logged Yet")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                    } else {
                        List {
                            ForEach(filteredAchievements) { achievement in
                                NavigationLink(destination: AddEditAchievementView(manager: manager, achievement: achievement)) {
                                    achievementRow(achievement: achievement)
                                }
                                .listRowBackground(Color.white.opacity(0.7))
                                .cornerRadius(12)
                                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                                .padding(.vertical, 5)
                            }
                            .onDelete(perform: manager.deleteAchievement)
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }
                }
            }
            .navigationTitle("Achievements")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddAchievementView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddAchievementView) {
                AddEditAchievementView(manager: manager)
            }
        }
    }

    // Card-styled row view for each achievement
    func achievementRow(achievement: Achievement) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(achievement.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            Text("Category: \(achievement.category)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text("Date Achieved: \(achievement.dateAchieved, style: .date)")
                    .font(.subheadline)
            }

            Text(achievement.personalBestValue)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(achievement.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}
