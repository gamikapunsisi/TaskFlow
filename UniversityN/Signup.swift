import SwiftUI
import Alamofire

struct SignUpView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var selectedRole: String = "client" // default role
    @State private var alertMessage = ""
    @State private var showAlert = false

    let roles = ["client", "tasker"]

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Back navigation action
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
                // Google sign-in action
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
                // Facebook sign-in action
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
                // Navigate to sign-in
            }
            .padding(.bottom)

        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func registerUser() {
        let url = "http://127.0.0.1:8000/api/register" // Replace with your server's API URL

        let parameters: Parameters = [
            "full_name": fullName,
            "email": email,
            "password": password,
            "password_confirmation": confirmPassword,
            "role": selectedRole
        ]
        print("Sending Parameters: \(parameters)")

        // Use responseDecodable instead of deprecated responseJSON
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
               .validate(statusCode: 200..<300)
               .responseDecodable(of: SignupResponse.self) { response in
                   switch response.result {
                   case .success(let signupResponse):
                       alertMessage = signupResponse.message
                   case .failure(let error):
                       if let data = response.data,
                          let serverMessage = String(data: data, encoding: .utf8) {
                           alertMessage = "Failed: \(serverMessage)"
                       } else {
                           alertMessage = "Failed: \(error.localizedDescription)"
                       }
                   }
                   showAlert = true
               }
    }
}

// Model to decode the response from the server
struct SignupResponse: Decodable {
    let success: Bool
    let message: String
    // Add other fields as necessary
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
