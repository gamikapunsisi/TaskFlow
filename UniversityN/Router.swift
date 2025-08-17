import SwiftUI

// Import the User model
struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let email_verified_at: String?
    let created_at: String
    let updated_at: String
    let role: String
}

enum Route: Hashable {
    case login
    case signup
    case clientProfile
    case taskerProfile
    case createTask
    case taskDetail(Int)
    case proposals(Int)
    case contracts
    case clientContracts
    case alerts
    case debug  // Debug console for development
}

class Router: ObservableObject {
    @Published var path = NavigationPath()
    @Published var isAuthenticated = false
    @Published var userRole: String = ""
    @Published var userId: Int = 0
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
    
    func handleAuthentication(user: User) {
        isAuthenticated = true
        userRole = user.role
        userId = user.id
        
        // Navigate to appropriate profile based on role
        if user.role == "client" {
            navigate(to: .clientProfile)
        } else {
            navigate(to: .taskerProfile)
        }
    }
    
    func logout() {
        isAuthenticated = false
        userRole = ""
        userId = 0
        navigateToRoot()
    }
}

struct RouterView: View {
    @StateObject private var router = Router()
    @StateObject private var taskVM = TaskViewModel()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            if !router.isAuthenticated {
                LoginView()
                    .environmentObject(router)
            } else {
                Group {
                    switch router.userRole {
                    case "client":
                        ClientProfileView(taskVM: taskVM)
                            .environmentObject(router)
                    case "tasker":
                        ProfileView()
                            .environmentObject(router)
                    default:
                        Text("Unknown role")
                    }
                }
            }
        }
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .login:
                LoginView()
                    .environmentObject(router)
            case .signup:
                SignUpView()
                    .environmentObject(router)
            case .clientProfile:
                ClientProfileView(taskVM: taskVM)
                    .environmentObject(router)
            case .taskerProfile:
                ProfileView()
                    .environmentObject(router)
            case .createTask:
                CreateTaskView()
                    .environmentObject(router)
            case .taskDetail(let taskId):
                JobDetailView()
                    .environmentObject(router)
            case .proposals(let taskId):
                ClientProposalsView(taskId: taskId)
                    .environmentObject(router)
            case .contracts:
                ContractsView()
                    .environmentObject(router)
            case .clientContracts:
                ClientContractsView()
                    .environmentObject(router)
            case .alerts:
                AlertsView()
                    .environmentObject(router)
            case .debug:
                DebugView()
                    .environmentObject(router)
            }
        }
    }
} 