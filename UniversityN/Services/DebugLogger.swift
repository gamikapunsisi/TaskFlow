//
//  DebugLogger.swift
//  UniversityN
//
//  Comprehensive debugging and logging utility
//

import Foundation
import os.log

// MARK: - Log Categories
enum LogCategory: String, CaseIterable {
    case authentication = "Authentication"
    case network = "Network"
    case configuration = "Configuration"
    case firestore = "Firestore"
    case error = "Error"
    case userInterface = "UI"
    case validation = "Validation"
    case performance = "Performance"
    
    var subsystem: String {
        return "com.universityn.taskflow"
    }
    
    var osLog: OSLog {
        return OSLog(subsystem: subsystem, category: rawValue)
    }
}

// MARK: - Log Level
enum LogLevel: Int, CaseIterable {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
    case critical = 4
    
    var emoji: String {
        switch self {
        case .debug: return "🔍"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        case .critical: return "🚨"
        }
    }
    
    var osLogType: OSLogType {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        case .critical: return .fault
        }
    }
}

// MARK: - Log Entry
struct LogEntry {
    let timestamp: Date
    let level: LogLevel
    let category: LogCategory
    let message: String
    let file: String
    let function: String
    let line: Int
    let metadata: [String: Any]?
    
    var formattedMessage: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        let timeString = formatter.string(from: timestamp)
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        
        return "\(level.emoji) [\(timeString)] \(category.rawValue) | \(fileName):\(line) \(function) | \(message)"
    }
}

// MARK: - Debug Logger
class DebugLogger: ObservableObject {
    static let shared = DebugLogger()
    
    @Published var logs: [LogEntry] = []
    @Published var isEnabled: Bool = true
    @Published var currentLogLevel: LogLevel = .debug
    @Published var enabledCategories: Set<LogCategory> = Set(LogCategory.allCases)
    
    private let maxLogEntries: Int = 1000
    private let logQueue = DispatchQueue(label: "com.universityn.logger", qos: .utility)
    
    private init() {
        #if DEBUG
        isEnabled = true
        currentLogLevel = .debug
        #else
        isEnabled = false
        currentLogLevel = .warning
        #endif
    }
    
    // MARK: - Logging Methods
    func log(
        _ message: String,
        level: LogLevel = .info,
        category: LogCategory,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        metadata: [String: Any]? = nil
    ) {
        guard isEnabled && level.rawValue >= currentLogLevel.rawValue else { return }
        guard enabledCategories.contains(category) else { return }
        
        let entry = LogEntry(
            timestamp: Date(),
            level: level,
            category: category,
            message: message,
            file: file,
            function: function,
            line: line,
            metadata: metadata
        )
        
        logQueue.async { [weak self] in
            // Log to system
            os_log("%{public}@", log: category.osLog, type: level.osLogType, entry.formattedMessage)
            
            // Add to internal log
            DispatchQueue.main.async {
                self?.addLogEntry(entry)
            }
        }
    }
    
    private func addLogEntry(_ entry: LogEntry) {
        logs.append(entry)
        
        // Maintain log size limit
        if logs.count > maxLogEntries {
            logs.removeFirst(logs.count - maxLogEntries)
        }
    }
    
    // MARK: - Convenience Methods
    func debug(_ message: String, category: LogCategory, metadata: [String: Any]? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, category: category, file: file, function: function, line: line, metadata: metadata)
    }
    
    func info(_ message: String, category: LogCategory, metadata: [String: Any]? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, category: category, file: file, function: function, line: line, metadata: metadata)
    }
    
    func warning(_ message: String, category: LogCategory, metadata: [String: Any]? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, category: category, file: file, function: function, line: line, metadata: metadata)
    }
    
    func error(_ message: String, category: LogCategory, metadata: [String: Any]? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, category: category, file: file, function: function, line: line, metadata: metadata)
    }
    
    func critical(_ message: String, category: LogCategory, metadata: [String: Any]? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .critical, category: category, file: file, function: function, line: line, metadata: metadata)
    }
    
    // MARK: - Firebase Authentication Specific Logging
    func logAuthError(error: Error, operation: String, email: String? = nil) {
        var metadata: [String: Any] = [
            "operation": operation,
            "error_domain": (error as NSError).domain,
            "error_code": (error as NSError).code
        ]
        
        if let email = email {
            // Only log email domain for privacy
            let domain = email.components(separatedBy: "@").last ?? "unknown"
            metadata["email_domain"] = domain
        }
        
        error("Authentication error in \(operation): \(error.localizedDescription)", 
              category: .authentication, 
              metadata: metadata)
    }
    
    func logNetworkError(error: Error, endpoint: String, httpCode: Int? = nil) {
        var metadata: [String: Any] = [
            "endpoint": endpoint,
            "error_domain": (error as NSError).domain,
            "error_code": (error as NSError).code
        ]
        
        if let httpCode = httpCode {
            metadata["http_code"] = httpCode
        }
        
        error("Network error for \(endpoint): \(error.localizedDescription)",
              category: .network,
              metadata: metadata)
    }
    
    // MARK: - Log Management
    func clearLogs() {
        logQueue.async {
            DispatchQueue.main.async { [weak self] in
                self?.logs.removeAll()
            }
        }
    }
    
    func exportLogs() -> String {
        return logs.map { $0.formattedMessage }.joined(separator: "\n")
    }
    
    func getLogsForCategory(_ category: LogCategory) -> [LogEntry] {
        return logs.filter { $0.category == category }
    }
    
    func getLogsForLevel(_ level: LogLevel) -> [LogEntry] {
        return logs.filter { $0.level == level }
    }
    
    // MARK: - Configuration
    func toggleCategory(_ category: LogCategory) {
        if enabledCategories.contains(category) {
            enabledCategories.remove(category)
        } else {
            enabledCategories.insert(category)
        }
    }
    
    func enableAllCategories() {
        enabledCategories = Set(LogCategory.allCases)
    }
    
    func disableAllCategories() {
        enabledCategories.removeAll()
    }
}