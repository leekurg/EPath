//
//  ESubPath+.swift
//  SwiftUI26
//
//  Created by Илья Аникин on 26.07.2025.
//

import SwiftUI

public extension ESubPath {
    //    MARK: - Rect
    static func rect(_ o: CGPoint, size: CGSize = CGSize(width: 100, height: 200)) -> Self {
        ESubPath(
            elements: [
                .init(type: .moveToPoint, point: CGPoint(x: 0, y: size.height) + o),
                .init(type: .addLineToPoint, point: CGPoint(x: 0, y: 0) + o),
                .init(type: .addLineToPoint, point: CGPoint(x: size.width, y: 0) + o),
                .init(type: .addLineToPoint, point: CGPoint(x: size.width, y: size.height) + o),
                .init(type: .closeSubpath, points: [])
            ]
        )
    }
    
    //    MARK: - Top round rect
    static func topRoundRect(_ o: CGPoint) -> Self {
        ESubPath(
            elements: [
                EPathElement(type: .moveToPoint, point: CGPoint(x: 0, y: 200) + o),
                EPathElement(type: .addLineToPoint, point: CGPoint(x: 0, y: 50) + o),
                EPathElement(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: 50, y: 0) + o,
                        CGPoint(x: 100, y: 50) + o
                    ]
                ),
                EPathElement(type: .addLineToPoint, point: CGPoint(x: 100, y: 200) + o),
                EPathElement(type: .closeSubpath, points: [])
            ]
        )
    }

    //    MARK: - Cubok
    static func cubok(_ o: CGPoint) -> Self {
        ESubPath(
            elements: [
                EPathElement(type: .moveToPoint, point: CGPoint(x: 0, y: 200) + o),
                EPathElement(type: .addLineToPoint, point: CGPoint(x: 0, y: 150) + o),
                EPathElement(type: .addLineToPoint, point: CGPoint(x: 50, y: 150) + o),
                EPathElement(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: 50, y: 75) + o,
                        CGPoint(x: 25, y: 50) + o
                    ]
                ),
                EPathElement(
                    type: .addLineToPoint,
                    point: CGPoint(x: 100, y: 50) + o
                ),
                EPathElement(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: 75, y: 75) + o,
                        CGPoint(x: 75, y: 150) + o
                    ]
                ),
                EPathElement(
                    type: .addLineToPoint,
                    point: CGPoint(x: 125, y: 150) + o
                ),
                EPathElement(
                    type: .addLineToPoint,
                    point: CGPoint(x: 125, y: 200) + o
                ),
                EPathElement(type: .closeSubpath, points: [])
            ]
        )
    }
    
    //    MARK: - Diamond
    static func diamond(_ o: CGPoint) -> Self {
        ESubPath(
            elements: [
                .init(type: .moveToPoint, point: CGPoint(x: 100, y: 200) + o),
                .init(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: 100, y: 100) + o,
                        CGPoint(x: 0, y: 100) + o
                    ]
                ),
                .init(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: 100, y: 100) + o,
                        CGPoint(x: 100, y: 0) + o
                    ]
                ),
                .init(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: 100, y: 100) + o,
                        CGPoint(x: 200, y: 100) + o
                    ]
                ),
                .init(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: 100, y: 100) + o,
                        CGPoint(x: 100, y: 200) + o
                    ]
                ),
                .init(type: .closeSubpath, points: [])
            ]
        )
    }
   
    //    MARK: - Circle
    static func circle(_ o: CGPoint, size: CGSize = .side(200)) -> Self {
        ESubPath(
            elements: [
                .init(type: .moveToPoint, point: CGPoint(x: size.width/2, y: size.height) + o),
                .init(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: 0, y: size.height) + o,
                        CGPoint(x: 0, y: size.height/2) + o
                    ]
                ),
                .init(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: 0, y: 0) + o,
                        CGPoint(x: size.width/2, y: 0) + o
                    ]
                ),
                .init(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: size.width, y: 0) + o,
                        CGPoint(x: size.width, y: size.height/2) + o
                    ]
                ),
                .init(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: size.width, y: size.height) + o,
                        CGPoint(x: size.width/2, y: size.height) + o
                    ]
                ),
                .init(type: .closeSubpath, points: [])
            ]
        )
    }
    
    // MARK: - Santa stick
    static func santaStick(_ o: CGPoint) -> Self {
        ESubPath(
            elements: [
                .init(type: .moveToPoint, point: CGPoint(x: 150, y: 200) + o),
                .init(
                    type: .addLineToPoint,
                    point: CGPoint(x: 150, y: 100) + o
                ),
                .init(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: 100, y: 50) + o,
                        CGPoint(x: 50, y: 100) + o
                    ]
                ),
                .init(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: 20, y: 100) + o,
                        CGPoint(x: 30, y: 70) + o
                    ]
                ),
                .init(
                    type: .addQuadCurveToPoint,
                    points: [
                        CGPoint(x: 120, y: 10) + o,
                        CGPoint(x: 180, y: 100) + o
                    ]
                ),
                .init(
                    type: .addLineToPoint,
                    point: CGPoint(x: 180, y: 200) + o
                ),
                .init(type: .closeSubpath, points: [])
            ]
        )
    }
    
    // MARK: - Horse shoe
    static func horseshoe(_ o: CGPoint) -> ESubPath {
        ESubPath(
            elements: [
                .move(to: CGPoint(x: 100, y: 150) + o),
                .cubicCurve(
                    c1: CGPoint(x: 50, y: 150) + o,
                    c2: CGPoint(x: 0, y: 120) + o,
                    d: CGPoint(x: 0, y: 50) + o
                ),
                .quadCurve(
                    c: CGPoint(x: 12.5, y: 30) + o,
                    d: CGPoint(x: 24, y: 50) + o
                ),
                .cubicCurve(
                    c1: CGPoint(x: 25, y: 150) + o,
                    c2: CGPoint(x: 175, y: 150) + o,
                    d: CGPoint(x: 175, y: 50) + o
                ),
                .cubicCurve(
                    c1: CGPoint(x: 182, y: 40) + o,
                    c2: CGPoint(x: 192, y: 40) + o,
                    d: CGPoint(x: 200, y: 50) + o
                ),
                .line(to: CGPoint(x: 175, y: 125) + o),
                .close
            ]
        )
    }
}
