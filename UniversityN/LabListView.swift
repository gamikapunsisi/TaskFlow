import SwiftUI

struct LabListView: View {
    @State private var selectedTab = 2
    @State private var selectedCategory = "All"  // State to track the selected category

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
                        ForEach(filteredLabs) { lab in  // Use filteredLabs instead of labData
                            LabCard(lab: lab)
                        }
                    }
                    .padding()
                }
                bottomTabBar
            }
        }
        .navigationBarHidden(true)
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

                Text("Third Floor, Mac LAB")
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
                .navigationBarHidden(true)
        }
    }

    var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(["Labs", "Canteen", "Office", "Library", "All"], id: \.self) { category in
                    Chip(label: category, isSelected: selectedCategory == category)
                        .onTapGesture {
                            selectedCategory = category
                        }
                }
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
                    NavigationLink(destination: MainEventAppView()) {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            .font(.title2)
                            .foregroundColor(selectedTab == 0 ? .blue : .gray)
                    }
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
                    NavigationLink(destination: LabListView()) {
                        Image(systemName: selectedTab == 2 ? "map.fill" : "map")
                            .font(.title2)
                            .foregroundColor(selectedTab == 2 ? .blue : .gray)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                // Profile tab
                Button(action: {
                    selectedTab = 3
                }) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                            .font(.title2)
                            .foregroundColor(selectedTab == 3 ? .blue : .gray)
                    }
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
                NavigationLink(destination: CampusMapView()) {
                    Image(systemName: "plus")
                        .resizable()
                        .padding(15)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .frame(width: 50, height: 50)
                }
            }
            .offset(y: -30) // Adjust the offset to raise the button
        }
    }
    var filteredLabs: [Lab] {
        if selectedCategory == "All" {
            return labData
        } else {
            return labData.filter { $0.category == selectedCategory }
        }
    }
}

struct LabCard: View {
    let lab: Lab

    var body: some View {
        NavigationLink(destination: LocationDetailView()) {
            VStack {
                Image(lab.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width:160 ,height: 100)
                    .clipped()
                    .cornerRadius(10)
                
                Text(lab.name)
                    .fontWeight(.medium)
                
                Text("\(lab.floor) floor")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
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
    var isSelected: Bool

    var body: some View {
        Text(label)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.black.opacity(0.5) : Color.blue)
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
    let category: String  // Add a category for each lab
}

let labData = [
    Lab(name: "Computer Lab", floor: "2", imageName: "computer_lab", category: "Labs"),
    Lab(name: "Mac Lab", floor: "3", imageName: "mac_lab", category: "Labs"),
    Lab(name: "Research Lab", floor: "3", imageName: "research_lab", category: "Labs"),
    Lab(name: "Main Canteen", floor: "Ground", imageName: "canteen", category: "Canteen"),
    Lab(name: "Admin Office", floor: "2", imageName: "admin_office", category: "Office"),
    Lab(name: "Accounting Office", floor: "2", imageName: "ac", category: "Office"),
    Lab(name: "HR Office", floor: "2", imageName: "hr_office", category: "Office")
    // Add more labs and categories as needed
]

struct LabListView_Previews: PreviewProvider {
    static var previews: some View {
        LabListView()
    }
}
