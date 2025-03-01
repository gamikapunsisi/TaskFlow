import SwiftUI

struct MainEventAppView: View {
    @State private var selectedTab = 0
    @State private var isShowingMenu = false
    var body: some View {
        ZStack{
            VStack {
                topNavigationBar
                categoryChips
                ScrollView(showsIndicators: false) {
                    VStack {
                        //                    categoryChips
                        eventSection(title: "Upcoming Events", events: [
                            EventData(name: "International Band Music", attendees: "+20 Going", location: "Harison Hall", image: "event1", date: "10 JUNE"),
                            EventData(name: "Jo Malone Invitational", attendees: "+15 Going", location: "Radius Gallery, NYC", image: "event2", date: "15 JUNE")
                        ])
                        inviteFriendsCard
                    }
                    .padding(.horizontal,20)
                    .padding(.bottom, 50) // Ensure space at the bottom for floating tab bar
                }
                bottomTabBar
            }
            .blur(radius: isShowingMenu ? 20 : 0)
            .disabled(isShowingMenu)
            
            
            if isShowingMenu {
                SideMenuView(isShowing: $isShowingMenu)
                    .transition(.move(edge: .leading))
            }
        }
        .edgesIgnoringSafeArea(.top) // Allow the top bar to extend into the status bar area
        .background(Color("Background")) // Use a named color or define a custom color
        .navigationBarHidden(true)
        .onTapGesture {
            if isShowingMenu {
                withAnimation {
                    isShowingMenu = false
                    
                }
            }
        }
    }
    
    // MARK: - View Components
    var topNavigationBar: some View {
        ZStack {
            Color.blue
                .edgesIgnoringSafeArea(.top) // Extending the blue background to the top edge of the screen
            HStack {
                Button(action: {
                    withAnimation {
                        isShowingMenu.toggle()
                    }
                }) {
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
            .padding(.horizontal,30) // Maintain horizontal padding for side spacing
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
            .padding(.horizontal,20) // Maintain horizontal padding for side spacing
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
            .padding(.horizontal,24)  // Padding for the entire scroll view's horizontal padding
            .padding(.bottom,8)
        }
    }
    
    func eventSection(title: String, events: [EventData]) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title3)
                    .bold()
                Spacer()
                Button("See All") {}
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(events) { event in
                        VStack {
                            ZStack(alignment: .topLeading) {
                                NavigationLink(destination: EventDetailView()) {
                                    Image("event") // Use actual images in your asset catalog
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 300, height: 200)
                                        .clipped()
                                        .cornerRadius(15)
                                        .shadow(radius: 5)
                                    
                                    Text(event.date)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(8)
                                        .background(Color.white.opacity(0.1))
                                        .foregroundColor(.red)
                                        .cornerRadius(8)
                                        .padding(10)
                                }
                            }
                            
                            HStack {
                                Text(event.name)
                                    .bold()
                                    .lineLimit(1)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            HStack {
                                HStack {
                                    Image(systemName: "person.3.fill")
                                    Text(event.attendees)
                                }
                                .padding(.trailing, 5)
                                
                                Spacer()
                                
                                Text(event.location)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding([.horizontal, .bottom])
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .frame(width: 300, height: 280)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    var inviteFriendsCard: some View {
        NavigationLink(destination: CampusMapView()) {
            ZStack {
                // Background Image
                Image("nibm")  // Ensure you have 'GiftBox' asset in your assets
                    .resizable()
                    .scaledToFill()  // Fill the entire background
                    .frame(height: 160)
                    .cornerRadius(10)
                    .clipped()  // Ensure the image does not bleed outside the corner radius
                    .shadow(radius: 10)
                //                        .padding(.horizontal)
                
                // Overlay to enhance text visibility
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.1))  // Semi-transparent overlay
                    .frame( height: 160)
                //                        .padding(.horizontal)
                
                VStack {
                    //                        Text("Invite your friends")
                    //                            .bold()
                    //                            .foregroundColor(.black)
                    //                            .font(.title3)
                    //
                    
                    //                        Text("Get $20 for ticket")
                    //                            .foregroundColor(.black)
                    //                            .font(.footnote)
                    //                            .padding(.bottom, 20)
                    
                    //                        Button(action: {}) {
                    //                            Text("INVITE ")
                    //                                .bold()
                    //                                .foregroundColor(.white)
                    //                                .padding(.vertical, 10)
                    //                                .padding(.horizontal, 30)
                    //                                .background(Color.black.opacity(0.1))
                    //                                .cornerRadius(10)
                    //                                .shadow(radius: 5)
                    //
                    //                        }
                }
            }
            .frame(height: 200)
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
    private func getTabIcon(_ index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "calendar"
        case 2: return "map"
        case 3: return "person"
        default: return "circle"
        }
    }
}

struct EventData: Identifiable {
    var id = UUID()
    var name: String
    var attendees: String
    var location: String
    var image: String
    var date: String
}

struct MainEventAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainEventAppView()
    }
}
