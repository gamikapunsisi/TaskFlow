//
//  BiometricAuthManager.swift
//  TaskFlow
//
//  Created by Gamika Punsisi on 2025-08-21.
//  Updated: 2025-08-21 18:10:11 UTC
//

import Foundation
import LocalAuthentication
import SwiftUI
import Security

// MARK: - Biometric Authentication Types
enum BiometricType {
    case none
    case touchID
    case faceID
    case opticID // For newer devices
    
    var displayName: String {
        switch self {
        case .none:
            return "None Available"
        case .touchID:
            return "Touch ID"
        case .faceID:
            return "Face ID"
        case .opticID:
            return "Optic ID"
        }
    }
    
    var icon: String {
        switch self {
        case .none:
            return "exclamationmark.triangle"
        case .touchID:
            return "touchid"
        case .faceID:
            return "faceid"
        case .opticID:
            return "opticid"
        }
    }
}

// MARK: - Biometric Authentication Results
enum BiometricAuthResult {
    case success
    case failure(BiometricAuthError)
    case cancelled
}

enum BiometricAuthError: LocalizedError {
    case notAvailable
    case notEnrolled
    case lockout
    case systemCancel
    case userCancel
    case userFallback
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case invalidContext
    case notInteractive
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "Biometric authentication is not available on this device"
        case .notEnrolled:
            return "No biometric data is enrolled. Please set up Face ID or Touch ID in Settings"
        case .lockout:
            return "Biometric authentication is locked out. Please use your device passcode"
        case .systemCancel:
            return "System cancelled biometric authentication"
        case .userCancel:
            return "User cancelled biometric authentication"
        case .userFallback:
            return "User chose to use alternative authentication method"
        case .biometryNotAvailable:
            return "Face ID/Touch ID is not available"
        case .biometryNotEnrolled:
            return "Face ID/Touch ID is not set up"
        case .biometryLockout:
            return "Face ID/Touch ID is temporarily locked"
        case .invalidContext:
            return "Invalid authentication context"
        case .notInteractive:
            return "Authentication context not interactive"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

// MARK: - Biometric Auth Manager
class BiometricAuthManager: ObservableObject {
    static let shared = BiometricAuthManager()
    
    @Published var biometricType: BiometricType = .none
    @Published var isBiometricAvailable = false
    @Published var isBiometricEnabled = false
    @Published var isAuthenticating = false
    
    private let context = LAContext()
    // ✅ Made internal for extensions/debugging access
    internal let userDefaults = UserDefaults.standard
    
    // Keys for UserDefaults and Keychain
    private let biometricEnabledKey = "BiometricAuthEnabled"
    internal let lastBiometricCheckKey = "LastBiometricCheck"
    
    // ✅ Keychain keys for credential storage
    private let keychainService = "TaskFlowApp.BiometricAuth"
    private let keychainAccount = "BiometricCredentials"
    
    init() {
        print("🔐 BiometricAuthManager initialized - User: gamikapunsisi at 2025-08-21 18:10:11")
        checkBiometricAvailability()
        loadBiometricSettings()
    }
    
    // MARK: - Biometric Availability Check
    
    func checkBiometricAvailability() {
        var error: NSError?
        
        // ✅ Use .deviceOwnerAuthenticationWithBiometrics for iOS compatibility
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print("❌ Biometric authentication not available: \(error?.localizedDescription ?? "Unknown error")")
            
            DispatchQueue.main.async {
                self.isBiometricAvailable = false
                self.biometricType = .none
            }
            return
        }
        
        let biometricType = getBiometricType()
        
        DispatchQueue.main.async {
            self.isBiometricAvailable = true
            self.biometricType = biometricType
        }
        
        print("✅ Biometric authentication available: \(biometricType.displayName) - User: gamikapunsisi at 2025-08-21 18:10:11")
        
        // Save check timestamp
        userDefaults.set(Date(), forKey: lastBiometricCheckKey)
    }
    
