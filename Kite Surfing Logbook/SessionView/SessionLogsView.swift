import SwiftUI

struct SessionLogsView: View {
    @ObservedObject var manager = SessionLogsManager()
    @State private var showingAddSessionView = false
    @State private var searchText = ""

    var filteredLogs: [SessionLog] {
        if searchText.isEmpty {
            return manager.sessionLogs
        } else {
            return manager.sessionLogs.filter { log in
                log.name.lowercased().contains(searchText.lowercased()) ||
                log.location.lowercased().contains(searchText.lowercased())
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
                    SearchBar(text: $searchText, placeholder: "Search by name or location")
                        .padding(.horizontal)

                    if manager.sessionLogs.isEmpty {
                        // Empty state view
                        VStack {
                            Image(systemName: "wind")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray.opacity(0.6))
                            Text("No Sessions Logged Yet")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                    } else {
                        List {
                            ForEach(filteredLogs) { log in
                                NavigationLink(destination: AddEditSessionView(manager: manager, sessionLog: log)) {
                                    sessionRow(log: log)
                                }
                                .listRowBackground(Color.white.opacity(0.7))
                                .cornerRadius(12)
                                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                                .padding(.vertical, 5)
                            }
                            .onDelete(perform: manager.deleteSessionLog)
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }
                }
            }
            .navigationTitle("Session Logs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddSessionView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddSessionView) {
                AddEditSessionView(manager: manager)
            }
        }
    }

    // Card-styled row view for each session
    func sessionRow(log: SessionLog) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(log.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            Text(log.location)
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Image(systemName: "wind")
                    .foregroundColor(.gray)
                Text("Wind Speed: \(log.windSpeed, specifier: "%.1f") knots")
                    .font(.subheadline)
            }

            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text(log.date, style: .date)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}



struct SearchBar: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
                .padding(.horizontal, 10)
        }
    }
}
