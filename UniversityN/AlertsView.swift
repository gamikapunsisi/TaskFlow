//
//  AlertsView.swift
//  UniversityN
//
//  Created by Gamika Punsisi on 2025-04-22.
//

import SwiftUI

struct AlertsView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Spacer()

                Text("Alerts")
                    .font(.system(size: 20, weight: .bold))

                Spacer()

                Image("profile") // Replace with actual image asset name
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .background(Color.blue.ignoresSafeArea(edges: .top))

            // Most Recents
            VStack(alignment: .leading, spacing: 16) {
                Text("Most Recents")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.horizontal)

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray5))
                    .padding(.horizontal)
                    .frame(height: 100)
                    .overlay(
                        HStack(spacing: 8) {
                            Text("No new notifications")
                                .foregroundColor(.black)

                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundColor(.black)
                        }
                    )
            }
            .padding(.top)

            // Earlier
            VStack(alignment: .leading, spacing: 10) {
                Text("Earlier")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.horizontal)

                ForEach(0..<2) { _ in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("You have received an invitation to interview for the job “UI Design”")
                            .font(.system(size: 14))
                            .foregroundColor(.black)

                        Text("Dec 25, 2024")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.blue)

                        Divider()
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)

            Spacer()

            // Bottom Navigation
            HStack {
                Spacer()
                Image(systemName: "square.grid.2x2")
                Spacer()
                Image(systemName: "doc.text")
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 60, height: 60)
                        .shadow(radius: 5)
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "bell")
                Spacer()
                Image(systemName: "message")
                Spacer()
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: -2)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
