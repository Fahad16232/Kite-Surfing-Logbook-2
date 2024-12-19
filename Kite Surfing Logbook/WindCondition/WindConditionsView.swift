import SwiftUI

struct WindConditionsView: View {
    @ObservedObject var manager = WindConditionsManager()
    @State private var showingAddWindConditionView = false
    @State private var searchText = ""

    var filteredConditions: [WindCondition] {
        if searchText.isEmpty {
            return manager.windConditions
        } else {
            return manager.windConditions.filter { condition in
                condition.name.lowercased().contains(searchText.lowercased()) ||
                condition.location.lowercased().contains(searchText.lowercased()) ||
                condition.windDirection.lowercased().contains(searchText.lowercased())
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
                    SearchBar(text: $searchText, placeholder: "Search by name, location, or direction")
                        .padding(.horizontal)

                    if manager.windConditions.isEmpty {
                        // Empty state view
                        VStack {
                            Image(systemName: "wind")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray.opacity(0.6))
                            Text("No Wind Forecasts Yet")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                    } else {
                        List {
                            ForEach(filteredConditions) { condition in
                                NavigationLink(destination: AddEditWindConditionView(manager: manager, windCondition: condition)) {
                                    windConditionRow(condition: condition)
                                }
                                .listRowBackground(Color.white.opacity(0.7))
                                .cornerRadius(12)
                                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                                .padding(.vertical, 5)
                            }
                            .onDelete(perform: manager.deleteWindCondition)
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }
                }
            }
            .navigationTitle("Wind Conditions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddWindConditionView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddWindConditionView) {
                AddEditWindConditionView(manager: manager)
            }
        }
    }

    // Card-styled row view for each wind condition
    func windConditionRow(condition: WindCondition) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(condition.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            Text(condition.location)
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text(condition.forecastDate, style: .date)
                    .font(.subheadline)
            }

            HStack {
                Image(systemName: "wind")
                    .foregroundColor(.gray)
                Text("Wind Speed: \(condition.windSpeed, specifier: "%.1f") knots")
                    .font(.subheadline)
            }

            HStack {
                Image(systemName: "arrow.up.right.circle")
                    .foregroundColor(.gray)
                Text("Direction: \(condition.windDirection)")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}
