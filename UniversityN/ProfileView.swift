import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode

    let tags: [String] = [
        "Figma", "Web Design", "User Interface Design", "UI/UX",
        "Mobile UI Design", "User Experience Design", "UI/UX Prototyping"
    ]

    var body: some View {
        VStack(spacing: 6) {
            // Top Bar
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.purple)
                }
                Spacer()
                Text("My Profile")
                    .font(.title3).bold()
                Spacer()
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .padding()
                        .foregroundColor(.purple)
                }
            }
            .padding()

            // Profile Header
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 15) {
                    ZStack(alignment: .bottomTrailing) {
                        Image("profile") // Replace with your image asset
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fill)

                        Circle()
                            .fill(Color.green)
                            .frame(width: 12, height: 12)
                            .offset(x: 4, y: 4)
                    }

                    VStack(alignment: .leading) {
                        Text("Gamika P.")
                            .font(.headline)
                        HStack {
                            Image(systemName: "location")
                            Text("Seeduwa, Sri Lanka")
                        }.font(.subheadline)
                        Text("10:57 am local time")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text("$259")
                            .font(.headline)
                        Text("Total earnings")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("3")
                            .font(.headline)
                        Text("Total jobs")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()

            Divider()

            // Bio Section
            VStack(alignment: .leading, spacing: 8) {
                Text("UI/UX Designer | User Interface Designer | Figma | Illustrator")
                    .font(.headline)

                Text("Hello There…")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("I’m Gamika Punsisi, a qualified professional UI/UX designer with 6+ years of experience. I’m passionate about user research, design principles, and staying up-to-date with the latest trends and technologies in design.")
                    .font(.body)
            }
            .padding()

            // Portfolio Section
            VStack(alignment: .leading) {
                Text("Portfolio")
                    .font(.headline)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<3) { index in
                            VStack {
                                Rectangle()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 160, height: 120)
                                    .cornerRadius(10)
                                Text(index == 0 ? "Mobile app UI/UX Design" : "Web Site UI/UX Design")
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
            }
            .padding()

            // Testimonials Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Testimonials")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    Text("E Commerce Mobile app UI/UX Design")
                        .foregroundColor(.purple)
                    Text("Oct 14, 2024 - Dec 25, 2024")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("The e-commerce app UI was beyond my expectations!")
                    HStack(spacing: 2) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    Text("$55.00")
                        .bold()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
            }
            .padding()

            // Skills Section
            VStack(alignment: .leading) {
                Text("Skills")
                    .font(.headline)

                WrapView(tags: tags)
            }
            .padding()

            Spacer()

            // Bottom Navigation Bar
            HStack(spacing: 30) {
                Image(systemName: "square.grid.2x2")
                Image(systemName: "doc.text")
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.purple)
                    .clipShape(Circle())
                Image(systemName: "bell")
                Image(systemName: "message")
            }
            .padding()
            .background(Color.white.shadow(radius: 4))
        }
    }
}

// MARK: - WrapView for displaying tags/skills
struct WrapView: View {
    var tags: [String]
    let spacing: CGFloat = 8

    @State private var totalHeight = CGFloat.zero

    var body: some View {
        VStack {
            GeometryReader { geo in
                self.generateContent(in: geo)
            }
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geo: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .font(.caption)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                    .alignmentGuide(.leading, computeValue: { d in
                        if width + d.width + spacing > geo.size.width {
                            width = 0
                            height += d.height + spacing
                        }
                        let result = width
                        width += d.width + spacing
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geo -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = geo.size.height
            }
            return Color.clear
        }
    }
}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
