//
//  AuthManager.swift
//  UniversityN
//
//  Authentication coordinator and session management
//

import Foundation
import Combine

// MARK: - Authentication State
enum AuthState {
    case unauthenticated
    case authenticating
    case authenticated(User)
    case error(AuthError)
}

// MARK: - Auth Manager
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var authState: AuthState = .unauthenticated
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var lastError: AuthError?
    
    private let authService: AuthService
    private let logger = DebugLogger.shared
    private var cancellables = Set<AnyCancellable>()
    
    // Session management
    private let sessionTimeout: TimeInterval = 3600 // 1 hour
    private var sessionTimer: Timer?
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService
        setupBindings()
        checkExistingSession()
    }
    
    private func setupBindings() {
        // Observe auth service state changes
        authService.$currentUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.currentUser = user
                self?.isAuthenticated = user != nil
                
                if let user = user {
                    self?.authState = .authenticated(user)
                    self?.startSessionTimer()
                } else {
                    self?.authState = .unauthenticated
                    self?.stopSessionTimer()
                }
            }
            .store(in: &cancellables)
        
        authService.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        authService.$lastError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.lastError = error
                if let error = error {
                    self?.authState = .error(error)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Session Management
    private func checkExistingSession() {
        logger.debug("Checking for existing session", category: .authentication)
        
        // In a real implementation, this would check for stored tokens
        // For now, we'll check if user data exists in UserDefaults
        if let userData = UserDefaults.standard.data(forKey: "current_user"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            logger.info("Found existing session", category: .authentication, metadata: ["user_id": user.id])
            currentUser = user
            isAuthenticated = true
            authState = .authenticated(user)
            startSessionTimer()
        }
    }
    
    private func saveSession(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "current_user")
            logger.debug("Session saved", category: .authentication)
        }
    }
    
    private func clearSession() {
        UserDefaults.standard.removeObject(forKey: "current_user")
        logger.debug("Session cleared", category: .authentication)
    }
    
    private func startSessionTimer() {
        stopSessionTimer()
        sessionTimer = Timer.scheduledTimer(withTimeInterval: sessionTimeout, repeats: false) { [weak self] _ in
            self?.handleSessionTimeout()
        }
        logger.debug("Session timer started", category: .authentication)
    }
    
    private func stopSessionTimer() {
        sessionTimer?.invalidate()
        sessionTimer = nil
        logger.debug("Session timer stopped", category: .authentication)
    }
    
    private func handleSessionTimeout() {
        logger.info("Session timeout occurred", category: .authentication)
        Task {
            await signOut()
        }
    }
    
    // MARK: - Authentication Methods
    func signUp(email: String, password: String, confirmPassword: String, fullName: String, role: String) async -> Bool {
        logger.info("Sign up requested", category: .authentication)
        
        // Validate password confirmation
        if password != confirmPassword {
            await MainActor.run {
                self.lastError = .passwordMismatch
                self.authState = .error(.passwordMismatch)
            }
            return false
        }
        
        await MainActor.run {
            self.authState = .authenticating
        }
        
        let result = await authService.signUp(email: email, password: password, fullName: fullName, role: role)
        
        switch result {
        case .success(let user):
            await MainActor.run {
                self.saveSession(user)
            }
            logger.info("Sign up successful via AuthManager", category: .authentication)
            return true
            
        case .failure(let error):
            logger.error("Sign up failed via AuthManager", category: .authentication, metadata: [
                "error_code": error.errorCode
            ])
            return false
        }
    }
    
    func signIn(email: String, password: String) async -> Bool {
        logger.info("Sign in requested", category: .authentication)
        
        await MainActor.run {
            self.authState = .authenticating
        }
        
        let result = await authService.signIn(email: email, password: password)
        
        switch result {
        case .success(let user):
            await MainActor.run {
                self.saveSession(user)
            }
            logger.info("Sign in successful via AuthManager", category: .authentication)
            return true
            
        case .failure(let error):
            logger.error("Sign in failed via AuthManager", category: .authentication, metadata: [
                "error_code": error.errorCode
            ])
            return false
        }
    }
    
    func signOut() async {
        logger.info("Sign out requested", category: .authentication)
        
        let result = await authService.signOut()
        
        switch result {
        case .success:
            await MainActor.run {
                self.clearSession()
                self.stopSessionTimer()
            }
            logger.info("Sign out successful via AuthManager", category: .authentication)
            
        case .failure(let error):
            logger.error("Sign out failed via AuthManager", category: .authentication, metadata: [
                "error_code": error.errorCode
            ])
        }
    }
    
    func resetPassword(email: String) async -> Bool {
        logger.info("Password reset requested", category: .authentication)
        
        let result = await authService.resetPassword(email: email)
        
        switch result {
        case .success:
            logger.info("Password reset successful via AuthManager", category: .authentication)
            return true
            
        case .failure(let error):
            logger.error("Password reset failed via AuthManager", category: .authentication, metadata: [
                "error_code": error.errorCode
            ])
            return false
        }
    }
    
    // MARK: - Validation
    func validateSignUpInput(email: String, password: String, confirmPassword: String, fullName: String) -> AuthError? {
        // Check password confirmation first
        if password != confirmPassword {
            return .passwordMismatch
        }
        
        // Use auth service validation
        return authService.validateInput(email: email, password: password, fullName: fullName)
    }
    
    func validateSignInInput(email: String, password: String) -> AuthError? {
        return authService.validateInput(email: email, password: password)
    }
    
    // MARK: - Utility Methods
    func refreshSession() {
        // Extend session timer
        if isAuthenticated {
            startSessionTimer()
        }
    }
    
    func getSessionInfo() -> [String: Any] {
        var info: [String: Any] = [
            "is_authenticated": isAuthenticated,
            "auth_state": String(describing: authState)
        ]
        
        if let user = currentUser {
            info["user_id"] = user.id
            info["user_role"] = user.role
            info["user_email_domain"] = user.email.components(separatedBy: "@").last ?? "unknown"
        }
        
        if let timer = sessionTimer {
            info["session_active"] = timer.isValid
        }
        
        return info
    }
    
    func clearErrors() {
        lastError = nil
        if case .error = authState {
            authState = isAuthenticated ? .authenticated(currentUser!) : .unauthenticated
        }
    }
}