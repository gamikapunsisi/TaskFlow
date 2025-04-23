import SwiftUI
import UIKit

// MARK: - Loading View

struct LoadingView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    VStack(spacing: 20) {
                        // App Icon
                        Image(systemName: "doc.text.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                            startPoint: .top,
                                                            endPoint: .bottom))

                        Text("Get Started Today!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        Text("Are you here to find skilled professionals or offer your services?\nChoose your role to begin.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 30)

                        HStack(spacing: 20) {
                            // Client Navigation Button
                            NavigationLink(destination: LoginView()) {
                                Text("AS A CLIENT")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.purple)
                                    .cornerRadius(10)
                            }

                            // Service Provider Navigation Button
                            NavigationLink(destination: LoginView()) {
                                Text("AS A SERVICE PROVIDER")
                                    .foregroundColor(.purple)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.purple, lineWidth: 2)
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                }
            }
        }
    }
}

// MARK: - Preview

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

// MARK: - Custom Corner Radius Extension

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        self.clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
