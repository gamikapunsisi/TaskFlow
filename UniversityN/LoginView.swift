import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    
    var body: some View {
        VStack {
//            Spacer()
            
            // Logo
            Image("logo") // Ensure this image is in your assets
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 150)
            
            
            // Email and Password fields
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
            
            // Remember Me and Forgot Password
            HStack {
                Toggle(isOn: $rememberMe) {
                    Text("Remember Me")
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                
                Spacer()
                
                Button("Forgot Password?") {
                    // Handle forgot password action
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Sign In Button
            Button(action: {
                // Handle sign in action
            }) {
                Text("SIGN IN")
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Social Login
            Text("OR")
                .padding(.top, 20)
            
            // Google Login
            Button(action: {
                // Handle Google login action
            }) {
                HStack {
                    Image("google") // Your Google logo image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
//                        .padding()
                    Text("Login with Google")
                        .foregroundColor(.black)
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(5)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            // Facebook Login
            Button(action: {
                // Handle Facebook login action
            }) {
                HStack {
                    Image("facebook") // Your Facebook logo image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
//                        .padding()
                    Text("Login with Facebook")
                        .foregroundColor(.black)
                }
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(5)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Sign up link
            Button("Don't have an account? Sign up") {
                // Handle sign up action
            }
            .padding(.top, 20)
            
//            Spacer()
            
            // Footer Image
            Image("footer") // Ensure this image is in your assets
                .resizable()
                .scaledToFit()
                .frame(width: 400)
                .padding(.bottom, -55)
        }
        .edgesIgnoringSafeArea(.all) // Ensures layout extends to the very edges of the display
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
