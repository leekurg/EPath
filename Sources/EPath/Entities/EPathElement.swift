//
//  EPathElement.swift
//  SwiftUI26
//
//  Created by Илья Аникин on 23.07.2025.
//

import Foundation

public struct EPathElement: Sendable {
    public let type: EPathElementType
    public let points: [CGPoint]
    
    public init(type: EPathElementType, points: [CGPoint]) {
        self.type = type
        self.points = points
    }
    
    public init(type: EPathElementType, point: CGPoint) {
        self.type = type
        self.points = [point]
    }
}

public extension EPathElement {
    var isCurve: Bool {
        switch type {
        case .addQuadCurveToPoint, .addCurveToPoint:
            return true
        default:
            return false
        }
    }
    
    var destination: CGPoint {
        switch type {
        case .moveToPoint: points[0]
        case .addLineToPoint: points[0]
        case .addQuadCurveToPoint: points[1]
        case .addCurveToPoint: points[2]
        case .closeSubpath: .zero
        }
    }
    
    func copyWithNewDestination(to: CGPoint) -> EPathElement {
        switch self.type {
        case .moveToPoint: .move(to: to)
        case .addLineToPoint: .line(to: to)
        case .addQuadCurveToPoint: .quadCurve(c: points[0], d: to)
        case .addCurveToPoint: .cubicCurve(c1: points[0], c2: points[1], d: to)
        case .closeSubpath: .close
        }
    }
}

public extension EPathElement {
    static func move(to point: CGPoint) -> EPathElement {
        EPathElement(type: .moveToPoint, point: point)
    }
    
    static func line(to point: CGPoint) -> EPathElement {
        EPathElement(type: .addLineToPoint, point: point)
    }
    
    static func quadCurve(c: CGPoint, d: CGPoint) -> EPathElement {
        EPathElement(type: .addQuadCurveToPoint, points: [c, d])
    }
    
    static func cubicCurve(c1: CGPoint, c2: CGPoint, d: CGPoint) -> EPathElement {
        EPathElement(type: .addCurveToPoint, points: [c1, c2, d])
    }
    
    static var close: EPathElement {
        EPathElement(type: .closeSubpath, points: [])
    }
}

extension EPathElement: CustomStringConvertible {
    public var description: String {
        switch type {
        case .moveToPoint: "move to \(points[0].formatted())"
        case .addLineToPoint: "line to \(points[0].formatted())"
        case .addCurveToPoint: "cubic curve to \(points[2].formatted())"
            + " [c1: \(points[0].formatted()), c2: \(points[1].formatted())]"
        case .addQuadCurveToPoint: "quad curve to \(points[1].formatted())"
            + " [c: \(points[0].formatted())"
        case .closeSubpath: "close subpath"
        }
    }
}
