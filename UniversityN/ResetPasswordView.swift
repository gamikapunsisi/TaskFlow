import SwiftUI

struct ResetPasswordView: View {
    @State private var email: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Action to go back
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
                Spacer()
                Text("Reset Password")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding()
            
            Text("Please enter your email address to request a password reset")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()
            
            TextField("abc@email.com", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                .keyboardType(.emailAddress)
            
            Button(action: {
                // Action for sending reset request
            }) {
                HStack {
                    Text("SEND")
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
