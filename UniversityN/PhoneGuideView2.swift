import SwiftUI

struct PhoneGuideView2: View {
    var body: some View {
        ZStack {
            Color(.systemBackground) // Background color for the view
                .edgesIgnoringSafeArea(.all)
            
            // Phone frame and content
            Image("mobile") // Replace with your mobile frame image in your assets
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height * 0.9)
                .overlay(
                    AppContent()
                        .padding(.bottom, 50), // Adjust padding to position the content correctly within the frame
                    alignment: .bottom
                )
        }
    }
}

struct AppContent: View {
    var body: some View {
         VStack {
             Spacer()
             
             VStack(alignment: .center, spacing: 10) {
                 // Title
                 Text("Explore Upcoming and Nearby Events")
                     .font(.title)
                     .fontWeight(.bold)
                     .foregroundColor(.white)
                     .padding(.top, 20)
                 
                 // Description
                 Text("In publishing and graphic design, Lorem is a placeholder text commonly used to demonstrate the visual form of a document without relying on meaningful content.")
                     .font(.subheadline)
                     .foregroundColor(.white)
                     .multilineTextAlignment(.center)
                     .padding(.horizontal)
                 
                 // Pagination and Navigation
                 HStack {
                     Button("Skip") {
                         // action for skip
                     }
                     .foregroundColor(.white)
                     
                     Spacer()
                     
                     // Page indicators
                     HStack {
                         Circle()
                             .frame(width: 10, height: 10)
                             .foregroundColor(.gray)
                         Circle()
                             .frame(width: 10, height: 10)
                             .foregroundColor(.gray) // Active page indicator
                         Circle()
                             .frame(width: 10, height: 10)
                             .foregroundColor(.gray)
                     }
                     
                     Spacer()
                     
                     Button("Next") {
                         // action for next
                     }
                     .foregroundColor(.white)
                 }
                 .padding(.horizontal, 30)
                 .padding(.vertical, 20)
             }
             .background(Color.blue)
             .cornerRadius(30)
             .padding(.bottom,-35)
             .shadow(radius: 10)
         }
         .background(Color(.systemGray6))
         .edgesIgnoringSafeArea(.all)
     }
 }

struct MobileAppPreview_Pre: PreviewProvider {
    static var previews: some View {
        PhoneGuideView2()
    }
}
