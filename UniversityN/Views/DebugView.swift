//
//  DebugView.swift
//  UniversityN
//
//  Debug and configuration view for Firebase troubleshooting
//

import SwiftUI

struct DebugView: View {
    @StateObject private var logger = DebugLogger.shared
    @StateObject private var firebaseManager = FirebaseManager.shared
    @State private var selectedCategory: LogCategory = .authentication
    @State private var showConfigDetails = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Firebase Configuration Status
                    ConfigurationStatusView()
                    
                    // Network Status
                    NetworkStatusView()
                    
                    // Configuration Report
                    ConfigurationReportView()
                    
                    // Log Categories
                    LogCategoryView()
                    
                    // Recent Logs
                    LogView()
                    
                    // Actions
                    ActionsView()
                }
                .padding()
            }
            .navigationTitle("Debug Console")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Configuration Status View
struct ConfigurationStatusView: View {
    @ObservedObject private var firebaseManager = FirebaseManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Firebase Configuration")
                .font(.headline)
                .fontWeight(.bold)
            
            HStack {
                Circle()
                    .fill(firebaseManager.isConfigured ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
                
                Text(firebaseManager.configurationStatus)
                    .font(.subheadline)
                
                Spacer()
                
                if firebaseManager.isConfigured {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
            
            if let error = firebaseManager.lastError {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Error Details:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                    
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    if let recovery = error.recoverySuggestion {
                        Text("Recovery Suggestion:")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                        
                        Text(recovery)
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Network Status View
struct NetworkStatusView: View {
    @ObservedObject private var firebaseManager = FirebaseManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Network Status")
                .font(.headline)
                .fontWeight(.bold)
            
            HStack {
                Circle()
                    .fill(firebaseManager.isNetworkAvailable ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
                
                Text(firebaseManager.isNetworkAvailable ? "Connected" : "Disconnected")
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: firebaseManager.isNetworkAvailable ? "wifi" : "wifi.slash")
                    .foregroundColor(firebaseManager.isNetworkAvailable ? .green : .red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Configuration Report View
struct ConfigurationReportView: View {
    @ObservedObject private var firebaseManager = FirebaseManager.shared
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Configuration Checklist")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(showDetails ? "Hide Details" : "Show Details") {
                    withAnimation {
                        showDetails.toggle()
                    }
                }
                .font(.caption)
                .foregroundColor(.purple)
            }
            
            if showDetails {
                let report = firebaseManager.getConfigurationReport()
                
                ForEach(report.validationChecks, id: \.name) { check in
                    HStack {
                        Text(check.status.emoji)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(check.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text(check.message)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Log Category View
struct LogCategoryView: View {
    @ObservedObject private var logger = DebugLogger.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Log Categories")
                .font(.headline)
                .fontWeight(.bold)
            
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 120))
            ], spacing: 8) {
                ForEach(LogCategory.allCases, id: \.self) { category in
                    Button(action: {
                        logger.toggleCategory(category)
                    }) {
                        Text(category.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(logger.enabledCategories.contains(category) ? Color.purple : Color.gray.opacity(0.3))
                            .foregroundColor(logger.enabledCategories.contains(category) ? .white : .gray)
                            .cornerRadius(16)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Log View
struct LogView: View {
    @ObservedObject private var logger = DebugLogger.shared
    @State private var selectedCategory: LogCategory? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Logs")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("\(filteredLogs.count) entries")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Category filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Button("All") {
                        selectedCategory = nil
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(selectedCategory == nil ? Color.purple : Color.gray.opacity(0.3))
                    .foregroundColor(selectedCategory == nil ? .white : .gray)
                    .cornerRadius(16)
                    .font(.caption)
                    
                    ForEach(LogCategory.allCases, id: \.self) { category in
                        Button(category.rawValue) {
                            selectedCategory = category
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedCategory == category ? Color.purple : Color.gray.opacity(0.3))
                        .foregroundColor(selectedCategory == category ? .white : .gray)
                        .cornerRadius(16)
                        .font(.caption)
                    }
                }
                .padding(.horizontal)
            }
            
            // Log entries
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(filteredLogs.suffix(50).enumerated()), id: \.offset) { index, log in
                        LogEntryView(log: log)
                            .transition(.opacity)
                    }
                }
            }
            .frame(maxHeight: 300)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var filteredLogs: [LogEntry] {
        if let category = selectedCategory {
            return logger.getLogsForCategory(category)
        } else {
            return logger.logs
        }
    }
}

// MARK: - Log Entry View
struct LogEntryView: View {
    let log: LogEntry
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(log.level.emoji)
                .font(.caption)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(log.category.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.purple)
                    
                    Spacer()
                    
                    Text(DateFormatter.logTime.string(from: log.timestamp))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(log.message)
                    .font(.caption)
                    .lineLimit(3)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Actions View
struct ActionsView: View {
    @ObservedObject private var logger = DebugLogger.shared
    @ObservedObject private var firebaseManager = FirebaseManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Actions")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                Button("Clear Logs") {
                    logger.clearLogs()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Validate Firebase Configuration") {
                    let _ = firebaseManager.validateConfiguration()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Test Network Connection") {
                    logger.info("Network connection test initiated", category: .network)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                ShareLink("Export Logs", item: logger.exportLogs())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Extensions
extension DateFormatter {
    static let logTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
}

#Preview {
    DebugView()
}