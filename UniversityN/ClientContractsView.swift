import SwiftUI

enum ContractStatus: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
    case requested = "Requested"
}

struct ClientContract: Identifiable {
    let id = UUID()
    let title: String
    let status: ContractStatus
    let price: Double
    let dateRange: String
}

struct ClientContractsView: View {
    @State private var contracts: [ClientContract] = [
        ClientContract(title: "Educational Mobile app UI/UX Design", status: .requested, price: 55.0, dateRange: "Feb 12, 2025"),
        ClientContract(title: "Educational Mobile app UI/UX Design", status: .active, price: 55.0, dateRange: "Feb 12, 2025 - Present"),
        ClientContract(title: "Educational Mobile app UI/UX Design", status: .completed, price: 55.0, dateRange: "Feb 12, 2025 - Mar 12, 2025")
    ]
    
    @State private var selectedTab: ContractStatus = .all
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Contracts")
                    .font(.headline)
                Spacer()
                Image("profile") // Add your profile image name here
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
            }
            .padding()

            TextField("Search contracts", text: .constant(""))
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

            HStack {
                ForEach(ContractStatus.allCases, id: \ .self) { tab in
                    Button(action: {
                        selectedTab = tab
                    }) {
                        Text("\(tab.rawValue)(\(filteredContracts(status: tab).count))")
                            .font(.subheadline)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .foregroundColor(selectedTab == tab ? .purple : .gray)
                            .background(selectedTab == tab ? Color.purple.opacity(0.1) : Color.clear)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)

            ScrollView {
                ForEach(filteredContracts(status: selectedTab)) { contract in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(contract.title)
                            .foregroundColor(.purple)
                            .font(.subheadline)

                        HStack {
                            Text(contract.status.rawValue)
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(4)
                                .background(contract.statusColor)
                                .cornerRadius(4)
                            Spacer()
                        }

                        Text("$\(String(format: "%.2f", contract.price))")
                            .font(.subheadline)

                        Text(contract.dateRange)
                            .font(.caption)
                            .foregroundColor(.gray)

                        if contract.status == .active {
                            HStack(spacing: 10) {
                                Button("Pay Now") {}
                                    .font(.caption)
                                    .padding(8)
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                Button("End Contract") {}
                                    .font(.caption)
                                    .padding(8)
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        } else if contract.status == .completed {
                            HStack {
                                Spacer()
                                Button("Back") {}
                                    .padding(8)
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                Button("Next") {}
                                    .padding(8)
                                    .background(Color.white)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.purple))
                                    .foregroundColor(.purple)
                                Spacer()
                            }
                        }

                        TextField("Send a message", text: .constant(""))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }

            Spacer()

            HStack {
                Image(systemName: "square.grid.2x2")
                Spacer()
                Image(systemName: "doc.text")
                Spacer()
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.purple)
                        .font(.largeTitle)
                }
                Spacer()
                Image(systemName: "bell")
                Spacer()
                Image(systemName: "message")
            }
            .padding()
            .background(Color.white.shadow(radius: 2))
        }
    }

    func filteredContracts(status: ContractStatus) -> [ClientContract] {
        if status == .all {
            return contracts
        } else {
            return contracts.filter { $0.status == status }
        }
    }
}

extension ClientContract {
    var statusColor: Color {
        switch status {
        case .active: return Color.green
        case .completed: return Color.gray
        case .requested: return Color.blue
        default: return Color.clear
        }
    }
}

struct ClientContractsView_Previews: PreviewProvider {
    static var previews: some View {
        ClientContractsView()
    }
}
