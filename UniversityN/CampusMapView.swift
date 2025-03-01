import SwiftUI
import UIKit

// MARK: - Zoomable Scroll View Setup
struct ZoomableScrollView: UIViewRepresentable {
    var image: UIImage

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.delegate = context.coordinator
        scrollView.backgroundColor = .black  // Optional for better edge visibility
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true

        let imageView = UIImageView(image: image)
               imageView.contentMode = .scaleAspectFit
               imageView.isUserInteractionEnabled = true
               scrollView.addSubview(imageView)
               scrollView.contentSize = imageView.frame.size

        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.frame.size

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 100.0  // Increased zoom scale

        // Configure the initial frame and content size
//        configureInitialSettings(scrollView)

        return scrollView
    }
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // Update the view if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ZoomableScrollView

        init(_ parent: ZoomableScrollView) {
            self.parent = parent
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return scrollView.subviews.first
        }
    }
    
}


struct CampusMapView: View {
    @State private var selectedTab = 2
    var body: some View {
        VStack {
            topSearchAndFilterBar
            ZoomableScrollView(image: UIImage(named: "campus map") ?? UIImage())
            bottomTabBar
        }
        .edgesIgnoringSafeArea(.top)
        
    }
    
    var topSearchAndFilterBar: some View {
        VStack {
            HStack {
                Button(action: {
                    // Action for menu
                }) {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
                
                Spacer()
                
                Text("Second Floor, Mac LAB")
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    // Action for location refresh
                }) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
            }
            .padding(.horizontal)
            .padding(.top, 50)  // Add padding to account for the top safe area on devices
            
            SearchBar()
                .padding(.horizontal)
                .padding(.top, 10)
        }
    }
    var bottomTabBar: some View {
        ZStack {
            // Main horizontal stack for the tab bar
            HStack(spacing: 0) {
                // Explore tab
                Button(action: {
                    selectedTab = 0
                }) {
                    NavigationLink(destination: MainEventAppView()) {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            .font(.title2)
                            .foregroundColor(selectedTab == 0 ? .blue : .gray)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                // Events tab
                Button(action: {
                    selectedTab = 1
                }) {
                    Image(systemName: selectedTab == 1 ? "calendar.circle.fill" : "calendar.circle")
                        .font(.title2)
                        .foregroundColor(selectedTab == 1 ? .blue : .gray)
                }
                .frame(maxWidth: .infinity)
                
                // Placeholder for the center button to balance the space
                Color.clear
                    .frame(width: 50, height: 50)
                
                Spacer()
                
                // Map tab
                Button(action: {
                    selectedTab = 2
                }) {
                    NavigationLink(destination: LabListView()) {
                        Image(systemName: selectedTab == 2 ? "map.fill" : "map")
                            .font(.title2)
                            .foregroundColor(selectedTab == 2 ? .blue : .gray)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                // Profile tab
                Button(action: {
                    selectedTab = 3
                }) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                            .font(.title2)
                            .foregroundColor(selectedTab == 3 ? .blue : .gray)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(width : 400,height: 50)
            .background(Color.white.opacity(1))
//            .clipShape(Capsule())
            .padding(.horizontal)
            .shadow(radius: 1)
            
            // Center floating action button
            Button(action: {
                // Action for the center button
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .padding(15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .frame(width: 50, height: 50)
            }
            .navigationBarHidden(true)
            .offset(y: -30) // Adjust the offset to raise the button
        }
    }
}


struct CampusMapView_Previews: PreviewProvider {
    static var previews: some View {
        CampusMapView()
    }
}
