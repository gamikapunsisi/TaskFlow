import SwiftUI
import Foundation

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var selectedRole = "client"
    @State private var showAlert = false
    @State private var alertMessage = ""
    @EnvironmentObject private var router: Router
    
    private let dbManager = DatabaseManager.shared
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
            
            // Registration Form
            VStack(spacing: 15) {
                TextField("Full Name", text: $fullName)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.name)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.newPassword)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.newPassword)
                
                Picker("Role", selection: $selectedRole) {
                    ForEach(roles, id: \.self) { role in
                        Text(role.capitalized)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal)
            
            // Sign Up Button
            Button(action: registerUser) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
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
        .alert("Message", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    func registerUser() {
        // Validate input
        guard !fullName.isEmpty else {
            alertMessage = "Please enter your full name"
            showAlert = true
            return
        }
        
        guard !email.isEmpty else {
            alertMessage = "Please enter your email"
            showAlert = true
            return
        }
        
        guard !password.isEmpty else {
            alertMessage = "Please enter a password"
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }
        
        do {
            let userId = try DatabaseManager.shared.createUser(
                name: fullName,
                email: email,
                password: password,
                role: selectedRole
            )
            
            // Create a user object for authentication
            let user = User(
                id: userId,
                name: fullName,
                email: email,
                email_verified_at: nil,
                created_at: ISO8601DateFormatter().string(from: Date()),
                updated_at: ISO8601DateFormatter().string(from: Date()),
                role: selectedRole
            )
            
            alertMessage = "Registration successful!"
            showAlert = true
            
            // Handle authentication after successful registration
            router.handleAuthentication(user: user)
        } catch {
            alertMessage = "Registration failed: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(Router())
}
