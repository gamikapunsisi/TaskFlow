//
//  ContractsView.swift
//  UniversityN
//
//  Created by Gamika Punsisi on 2025-04-22.
//

import SwiftUI

struct Contract: Identifiable {
    let id = UUID()
    let title: String
    let status: String
    let date: String
    let escrow: String
    let actionButtonTitle: String?
    let statusColor: Color
}

struct ContractsView: View {
    @State private var selectedTab = "All"
    private let tabs = ["All", "Active", "Completed", "Requested"]

    private let contracts = [
        Contract(title: "Educational Mobile app UI/UX Design", status: "Requested", date: "Feb 12, 2025 - Present", escrow: "$55.00 in Escrow", actionButtonTitle: "Accept Contract", statusColor: .blue),
        Contract(title: "Educational Mobile app UI/UX Design", status: "Active", date: "Feb 12, 2025 - Present", escrow: "$55.00 in Escrow", actionButtonTitle: "Submit Work", statusColor: .green),
        Contract(title: "Educational Mobile app UI/UX Design", status: "Completed", date: "Feb 12, 2025 - Present", escrow: "$55.00 in Escrow", actionButtonTitle: nil, statusColor: .gray)
    ]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Earnings available now:")
                        .font(.subheadline)
                    Spacer()
                    Button("Get Paid") {}
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(10)
                }

                Text("$259")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 10)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(tabs, id: \.self) { tab in
                            Button(action: {
                                selectedTab = tab
                            }) {
                                VStack {
                                    Text(tab)
                                        .foregroundColor(selectedTab == tab ? .black : .gray)
                                        .fontWeight(selectedTab == tab ? .bold : .regular)
                                    if selectedTab == tab {
                                        RoundedRectangle(cornerRadius: 2)
                                            .frame(height: 2)
                                            .foregroundColor(.black)
                                    } else {
                                        Color.clear.frame(height: 2)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                ScrollView {
                    ForEach(contracts) { contract in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(contract.title)
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("Hired by Mike Newland")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            HStack {
                                Text(contract.status)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(contract.statusColor)
                                    .cornerRadius(20)
                                Spacer()
                            }

                            Text(contract.escrow)
                                .font(.subheadline)
                                .foregroundColor(.black)

                            Text(contract.date)
                                .font(.caption)
                                .foregroundColor(.gray)

                            if let buttonTitle = contract.actionButtonTitle {
                                Button(buttonTitle) {}
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }

                            Button("Send a message") {}
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 3)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    }
                }

                Spacer()

                HStack {
                    Button("Back") {}
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)

                    Button("Next") {}
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Contracts")
        }
    }
}

struct ContractsView_Previews: PreviewProvider {
    static var previews: some View {
        ContractsView()
    }
}
