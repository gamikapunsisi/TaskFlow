//
//  AuthenticationDemo.swift
//  UniversityN
//
//  Demo and testing utilities for the enhanced Firebase authentication
//

import SwiftUI

struct AuthenticationDemo: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showDemoScenarios = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Firebase Authentication Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                // Configuration Status
                ConfigurationStatusCard()
                
                // Demo Scenarios
                if showDemoScenarios {
                    DemoScenariosView()
                }
                
                // Toggle Demo Scenarios
                Button(showDemoScenarios ? "Hide Demo Scenarios" : "Show Demo Scenarios") {
                    withAnimation {
                        showDemoScenarios.toggle()
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
                
                // Navigation to Debug Console
                NavigationLink("Open Debug Console", destination: DebugView())
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .navigationTitle("Auth Demo")
            .navigationBarHidden(true)
        }
    }
}

struct ConfigurationStatusCard: View {
    @ObservedObject private var firebaseManager = FirebaseManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Firebase Status")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Circle()
                    .fill(firebaseManager.isConfigured ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
            }
            
            Text(firebaseManager.configurationStatus)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Label("Network", systemImage: firebaseManager.isNetworkAvailable ? "wifi" : "wifi.slash")
                    .font(.caption)
                    .foregroundColor(firebaseManager.isNetworkAvailable ? .green : .red)
                
                Spacer()
                
                Text(firebaseManager.isNetworkAvailable ? "Connected" : "Offline")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct DemoScenariosView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Test Scenarios")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                DemoButton(
                    title: "Test Empty Email Error",
                    description: "Triggers email validation error",
                    action: {
                        authViewModel.emailField.value = ""
                        authViewModel.passwordField.value = "password123"
                        Task { await authViewModel.signIn() }
                    }
                )
                
                DemoButton(
                    title: "Test Weak Password Error",
                    description: "Triggers password strength validation",
                    action: {
                        authViewModel.emailField.value = "test@example.com"
                        authViewModel.passwordField.value = "123"
                        authViewModel.fullNameField.value = "Test User"
                        authViewModel.confirmPasswordField.value = "123"
                        Task { await authViewModel.signUp() }
                    }
                )
                
                DemoButton(
                    title: "Test Network Error Simulation",
                    description: "Simulates network connectivity error",
                    action: {
                        DebugLogger.shared.info("Network error simulation triggered", category: .network)
                        // This would typically test offline scenarios
                    }
                )
                
                DemoButton(
                    title: "Test Configuration Validation",
                    description: "Validates Firebase configuration",
                    action: {
                        let isValid = FirebaseManager.shared.validateConfiguration()
                        DebugLogger.shared.info("Configuration validation result: \(isValid)", category: .configuration)
                    }
                )
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

struct DemoButton: View {
    let title: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: action) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "play.circle")
                        .foregroundColor(.blue)
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }
        }
    }
}

#Preview {
    AuthenticationDemo()
}