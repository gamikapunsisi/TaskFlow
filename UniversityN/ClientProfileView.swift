import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ClientProfileView()
                    .tabItem {
                        Image(systemName: "square.grid.2x2")
                        Text("Home")
                    }
                    .tag(0)

                Text("Documents")
                    .tabItem {
                        Image(systemName: "doc.text")
                        Text("Docs")
                    }
                    .tag(1)

                Text("Create New")
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("New")
                    }
                    .tag(2)

                Text("Notifications")
                    .tabItem {
                        Image(systemName: "bell")
                        Text("Alerts")
                    }
                    .badge(2)
                    .tag(3)

                Text("Messages")
                    .tabItem {
                        Image(systemName: "message")
                        Text("Chat")
                    }
                    .badge(1)
                    .tag(4)
            }
            .accentColor(.purple)

            // Floating action button in center
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            selectedTab = 2
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.purple)
                                .frame(width: 60, height: 60)
                                .shadow(radius: 4)
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 28, weight: .bold))
                        }
                    }
                    .padding(.bottom, 20)
                    .offset(y: -10)
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Client Profile View

struct ClientProfileView: View {
    @State private var testimonialPage = 1

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Profile Info
                    HStack(alignment: .center, spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                            Circle()
                                .fill(Color.green)
                                .frame(width: 12, height: 12)
                                .offset(x: -4, y: -4)
                        }

                        VStack(alignment: .leading) {
                            Text("Gamika Punsisi.")
                                .font(.title2)
                                .bold()
                            Text("📍 Minuwangoda, Sri Lanka")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("🕙 10:57 am local time")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.purple)
                        }
                    }

                    // Spend and Jobs
                    HStack {
                        VStack(alignment: .leading) {
                            Text("$10k")
                                .font(.title2)
                                .bold()
                            Text("Total spend")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("50")
                                .font(.title2)
                                .bold()
                            Text("Total jobs")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }

                    Divider()

                    // Active Job Post
                    Text("Active Job Post")
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            JobCard(
                                title: "Educational Mobile app UI/UX Design",
                                date: "Feb 12, 2025",
                                proposals: "5 to 10"
                            )
                            JobCard(
                                title: "House Painting Job around Minuwangoda",
                                date: "Feb 12, 2025",
                                proposals: "5 to 10"
                            )
                        }
                        .padding(.vertical)
                    }

                    HStack {
                        Spacer()
                        Text("1/1")
                            .foregroundColor(.gray)
                        Spacer()
                        Button("Next") {}
                            .foregroundColor(.purple)
                    }

                    Divider()

                    // Testimonials
                    Text("Testimonials")
                        .font(.headline)

                    TestimonialCard()

                    HStack {
                        Button("Back") {
                            if testimonialPage > 1 {
                                testimonialPage -= 1
                            }
                        }
                        .foregroundColor(.gray)

                        Spacer()

                        Text("\(testimonialPage)/4")
                            .foregroundColor(.gray)

                        Spacer()

                        Button("Next") {
                            if testimonialPage < 4 {
                                testimonialPage += 1
                            }
                        }
                        .foregroundColor(.purple)
                    }
                }
                .padding()
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {}) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            })
        }
    }
}

// MARK: - Job Card

struct JobCard: View {
    var title: String
    var date: String
    var proposals: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(.purple)
            Text(date)
                .font(.caption)
                .foregroundColor(.gray)
            Text("Fixed Price: $55.00")
                .font(.caption)
            Text("Proposal: \(proposals)")
                .font(.caption)
                .bold()
        }
        .padding()
        .frame(width: 250)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

// MARK: - Testimonial Card

struct TestimonialCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("E Commerce Mobile app UI/UX Design")
                .font(.headline)
                .foregroundColor(.purple)
            Text("Oct 14, 2024 - Dec 25, 2024")
                .font(.caption)
                .foregroundColor(.gray)
            Text("The e-commerce app UI was beyond my expectations!")
                .font(.body)
            HStack(spacing: 2) {
                ForEach(0..<5, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
            }
            Text("$55.00")
                .font(.caption)
                .padding(.top, 2)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

#Preview {
    MainTabView()
}
