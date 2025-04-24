import SwiftUI
import Alamofire

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isClientLoggedIn: Bool = false
    @State private var isTaskerLoggedIn: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Image("taskflowlogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 150)
                        .padding(.top, 50)

                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)

                    HStack {
                        Toggle("Remember Me", isOn: $rememberMe)
                            .toggleStyle(SwitchToggleStyle(tint: .purple))

                        Spacer()

                        Button("Forgot Password?") {
                            // Implement logic
                        }
                        .foregroundColor(.purple)
                        .font(.footnote)
                    }
                    .padding(.horizontal)

                    Button(action: {
                        loginUser()
                    }) {
                        Text("SIGN IN")
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    Text("OR")
                        .padding(.top)

                    VStack(spacing: 10) {
                        socialLoginButton(image: "google", text: "Login with Google")
                        socialLoginButton(image: "facebook", text: "Login with Facebook")
                    }
                    .padding(.horizontal)

                    NavigationLink("Don't have an account? Sign Up", destination: SignupView())
                        .font(.footnote)
                        .padding(.top, 10)

                    Spacer()

                    Image("footer")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationDestination(isPresented: $isClientLoggedIn) {
                ClientProfileView() // ✅ Correctly routes to your existing profile view
            }
            .navigationDestination(isPresented: $isTaskerLoggedIn) {
                ProfileView()
            }
        }
    }

    // MARK: - API Request
    func loginUser() {
        let url = "http://localhost:8000/api/login"
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
                        UserDefaults.standard.set(decoded.access_token, forKey: "userToken")

                        if let role = UserRole(rawValue: decoded.user.role) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                switch role {
                                case .client:
                                    isClientLoggedIn = true
                                case .tasker:
                                    isTaskerLoggedIn = true
                                }
                            }
                        } else {
                            alertMessage = "Unknown role: \(decoded.user.role)"
                            showAlert = true
                        }
                    } catch {
                        alertMessage = "Decoding failed: \(error.localizedDescription)"
                        showAlert = true
                    }

                case .failure(let error):
                    alertMessage = "Network Error: \(error.localizedDescription)"
                    showAlert = true
                }
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

// MARK: - Enums & Models
enum UserRole: String {
    case client
    case tasker
}

struct LoginResponse: Decodable {
    let message: String
    let access_token: String
    let token_type: String
    let user: User
}

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
    let email_verified_at: String?
    let created_at: String
    let updated_at: String
    let role: String
}

// MARK: - Placeholder Views
struct SignupView: View {
    var body: some View {
        Text("Signup Screen")
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
