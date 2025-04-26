import SwiftUI

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
    @EnvironmentObject private var router: Router
    @StateObject private var taskVM = TaskViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Task Details")
                .font(.title2)
                .bold()
                .padding(.bottom, 10)
            
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
            
            Button(action: submitTask) {
                if isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Create Task")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                }
            }
            .disabled(isSubmitting)
            .padding(.top)
        }
        .padding()
        .navigationTitle("Create Task")
        .alert("Success", isPresented: $showSuccess) {
            Button("OK") {
                clearForm()
                router.navigate(to: .clientProfile)
            }
        } message: {
            Text("Task created successfully!")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
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
        
        isSubmitting = true
        
        taskVM.createTask(
            title: title,
            description: description,
            budget: budgetInt,
            category: category,
            deadline: deadlineStr,
            userId: router.userId
        )
        
        isSubmitting = false
        showSuccess = true
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
        .environmentObject(Router())
}
