import SwiftUI

struct LocationDetailView: View {
    @State private var selectedTab = 0
    @State private var selectedFloor = "3 Floor"

    var body: some View {
        VStack {
            // Header for selecting the location and floor
            headerSection

            // Map image
            mapSection
            
//            bottomTabBar
            Spacer()
            bottomTabBar
            
            

            // Bottom tab bar is assumed to be handled by a parent TabView
        }
        .navigationTitle("Your Location")
        .navigationBarTitleDisplayMode(.inline)
        .edgesIgnoringSafeArea(.bottom)
        
    }

    var headerSection: some View {
        VStack {
                    HStack {
                        // Location pin icon
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                        
                        // Text for location with more descriptive setup
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Your location")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            // MAC Lab text alongside dropdown icon
                            HStack {
                                Text("Lab 01")
                                    .font(.headline) // Slightly larger and bolder font
                                    .foregroundColor(.blue)
                                
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 5) // Smaller chevron
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Spacer()
                        
                        // Settings button
                        Button(action: {
                            // Action for settings or more options
                        }) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.gray)
                                .imageScale(.large)
                        }
                    }
                    .padding()
                    
                    // Floor picker hidden under 'MAC Lab' and showing only when needed
                    Picker("Select Floor", selection: $selectedFloor) {
                        Text("1 Floor").tag("1 Floor")
                        Text("2 Floor").tag("2 Floor")
                        Text("3 Floor").tag("3 Floor")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)
            }

    var mapSection: some View {
        ZStack {
            // Simulated Map Image
            Image("map") // Ensure you have a placeholder map image in your assets
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 500)
                .clipped()
                .cornerRadius(10)
                .shadow(radius: 5)
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
            .padding(.bottom,30)
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

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView()
    }
}
