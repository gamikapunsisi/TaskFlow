//
//  AppNavigation.swift
//  UniversityN
//
//  Created by Gamika Punsisi on 2025-02-28.
//
//import SwiftUI
//
//struct AppNavigation: View {
//    var body: some View {
//        if #available(iOS 16.0, *) {
//            NavigationStack {
//                LoginView()
//                    .navigationDestination(for: String.self) { route in
//                        switch route {
//                        case "verification":
//                            VerificationView()
//                        case "signup":
//                            LoginView()
//                        default:
//                            Text("Page Not Found")
//                        }
//                    }
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}
