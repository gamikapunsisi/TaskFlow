import SwiftUI



struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    init(data: Data, spacing: CGFloat = 10, alignment: HorizontalAlignment = .leading, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        LazyVStack(alignment: alignment, spacing: spacing) {
            var width = CGFloat.zero
            var height = CGFloat.zero
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    ForEach(Array(data), id: \.self) { item in
                        content(item)
                            .padding(.all, 5)
                            .background(GeometryReader { geo in
                                Color.clear.onAppear {
                                    if width + geo.size.width > geometry.size.width {
                                        width = 0
                                        height -= geo.size.height + spacing
                                    }
                                    width += geo.size.width + spacing
                                }
                            })
                            .offset(x: width, y: height)
                    }
                }
            }
            .frame(height: height * -1)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 0) {
            
            // Top bar
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer()
                Text("My Profile")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Spacer().frame(width: 44) // To balance the left button
            }
            .padding(.top, 50)
            .background(Color.blue)
            .foregroundColor(.white)
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Profile Image and Info
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomTrailing) {
                            Image("profile_picture") // Replace with your image
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 4)
                            
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.purple)
                                .background(Circle().fill(Color.white))
                                .offset(x: 5, y: 5)
                        }
                        
                        Text("Gamika P.")
                            .font(.headline)
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.subheadline)
                            Text("Seeduwa, Sri Lanka")
                                .font(.subheadline)
                        }
                        Text("10:57 am local time")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    // Earnings and Jobs
                    HStack {
                        VStack {
                            Text("$259")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Total earnings")
                                .font(.caption)
                        }
                        Spacer()
                        VStack {
                            Text("3")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Total jobs")
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Title and About
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("UI/UX Designer | User Interface Designer | Figma | Illustrator")
                                .font(.headline)
                                .lineLimit(3)
                            Spacer()
                            Image(systemName: "pencil.circle")
                                .foregroundColor(.purple)
                        }
                        
                        HStack {
                            Text("Hello There...")
                                .font(.subheadline)
                            Spacer()
                            Image(systemName: "pencil.circle")
                                .foregroundColor(.purple)
                        }
                        
                        Text("""
                        I’m Gamika Punsisi, a qualified professional UI/UX designer with 6+ years of experience. I’m passionate about user research, design principles, and staying up-to-date with the latest trends and technologies in design.
                        """)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    // Portfolio
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Portfolio")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.purple)
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                Image("portfolio1")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(12)
                                
                                Image("portfolio2")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(12)
                            }
                        }
                        
                        HStack {
                            Button("Back") {}
                                .frame(width: 80, height: 30)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            
                            Spacer()
                            Text("1/4")
                                .font(.footnote)
                            
                            Spacer()
                            
                            Button("Next") {}
                                .frame(width: 80, height: 30)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Testimonials
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Testimonials")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("E Commerce Mobile app UI/UX Design")
                                .foregroundColor(.purple)
                                .font(.headline)
                            Text("Oct 14, 2024 - Dec 25, 2024")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("The e-commerce app UI was beyond my expectations!")
                                .font(.subheadline)
                            
                            HStack {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                }
                            }
                            
                            Text("$55.00")
                                .font(.headline)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3))
                        )
                        
                        HStack {
                            Button("Back") {}
                                .frame(width: 80, height: 30)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            
                            Spacer()
                            Text("1/4")
                                .font(.footnote)
                            
                            Spacer()
                            
                            Button("Next") {}
                                .frame(width: 80, height: 30)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Skills
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Skills")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        WrapView(tags: ["Figma", "Web Design", "User Interface Design", "UI/UX", "Mobile UI Design", "User Experience Design", "UI/UX Prototyping"])
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            
            // Bottom Navigation
            HStack {
                Spacer()
                Image(systemName: "square.grid.2x2")
                Spacer()
                Image(systemName: "doc.text")
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 50, height: 50)
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "bell")
                Spacer()
                Image(systemName: "bubble.left")
                Spacer()
            }
            .padding()
            .background(Color.white.shadow(radius: 5))
        }
        .ignoresSafeArea(edges: .top)
    }
}

struct WrapView: View {
    let tags: [String]
    
    var body: some View {
        FlexibleView(data: tags, spacing: 10, alignment: .leading) { tag in
            Text(tag)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20)
                .font(.caption)
        }
    }
}

#Preview {
    ProfileView()
}
