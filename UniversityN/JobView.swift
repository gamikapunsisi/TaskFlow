//
//  Untitled 2.swift
//  UniversityN
//
//  Created by Gamika Punsisi on 2025-04-22.
//

import SwiftUI

//struct Job: Identifiable {
//    let id = UUID()
//    let title: String
//    let budget: String
//    let description: String
//    let tags: [String]
//    let location: String
//    let proposals: String
//}



struct JobView: View {
    @StateObject var viewModel = TaskViewModel()
    @State private var currentPage = 0
    private let itemsPerPage = 2

    var paginatedTasks: [Task] {
        let startIndex = currentPage * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, viewModel.tasks.count)
        return Array(viewModel.tasks[startIndex..<endIndex])
    }

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

                // Job List (Paginated)
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(paginatedTasks) { task in
                            TaskCardView(task: task)
                                .frame(height: 280) // control height for perfect 2-card fit
                        }
                    }
                    .padding()
                }

                // Pagination Controls
                HStack {
                    Button("Back") {
                        if currentPage > 0 {
                            currentPage -= 1
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(currentPage == 0 ? Color(.systemGray4) : Color(.systemGray5))
                    .cornerRadius(10)
                    .disabled(currentPage == 0)

                    Text("\(currentPage + 1)/\(max(1, Int(ceil(Double(viewModel.tasks.count) / Double(itemsPerPage)))))")
                        .foregroundColor(.gray)

                    Button("Next") {
                        if (currentPage + 1) * itemsPerPage < viewModel.tasks.count {
                            currentPage += 1
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background((currentPage + 1) * itemsPerPage >= viewModel.tasks.count ? Color(.systemGray4) : Color(.systemGray5))
                    .cornerRadius(10)
                    .disabled((currentPage + 1) * itemsPerPage >= viewModel.tasks.count)
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
            .onAppear {
                viewModel.fetchTasks()
            }
        }
    }
}


// 👉 Corrected TaskCardView to accept `Task`, not `Job`
struct TaskCardView: View {
    let task: Task

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(task.createdAt ?? "Just now")
                .font(.caption)
                .foregroundColor(.gray)

            Text(task.title)
                .font(.headline)
                .foregroundColor(.purple)

            Text("Fixed Price - Est Budget: $\(task.budget ?? "0")")
                .font(.subheadline)
                .foregroundColor(.black)

            Text(task.description)
                .font(.caption)
                .foregroundColor(.gray)

            // Category Tag
            Text(task.category)
                .font(.caption)
                .padding(6)
                .background(Color(.systemGray6))
                .cornerRadius(10)

            HStack {
                Image(systemName: "calendar")
                Text("Deadline: \(task.deadline)")
            }
            .font(.caption)
            .foregroundColor(.gray)

            Text("Proposals: \(task.proposalsCount ?? 0)")
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
