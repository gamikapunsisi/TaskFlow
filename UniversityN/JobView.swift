//
//  Untitled 2.swift
//  UniversityN
//
//  Created by Gamika Punsisi on 2025-04-22.
//

import SwiftUI

struct Job: Identifiable {
    let id = UUID()
    let title: String
    let budget: String
    let description: String
    let tags: [String]
    let location: String
    let proposals: String
}

struct JobView: View {
    let job = Job(
        title: "Tourism Mobile app UI/UX Design",
        budget: "$250",
        description: "We are seeking a talented UI/UX designer to create visually appealing and user-friendly design for our web application.",
        tags: ["Figma", "Web Design", "User Interface Design", "UI/UX"],
        location: "United States",
        proposals: "5 to 10"
    )

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for jobs", text: .constant(""))
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                Text("Browse jobs that match your experience to a client’s hiring preference.\nOrdered by most recent.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding([.horizontal, .top])

                // Job List
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(0..<3) { _ in
                            JobCardView(job: job)
                        }
                    }
                    .padding()
                }

                // Pagination
                HStack {
                    Button("Back") {}
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray5))
                        .cornerRadius(10)

                    Text("1/50")
                        .foregroundColor(.gray)

                    Button("Next") {}
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                }
                .padding()

                // Bottom Bar
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
            .navigationBarTitle("Jobs", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                },
                trailing: Image(systemName: "person.crop.circle")
            )
        }
    }
}

struct JobCardView: View {
    let job: Job

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Posted 2 seconds ago")
                .font(.caption)
                .foregroundColor(.gray)

            Text(job.title)
                .font(.headline)
                .foregroundColor(.purple)

            Text("Fixed Price - Est Budget: \(job.budget)")
                .font(.subheadline)
                .foregroundColor(.black)

            Text(job.description)
                .font(.caption)
                .foregroundColor(.gray)

            // Tags
            HStack {
                ForEach(job.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(6)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
            }

            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text(job.location)
            }
            .font(.caption)
            .foregroundColor(.gray)

            Text("Proposal: \(job.proposals)")
                .font(.caption)

            Button(action: {}) {
                Text("Apply Now")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 3)
    }
}

struct JobView_Previews: PreviewProvider {
    static var previews: some View {
        JobView()
    }
}
