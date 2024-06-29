//
//  LogCategory.swift
//  LoggingKit
//
//  Created by Jacob Brewer on 6/29/24.
//

import Foundation

public protocol LogCategory: CaseIterable, RawRepresentable, Hashable where RawValue == String {
    static var defaultCategory: Self { get }
}
