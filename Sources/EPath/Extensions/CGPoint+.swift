//
//  CGPoint+.swift
//  SwiftUI26
//
//  Created by Илья Аникин on 22.07.2025.
//

import Foundation

public extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    func formatted() -> String {
        "(\(String(format: "%.2f", x)), \(String(format: "%.2f", y)))"
    }
}
