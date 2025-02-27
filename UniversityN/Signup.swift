import SwiftUI

struct SignUpView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Action for back navigation
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
                .padding([.horizontal, .bottom])

            Button(action: {
                // Action for sign up
            }) {
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

            // Google Sign In
            Button(action: {
                // Action for Google sign in
            }) {
                HStack {
                    Image("google") // Your Google icon
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

            // Facebook Sign In
            Button(action: {
                // Action for Facebook sign in
            }) {
                HStack {
                    Image("facebook") // Your Facebook icon
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

//            Spacer()

            Button("Already have an account? Sign in") {
                // Action for switching to sign in
            }
            .padding(.bottom)

//            Image("footer") // Ensure this image is in your assets
//                .resizable()
//                .scaledToFit()
//                .frame(width: 400)
//                .padding(.bottom, -55)
                
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
