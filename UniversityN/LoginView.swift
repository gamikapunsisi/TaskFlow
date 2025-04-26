import SwiftUI
import LocalAuthentication
import Foundation

// MARK: - CustomTextField (to disable AutoFill)
struct CustomTextField: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField

        init(_ parent: CustomTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }

    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.text = text
        textField.isSecureTextEntry = isSecure
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = isSecure ? .default : .emailAddress
        textField.textContentType = .none // 💥 Key to stop AutoFill
        textField.inputAssistantItem.leadingBarButtonGroups = [] // 💥 Remove QuickType bar
        textField.inputAssistantItem.trailingBarButtonGroups = []

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

// MARK: - Login View
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @EnvironmentObject private var router: Router
    
    private let dbManager = DatabaseManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            // Logo and Title
            VStack(spacing: 10) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("Welcome Back!")
                    .font(.title)
                    .bold()
                
                Text("Sign in to continue")
                    .foregroundColor(.gray)
            }
            .padding(.top, 50)
            
            // Login Form
            VStack(spacing: 15) {
                CustomTextField(text: $email, placeholder: "Email")
                
                CustomTextField(text: $password, placeholder: "Password", isSecure: true)
                
                Button("Forgot Password?") {
                    // Handle forgot password
                }
                .foregroundColor(.purple)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal)
            
            // Login Button
            Button(action: login) {
                Text("Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            // Social Login
            VStack(spacing: 15) {
                Text("Or continue with")
                    .foregroundColor(.gray)
                
                HStack(spacing: 20) {
                    socialLoginButton(image: "google", text: "Google")
                    socialLoginButton(image: "apple", text: "Apple")
                }
            }
            .padding(.top)
            
            Spacer()
            
            // Sign Up Link
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                Button("Sign Up") {
                    router.navigate(to: .signup)
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
    
    func login() {
        do {
            if let user = try DatabaseManager.shared.getUser(email: email, password: password) {
                router.handleAuthentication(user: user)
            } else {
                alertMessage = "Invalid email or password"
                showAlert = true
            }
        } catch {
            alertMessage = "Login error: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access your account."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // For biometric login, we'll use a default user for now
                        // In a real app, you would retrieve the user from secure storage
                        let defaultUser = User(
                            id: 1,
                            name: "Default User",
                            email: "default@example.com",
                            email_verified_at: nil,
                            created_at: ISO8601DateFormatter().string(from: Date()),
                            updated_at: ISO8601DateFormatter().string(from: Date()),
                            role: "client"
                        )
                        router.handleAuthentication(user: defaultUser)
                    } else {
                        alertMessage = "Authentication failed. Please try again."
                        showAlert = true
                    }
                }
            }
        } else {
            alertMessage = "Biometric authentication is not available on this device."
            showAlert = true
        }
    }
    
    // MARK: - Social Login Button
    func socialLoginButton(image: String, text: String) -> some View {
        HStack {
            Image(image)
                .resizable()
                .frame(width: 24, height: 24)
            Text(text)
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

#Preview {
    LoginView()
        .environmentObject(Router())
}