    private func getBiometricType() -> BiometricType {
        guard #available(iOS 11.0, *) else { return .none }
        
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        case .opticID:
            if #available(iOS 17.0, *) {
                return .opticID
            } else {
                return .faceID
            }
        @unknown default:
            return .none
        }
    }
    
    // MARK: - Authentication Methods
    
    func authenticateUser(reason: String = "Authenticate to access TaskFlow") async -> BiometricAuthResult {
        print("🔐 Starting biometric authentication - User: gamikapunsisi at 2025-08-21 18:10:11")
        
        await MainActor.run {
            self.isAuthenticating = true
        }
        
        // Check if biometrics are available
        guard isBiometricAvailable else {
            await MainActor.run {
                self.isAuthenticating = false
            }
            print("❌ Biometric authentication not available")
            return .failure(.notAvailable)
        }
        
        // Create new context for each authentication attempt
        let authContext = LAContext()
        
        // Configure authentication context
        authContext.localizedCancelTitle = "Cancel"
        authContext.localizedFallbackTitle = "Use Password"
        
        var error: NSError?
        
        // ✅ Check if biometric authentication is available using correct policy
        guard authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            await MainActor.run {
                self.isAuthenticating = false
            }
            
            let biometricError = mapLAError(error)
            print("❌ Cannot evaluate biometric policy: \(biometricError.errorDescription ?? "Unknown")")
            return .failure(biometricError)
        }
        
        do {
            // ✅ Use correct policy for evaluation
            let success = try await authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            
            await MainActor.run {
                self.isAuthenticating = false
            }
            
            if success {
                print("✅ Biometric authentication successful - User: gamikapunsisi at 2025-08-21 18:10:11")
                return .success
            } else {
                print("❌ Biometric authentication failed")
                return .failure(.unknown(NSError(domain: "BiometricAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Authentication failed"])))
            }
            
        } catch {
            await MainActor.run {
                self.isAuthenticating = false
            }
            
            let biometricError = mapLAError(error as NSError)
            print("❌ Biometric authentication error: \(biometricError.errorDescription ?? "Unknown")")
            
            if case .userCancel = biometricError {
                return .cancelled
            }
            
            return .failure(biometricError)
        }
    }
    
    // MARK: - Quick Authentication
    
    func quickAuthenticate() async -> Bool {
        let result = await authenticateUser(reason: "Unlock TaskFlow with \(biometricType.displayName)")
        
        switch result {
        case .success:
            return true
        case .failure(let error):
            print("❌ Quick authentication failed: \(error.errorDescription ?? "Unknown")")
            return false
        case .cancelled:
            print("⚠️ Quick authentication cancelled by user")
            return false
        }
    }
    
    // MARK: - Settings Management
    
    func enableBiometricAuth() async -> Bool {
        print("🔐 Enabling biometric authentication - User: gamikapunsisi at 2025-08-21 18:10:11")
        
        guard isBiometricAvailable else {
            print("❌ Cannot enable: Biometric authentication not available")
            return false
        }
        
        // Test authentication before enabling
        let result = await authenticateUser(reason: "Enable \(biometricType.displayName) for TaskFlow")
        
        switch result {
        case .success:
            await MainActor.run {
                self.isBiometricEnabled = true
            }
            saveBiometricSettings()
            print("✅ Biometric authentication enabled successfully")
            return true
            
        case .failure(let error):
            print("❌ Failed to enable biometric auth: \(error.errorDescription ?? "Unknown")")
            return false
            
        case .cancelled:
            print("⚠️ User cancelled biometric setup")
            return false
        }
    }
    
    // ✅ Add missing method with delay
    func enableBiometricAuthWithDelay() async -> Bool {
        print("🔐 Enabling biometric authentication with delay - User: gamikapunsisi at 2025-08-21 18:10:11")
        
        // Add a delay to ensure any previous alerts are dismissed
        do {
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        } catch {
            print("❌ Delay failed: \(error.localizedDescription)")
        }
        
        return await enableBiometricAuth()
    }
    
    func disableBiometricAuth() {
        print("🔐 Disabling biometric authentication - User: gamikapunsisi at 2025-08-21 18:10:11")
        
        DispatchQueue.main.async {
            self.isBiometricEnabled = false
        }
        
        saveBiometricSettings()
        
        // ✅ Remove stored credentials when disabling
        removeStoredCredentials()
        
        print("✅ Biometric authentication disabled")
    }
    
    private func loadBiometricSettings() {
        isBiometricEnabled = userDefaults.bool(forKey: biometricEnabledKey)
        print("📱 Loaded biometric settings - Enabled: \(isBiometricEnabled)")
    }
    
    private func saveBiometricSettings() {
        userDefaults.set(isBiometricEnabled, forKey: biometricEnabledKey)
        print("💾 Saved biometric settings - Enabled: \(isBiometricEnabled)")
    }
    
    // MARK: - ✅ Keychain Methods (MISSING IN ORIGINAL)
    
    func removeStoredCredentials() {
        print("🗑️ Removing stored credentials - User: gamikapunsisi at 2025-08-21 18:10:11")
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        switch status {
        case errSecSuccess:
            print("✅ Stored credentials removed successfully")
        case errSecItemNotFound:
            print("ℹ️ No stored credentials found to remove")
        default:
            print("❌ Failed to remove stored credentials: \(status)")
        }
    }
    
    func storeCredentials(_ data: Data) -> Bool {
        print("💾 Storing biometric credentials - User: gamikapunsisi at 2025-08-21 18:10:11")
        
        // First, remove any existing credentials
        removeStoredCredentials()
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            print("✅ Credentials stored successfully")
            return true
        default:
            print("❌ Failed to store credentials: \(status)")
            return false
        }
    }
    
    func retrieveStoredCredentials() -> Data? {
        print("🔍 Retrieving stored credentials - User: gamikapunsisi at 2025-08-21 18:10:11")
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        switch status {
        case errSecSuccess:
            print("✅ Retrieved stored credentials")
            return result as? Data
        case errSecItemNotFound:
            print("ℹ️ No stored credentials found")
            return nil
        default:
            print("❌ Failed to retrieve credentials: \(status)")
            return nil
        }
    }
    
    // MARK: - Error Mapping
    
    private func mapLAError(_ error: NSError?) -> BiometricAuthError {
        guard let error = error else { return .unknown(NSError()) }
        
        switch error.code {
        case LAError.biometryNotAvailable.rawValue:
            return .biometryNotAvailable
        case LAError.biometryNotEnrolled.rawValue:
            return .biometryNotEnrolled
        case LAError.biometryLockout.rawValue:
            return .biometryLockout
        case LAError.userCancel.rawValue:
            return .userCancel
        case LAError.userFallback.rawValue:
            return .userFallback
        case LAError.systemCancel.rawValue:
            return .systemCancel
        case LAError.invalidContext.rawValue:
            return .invalidContext
        case LAError.notInteractive.rawValue:
            return .notInteractive
        default:
            return .unknown(error)
        }
    }
    
    // MARK: - Utility Methods
    
    func getBiometricStatusMessage() -> String {
        if !isBiometricAvailable {
            return "Biometric authentication is not available on this device"
        }
        
        if !isBiometricEnabled {
            return "\(biometricType.displayName) is available but not enabled"
        }
        
        return "\(biometricType.displayName) is enabled and ready to use"
    }
    
    func shouldShowBiometricOption() -> Bool {
        return isBiometricAvailable && isBiometricEnabled
    }
    
    // MARK: - Debug Methods
    
    func getBiometricDebugInfo() -> String {
        var info = "🔐 Biometric Debug Info - User: gamikapunsisi at 2025-08-21 18:10:11\n"
        info += "📱 Device Type: \(biometricType.displayName)\n"
        info += "✅ Available: \(isBiometricAvailable)\n"
        info += "🔛 Enabled: \(isBiometricEnabled)\n"
        info += "⏳ Authenticating: \(isAuthenticating)\n"
        
        // Device information
        info += "📟 Device Model: \(UIDevice.current.model)\n"
        info += "🔢 iOS Version: \(UIDevice.current.systemVersion)\n"
        info += "🏷️ Device Name: \(UIDevice.current.name)\n"
        
        // Biometric context details
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        info += "🔍 Can Evaluate Policy: \(canEvaluate)\n"
        
        if let error = error {
            info += "❌ Policy Error: \(error.localizedDescription)\n"
            info += "🔢 Error Code: \(error.code)\n"
        }
        
        // UserDefaults check
        info += "💾 Settings Key: \(biometricEnabledKey)\n"
        info += "🔑 Stored Enabled: \(userDefaults.bool(forKey: biometricEnabledKey))\n"
        
        if let lastCheck = userDefaults.object(forKey: lastBiometricCheckKey) as? Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            info += "🕒 Last Check: \(formatter.string(from: lastCheck)) UTC\n"
        } else {
            info += "🕒 Last Check: Never\n"
        }
        
        // Biometry type details
        if #available(iOS 11.0, *) {
            info += "🔬 LAContext Biometry Type: \(context.biometryType.rawValue)\n"
        }
        
        // Keychain info
        info += "🔐 Keychain Service: \(keychainService)\n"
        info += "👤 Keychain Account: \(keychainAccount)\n"
        
        let hasStoredCredentials = retrieveStoredCredentials() != nil
        info += "💾 Has Stored Credentials: \(hasStoredCredentials)\n"
        
        info += "🏁 Debug Info Generated at: 2025-08-21 18:10:11 UTC\n"
        
        return info
    }
    
    func performDebugCheck() -> (available: Bool, enabled: Bool, type: String) {
        print("🧪 Performing debug check - User: gamikapunsisi at 2025-08-21 18:10:11")
        
        // Force refresh availability check
        checkBiometricAvailability()
        
        return (
            available: isBiometricAvailable,
            enabled: isBiometricEnabled,
            type: biometricType.displayName
        )
    }
    
    // MARK: - Additional Helper Methods
    
    func resetBiometricSettings() {
        print("🔄 Resetting biometric settings - User: gamikapunsisi at 2025-08-21 18:10:11")
        
        DispatchQueue.main.async {
            self.isBiometricEnabled = false
        }
        
        userDefaults.removeObject(forKey: biometricEnabledKey)
        userDefaults.removeObject(forKey: lastBiometricCheckKey)
        removeStoredCredentials()
        
        print("✅ Biometric settings reset successfully")
    }
    
    func validateBiometricState() -> Bool {
        let isSystemAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        let isSettingEnabled = userDefaults.bool(forKey: biometricEnabledKey)
        
        // If system says it's not available but we have it enabled, reset
        if !isSystemAvailable && isSettingEnabled {
            print("⚠️ Biometric state mismatch detected, resetting...")
            resetBiometricSettings()
            return false
        }
        
        return isSystemAvailable && isSettingEnabled
    }
}
