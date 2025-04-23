import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool

    var body: some View {
        ZStack {
            // Dark overlay
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.9))
            .opacity(isShowing ? 1 : 0)
            .onTapGesture {
                withAnimation {
                    isShowing = false
                }
            }

            // Side Menu Content
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    // Profile
                    VStack(alignment: .leading) {
                        Image("profile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            .padding(.bottom, 10)

                        Text("Ashfak Sayem")
                            .font(.headline)
                            .foregroundColor(.black)

                        Text("View Profile")
                            .font(.caption)
                            .foregroundColor(.black.opacity(0.7))
                            .padding(.bottom, 30)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 50)

                    // Menu items
                    ForEach(MenuOption.allCases, id: \.self) { option in
                        Button(action: {
                            withAnimation {
                                self.isShowing = false
                            }
                        }) {
                            MenuOptionView(option: option)
                        }
                    }

                    Spacer()
                }
                .padding()
                .frame(width: 250)
                .background(Color.white)
                .offset(x: isShowing ? 0 : -250)
                .animation(.default, value: isShowing) // ✅ FIXED: replaced deprecated .animation()

                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}

enum MenuOption: CaseIterable {
    case myProfile, bookmarks, settings, signOut

    var title: String {
        switch self {
        case .myProfile: return "My Profile"
        case .bookmarks: return "Bookmarks"
        case .settings: return "Settings"
        case .signOut: return "Sign Out"
        }
    }

    var imageName: String {
        switch self {
        case .myProfile: return "person"
        case .bookmarks: return "book"
        case .settings: return "gear"
        case .signOut: return "arrowshape.turn.up.left"
        }
    }
}

struct MenuOptionView: View {
    let option: MenuOption

    var body: some View {
        HStack {
            Image(systemName: option.imageName)
                .imageScale(.large)
                .foregroundColor(.black)
                .frame(width: 30, height: 30)

            Text(option.title)
                .foregroundColor(.black)
                .font(.headline)

            Spacer()
        }
        .padding()
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true))
    }
}
