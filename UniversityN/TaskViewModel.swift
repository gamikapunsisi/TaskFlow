//
//  TaskViewModel.swift
//  UniversityN
//
//  Created by Gamika Punsisi on 2025-04-25.
//

//import SwiftUI
//
//class TaskViewModel: ObservableObject {
//    @Published var tasks: [Task] = [
//        Task(title: "Educational Mobile app UI/UX Design", deadline: "Feb 12, 2025", proposalsCount: "5 to 10"),
//        Task(title: "House Painting Job around Minuwangoda", deadline: "Feb 12, 2025", proposalsCount: "5 to 10")
//    ]
//}
//
//struct Task: Identifiable {
//    let id = UUID()
//    var title: String
//    var deadline: String
//    var proposalsCount: String
//}
import SwiftUI
import Foundation


class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []

    // Function to fetch tasks from the API
    func fetchTasks() {
        guard let url = URL(string: "http://localhost:8000/api/tasks") else {
            print("Invalid URL")
            return
        }

        // Create a URLSession data task to fetch the tasks
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle any errors
            if let error = error {
                print("Error fetching tasks: \(error.localizedDescription)")
                return
            }

            // Check for a valid response
            guard let data = data else {
                print("No data received")
                return
            }

            // Attempt to decode the data into Task objects
            do {
                let decoder = JSONDecoder()
                let decodedTasks = try decoder.decode([Task].self, from: data)
                DispatchQueue.main.async {
                    // Update the tasks array on the main thread
                    self.tasks = decodedTasks
                }
            } catch {
                print("Error decoding tasks: \(error.localizedDescription)")
            }
        }
        .resume() // Start the data task
    }
}

// Task struct inside the same file
// Task Model with computed proposalsCount
struct Task: Identifiable, Decodable {
    let id: Int?
    var title: String
    var description: String
    var budget: String?
    var category: String
    var deadline: String
    var status: String?
    var createdAt: String?
    var updatedAt: String?
    var bids: [String]?
    var proposalsCount: Int?  // Optional
}



