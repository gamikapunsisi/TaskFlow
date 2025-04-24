import SwiftUI
import Alamofire

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                Image("taskflowlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 150)
                    .padding(.top, 50)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color.secondary.opacity(0.3))
                    .cornerRadius(5)
                    .padding(.horizontal, 20)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.secondary.opacity(0.3))
                    .cornerRadius(5)
                    .padding(.horizontal, 20)

                HStack {
                    Toggle(isOn: $rememberMe) {
                        Text("Remember Me")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .purple))

                    Spacer()

                    Button("Forgot Password?") {
                        // Forgot password action
                    }
                    .foregroundColor(.purple)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                Button(action: {
                    loginUser()
                }) {
                    Text("SIGN IN")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(5)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Text("OR").padding(.top, 20)

                Button(action: {
                    // Google login logic
                }) {
                    HStack {
                        Image("google")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Login with Google")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(5)
                }
                .padding(.horizontal, 20)

                Button(action: {
                    // Facebook login logic
                }) {
                    HStack {
                        Image("facebook")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("Login with Facebook")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(5)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                NavigationLink("Don't have an account? Sign Up", destination: SignupView())
                    .padding(.top, 20)

                Image("footer")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400)
                    .padding(.bottom, -55)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

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
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("✅ Raw response:\n\(jsonString)")
                    }

                    do {
                        let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
                        alertMessage = decoded.message
                        showAlert = true
                        print("Token: \(decoded.access_token)")
                        print("Logged in user: \(decoded.user.name)")
                        // Store token or handle navigation here
                        // Example: UserDefaults.standard.set(decoded.access_token, forKey: "userToken")

                    } catch {
                        print("❌ Decoding Error: \(error)")
                        alertMessage = "Failed to decode response: \(error.localizedDescription)"
                        showAlert = true
                    }

                case .failure(let error):
                    alertMessage = "Network error: \(error.localizedDescription)"
                    showAlert = true
                }
            }
    }
}

// Updated model to match your API response
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
