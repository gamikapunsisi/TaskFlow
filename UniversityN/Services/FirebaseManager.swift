//
//  FirebaseManager.swift
//  UniversityN
//
//  Firebase configuration and initialization manager
//

import Foundation
import Network

// MARK: - Firebase Configuration Error Types
enum FirebaseConfigurationError: LocalizedError {
    case configurationFileNotFound
    case invalidConfiguration
    case initializationFailed(String)
    case networkUnavailable
    case serviceUnavailable
    
    var errorDescription: String? {
        switch self {
        case .configurationFileNotFound:
            return "GoogleService-Info.plist file not found. Please add the Firebase configuration file to your project."
        case .invalidConfiguration:
            return "Invalid Firebase configuration. Please check your GoogleService-Info.plist file."
        case .initializationFailed(let details):
            return "Firebase initialization failed: \(details)"
        case .networkUnavailable:
            return "Network connection required for Firebase services."
        case .serviceUnavailable:
            return "Firebase services are currently unavailable."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .configurationFileNotFound:
            return "1. Download GoogleService-Info.plist from Firebase Console\n2. Add it to your Xcode project\n3. Ensure it's included in your app bundle"
        case .invalidConfiguration:
            return "Verify that your GoogleService-Info.plist contains valid project configuration from Firebase Console"
        case .initializationFailed:
            return "Check Firebase Console for service status and verify your configuration"
        case .networkUnavailable:
            return "Please check your internet connection and try again"
        case .serviceUnavailable:
            return "Firebase services may be experiencing issues. Please try again later"
        }
    }
}

// MARK: - Firebase Manager
class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    @Published var isConfigured = false
    @Published var configurationStatus: String = "Not initialized"
    @Published var lastError: FirebaseConfigurationError?
    
    private let networkMonitor = NWPathMonitor()
    private let networkQueue = DispatchQueue(label: "NetworkMonitor")
    @Published var isNetworkAvailable = false
    
    private init() {
        setupNetworkMonitoring()
        validateConfiguration()
    }
    
    // MARK: - Network Monitoring
    private func setupNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isNetworkAvailable = path.status == .satisfied
                DebugLogger.shared.log("Network status changed: \(path.status)", category: .network)
            }
        }
        networkMonitor.start(queue: networkQueue)
    }
    
    // MARK: - Configuration Validation
    func validateConfiguration() -> Bool {
        DebugLogger.shared.log("Starting Firebase configuration validation", category: .configuration)
        
        // Check for GoogleService-Info.plist
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            let error = FirebaseConfigurationError.configurationFileNotFound
            handleConfigurationError(error)
            return false
        }
        
        // Validate plist contents
        guard let plist = NSDictionary(contentsOfFile: path) else {
            let error = FirebaseConfigurationError.invalidConfiguration
            handleConfigurationError(error)
            return false
        }
        
        // Check required keys
        let requiredKeys = [
            "PROJECT_ID",
            "BUNDLE_ID",
            "API_KEY",
            "GOOGLE_APP_ID"
        ]
        
        for key in requiredKeys {
            guard plist.object(forKey: key) != nil else {
                let error = FirebaseConfigurationError.invalidConfiguration
                handleConfigurationError(error)
                DebugLogger.shared.log("Missing required key: \(key)", category: .error)
                return false
            }
        }
        
        configurationStatus = "Configuration valid"
        isConfigured = true
        DebugLogger.shared.log("Firebase configuration validation successful", category: .configuration)
        return true
    }
    
    // MARK: - Firebase Initialization
    func initializeFirebase() {
        DebugLogger.shared.log("Initializing Firebase", category: .configuration)
        
        guard isNetworkAvailable else {
            let error = FirebaseConfigurationError.networkUnavailable
            handleConfigurationError(error)
            return
        }
        
        // Since we can't import Firebase SDK in this environment,
        // we'll simulate the initialization process
        simulateFirebaseInit()
    }
    
    private func simulateFirebaseInit() {
        // This would typically be: FirebaseApp.configure()
        DebugLogger.shared.log("Firebase initialization simulated", category: .configuration)
        configurationStatus = "Firebase initialized (simulated)"
    }
    
    // MARK: - Error Handling
    private func handleConfigurationError(_ error: FirebaseConfigurationError) {
        lastError = error
        configurationStatus = error.localizedDescription
        isConfigured = false
        DebugLogger.shared.log("Configuration error: \(error.localizedDescription)", category: .error)
    }
    
    // MARK: - Configuration Check Results
    func getConfigurationReport() -> ConfigurationReport {
        return ConfigurationReport(
            isConfigured: isConfigured,
            hasNetworkConnection: isNetworkAvailable,
            configurationStatus: configurationStatus,
            lastError: lastError,
            validationChecks: performValidationChecks()
        )
    }
    
    private func performValidationChecks() -> [ValidationCheck] {
        var checks: [ValidationCheck] = []
        
        // Configuration file check
        let hasConfigFile = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil
        checks.append(ValidationCheck(
            name: "GoogleService-Info.plist",
            status: hasConfigFile ? .passed : .failed,
            message: hasConfigFile ? "Configuration file found" : "Configuration file missing"
        ))
        
        // Network connectivity check
        checks.append(ValidationCheck(
            name: "Network Connectivity",
            status: isNetworkAvailable ? .passed : .failed,
            message: isNetworkAvailable ? "Network available" : "No network connection"
        ))
        
        // Bundle ID validation
        if let bundleId = Bundle.main.bundleIdentifier {
            checks.append(ValidationCheck(
                name: "Bundle ID",
                status: .passed,
                message: "Bundle ID: \(bundleId)"
            ))
        } else {
            checks.append(ValidationCheck(
                name: "Bundle ID",
                status: .failed,
                message: "Bundle ID not found"
            ))
        }
        
        return checks
    }
}

// MARK: - Configuration Report Models
struct ConfigurationReport {
    let isConfigured: Bool
    let hasNetworkConnection: Bool
    let configurationStatus: String
    let lastError: FirebaseConfigurationError?
    let validationChecks: [ValidationCheck]
}

struct ValidationCheck {
    let name: String
    let status: ValidationStatus
    let message: String
}

enum ValidationStatus {
    case passed
    case failed
    case warning
    
    var emoji: String {
        switch self {
        case .passed: return "✅"
        case .failed: return "❌"
        case .warning: return "⚠️"
        }
    }
}