import SwiftUI

struct EventDetailView: View {
    var body: some View {
        VStack {
            
            ScrollView {
                VStack(alignment: .leading) {
                    // Event Banner
                    ZStack(alignment: .topLeading) {
                        Image("event") // Replace with your image asset
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                        
                        // Back Button
                        Button(action: {
                            // Handle back navigation
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        .padding(.leading, 16)
                        .padding(.top, 40)
                        
                        // Event Details Title
                        Text("Event Details")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top, 50)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    // Attendee Section
                    HStack {
                        HStack(spacing: -8) {
                            Image("profile1") // Replace with attendee images
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                            Image("profile2")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                            Image("profile3")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                        }
                        
                        Text("+20 Going")
                            .foregroundColor(.blue)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            // Invite action
                        }) {
                            Text("Invite")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(7)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal, 16)
                    .offset(y: -20) // Floating effect
                    
                    // Event Title
                    Text("International Band Music Concert")
                        .font(.title)
                        .bold()
                        .padding(.horizontal, 16)
                    
                    // Event Date & Time
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("14 December, 2021")
                                .bold()
                            Text("Tuesday, 4:00PM - 9:00PM")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // Event Location
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Gala Convention Center")
                                .bold()
                            Text("36 Guild Street London, UK")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // Organizer Section
                    HStack {
                        Image("organizer") // Replace with organizer profile image
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text("Ashfak Sayem")
                                .bold()
                            Text("Organizer")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        Button(action: {
                            // Follow action
                        }) {
                            Text("Follow")
                                .foregroundColor(.blue)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // About Event
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About Event")
                            .bold()
                        Text("Enjoy your favorite dish and a lovely evening with friends and family. Food from local food trucks will be available for purchase. Read More...")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // Buy Ticket Button
                    Button(action: {
                        // Handle ticket purchase
                    }) {
                        HStack {
                            Text("BUY TICKET $120")
                                .bold()
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        
                    }
                    
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
//                .navigationBarHidden(true)
            }
//            .navigationBarHidden(true)
        }
        .edgesIgnoringSafeArea(.top)
//        .navigationBarHidden(true)

    }}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView()
    }
}
