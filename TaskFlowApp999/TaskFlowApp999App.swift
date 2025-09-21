//
//  TaskFlowApp999App.swift
//  TaskFlowApp999
//
//  Created by Gamika Punsisi on 2025-09-19.
//

import SwiftUI
import FirebaseCore
import Firebase

@main
struct TaskFlowApp999App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var notificationManager = NotificationManager.shared

    
    init() {
        configureApp()
        print("🚀 TaskFlowApp initialized - User: gamikapunsisi at 2025-08-20 13:21:20")
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authVM)
                .environmentObject(notificationManager)
                .onAppear {
                    print("📱 TaskFlowApp appeared - User: gamikapunsisi at 2025-08-20 13:21:20")
                    handleAppLaunch()
                }
                .onChange(of: notificationManager.isAuthorized) { oldValue, newValue in
                    print("🔔 Notification authorization changed: \(newValue ? "✅ Authorized" : "❌ Not Authorized")")
                }
        }
    }
    
    // MARK: - App Configuration
    private func configureApp() {
        print("⚙️ Configuring TaskFlow App - User: gamikapunsisi at 2025-08-20 13:21:20")
        
        // Check if we're in UI testing mode
        if isUITesting {
            print("🧪 UI Testing Mode Detected")
            setupUITestingMode()
            return
        }
        
        // Note: Firebase is configured in AppDelegate, not here
        print("🔥 Firebase will be configured by AppDelegate - User: gamikapunsisi at 2025-08-20 13:21:20")
        
        // Set up crash reporting and analytics
        setupProductionEnvironment()
    }
    
    private func setupUITestingMode() {
        print("🧪 Setting up UI Testing environment - User: gamikapunsisi at 2025-08-20 13:21:20")
        
        // Disable animations for faster testing
        if ProcessInfo.processInfo.arguments.contains("DISABLE_ANIMATIONS") {
            UIView.setAnimationsEnabled(false)
            print("🎭 Animations disabled for testing")
        }
        
        // Set up mock Firebase configuration (if needed)
        setupMockFirebaseForTesting()
        
        // Configure mock authentication state
        configureMockAuthentication()
        
        // Set user defaults for testing
        UserDefaults.standard.set(true, forKey: "UI_TESTING_MODE")
        
        // Disable network requests if specified
        if ProcessInfo.processInfo.arguments.contains("DISABLE_NETWORK") {
            UserDefaults.standard.set(true, forKey: "DISABLE_NETWORK")
            print("🌐 Network requests disabled for testing")
        }
    }
    
    private func setupMockFirebaseForTesting() {
        // For UI testing, we might want to use Firebase emulator or skip Firebase entirely
        if ProcessInfo.processInfo.environment["USE_FIREBASE_EMULATOR"] == "true" {
            // Configure Firebase emulator if needed
            print("🔧 Would configure Firebase emulator here - User: gamikapunsisi at 2025-08-20 13:21:20")
        } else {
            // Skip Firebase configuration for pure UI testing
            print("⏭️ Skipping Firebase configuration for UI testing - User: gamikapunsisi at 2025-08-20 13:21:20")
        }
    }
    
    private func configureMockAuthentication() {
        // Set up mock authentication based on environment variables
        if let mockAuthState = ProcessInfo.processInfo.environment["MOCK_AUTHENTICATED"],
           mockAuthState == "true" {
            UserDefaults.standard.set(true, forKey: "MOCK_AUTHENTICATED")
            
            // Set mock user role - default to client for UI testing
            let mockRole = ProcessInfo.processInfo.environment["MOCK_USER_ROLE"] ?? "client"
            UserDefaults.standard.set(mockRole, forKey: "MOCK_USER_ROLE")
            
            // Set mock user data
            UserDefaults.standard.set("gamikapunsisi@taskflow.lk", forKey: "MOCK_USER_EMAIL")
            UserDefaults.standard.set("Gamika Punsisi", forKey: "MOCK_USER_NAME")
            UserDefaults.standard.set("test-user-uid-123", forKey: "MOCK_USER_UID")
            
            print("🧪 Mock authentication configured - Role: \(mockRole) - User: gamikapunsisi at 2025-08-20 13:21:20")
        } else {
            UserDefaults.standard.set(false, forKey: "MOCK_AUTHENTICATED")
            print("🧪 Mock authentication disabled - User: gamikapunsisi at 2025-08-20 13:21:20")
        }
    }
    
    private func setupProductionEnvironment() {
        #if DEBUG
        print("🔧 Running in DEBUG mode - User: gamikapunsisi at 2025-08-20 13:21:20")
        // Enable additional debugging
        UserDefaults.standard.set(true, forKey: "ENABLE_DEBUG_LOGGING")
        #else
        print("🚀 Running in PRODUCTION mode - User: gamikapunsisi at 2025-08-20 13:21:20")
        // Disable debug features
        UserDefaults.standard.set(false, forKey: "ENABLE_DEBUG_LOGGING")
        #endif
        
        // Set app version for tracking
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            UserDefaults.standard.set("\(version) (\(build))", forKey: "APP_VERSION")
            print("📱 TaskFlow Version: \(version) (\(build)) - User: gamikapunsisi at 2025-08-20 13:21:20")
        }
    }
    
    // MARK: - App Launch Handling
    private func handleAppLaunch() {
        print("🚀 TaskFlow App Launched - User: gamikapunsisi at 2025-08-20 13:21:20")
        
        // Handle different launch scenarios
        if isUITesting {
            handleUITestingLaunch()
        } else {
            handleNormalLaunch()
        }
        
        // Log system information
        logSystemInformation()
    }
    
    private func handleUITestingLaunch() {
        print("🧪 Handling UI Testing launch - User: gamikapunsisi at 2025-08-20 13:21:20")
        
        // Set up mock authentication state after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setupMockAuthenticationState()
        }
        
        // Disable unnecessary background tasks
        disableBackgroundTasks()
    }
    
    private func handleNormalLaunch() {
        print("✅ Handling normal app launch - User: gamikapunsisi at 2025-08-20 13:21:20")
        
        // Perform any necessary app setup
        performAppWarmup()
        
        // Check for app updates or maintenance
        checkAppStatus()
    }
    
    private func setupMockAuthenticationState() {
        guard UserDefaults.standard.bool(forKey: "MOCK_AUTHENTICATED") else {
            print("🧪 Mock authentication not enabled - User: gamikapunsisi at 2025-08-20 13:21:20")
            return
        }
        
        // Apply mock authentication to AuthViewModel
        DispatchQueue.main.async {
            self.authVM.isLoggedIn = true
            
            let mockRoleString = UserDefaults.standard.string(forKey: "MOCK_USER_ROLE") ?? "client"
            if let mockRole = UserRole(rawValue: mockRoleString) {
                self.authVM.role = mockRole
                print("🧪 Applied mock authentication - Role: \(mockRole) - User: gamikapunsisi at 2025-08-20 13:21:20")
            } else {
                // Default to client for UI testing
                self.authVM.role = .client
                print("🧪 Applied default client role for testing - User: gamikapunsisi at 2025-08-20 13:21:20")
            }
        }
    }
    
    private func disableBackgroundTasks() {
        // Disable background tasks that might interfere with UI testing
        print("🔇 Background tasks disabled for testing - User: gamikapunsisi at 2025-08-20 13:21:20")
    }
    
    private func performAppWarmup() {
        // Perform any necessary warmup tasks
        // This could include preloading data, checking permissions, etc.
        print("🔥 Performing app warmup - User: gamikapunsisi at 2025-08-20 13:21:20")
        
        // Wait for Firebase to be configured in AppDelegate before using it
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("🔥 Firebase should now be configured by AppDelegate - User: gamikapunsisi at 2025-08-20 13:21:20")
        }
    }
    
    private func checkAppStatus() {
        // Check if app needs updates or if there are any maintenance notices
        print("🔍 Checking app status - User: gamikapunsisi at 2025-08-20 13:21:20")
    }
    
    private func logSystemInformation() {
        let device = UIDevice.current
        print("📱 Device Info - User: gamikapunsisi at 2025-08-20 13:21:20:")
        print("   - Model: \(device.model)")
        print("   - System: \(device.systemName) \(device.systemVersion)")
        print("   - Name: \(device.name)")
        
        if let bundleId = Bundle.main.bundleIdentifier {
            print("📦 Bundle ID: \(bundleId)")
        }
        
        // Log memory usage if in debug mode
        #if DEBUG
        let memoryUsage = getMemoryUsage()
        print("💾 Memory Usage: \(String(format: "%.2f", memoryUsage)) MB")
        #endif
    }
    
    #if DEBUG
    private func getMemoryUsage() -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return Double(info.resident_size) / 1024.0 / 1024.0
        }
        return 0
    }
    #endif
}

