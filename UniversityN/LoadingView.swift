import SwiftUI

struct LoadingView: View {
    @State private var isActive = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("logo2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)

                Spacer()

                Image("footer")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 700)
                    .padding(.bottom, -10)

                NavigationLink(
                    destination: LoginView(),
                    isActive: $isActive,
                    label: { EmptyView() } // Invisible link
                )
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isActive = true
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Avoids sidebar on iPads
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
