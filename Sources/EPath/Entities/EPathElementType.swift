//
//  EPathElementType.swift
//  SwiftUI26
//
//  Created by Илья Аникин on 23.07.2025.
//

public enum EPathElementType: Sendable {
    case moveToPoint
    case addLineToPoint
    /// Points: control, destination
    case addQuadCurveToPoint
    /// Points: control1, control2, destination
    case addCurveToPoint
    case closeSubpath
}
