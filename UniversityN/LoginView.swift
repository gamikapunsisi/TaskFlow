import SwiftUI
import LocalAuthentication


struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var navigateToVerification = false  // Navigation state
    
    var body: some View {
        NavigationView {  // Using NavigationView for iOS 15 and below
            VStack {
                // Logo
                Image("taskflowlogo") // Ensure this image is in your assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 150)
                    .padding(.top, 50)
                
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
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    
                    Spacer()
                    
                    Button("Forgot Password?") {
                        // Handle forgot password action
                    }
                    .foregroundColor(.purple)

                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Sign In Button
                NavigationLink(destination: VerificationView()) {
                    Text("SIGN IN")
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
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
                        NavigationLink(destination: VerificationView()) {
                            Image("google") // Your Google logo image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text("Login with Google")
                                .foregroundColor(.black)
                        }
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
                        NavigationLink(destination: VerificationView()) {
                            Image("facebook") // Your Facebook logo image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text("Login with Facebook")
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(5)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Sign up link
                Button(action: {
                    // Handle sign up action
                }) {
                    Text("Don't have an account? ")
                        .foregroundColor(.black) +
                    Text("Sign up")
                        .foregroundColor(.purple)
                }
                .padding(.top, 20)

                // Footer Image
                Image("footer") // Ensure this image is in your assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400)
                    .padding(.bottom, -55)
            }
            .edgesIgnoringSafeArea(.all) // Ensures layout extends to the very edges of the display
            .navigationBarHidden(true)
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
