import SwiftUI
import Foundation

struct SignUpView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @EnvironmentObject private var router: Router
    
    private let roles = ["client", "tasker"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Logo and Title
            VStack(spacing: 10) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("Create Account")
                    .font(.title)
                    .bold()
                
                Text("Sign up to get started")
                    .foregroundColor(.gray)
            }
            .padding(.top, 50)
            
            // Registration Form with Enhanced Error Handling
            VStack(spacing: 15) {
                // Full Name Field with Error Handling
                VStack(alignment: .leading, spacing: 4) {
                    TextField("Full Name", text: $authViewModel.fullNameField.value)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.name)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.words)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(authViewModel.fullNameField.hasError ? Color.red : Color.clear, lineWidth: 1)
                        )
                    
                    if let error = authViewModel.fullNameField.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // Email Field with Error Handling
                VStack(alignment: .leading, spacing: 4) {
                    TextField("Email", text: $authViewModel.emailField.value)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(authViewModel.emailField.hasError ? Color.red : Color.clear, lineWidth: 1)
                        )
                    
                    if let error = authViewModel.emailField.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // Password Field with Error Handling
                VStack(alignment: .leading, spacing: 4) {
                    SecureField("Password", text: $authViewModel.passwordField.value)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.newPassword)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(authViewModel.passwordField.hasError ? Color.red : Color.clear, lineWidth: 1)
                        )
                    
                    if let error = authViewModel.passwordField.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // Confirm Password Field with Error Handling
                VStack(alignment: .leading, spacing: 4) {
                    SecureField("Confirm Password", text: $authViewModel.confirmPasswordField.value)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.newPassword)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(authViewModel.confirmPasswordField.hasError ? Color.red : Color.clear, lineWidth: 1)
                        )
                    
                    if let error = authViewModel.confirmPasswordField.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                // Role Selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("I want to:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Picker("Role", selection: $authViewModel.selectedRole) {
                        Text("Hire services (Client)").tag("client")
                        Text("Offer services (Tasker)").tag("tasker")
                    }
                    .pickerStyle(.segmented)
                }
            }
            .padding(.horizontal)
            
            // Sign Up Button with Loading State
            Button(action: { 
                Task {
                    await authViewModel.signUp()
                }
            }) {
                HStack {
                    if authViewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .foregroundColor(.white)
                    }
                    Text(authViewModel.isLoading ? "Creating Account..." : "Sign Up")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(authViewModel.isFormValid && !authViewModel.isLoading ? Color.purple : Color.gray)
                .cornerRadius(10)
            }
            .disabled(!authViewModel.isFormValid || authViewModel.isLoading)
            .padding(.horizontal)
            
            // Debug Information (Development Only)
            if authViewModel.showDebugInfo {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Debug Information")
                        .font(.headline)
                        .padding(.top)
                    
                    Text("Configuration Status: \(firebaseManager.configurationStatus)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("Network Available: \(firebaseManager.isNetworkAvailable ? "Yes" : "No")")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("Form Valid: \(authViewModel.isFormValid ? "Yes" : "No")")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
            
            // Debug Toggle Button (Development Only)
            #if DEBUG
            Button("Toggle Debug Info") {
                authViewModel.toggleDebugInfo()
            }
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.top, 5)
            #endif
            
            Spacer()
            
            // Login Link
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                Button("Login") {
                    router.navigate(to: .login)
                }
                .foregroundColor(.purple)
            }
            .padding(.bottom)
        }
        .padding()
        .alert(authViewModel.alertTitle, isPresented: $authViewModel.showAlert) {
            Button("OK", role: .cancel) { 
                authViewModel.clearErrors()
            }
        } message: {
            Text(authViewModel.alertMessage)
        }
        .onChange(of: authManager.isAuthenticated) { isAuthenticated in
            if isAuthenticated, let user = authManager.currentUser {
                router.handleAuthentication(user: user)
            }
        }
        .onAppear {
            // Initialize Firebase configuration check
            firebaseManager.validateConfiguration()
        }
    }
    
    // Firebase Manager reference for debug info
    private var firebaseManager: FirebaseManager {
        FirebaseManager.shared
    }
    
    // Auth Manager reference for authentication state
    private var authManager: AuthManager {
        AuthManager.shared
    }
}

#Preview {
    SignUpView()
        .environmentObject(Router())
}
