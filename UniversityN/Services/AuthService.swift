//
//  AuthService.swift
//  UniversityN
//
//  Firebase Authentication service with comprehensive error handling
//

import Foundation
import Combine

// MARK: - Authentication Error Types
enum AuthError: LocalizedError {
    // Firebase Auth Errors
    case emailAlreadyInUse
    case invalidEmail
    case weakPassword
    case userNotFound
    case wrongPassword
    case userDisabled
    case tooManyRequests
    case networkError
    case emailNotVerified
    
    // Custom Validation Errors
    case emptyEmail
    case emptyPassword
    case passwordTooShort
    case passwordMismatch
    case invalidEmailFormat
    case emptyFullName
    
    // System Errors
    case unknownError(String)
    case firebaseNotConfigured
    case signUpFailed(String)
    case signInFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .emailAlreadyInUse:
            return "This email address is already registered. Please use a different email or try signing in."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .weakPassword:
            return "Password must be at least 8 characters long and contain a mix of letters, numbers, and special characters."
        case .userNotFound:
            return "No account found with this email address. Please check your email or create a new account."
        case .wrongPassword:
            return "Incorrect password. Please try again or reset your password."
        case .userDisabled:
            return "This account has been disabled. Please contact support for assistance."
        case .tooManyRequests:
            return "Too many failed attempts. Please wait a few minutes before trying again."
        case .networkError:
            return "Network connection error. Please check your internet connection and try again."
        case .emailNotVerified:
            return "Please verify your email address before signing in."
        case .emptyEmail:
            return "Please enter your email address."
        case .emptyPassword:
            return "Please enter your password."
        case .passwordTooShort:
            return "Password must be at least 8 characters long."
        case .passwordMismatch:
            return "Passwords do not match. Please try again."
        case .invalidEmailFormat:
            return "Please enter a valid email address format."
        case .emptyFullName:
            return "Please enter your full name."
        case .unknownError(let message):
            return "An unexpected error occurred: \(message)"
        case .firebaseNotConfigured:
            return "Authentication service is not properly configured. Please try again later."
        case .signUpFailed(let message):
            return "Account creation failed: \(message)"
        case .signInFailed(let message):
            return "Sign in failed: \(message)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .emailAlreadyInUse:
            return "Try signing in with this email, or use the 'Forgot Password' option if needed."
        case .weakPassword:
            return "Choose a stronger password with at least 8 characters, including uppercase, lowercase, numbers, and symbols."
        case .userNotFound:
            return "Double-check your email address or create a new account."
        case .wrongPassword:
            return "Try again or tap 'Forgot Password' to reset your password."
        case .tooManyRequests:
            return "Wait 15 minutes before attempting to sign in again."
        case .networkError:
            return "Check your internet connection and try again."
        case .emailNotVerified:
            return "Check your email inbox for a verification link and click it to verify your account."
        default:
            return nil
        }
    }
    
    var errorCode: String {
        switch self {
        case .emailAlreadyInUse: return "email-already-in-use"
        case .invalidEmail: return "invalid-email"
        case .weakPassword: return "weak-password"
        case .userNotFound: return "user-not-found"
        case .wrongPassword: return "wrong-password"
        case .userDisabled: return "user-disabled"
        case .tooManyRequests: return "too-many-requests"
        case .networkError: return "network-error"
        case .emailNotVerified: return "email-not-verified"
        case .emptyEmail: return "empty-email"
        case .emptyPassword: return "empty-password"
        case .passwordTooShort: return "password-too-short"
        case .passwordMismatch: return "password-mismatch"
        case .invalidEmailFormat: return "invalid-email-format"
        case .emptyFullName: return "empty-full-name"
        case .unknownError: return "unknown-error"
        case .firebaseNotConfigured: return "firebase-not-configured"
        case .signUpFailed: return "sign-up-failed"
        case .signInFailed: return "sign-in-failed"
        }
    }
}

// MARK: - Auth Service Result
enum AuthResult {
    case success(User)
    case failure(AuthError)
}

