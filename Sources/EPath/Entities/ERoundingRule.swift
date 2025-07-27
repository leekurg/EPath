//
//  ERoundingRule.swift
//  SwiftUI26
//
//  Created by Илья Аникин on 26.07.2025.
//

import Foundation

/// Retermines which figure's vertex will be rounded.
public enum ERoundingRule: Sendable {
    /// Rounding left turn in vertex
    case left
    /// Rounding right turn in vertex
    case right
    /// Rounding all turns
    case all
    
    public func validate(_ vectorCross: CGFloat) -> Bool {
        switch self {
        case .left:
            vectorCross < 0
        case .right:
            vectorCross > 0
        case .all:
            vectorCross != 0
        }
    }
}