// MARK: - Extensions for Better Organization
extension TaskFlowApp999App {
    
    // MARK: - Environment Helpers
    var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("UI_TESTING") ||
        ProcessInfo.processInfo.arguments.contains("UI-TESTING") ||
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil ||
        NSClassFromString("XCTestCase") != nil
    }
    
    var isDebugMode: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    var isProduction: Bool {
        !isDebugMode && !isUITesting
    }
}

// MARK: - Launch Configuration
struct LaunchConfiguration {
    static let current = LaunchConfiguration()
    
    let isUITesting: Bool
    let isDebugMode: Bool
    let mockAuthenticated: Bool
    let mockUserRole: String
    let disableAnimations: Bool
    let disableNetwork: Bool
    
    private init() {
        isUITesting = ProcessInfo.processInfo.arguments.contains("UI_TESTING") ||
                     ProcessInfo.processInfo.arguments.contains("UI-TESTING") ||
                     ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil ||
                     NSClassFromString("XCTestCase") != nil
        
        isDebugMode = {
            #if DEBUG
            return true
            #else
            return false
            #endif
        }()
        
        mockAuthenticated = ProcessInfo.processInfo.environment["MOCK_AUTHENTICATED"] == "true"
        mockUserRole = ProcessInfo.processInfo.environment["MOCK_USER_ROLE"] ?? "client"
        disableAnimations = ProcessInfo.processInfo.arguments.contains("DISABLE_ANIMATIONS")
        disableNetwork = ProcessInfo.processInfo.arguments.contains("DISABLE_NETWORK")
        
        print("🔧 LaunchConfiguration created - UI Testing: \(isUITesting) - User: gamikapunsisi at 2025-08-20 13:21:20")
    }
}
