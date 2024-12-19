import SwiftUI

struct KiteInventoryView: View {
    @ObservedObject var manager = KiteInventoryManager()
    @State private var showingAddKiteView = false
    @State private var searchText = ""

    var filteredKites: [Kite] {
        if searchText.isEmpty {
            return manager.kites
        } else {
            return manager.kites.filter { kite in
                kite.name.lowercased().contains(searchText.lowercased()) ||
                kite.brand.lowercased().contains(searchText.lowercased()) ||
                kite.model.lowercased().contains(searchText.lowercased())
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
                    SearchBar(text: $searchText, placeholder: "Search by name, brand, or model")
                        .padding(.horizontal)

                    if manager.kites.isEmpty {
                        // Empty state view
                        VStack {
                            Image(systemName: "kite")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray.opacity(0.6))
                            Text("No Kites Logged Yet")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                    } else {
                        List {
                            ForEach(filteredKites) { kite in
                                NavigationLink(destination: AddEditKiteView(manager: manager, kite: kite)) {
                                    kiteRow(kite: kite)
                                }
                                .listRowBackground(Color.white.opacity(0.7))
                                .cornerRadius(12)
                                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                                .padding(.vertical, 5)
                            }
                            .onDelete(perform: manager.deleteKite)
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }
                }
            }
            .navigationTitle("Kite Inventory")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddKiteView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddKiteView) {
                AddEditKiteView(manager: manager)
            }
        }
    }

    // Card-styled row view for each kite
    func kiteRow(kite: Kite) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(kite.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            Text("\(kite.brand) \(kite.model)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Image(systemName: "ruler")
                    .foregroundColor(.gray)
                Text("Size: \(kite.size)")
                    .font(.subheadline)
            }

            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text("Year: \(kite.year)")
                    .font(.subheadline)
            }

            HStack {
                Image(systemName: "gearshape")
                    .foregroundColor(.gray)
                Text("Condition: \(kite.condition)")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 4)
    }
}
