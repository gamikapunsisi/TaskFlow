import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("logo2")  // Replace "logo" with your actual logo asset name
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)  // Adjust the size as needed

            Spacer()
            
            Image("footer") // Ensure this image is in your assets
                .resizable()
                .scaledToFit()
                .frame(width: 700)
                .padding(.bottom,-10)
        }
        .background(Color.white)  // Assuming the background is white
        .edgesIgnoringSafeArea(.all)  // This will make the view extend to all edges
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