// MARK: - Auth Service Protocol
protocol AuthServiceProtocol {
    func signUp(email: String, password: String, fullName: String, role: String) async -> AuthResult
    func signIn(email: String, password: String) async -> AuthResult
    func signOut() async -> Result<Void, AuthError>
    func resetPassword(email: String) async -> Result<Void, AuthError>
    func validateInput(email: String, password: String, fullName: String?) -> AuthError?
}

// MARK: - Firebase Auth Service
class AuthService: ObservableObject, AuthServiceProtocol {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var lastError: AuthError?
    
    private let logger = DebugLogger.shared
    private let firebaseManager = FirebaseManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupFirebaseConfigurationObserver()
    }
    
    private func setupFirebaseConfigurationObserver() {
        firebaseManager.$isConfigured
            .sink { [weak self] isConfigured in
                if !isConfigured {
                    self?.logger.warning("Firebase not configured, authentication may fail", category: .configuration)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Input Validation
    func validateInput(email: String, password: String, fullName: String? = nil) -> AuthError? {
        // Validate full name for sign up
        if let fullName = fullName, fullName.trimmingCharacters(in: .whitespaces).isEmpty {
            return .emptyFullName
        }
        
        // Validate email
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            return .emptyEmail
        }
        
        if !isValidEmail(email) {
            return .invalidEmailFormat
        }
        
        // Validate password
        if password.isEmpty {
            return .emptyPassword
        }
        
        if password.count < 8 {
            return .passwordTooShort
        }
        
        return nil
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, fullName: String, role: String) async -> AuthResult {
        logger.info("Starting sign up process", category: .authentication, metadata: [
            "email_domain": extractEmailDomain(email),
            "role": role
        ])
        
        // Validate Firebase configuration
        guard firebaseManager.isConfigured else {
            let error = AuthError.firebaseNotConfigured
            logger.logAuthError(error: error, operation: "signUp", email: email)
            return .failure(error)
        }
        
        // Validate input
        if let validationError = validateInput(email: email, password: password, fullName: fullName) {
            logger.logAuthError(error: validationError, operation: "signUp", email: email)
            return .failure(validationError)
        }
        
        // Check network connectivity
        guard firebaseManager.isNetworkAvailable else {
            let error = AuthError.networkError
            logger.logAuthError(error: error, operation: "signUp", email: email)
            return .failure(error)
        }
        
        await MainActor.run {
            isLoading = true
            lastError = nil
        }
        
        do {
            // Simulate Firebase Auth sign up
            let user = try await performFirebaseSignUp(email: email, password: password, fullName: fullName, role: role)
            
            await MainActor.run {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
            }
            
            logger.info("Sign up successful", category: .authentication, metadata: [
                "user_id": user.id,
                "role": user.role
            ])
            
            return .success(user)
            
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
            
            let authError = mapFirebaseErrorToAuthError(error)
            logger.logAuthError(error: authError, operation: "signUp", email: email)
            
            await MainActor.run {
                self.lastError = authError
            }
            
            return .failure(authError)
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async -> AuthResult {
        logger.info("Starting sign in process", category: .authentication, metadata: [
            "email_domain": extractEmailDomain(email)
        ])
        
        // Validate Firebase configuration
        guard firebaseManager.isConfigured else {
            let error = AuthError.firebaseNotConfigured
            logger.logAuthError(error: error, operation: "signIn", email: email)
            return .failure(error)
        }
        
        // Validate input
        if let validationError = validateInput(email: email, password: password) {
            logger.logAuthError(error: validationError, operation: "signIn", email: email)
            return .failure(validationError)
        }
        
        // Check network connectivity
        guard firebaseManager.isNetworkAvailable else {
            let error = AuthError.networkError
            logger.logAuthError(error: error, operation: "signIn", email: email)
            return .failure(error)
        }
        
        await MainActor.run {
            isLoading = true
            lastError = nil
        }
        
        do {
            // Try Firebase Auth first, fallback to local database
            let user = try await performFirebaseSignIn(email: email, password: password)
                ?? performLocalSignIn(email: email, password: password)
            
            guard let user = user else {
                throw AuthError.userNotFound
            }
            
            await MainActor.run {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
            }
            
            logger.info("Sign in successful", category: .authentication, metadata: [
                "user_id": user.id,
                "role": user.role
            ])
            
            return .success(user)
            
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
            
            let authError = mapFirebaseErrorToAuthError(error)
            logger.logAuthError(error: authError, operation: "signIn", email: email)
            
            await MainActor.run {
                self.lastError = authError
            }
            
            return .failure(authError)
        }
    }
    
    // MARK: - Sign Out
    func signOut() async -> Result<Void, AuthError> {
        logger.info("Starting sign out process", category: .authentication)
        
        do {
            // Simulate Firebase sign out
            try await performFirebaseSignOut()
            
            await MainActor.run {
                self.currentUser = nil
                self.isAuthenticated = false
                self.lastError = nil
            }
            
            logger.info("Sign out successful", category: .authentication)
            return .success(())
            
        } catch {
            let authError = mapFirebaseErrorToAuthError(error)
            logger.logAuthError(error: authError, operation: "signOut")
            
            await MainActor.run {
                self.lastError = authError
            }
            
            return .failure(authError)
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) async -> Result<Void, AuthError> {
        logger.info("Starting password reset process", category: .authentication, metadata: [
            "email_domain": extractEmailDomain(email)
        ])
        
        // Validate email
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            return .failure(.emptyEmail)
        }
        
        if !isValidEmail(email) {
            return .failure(.invalidEmailFormat)
        }
        
        // Check network connectivity
        guard firebaseManager.isNetworkAvailable else {
            let error = AuthError.networkError
            logger.logAuthError(error: error, operation: "resetPassword", email: email)
            return .failure(error)
        }
        
        do {
            // Simulate Firebase password reset
            try await performFirebasePasswordReset(email: email)
            
            logger.info("Password reset email sent successfully", category: .authentication)
            return .success(())
            
        } catch {
            let authError = mapFirebaseErrorToAuthError(error)
            logger.logAuthError(error: authError, operation: "resetPassword", email: email)
            return .failure(authError)
        }
    }
    
    // MARK: - Firebase Simulation Methods
    private func performFirebaseSignUp(email: String, password: String, fullName: String, role: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        // Simulate Firebase Auth creation
        let user = User(
            id: Int.random(in: 1000...9999),
            name: fullName,
            email: email,
            email_verified_at: nil,
            created_at: ISO8601DateFormatter().string(from: Date()),
            updated_at: ISO8601DateFormatter().string(from: Date()),
            role: role
        )
        
        // Also save to local database as backup
        try DatabaseManager.shared.createUser(name: fullName, email: email, password: password, role: role)
        
        return user
    }
    
    private func performFirebaseSignIn(email: String, password: String) async throws -> User? {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // In a real Firebase implementation, this would authenticate with Firebase Auth
        // For now, we'll fall back to local database
        return nil
    }
    
    private func performLocalSignIn(email: String, password: String) throws -> User? {
        return try DatabaseManager.shared.getUser(email: email, password: password)
    }
    
    private func performFirebaseSignOut() async throws {
        // Simulate Firebase sign out
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
    }
    
    private func performFirebasePasswordReset(email: String) async throws {
        // Simulate Firebase password reset
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
    }
    
    // MARK: - Error Mapping
    private func mapFirebaseErrorToAuthError(_ error: Error) -> AuthError {
        // In a real implementation, this would check Firebase error codes
        if let authError = error as? AuthError {
            return authError
        }
        
        let nsError = error as NSError
        
        // Map common Firebase error codes
        switch nsError.code {
        case 17007: // Email already in use
            return .emailAlreadyInUse
        case 17008: // Invalid email
            return .invalidEmail
        case 17026: // Weak password
            return .weakPassword
        case 17011: // User not found
            return .userNotFound
        case 17009: // Wrong password
            return .wrongPassword
        case 17005: // User disabled
            return .userDisabled
        case 17010: // Too many requests
            return .tooManyRequests
        default:
            return .unknownError(error.localizedDescription)
        }
    }
    
    // MARK: - Utility Methods
    private func extractEmailDomain(_ email: String) -> String {
        return email.components(separatedBy: "@").last ?? "unknown"
    }
}