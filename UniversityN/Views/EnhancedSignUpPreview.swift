//
//  EnhancedSignUpPreview.swift
//  UniversityN
//
//  Preview and demonstration of enhanced SignUp form with error handling
//

import SwiftUI

struct EnhancedSignUpPreview: View {
    @State private var authViewModel = AuthViewModel()
    
    init() {
        // Set up some demo data to show the enhanced UI
        setupDemoData()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.purple)
                        
                        Text("Enhanced SignUp")
                            .font(.title)
                            .bold()
                        
                        Text("With comprehensive error handling")
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    // Demo Form with Errors
                    VStack(spacing: 15) {
                        // Full Name Field with Error
                        VStack(alignment: .leading, spacing: 4) {
                            TextField("Full Name", text: .constant(""))
                                .textFieldStyle(.roundedBorder)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.red, lineWidth: 1)
                                )
                            
                            Text("Full name is required")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        // Email Field with Error
                        VStack(alignment: .leading, spacing: 4) {
                            TextField("Email", text: .constant("invalid-email"))
                                .textFieldStyle(.roundedBorder)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.red, lineWidth: 1)
                                )
                            
                            Text("Please enter a valid email address")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        // Password Field with Error
                        VStack(alignment: .leading, spacing: 4) {
                            SecureField("Password", text: .constant("123"))
                                .textFieldStyle(.roundedBorder)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.red, lineWidth: 1)
                                )
                            
                            Text("Password must be at least 8 characters")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        // Confirm Password Field - Valid
                        VStack(alignment: .leading, spacing: 4) {
                            SecureField("Confirm Password", text: .constant("validpassword123"))
                                .textFieldStyle(.roundedBorder)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.green, lineWidth: 1)
                                )
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.caption)
                                Text("Looks good!")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        // Role Selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("I want to:")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Picker("Role", selection: .constant("client")) {
                                Text("Hire services (Client)").tag("client")
                                Text("Offer services (Tasker)").tag("tasker")
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Enhanced Sign Up Button
                    Button(action: {}) {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                                .foregroundColor(.white)
                            Text("Creating Account...")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                    }
                    .disabled(true)
                    .padding(.horizontal)
                    
                    // Debug Information
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Debug Information")
                            .font(.headline)
                            .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            InfoRow(label: "Configuration Status", value: "GoogleService-Info.plist not found", color: .red)
                            InfoRow(label: "Network Available", value: "Yes", color: .green)
                            InfoRow(label: "Form Valid", value: "No (3 errors)", color: .red)
                            InfoRow(label: "Validation Errors", value: "Empty name, Invalid email, Weak password", color: .orange)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Features List
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Enhanced Features")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        FeatureRow(icon: "checkmark.circle", title: "Real-time Validation", description: "Instant field validation with visual feedback")
                        FeatureRow(icon: "exclamationmark.triangle", title: "Detailed Error Messages", description: "User-friendly errors with recovery suggestions")
                        FeatureRow(icon: "network", title: "Network Monitoring", description: "Detects connectivity issues and provides feedback")
                        FeatureRow(icon: "gear", title: "Configuration Validation", description: "Validates Firebase setup automatically")
                        FeatureRow(icon: "doc.text.magnifyingglass", title: "Advanced Logging", description: "Comprehensive debugging with log export")
                        FeatureRow(icon: "shield.checkered", title: "Security Focused", description: "Input validation and secure session management")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("Enhanced SignUp Demo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func setupDemoData() {
        // This would normally be done in the actual AuthViewModel
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text("\(label):")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .foregroundColor(color)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

#Preview {
    EnhancedSignUpPreview()
}