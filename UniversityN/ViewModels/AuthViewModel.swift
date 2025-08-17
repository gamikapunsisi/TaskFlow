//
//  AuthViewModel.swift
//  UniversityN
//
//  Authentication view model with comprehensive error handling and user feedback
//

import Foundation
import SwiftUI
import Combine

// MARK: - Auth UI State
enum AuthUIState {
    case idle
    case validating
    case processing
    case success
    case error(String)
}

// MARK: - Form Field State
struct FormFieldState {
    var value: String = ""
    var errorMessage: String?
    var isValid: Bool = true
    
    var hasError: Bool {
        return errorMessage != nil
    }
}

// MARK: - Auth View Model
@MainActor
class AuthViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var uiState: AuthUIState = .idle
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertTitle = "Message"
    @Published var alertMessage = ""
    
    // Form fields
    @Published var fullNameField = FormFieldState()
    @Published var emailField = FormFieldState()
    @Published var passwordField = FormFieldState()
    @Published var confirmPasswordField = FormFieldState()
    @Published var selectedRole = "client"
    
    // Validation state
    @Published var isFormValid = false
    @Published var validationErrors: [String] = []
    
    // Error display
    @Published var currentError: AuthError?
    @Published var errorDisplayMode: ErrorDisplayMode = .alert
    
    // Debug information
    @Published var showDebugInfo = false
    @Published var debugInformation: [String: Any] = [:]
    
    // MARK: - Private Properties
    private let authManager = AuthManager.shared
    private let logger = DebugLogger.shared
    private let firebaseManager = FirebaseManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var validationTimer: Timer?
    
    // Configuration
    private let validationDelay: TimeInterval = 0.5
    private let roles = ["client", "tasker"]
    
    init() {
        setupBindings()
        setupValidation()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // Observe auth manager state
        authManager.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        authManager.$lastError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.handleAuthError(error)
                }
            }
            .store(in: &cancellables)
        
        authManager.$authState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleAuthStateChange(state)
            }
            .store(in: &cancellables)
        
        // Observe Firebase configuration
        firebaseManager.$isConfigured
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConfigured in
                self?.updateDebugInformation()
            }
            .store(in: &cancellables)
        
        firebaseManager.$configurationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateDebugInformation()
            }
            .store(in: &cancellables)
    }
    
    private func setupValidation() {
        // Real-time validation for form fields
        Publishers.CombineLatest4(
            $fullNameField.map(\.value),
            $emailField.map(\.value),
            $passwordField.map(\.value),
            $confirmPasswordField.map(\.value)
        )
        .debounce(for: .seconds(validationDelay), scheduler: DispatchQueue.main)
        .sink { [weak self] fullName, email, password, confirmPassword in
            self?.validateForm(fullName: fullName, email: email, password: password, confirmPassword: confirmPassword)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Sign Up
    func signUp() async {
        logger.info("Sign up initiated from UI", category: .authentication)
        
        guard validateBeforeSubmission() else {
            logger.warning("Sign up validation failed", category: .validation)
            return
        }
        
        clearErrors()
        uiState = .processing
        
        let success = await authManager.signUp(
            email: emailField.value,
            password: passwordField.value,
            confirmPassword: confirmPasswordField.value,
            fullName: fullNameField.value,
            role: selectedRole
        )
        
        if success {
            uiState = .success
            showSuccessMessage("Account created successfully!")
            logger.info("Sign up completed successfully from UI", category: .authentication)
        } else {
            uiState = .error("Sign up failed")
            logger.error("Sign up failed from UI", category: .authentication)
        }
        
        updateDebugInformation()
    }
    
    // MARK: - Sign In
    func signIn() async {
        logger.info("Sign in initiated from UI", category: .authentication)
        
        guard validateSignInInput() else {
            logger.warning("Sign in validation failed", category: .validation)
            return
        }
        
        clearErrors()
        uiState = .processing
        
        let success = await authManager.signIn(
            email: emailField.value,
            password: passwordField.value
        )
        
        if success {
            uiState = .success
            logger.info("Sign in completed successfully from UI", category: .authentication)
        } else {
            uiState = .error("Sign in failed")
            logger.error("Sign in failed from UI", category: .authentication)
        }
        
        updateDebugInformation()
    }
    
    // MARK: - Password Reset
    func resetPassword() async {
        logger.info("Password reset initiated from UI", category: .authentication)
        
        guard !emailField.value.isEmpty else {
            showErrorMessage("Please enter your email address")
            return
        }
        
        clearErrors()
        uiState = .processing
        
        let success = await authManager.resetPassword(email: emailField.value)
        
        if success {
            uiState = .success
            showSuccessMessage("Password reset email sent successfully!")
        } else {
            uiState = .error("Password reset failed")
        }
        
        updateDebugInformation()
    }
    
    // MARK: - Validation
    private func validateForm(fullName: String, email: String, password: String, confirmPassword: String) {
        validationErrors.removeAll()
        
        // Validate each field
        validateFullName(fullName)
        validateEmail(email)
        validatePassword(password)
        validatePasswordConfirmation(password, confirmPassword)
        
        // Update form validation state
        isFormValid = validationErrors.isEmpty && 
                     !fullName.isEmpty && 
                     !email.isEmpty && 
                     !password.isEmpty && 
                     !confirmPassword.isEmpty
        
        logger.debug("Form validation completed", category: .validation, metadata: [
            "is_valid": isFormValid,
            "error_count": validationErrors.count
        ])
    }
    
    private func validateFullName(_ fullName: String) {
        if fullName.trimmingCharacters(in: .whitespaces).isEmpty {
            fullNameField.errorMessage = "Full name is required"
            fullNameField.isValid = false
        } else if fullName.count < 2 {
            fullNameField.errorMessage = "Full name must be at least 2 characters"
            fullNameField.isValid = false
            validationErrors.append("Full name too short")
        } else {
            fullNameField.errorMessage = nil
            fullNameField.isValid = true
        }
    }
    
    private func validateEmail(_ email: String) {
        if email.isEmpty {
            emailField.errorMessage = "Email is required"
            emailField.isValid = false
        } else if !isValidEmail(email) {
            emailField.errorMessage = "Please enter a valid email address"
            emailField.isValid = false
            validationErrors.append("Invalid email format")
        } else {
            emailField.errorMessage = nil
            emailField.isValid = true
        }
    }
    
    private func validatePassword(_ password: String) {
        if password.isEmpty {
            passwordField.errorMessage = "Password is required"
            passwordField.isValid = false
        } else if password.count < 8 {
            passwordField.errorMessage = "Password must be at least 8 characters"
            passwordField.isValid = false
            validationErrors.append("Password too short")
        } else if !isStrongPassword(password) {
            passwordField.errorMessage = "Password should include letters, numbers, and symbols"
            passwordField.isValid = false
            validationErrors.append("Weak password")
        } else {
            passwordField.errorMessage = nil
            passwordField.isValid = true
        }
    }
    
    private func validatePasswordConfirmation(_ password: String, _ confirmPassword: String) {
        if confirmPassword.isEmpty {
            confirmPasswordField.errorMessage = "Please confirm your password"
            confirmPasswordField.isValid = false
        } else if password != confirmPassword {
            confirmPasswordField.errorMessage = "Passwords do not match"
            confirmPasswordField.isValid = false
            validationErrors.append("Password mismatch")
        } else {
            confirmPasswordField.errorMessage = nil
            confirmPasswordField.isValid = true
        }
    }
    
    private func validateBeforeSubmission() -> Bool {
        let error = authManager.validateSignUpInput(
            email: emailField.value,
            password: passwordField.value,
            confirmPassword: confirmPasswordField.value,
            fullName: fullNameField.value
        )
        
        if let error = error {
            handleAuthError(error)
            return false
        }
        
        return isFormValid
    }
    
    private func validateSignInInput() -> Bool {
        let error = authManager.validateSignInInput(
            email: emailField.value,
            password: passwordField.value
        )
        
        if let error = error {
            handleAuthError(error)
            return false
        }
        
        return !emailField.value.isEmpty && !passwordField.value.isEmpty
    }
    
    // MARK: - Utility Methods
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isStrongPassword(_ password: String) -> Bool {
        let hasUpperCase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowerCase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasNumbers = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSymbols = password.rangeOfCharacter(from: .symbols) != nil ||
                        password.rangeOfCharacter(from: .punctuationCharacters) != nil
        
        return hasUpperCase && hasLowerCase && hasNumbers && hasSymbols
    }
    
    // MARK: - Error Handling
    private func handleAuthError(_ error: AuthError) {
        currentError = error
        
        switch errorDisplayMode {
        case .alert:
            showErrorAlert(error)
        case .inline:
            showInlineError(error)
        case .toast:
            showToastError(error)
        }
        
        logger.error("Auth error handled in UI", category: .userInterface, metadata: [
            "error_code": error.errorCode,
            "display_mode": String(describing: errorDisplayMode)
        ])
    }
    
    private func showErrorAlert(_ error: AuthError) {
        alertTitle = "Authentication Error"
        alertMessage = error.localizedDescription
        
        if let recovery = error.recoverySuggestion {
            alertMessage += "\n\n" + recovery
        }
        
        showAlert = true
    }
    
    private func showInlineError(_ error: AuthError) {
        // Map error to appropriate field
        switch error {
        case .emptyEmail, .invalidEmail, .invalidEmailFormat, .emailAlreadyInUse:
            emailField.errorMessage = error.localizedDescription
            emailField.isValid = false
        case .emptyPassword, .weakPassword, .passwordTooShort:
            passwordField.errorMessage = error.localizedDescription
            passwordField.isValid = false
        case .passwordMismatch:
            confirmPasswordField.errorMessage = error.localizedDescription
            confirmPasswordField.isValid = false
        case .emptyFullName:
            fullNameField.errorMessage = error.localizedDescription
            fullNameField.isValid = false
        default:
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    private func showToastError(_ error: AuthError) {
        // This would show a toast notification
        alertMessage = error.localizedDescription
        showAlert = true
    }
    
    private func handleAuthStateChange(_ state: AuthState) {
        switch state {
        case .unauthenticated:
            uiState = .idle
        case .authenticating:
            uiState = .processing
        case .authenticated(_):
            uiState = .success
        case .error(let error):
            uiState = .error(error.localizedDescription)
            handleAuthError(error)
        }
        
        updateDebugInformation()
    }
    
    // MARK: - UI Helpers
    private func showSuccessMessage(_ message: String) {
        alertTitle = "Success"
        alertMessage = message
        showAlert = true
    }
    
    private func showErrorMessage(_ message: String) {
        alertTitle = "Error"
        alertMessage = message
        showAlert = true
    }
    
    func clearErrors() {
        currentError = nil
        fullNameField.errorMessage = nil
        fullNameField.isValid = true
        emailField.errorMessage = nil
        emailField.isValid = true
        passwordField.errorMessage = nil
        passwordField.isValid = true
        confirmPasswordField.errorMessage = nil
        confirmPasswordField.isValid = true
        validationErrors.removeAll()
        
        authManager.clearErrors()
        
        if case .error = uiState {
            uiState = .idle
        }
    }
    
    func clearForm() {
        fullNameField.value = ""
        emailField.value = ""
        passwordField.value = ""
        confirmPasswordField.value = ""
        clearErrors()
    }
    
    // MARK: - Debug Information
    private func updateDebugInformation() {
        debugInformation = [
            "ui_state": String(describing: uiState),
            "is_loading": isLoading,
            "is_form_valid": isFormValid,
            "validation_errors": validationErrors,
            "firebase_configured": firebaseManager.isConfigured,
            "firebase_status": firebaseManager.configurationStatus,
            "network_available": firebaseManager.isNetworkAvailable,
            "auth_session": authManager.getSessionInfo()
        ]
    }
    
    func getConfigurationReport() -> ConfigurationReport {
        return firebaseManager.getConfigurationReport()
    }
    
    func toggleDebugInfo() {
        showDebugInfo.toggle()
        if showDebugInfo {
            updateDebugInformation()
        }
    }
}

// MARK: - Error Display Mode
enum ErrorDisplayMode {
    case alert
    case inline
    case toast
}