//
//  ClientProposalsView.swift
//  UniversityN
//
//  Created by Gamika Punsisi on 2025-04-23.
//

import SwiftUI

struct ClientProposalsView: View {
    let taskId: Int
    var proposals = Proposal.mockData

    var body: some View {
        VStack(spacing: 0) {

            // Header
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer()
                Text("Proposals")
                    .font(.headline)
                Spacer()
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .padding()
            }
            .background(Color.blue)
            .foregroundColor(.white)

            // Job Details
            VStack(alignment: .leading, spacing: 4) {
                Text("Feb 12, 2025")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack {
                    Text("Educational Mobile app UI/UX Design")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "pencil")
                            .foregroundColor(.purple)
                    }
                }
                Text("$55.00")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()

            Divider()

            // Proposal List
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(proposals) { proposal in
                        ProposalRow(proposal: proposal)
                    }
                }
                .padding()
            }

            // Bottom Tab Bar with FAB
            ZStack {
                HStack {
                    Spacer()
                    Image(systemName: "square.grid.2x2")
                    Spacer()
                    Image(systemName: "message")
                    Spacer()
                    Image(systemName: "bell")
                    Spacer()
                    Image(systemName: "ellipsis")
                    Spacer()
                }
                .padding()
                .background(Color.white.shadow(radius: 2))

                Button(action: {}) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                        .background(Circle().fill(Color.purple))
                        .shadow(radius: 4)
                }
                .offset(y: -30)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - ProposalRow View
struct ProposalRow: View {
    var proposal: Proposal

    var body: some View {
        HStack {
            if let imageName = proposal.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 45, height: 45)
                    .overlay(
                        Text(proposal.initial)
                            .font(.headline)
                            .foregroundColor(.black)
                    )
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(proposal.name)
                    .bold()
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(proposal.rating) ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                    Text(String(format: "%.1f", proposal.rating))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text("See Profile")
                    .font(.caption2)
                    .foregroundColor(.purple)
            }
            Spacer()

            Button("Send Contract") {}
                .font(.caption)
                .padding(6)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.purple, lineWidth: 1))
        }
    }
}

// MARK: - Proposal Model
struct Proposal: Identifiable {
    let id = UUID()
    let name: String
    let rating: Double
    let initial: String
    let imageName: String?

    static let mockData: [Proposal] = [
        Proposal(name: "Mike Newland", rating: 5.0, initial: "M", imageName: nil),
        Proposal(name: "Andrew", rating: 5.0, initial: "A", imageName: nil),
        Proposal(name: "Annh", rating: 4.9, initial: "A", imageName: "user1"),
        Proposal(name: "Rassel", rating: 5.0, initial: "R", imageName: nil),
        Proposal(name: "Samith", rating: 4.5, initial: "S", imageName: nil),
        Proposal(name: "Ancy", rating: 5.0, initial: "A", imageName: nil)
    ]
}

#Preview {
    ClientProposalsView(taskId: 1)
}
