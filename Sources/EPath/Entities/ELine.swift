//
//  ELine.swift
//  SwiftUI26
//
//  Created by Илья Аникин on 25.07.2025.
//

import Foundation

public struct ELine: Sendable {
    public static let zero = ELine(from: .zero, to: .zero)
    
    public let from: CGPoint
    public let to: CGPoint
    
    public init(from: CGPoint, to: CGPoint) {
        self.from = from
        self.to = to
    }
    
    public func reversed() -> ELine {
        ELine(from: to, to: from)
    }
    
    public var vector: CGVector {
        CGVector(p1: from, p2: to)
    }
}

public extension ELine {
    func intersection(with line: ELine) -> CGPoint? {
        let p1 = self.from
        let p2 = self.to
        let p3 = line.from
        let p4 = line.to
        
        let a1 = p2.y - p1.y
        let b1 = p1.x - p2.x
        let c1 = a1 * p1.x + b1 * p1.y

        let a2 = p4.y - p3.y
        let b2 = p3.x - p4.x
        let c2 = a2 * p3.x + b2 * p3.y

        let determinant = a1 * b2 - a2 * b1

        //if lines are parallel
        if abs(determinant) < .ulpOfOne {
            return nil
        }

        let x = (b2 * c1 - b1 * c2) / determinant
        let y = (a1 * c2 - a2 * c1) / determinant
        return CGPoint(x: x, y: y)
    }
    
    func point(distanceFromEnd distance: CGFloat) -> CGPoint {
        let vector = CGVector(p1: from, p2: to).normalized
        
        return CGPoint(
            x: to.x - vector.dx * distance,
            y: to.y - vector.dy * distance
        )
    }
    
    func point(distanceFromStart distance: CGFloat) -> CGPoint {
        let vector = CGVector(p1: from, p2: to).normalized
        
        return CGPoint(
            x: from.x + vector.dx * distance,
            y: from.y + vector.dy * distance
        )
    }
}

extension ELine: CustomStringConvertible {
    public var description: String {
        "from \(from) to \(to)"
    }
}
