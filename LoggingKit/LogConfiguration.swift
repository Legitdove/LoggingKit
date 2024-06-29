//
//  LogConfiguration.swift
//  LoggingKit
//
//  Created by Jacob Brewer on 6/29/24.
//

import Foundation

public struct LogConfiguration {
    public let subsystem: String
    public let minimumLogLevel: LogKit.LogLevel
    
    public init(subsystem: String, minimumLogLevel: LogKit.LogLevel) {
        self.subsystem = subsystem
        self.minimumLogLevel = minimumLogLevel
    }
}
