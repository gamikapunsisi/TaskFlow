import SwiftUI

struct MainEventAppView: View {
    @State private var selectedTab = 0
    var body: some View {
        VStack {
            topNavigationBar
            categoryChips
            ScrollView(showsIndicators: false) {
                VStack {
//                    categoryChips
                        eventSection(title: "Upcoming Events", events: [
                        EventData(name: "International Band Music", attendees: "+20 Going", location: "36 Guild Street London, UK"),
                        EventData(name: "Jo Malone Invitational", attendees: "+15 Going", location: "Radius Gallery, NYC")
                    ])
                    inviteFriendsCard
                }
                .padding(.bottom, 50) // Ensure space at the bottom for floating tab bar
            }
            bottomTabBar
        }
        .edgesIgnoringSafeArea(.top) // Allow the top bar to extend into the status bar area
        .background(Color("Background")) // Use a named color or define a custom color
    }
    
    // MARK: - View Components
    var topNavigationBar: some View {
        ZStack {
            Color.blue
                .edgesIgnoringSafeArea(.top) // Extending the blue background to the top edge of the screen
            HStack {
                Button(action: {}) {
                    Image(systemName: "text.alignleft")
                        .imageScale(.large)
                        .foregroundColor(.white)
                }

                Spacer()
//                Text ("Current Location ")
                Text("New York, USA")
                    .foregroundColor(.white)
                    .font(.headline) // You can adjust the font size if necessary

                Spacer()

                Button(action: {}) {
                    Image(systemName: "bell")
                        .imageScale(.large)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal,20) // Maintain horizontal padding for side spacing
            .padding(.vertical, 8) // Reduce vertical padding to decrease the height
            HStack {
                TextField("   |    Search...", text: .constant(""))
                    .padding(.leading, 40)
                    .foregroundColor(.primary)
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color.white)
//                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
//                    )
                    .overlay(
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding(.leading, 8),
                        alignment: .leading
                    )
                
                Button(action: {}) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding(.top,130)
            .padding(.horizontal,10) // Maintain horizontal padding for side spacing
            .padding(.vertical, 8) // Reduce vertical padding to decrease the height
            
        }
        
        .frame(height: 200) // Explicitly set a smaller height for the navigation bar
        .cornerRadius(30)
        
        
    }
    

    
    
    var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {  // Increase spacing between buttons
                            Button(action: {}) {
                                Label("Art", systemImage: "paintpalette")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(height: 40)
                                    .background(Color.blue)
                                    .cornerRadius(22)
                            }
                            
                            Button(action: {}) {
                                Label("Music", systemImage: "music.note")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(height: 40)
                                    .background(Color.blue)
                                    .cornerRadius(22)
                            }
                            
                            Button(action: {}) {
                                Label("Food", systemImage: "fork.knife")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(height: 40)
                                    .background(Color.blue)
                                    .cornerRadius(22)
                            }
                            
                            Button(action: {}) {
                                Label("Sports", systemImage: "sportscourt")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(height: 40)
                                    .background(Color.blue)
                                    .cornerRadius(22)
                            }
                        }
                        .padding(.horizontal)  // Padding for the entire scroll view's horizontal padding
                        .padding(.bottom,8)
        }
    }
    
    func eventSection(title: String, events: [EventData]) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                    .bold()
                Spacer()
                Button("See All") {}
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(events) { event in
                        VStack {
                            Image("placeholder") // Replace "placeholder" with your actual image resource
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 100)
                                .cornerRadius(10)
                            
                            Text(event.name)
                                .bold()
                            Text(event.attendees)
                            Text(event.location)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 230, height: 300)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding(.horizontal)
                .padding(.top,10)
                .padding(.bottom,10)
            }
        }
    }
    
    var inviteFriendsCard: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.3)]), startPoint: .top, endPoint: .bottom))
                .shadow(radius: 10)
                .padding()
            
            // Content
            VStack(spacing: 20) {
                Text("Invite your friends")
                    .bold()
//                    .font(.title)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                Text("Get $20 for ticket")
//                    .font(.headline)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                
                Button(action: {}) {
                    Text("INVITE")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 140, height: 44)
                        .background(Color.cyan)
                        .cornerRadius(5)
                        
                }
                .shadow(radius: 5)
            }
            .padding()
            
            // Decorative graphics and illustrations
            HStack {
                Spacer()
                VStack {
                    Image("giftBox") // Ensure you have a 'giftBox' asset
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Spacer()
                }
                .padding(.top, 50)
            }
            
        }
        .frame(width: 390, height: 200)
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

struct EventData: Identifiable {
    var id = UUID()
    var name: String
    var attendees: String
    var location: String
}

struct MainEventAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainEventAppView()
    }
}
