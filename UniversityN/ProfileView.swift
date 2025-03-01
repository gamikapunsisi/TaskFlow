import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 30) {
                    Image("profile")  // Ensure your actual image asset is named correctly
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                        .padding(.top, 100)

                    Text("Ashfak Sayem")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)

                    HStack(spacing: 50) {
                        InfoBlock(title: "350", subtitle: "Following")
                        InfoBlock(title: "346", subtitle: "Followers")
                    }
                    .padding(.top, 5)

                    Button(action: {
                        // Action for Edit Profile
                    }) {
                        Text("Edit Profile")
                            .fontWeight(.semibold)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.5)]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                            .padding(.horizontal)
                    }
                    .padding(.vertical)

                    Group {
                        Text("About Me")
                            .font(.headline)
                            .padding(.vertical, 5)

                        Text("Enjoy your favorite dish and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                        HStack {
                            ForEach(["Games Online", "Concert", "Music", "Art", "Movie", "Others"], id: \.self) { interest in
                                InterestTag(text: interest)
                            }
                        }
                        .padding(.vertical)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color(.systemBackground))
//            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.blue)
            })
        }
        .navigationBarHidden(true)
    }
}

struct InfoBlock: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct InterestTag: View {
    var text: String
    
    var body: some View {
        Text(text)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            .font(.caption)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
