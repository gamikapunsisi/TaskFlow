//
//  JobDetail.swift
//  UniversityN
//
//  Created by Gamika Punsisi on 2025-04-22.
//
import SwiftUI

struct JobDetailView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                }
                Spacer()
                Text("Job Details")
                    .font(.title2).bold()
                Spacer()
                Image("client_photo") // Replace with your image
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            .padding()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Job Info
                    HStack {
                        Text("Posted 2 seconds ago")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("Proposal: 5 to 10")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Text("Tourism Mobile app UI/UX Design")
                        .font(.headline)
                        .foregroundColor(Color.purple)

                    Text("Fixed Price – Est Budget : $250")
                        .bold()
                        .font(.subheadline)

                    Text("""
We are looking for a creative and detail-oriented UI/UX designer to design a visually appealing and user-friendly interface for our tourism mobile application. The ideal candidate should have experience in modern mobile UI design, intuitive navigation, and a seamless user experience to enhance traveler engagement.
""")
                        .font(.body)
                        .foregroundColor(.gray)

                    // Responsibilities
                    VStack(alignment: .leading) {
                        Text("Responsibilities:")
                            .bold()
                        ForEach([
                            "Design a clean, engaging, and responsive UI for the tourism app.",
                            "Create wireframes, prototypes, and high-fidelity mockups.",
                            "Ensure an intuitive user experience with smooth navigation.",
                            "Implement modern UI trends while keeping the brand identity.",
                            "Collaborate with developers for design implementation.",
                            "Optimize designs for both Android and iOS platforms."
                        ], id: \.self) {
                            Text("• \($0)")
                                .font(.subheadline)
                        }
                    }

                    // Requirements
                    VStack(alignment: .leading) {
                        Text("Requirements:")
                            .bold()
                        ForEach([
                            "Proven experience in UI/UX design for mobile apps.",
                            "Proficiency in Figma, Adobe XD, or Sketch.",
                            "Strong understanding of user-centered design principles.",
                            "Portfolio showcasing previous mobile UI designs (especially in travel/tourism is a +).",
                            "Ability to deliver high-quality designs on time."
                        ], id: \.self) {
                            Text("• \($0)")
                                .font(.subheadline)
                        }
                    }

                    // Location + Track
                    HStack {
                        Label("United States", systemImage: "mappin.and.ellipse")
                            .font(.subheadline)
                        Spacer()
                        Button("Track Location") {}
                            .foregroundColor(.purple)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.purple, lineWidth: 1)
                            )
                    }

                    // Skills
                    VStack(alignment: .leading) {
                        Text("Skills and Expertise:")
                            .bold()
                        FlowLayout {
                            ForEach(["Figma", "Web Design", "User Interface Design", "UI/UX"], id: \.self) { tag in
                                Text(tag)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(20)
                            }
                        }
                    }

                    // Client Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text("About the client")
                            .font(.title3).bold()
                        Text("Mike Newland")
                            .bold()
                        Text("United States\n2:22 AM")
                        Text("2 jobs posted")
                        Text("0% hire rate, 3 open jobs")
                        Text("Member since Mar 23, 2025")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    // Testimonial
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Testimonials")
                            .font(.headline).bold()
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2))
                            .background(Color.white)
                            .overlay(
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("E Commerce Mobile app UI/UX Design")
                                        .foregroundColor(.purple)
                                        .bold()
                                    Text("Oct 14, 2024 - Dec 25, 2024")
                                        .font(.caption)
                                    Text("A Fantastic Collaboration Experience!")
                                    HStack {
                                        ForEach(0..<5) { _ in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                    Text("$55.00")
                                        .bold()
                                }
                                .padding()
                            )
                    }

                    // Pagination + Apply
                    HStack {
                        Button("Back") {}
                            .padding()
                            .background(Color(.systemGray5))
                            .cornerRadius(10)

                        Spacer()

                        Text("1/5")

                        Spacer()

                        Button("Next") {}
                            .padding()
                            .background(Color(.systemGray5))
                            .cornerRadius(10)
                    }

                    Button("Apply Now") {}
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()
            }

            // Bottom Nav
            HStack {
                Image(systemName: "square.grid.2x2")
                Spacer()
                Image(systemName: "list.bullet")
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 60, height: 60)
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "bell")
                Spacer()
                Image(systemName: "message")
            }
            .padding()
            .background(Color.white.shadow(radius: 2))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// Flow Layout for skills tags
struct FlowLayout<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading) {
            content()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct JobDetailView_Previews: PreviewProvider {
    static var previews: some View {
        JobDetailView()
    }
}
