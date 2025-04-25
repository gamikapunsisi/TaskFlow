import SwiftUI

struct TaskData: Codable {
    let title: String
    let description: String
    let budget: Int
    let category: String
    let deadline: String
}

struct CreateTaskView: View {
    @State private var title = ""
    @State private var description = ""
    @State private var budget = ""
    @State private var category = ""
    @State private var deadline = Date()

    @State private var isSubmitting = false
    @State private var showSuccess = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var navigateToProfile = false
    @StateObject var taskVM = TaskViewModel()



    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Task Details")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 10)

                    Group {
                        TextField("Title", text: $title)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.name)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .textContentType(.oneTimeCode)
                            .disableAutocorrection(true)

                        TextField("Description", text: $description)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.none)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .textContentType(.oneTimeCode)
                            .disableAutocorrection(true)

                        TextField("Budget", text: $budget)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .textContentType(.none)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .textContentType(.oneTimeCode)
                            .disableAutocorrection(true)

                        TextField("Category", text: $category)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.none)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .textContentType(.oneTimeCode)
                            .disableAutocorrection(true)

                        DatePicker("Deadline", selection: $deadline, displayedComponents: [.date, .hourAndMinute])
                    }

                    Button(action: submitTask) {
                        if isSubmitting {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            Text("Submit Task")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .disabled(isSubmitting)
//                    NavigationLink(destination: ClientProfileView(), isActive: $navigateToProfile) {
//                                      EmptyView()
//                                  }
                    NavigationLink(destination: ClientProfileView(taskVM: taskVM), isActive: $navigateToProfile) {
                        EmptyView()
                    }

                }
                .padding()
            }
            .navigationTitle("Create Task")
            .alert("Success", isPresented: $showSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your task has been submitted.")
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    func submitTask() {
        guard let budgetInt = Int(budget) else {
            errorMessage = "Budget must be a number."
            showError = true
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let deadlineStr = formatter.string(from: deadline)

        let task = TaskData(title: title, description: description, budget: budgetInt, category: category, deadline: deadlineStr)

        guard let url = URL(string: "http://localhost:8000/api/tasks") else {
            errorMessage = "Invalid URL."
            showError = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(task)
        } catch {
            errorMessage = "Encoding error: \(error.localizedDescription)"
            showError = true
            return
        }

        isSubmitting = true

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "Submit error: \(error.localizedDescription)"
                    showError = true
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                DispatchQueue.main.async {
                    showSuccess = true
                    clearForm()
                    navigateToProfile = true // ✅ Navigate to profile

                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Unexpected server response."
                    showError = true
                }
            }
        }.resume()
    }

    func clearForm() {
        title = ""
        description = ""
        budget = ""
        category = ""
        deadline = Date()
    }
}

#Preview {
    CreateTaskView()
}
