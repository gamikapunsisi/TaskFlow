import SwiftUI
import Alamofire

struct SignUpView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var selectedRole: String = "client"
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var shouldNavigate = false

    let roles = ["client", "tasker"]

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {
                        // Optional: Handle back navigation
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                    }
                    Spacer()
                    Text("Sign up")
                        .font(.headline)
                    Spacer()
                }
                .padding()

                TextField("Full name", text: $fullName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("abc@email.com", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Confirm password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Picker("Role", selection: $selectedRole) {
                    ForEach(roles, id: \.self) { role in
                        Text(role.capitalized)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Button(action: registerUser) {
                    HStack {
                        Text("SIGN UP")
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                Text("OR")
                    .padding()

                Button(action: {
                    // Google sign-in
                }) {
                    HStack {
                        Image("google")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text("Login with Google")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)

                Button(action: {
                    // Facebook sign-in
                }) {
                    HStack {
                        Image("facebook")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text("Login with Facebook")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)

                Button("Already have an account? Sign in") {
                    shouldNavigate = true
                }
                .padding(.bottom)

                // ✅ New iOS 16+ compliant way to navigate
                NavigationLink("", value: "login")
            }
            .navigationDestination(for: String.self) { route in
                if route == "login" {
                    LoginView()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onChange(of: shouldNavigate) { value in
                if value {
                    shouldNavigate = false // reset
                    DispatchQueue.main.async {
                        shouldNavigate = true // trigger again
                    }
                }
            }
        }
    }

    func registerUser() {
        let url = "http://127.0.0.1:8000/api/register"

        let parameters: Parameters = [
            "full_name": fullName,
            "email": email,
            "password": password,
            "password_confirmation": confirmPassword,
            "role": selectedRole
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SignupResponse.self) { response in
                switch response.result {
                case .success(let signupResponse):
                    alertMessage = signupResponse.message
                    showAlert = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        shouldNavigate = true
                    }
                case .failure(let error):
                    if let data = response.data,
                       let serverMessage = String(data: data, encoding: .utf8) {
                        alertMessage = "Failed: \(serverMessage)"
                    } else {
                        alertMessage = "Failed: \(error.localizedDescription)"
                    }
                    showAlert = true
                }
            }
    }
}

struct SignupResponse: Decodable {
    let success: Bool
    let message: String
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpView()
        }
    }
}
