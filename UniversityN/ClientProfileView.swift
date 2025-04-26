import SwiftUI



struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var taskVM = TaskViewModel()


    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ClientProfileView(taskVM: taskVM) // ← pass it here
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

//                Text("Create New")
//                    .tabItem {
//                        Image(systemName: "plus.circle")
//                        Text("New")
//                    }
//                    .tag(2)
                     // Create New tab
                NavigationView {
                    CreateTaskView()
                }
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
        .onAppear {
                   taskVM.fetchTasks() // Fetch tasks when the view appears
               }
    }
}

// MARK: - Client Profile View

struct ClientProfileView: View {
    @ObservedObject var taskVM: TaskViewModel // ← added this

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

//                        Button(action: {}) {
//                            Image(systemName: "square.and.arrow.up")
//                                .foregroundColor(.purple)
//                        }
                        NavigationLink(destination: LoginView()) {
                            Button(action: {
                                // Add any logout logic here, such as clearing user data
                            }) {
                                Image(systemName: "arrow.right.circle.fill") // Logout icon
                                    .foregroundColor(.purple)
                                    .font(.system(size: 30)) // Adjust size if needed
                            }
                        }

                    }

                    // Spend and Jobs
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Rs:5600")
                                .font(.title2)
                                .bold()
                            Text("Total spend")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("10")
                                .font(.title2)
                                .bold()
                            Text("Total jobs")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }

                    Divider()
                    
                    // MARK: - Active Job Post
                    // MARK: - Active Job Post
                    Text("Active Job Post")
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // Dynamically load JobCards from API
//                            ForEach(taskVM.tasks) { task in
//                                JobCard(
//                                    title: task.title,
//                                    date: task.deadline,
//                                    proposals: task.proposalsCount
//                                )
//                            }
                            // In the ClientProfileView.swift
                            ForEach(taskVM.tasks) { task in
                                JobCard(
                                    title: task.title,
                                    date: task.deadline,
                                    category: task.category

                                )

                            }




                        }
                        .padding(.vertical)
                    }

                    // Job Count Indicator
//                    HStack {
//                        Spacer()
//                        Text("1/\(taskVM.tasks.count)")
//                            .foregroundColor(.gray)
//                        Spacer()
//                        Button("Next") {}
//                            .foregroundColor(.purple)
//                    }
//
//                    Divider()
                    
                    // Job Count Indicator and Navigation
                    HStack {
                        Text("1/\(taskVM.tasks.count)") // You can later bind current index
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button("Next") {
                            // Add next logic here
                        }
                        .foregroundColor(.purple)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)

                    Divider()


                

//                    HStack {
//                        Spacer()
//                        Text("1/1")
//                            .foregroundColor(.gray)
//                        Spacer()
//                        Button("Next") {}
//                            .foregroundColor(.purple)
//                    }
//
//                    Divider()

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
    var category: String


    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(.purple)
            
            Text("Category: \(category)")
                           .font(.subheadline)
                           .foregroundColor(.blue)
            
            Text(date)
                .font(.caption)
                .foregroundColor(.gray)
//            Text("Fixed Price: $55.00")
//                .font(.caption)
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
