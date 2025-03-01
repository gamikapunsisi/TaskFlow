//
//  Router.swift
//  UniversityN
//
//  Created by Gamika Punsisi on 2025-02-28.
//
//
//import SwiftUI
//
//// Define an enum for screen names to prevent magic strings
//enum ScreenName: String {
//    case verificationView = "VerificationView"
//    case profileView = "ProfileView"
//    // Add more screen names as you add more views
//    
//    // Fallback case to handle unknown screens
//    case unknown
//}
//
//struct Router: View {
//    var screenName: ScreenName
//    
//    var body: some View {
//        switch screenName {
//        case .verificationView:
//            VerificationView() // Your existing VerificationView
//        case .profileView:
//            ProfileView() // Your existing ProfileView
//        // Add other cases as you add more views
//        case .unknown:
//            Text("Unknown Screen")
//        }
//    }
//}
//
//struct Router_Previews: PreviewProvider {
//    static var previews: some View {
//        // Example Preview
//        Router(screenName: .verificationView)
//    }
//}
//
