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

// MARK: - Task Model
struct Task: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let budget: Int
    let category: String
    let deadline: String
    let status: String
    let userId: Int
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case budget
        case category
        case deadline
        case status
        case userId = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Task View Model
class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var isLoading = false
    @Published var error: String?
    
    public let dbManager = Databas
    
    init() {
        fetchTasks()
    }
    
    // MARK: - Task Operations
    func fetchTasks() {
        isLoading = true
        error = nil
        
        do {
            tasks = try dbManager.getTasks()
            isLoading = false
        } catch {
            self.error = error.localizedDescription
            isLoading = false
        }
    }
    
    func createTask(title: String, description: String, budget: Int, category: String, deadline: String, userId: Int) {
        do {
            try dbManager.createTask(
                title: title,
                description: description,
                budget: budget,
                category: category,
                deadline: deadline,
                userId: userId
            )
            fetchTasks() // Refresh the task list
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func updateTaskStatus(taskId: Int, status: String) {
        do {
            try dbManager.updateTaskStatus(taskId: taskId, status: status)
            fetchTasks() // Refresh the task list
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func deleteTask(taskId: Int) {
        do {
            try dbManager.deleteTask(taskId: taskId)
            fetchTasks() // Refresh the task list
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    // MARK: - Proposal Operations
    func submitProposal(taskId: Int, userId: Int, amount: Int, message: String) {
        do {
            try dbManager.createProposal(
                taskId: taskId,
                userId: userId,
                amount: amount,
                message: message
            )
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func getProposals(for taskId: Int) -> [Proposal] {
        do {
            return try dbManager.getProposals(taskId: taskId)
        } catch {
            self.error = error.localizedDescription
            return []
        }
    }
    
    func acceptProposal(proposalId: Int) {
        do {
            try dbManager.acceptProposal(proposalId: proposalId)
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func rejectProposal(proposalId: Int) {
        do {
            try dbManager.rejectProposal(proposalId: proposalId)
        } catch {
            self.error = error.localizedDescription
        }
    }
}



