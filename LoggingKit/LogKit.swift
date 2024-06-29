//
//  LoggingKit.swift
//  LoggingKit
//
//  Created by Jacob Brewer on 6/29/24.
//

import Foundation
import os.log

public class LogKit {
    private static var configuration: LogConfiguration?
    private static var loggers: [AnyHashable: OSLog] = [:]
    private static var categoryType: Any.Type?
    
    public static func configure<Category: LogCategory>(with config: LogConfiguration, categoryType: Category.Type) {
        configuration = config
        self.categoryType = categoryType
        loggers = Dictionary(uniqueKeysWithValues: Category.allCases.map {
            ($0, OSLog(subsystem: config.subsystem, category: $0.rawValue))
        })
    }
    
    public enum LogLevel: Int {
        case debug = 0
        case info = 1
        case warning = 2
        case error = 3
        
        var osLogType: OSLogType {
            switch self {
            case .debug: return .debug
            case .info: return .info
            case .warning: return .error
            case .error: return .fault
            }
        }
    }
    
    public static func log<Category: LogCategory>(_ message: String, level: LogLevel, category: Category? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        guard let config = configuration else {
            fatalError("LoggingKit not configured. Call LoggingKit.configure(with:categoryType:) before using.")
        }
        
        guard level.rawValue >= config.minimumLogLevel.rawValue else { return }
        
        let categoryToUse = category ?? (Category.defaultCategory as! Category)
        guard let log = loggers[categoryToUse] else {
            fatalError("Undefined log category: \(categoryToUse)")
        }
        
        let logMessage = "[\(level)] [\(sourceFileName(filePath: file)):\(line)] \(function) - \(message)"
        os_log(level.osLogType, log: log, "%{public}@", logMessage)
    }
    
    public static func debug<Category: LogCategory>(_ message: String, category: Category? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, category: category, file: file, function: function, line: line)
    }
    
    public static func info<Category: LogCategory>(_ message: String, category: Category? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, category: category, file: file, function: function, line: line)
    }
    
    public static func warning<Category: LogCategory>(_ message: String, category: Category? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, category: category, file: file, function: function, line: line)
    }
    
    public static func error<Category: LogCategory>(_ message: String, category: Category? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, category: category, file: file, function: function, line: line)
    }
    
    private static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
