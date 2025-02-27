import SwiftUI

struct LabListView: View {
    @State private var selectedTab = 0
    var body: some View {
        NavigationView {
            VStack {
                // Top search and filter bar
                topSearchAndFilterBar
                
                // Category chips
                categoryChips
                
                // Lab grid list
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(labData) { lab in
                            LabCard(lab: lab)
                        }
                    }
                    .padding()
                }
                bottomTabBar
            }
            .navigationBarHidden(true)
        }
    }

    var topSearchAndFilterBar: some View {
        VStack {
            HStack {
                Button(action: {
                    // Action for menu
                }) {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }

                Spacer()

                Text("Second Floor, Mac LAB")
                    .fontWeight(.semibold)
                
                Spacer()

                Button(action: {
                    // Action for location refresh
                }) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
            }
            .padding(.horizontal)
            .padding(.top, 50)  // Add padding to account for the top safe area on devices

            SearchBar()
                .padding(.horizontal)
                .padding(.top, 10)
        }
    }

    var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Chip(label: "Labs")
                Chip(label: "Canteen")
                Chip(label: "Office")
                Chip(label: "Library")
            }
            .padding(.horizontal)
        }
    }
    
    var bottomTabBar: some View {
        ZStack {
            // Main horizontal stack for the tab bar
            HStack(spacing: 0) {
                // Explore tab
                Button(action: {
                    selectedTab = 0
                }) {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .font(.title2)
                        .foregroundColor(selectedTab == 0 ? .blue : .gray)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                // Events tab
                Button(action: {
                    selectedTab = 1
                }) {
                    Image(systemName: selectedTab == 1 ? "calendar.circle.fill" : "calendar.circle")
                        .font(.title2)
                        .foregroundColor(selectedTab == 1 ? .blue : .gray)
                }
                .frame(maxWidth: .infinity)
                
                // Placeholder for the center button to balance the space
                Color.clear
                    .frame(width: 50, height: 50)
                
                Spacer()
                
                // Map tab
                Button(action: {
                    selectedTab = 2
                }) {
                    Image(systemName: selectedTab == 2 ? "map.fill" : "map")
                        .font(.title2)
                        .foregroundColor(selectedTab == 2 ? .blue : .gray)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                // Profile tab
                Button(action: {
                    selectedTab = 3
                }) {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                        .font(.title2)
                        .foregroundColor(selectedTab == 3 ? .blue : .gray)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(width : 400,height: 50)
            .background(Color.white.opacity(1))
//            .clipShape(Capsule())
            .padding(.horizontal)
            .shadow(radius: 1)
            
            // Center floating action button
            Button(action: {
                // Action for the center button
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .padding(15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .frame(width: 50, height: 50)
            }
            .offset(y: -30) // Adjust the offset to raise the button
        }
    }
}

struct LabCard: View {
    let lab: Lab

    var body: some View {
        VStack {
            Image(lab.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipped()
                .cornerRadius(10)
            
            Text(lab.name)
                .fontWeight(.medium)
            
            Text("\(lab.floor) floor")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.all, 10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct SearchBar: View {
    @State private var searchText = ""

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search by name, type...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct Chip: View {
    var label: String

    var body: some View {
        Text(label)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
    }
}


// Sample data
struct Lab: Identifiable {
    let id = UUID()
    let name: String
    let floor: String
    let imageName: String
}

let labData = [
    Lab(name: "Chemistry Lab", floor: "1", imageName: "chemistry_lab"),
    Lab(name: "Computer Lab", floor: "2", imageName: "computer_lab"),
    Lab(name: "Mac Lab", floor: "3", imageName: "mac_lab"),
    Lab(name: "Research Lab", floor: "3", imageName: "research_lab")
]

struct LabListView_Previews: PreviewProvider {
    static var previews: some View {
        LabListView()
    }
}
