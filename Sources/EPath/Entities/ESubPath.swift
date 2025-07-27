//
//  ESubPath.swift
//  SwiftUI26
//
//  Created by Илья Аникин on 17.07.2025.
//

import SwiftUI

/// Sub path component of ``EPath``. Represents a single closed path.
///
/// Sub path must respects the rules:
/// - Starts with **.moveToLine**
/// - Ends with **.closePath**
/// - Icludes at least 3 components
///
public struct ESubPath: Sendable {
    private(set) var elements: [EPathElement] = []
    
    public init(elements: [EPathElement] = []) {
        self.elements = elements
        initPostProcess()
    }
    
    public init(cgPath: CGPath) {
        cgPath.applyWithBlock { pointer in
            let node = pointer.pointee
            switch node.type {
            case .moveToPoint:
                elements.append(
                    EPathElement(type: .moveToPoint, point: node.points[0])
                )
            case .addLineToPoint:
                elements.append(
                    EPathElement(type: .addLineToPoint, point: node.points[0])
                )
            case .addQuadCurveToPoint:
                elements.append(
                    EPathElement(
                        type: .addQuadCurveToPoint,
                        points: [
                            node.points[0], //control
                            node.points[1]  //destination
                        ]
                    )
                )
            case .addCurveToPoint:
                elements.append(
                    EPathElement(
                        type: .addCurveToPoint,
                        points: [
                            node.points[0], //control 1
                            node.points[1], //control 2
                            node.points[2]  //destination
                        ]
                    )
                )
            case .closeSubpath:
                elements.append(EPathElement(type: .closeSubpath, points: []))
            @unknown default:
                break
            }
        }
        
        initPostProcess()
    }
    
    /// Returns a **thinned** representation of this ``ESubPath``.
    ///
    /// *Thinning* means that all small elements of a path will be merged into one
    /// with respect to figure's general form. An element is considered small, if its
    /// *vector length* is lesser than **minLength**.
    ///
    public func thinned(minLength: CGFloat = 1) -> ESubPath {
        var thinned: [EPathElement] = Array(elements.prefix(1))
        
        let count = elements.count
        var i = 1   //skip first .moveToPoint
        
        while i < count-1 {
            let nextIndex = findNextLongElement(from: i+1, minLength: minLength)
            
            if nextIndex == i+1 {
                thinned.append(elements[i])
                i += 1
            } else {
                if let intersection = destinationLine(forIndex: i).intersection(with: startLine(forIndex: nextIndex)) {
                    thinned.append(elements[i].copyWithNewDestination(to: intersection))
                } else {
                    thinned.append(elements[i])
                }
                
                i = nextIndex
            }
        }
        
        thinned.append(.close)
        
        return ESubPath(elements: thinned)
    }
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        
        for element in elements {
            switch element.type {
            case .moveToPoint:
                path.move(to: element.points[0])
            case .addLineToPoint:
                path.addLine(to: element.points[0])
            case .addQuadCurveToPoint:
                path.addQuadCurve(to: element.points[1], control: element.points[0])
            case .addCurveToPoint:
                path.addCurve(
                    to: element.points[2],
                    control1: element.points[0],
                    control2: element.points[1]
                )
            case .closeSubpath:
                path.closeSubpath()
            }
        }
        
        return path
    }
}

private extension ESubPath {
    /// Finds element with bigger or equal *vector length* starting from **index**(including **index**'s element).
    /// Returns **index** if no such elements were found.
    func findNextLongElement(from index: Int, minLength: CGFloat) -> Int {
        guard index - 1 >= 0 else { return index }
        
        var i = index
        
        while i < elements.count {
            if CGVector(p1: elements[i-1].destination, p2: elements[i].destination).length >= minLength {
                return i
            }
            
            i += 1
        }
        
        return index
    }
    
    mutating func initPostProcess() {
        // closePath -> line to first element + closePath
        guard
            elements.count >= 3,
            elements[0].type != .closeSubpath,
            elements.last?.type == .closeSubpath
        else {
            return
        }

        let end = startPoint(forIndex: 0)
        let start = elements[elements.count-2].destination
        
        guard CGVector(p1: start, p2: end).length > 1 else { return }
        
        elements.replace(
            at: elements.endIndex - 1,
            with: EPathElement(type: .addLineToPoint, point: end)
        )
        elements.append(EPathElement(type: .closeSubpath, points: []))
    }
}

public extension ESubPath {
    func startPoint(forIndex index: Int) -> CGPoint {
        destionationPoint(forIndex: (index - 1 >= 0 ? index - 1 : elements.count - 1 ))
    }
    
    func destionationPoint(forIndex index: Int) -> CGPoint {
        switch elements[index].type {
        case .moveToPoint:
            elements[index].points[0]
        case .addLineToPoint:
            elements[index].points[0]
        case .addQuadCurveToPoint:
            elements[index].points[1]
        case .addCurveToPoint:
            elements[index].points[2]
        case .closeSubpath:
            index + 1 >= elements.count ? elements[0].points[0] : elements[index + 1].points[0]
        }
    }
    
    func startVector(forIndex index: Int) -> CGVector {
        let prev = destionationPoint(forIndex: index - 1 >= 0 ? index - 1 : elements.count - 1)

        switch elements[index].type {
        case .addLineToPoint:
            return CGVector(
                dx: elements[index].points[0].x - prev.x,
                dy: elements[index].points[0].y - prev.y
            )
        case .addQuadCurveToPoint:
            return CGVector(
                dx: elements[index].points[0].x - prev.x,
                dy: elements[index].points[0].y - prev.y
            )
        case .addCurveToPoint:
            return CGVector(
                dx: elements[index].points[0].x - prev.x,
                dy: elements[index].points[0].y - prev.y
            )
        case .closeSubpath:
            return CGVector(
                dx: startPoint(forIndex: 1).x - prev.x,
                dy: startPoint(forIndex: 1).y - prev.y
            )
        default:
            return .zero
        }
    }
    
    func destinationVector(forIndex index: Int) -> CGVector {
        switch elements[index].type {
        case .addLineToPoint:
            return startVector(forIndex: index)
        case .addQuadCurveToPoint:
            return CGVector(
                dx: elements[index].points[1].x - elements[index].points[0].x,
                dy: elements[index].points[1].y - elements[index].points[0].y
            )
        case .addCurveToPoint:
            return CGVector(
                dx: elements[index].points[2].x - elements[index].points[1].x,
                dy: elements[index].points[2].y - elements[index].points[1].y
            )
        case .closeSubpath:
            return startVector(forIndex: index)
        default:
            return .zero
        }
    }
    
    func startLine(forIndex index: Int) -> ELine {
        let prev = destionationPoint(forIndex: index - 1 >= 0 ? index - 1 : elements.count - 1)

        switch elements[index].type {
        case .moveToPoint:
            return .zero
        case .addLineToPoint:
            return ELine(from: prev, to: elements[index].destination)
        case .addQuadCurveToPoint:
            return ELine(from: prev, to: elements[index].points[0])
        case .addCurveToPoint:
            return ELine(from: prev, to: elements[index].points[0])
        case .closeSubpath:
            return ELine(from: prev, to: destionationPoint(forIndex: index))
        }
    }
    
    func destinationLine(forIndex index: Int) -> ELine {
        switch elements[index].type {
        case .moveToPoint:
            return .zero
        case .addLineToPoint:
            return startLine(forIndex: index).reversed()
        case .addQuadCurveToPoint:
            return ELine(from: elements[index].points[0], to: elements[index].points[1])
        case .addCurveToPoint:
            return ELine(from: elements[index].points[1], to: elements[index].points[2])
        case .closeSubpath:
            return startLine(forIndex: index).reversed()
        }
    }
}

// MARK: Draw
@available(iOS 15, macOS 12, *)
public extension ESubPath {
    func drawDestinations(
        in context: GraphicsContext,
        size: CGSize = .side(5),
        color: Color = .red
    ) {
        elements.forEach { el in
            context
                .fill(
                    Path { p in
                        p.addRect(
                            CGRect(
                                origin: CGPoint(
                                    x: el.destination.x - size.width / 2,
                                    y: el.destination.y - size.height / 2
                                ),
                                size: size
                            )
                        )
                    },
                    with: .color(color)
                )
        }
    }
    
    func drawWarnings(
        in context: GraphicsContext,
        minLength: CGFloat = 2,
        size: CGSize = CGSize(width: 5, height: 2),
        color: Color = .orange
    ) {
        for (i, curr) in elements.enumerated() {
            if i == 0 { continue }
            
            let len = CGVector(p1: elements[i-1].destination, p2: curr.destination).length
            if len <= minLength {
                context
                    .fill(
                        Path { p in
                            p.addRect(
                                CGRect(
                                    origin: CGPoint(
                                        x: curr.destination.x - size.width / 2,
                                        y: curr.destination.y - size.height / 2
                                    ),
                                    size: size
                                )
                            )
                        },
                        with: .color(color)
                    )
            }
        }
    }
    
    func drawStarts(
        in context: GraphicsContext,
        size: CGSize = .side(3),
        color: Color = .red
    ) {
        if let first = elements.first?.destination {
            context.drawCross(at: first, size: size, color: color)
        }
    }
    
    func drawEnds(
        in context: GraphicsContext,
        size: CGSize = .side(3),
        color: Color = .blue
    ) {
        if elements.count > 3 {
            context.drawCross(at: elements[elements.count-3].destination, size: size, color: color)
        }
    }
}

// MARK: - Analyse
extension ESubPath: CustomStringConvertible {
    public var description: String {
        elements.enumerated().map { "\($0.offset): \($0.element)" }.joined(separator: "\n")
    }
    
    public func analysisDescription(minLength: CGFloat = 1) -> String {
        var analysis = ""
        
        for (i, curr) in elements.enumerated() {
            if i == 0 { continue }
            
            let len = CGVector(p1: elements[i-1].destination, p2: curr.destination).length
            if len <= minLength {
                analysis += "\(i): \(elements[i])"
                    + " ⚠️ small! [\(String(format: "%.1f", len)) < \(String(format: "%.1f", minLength))]\n"
            }
        }
        
        return analysis
    }
}

// MARK: Rounding
extension ESubPath {
    /// Returns a **rounded** representation of this ``ESubPath``.
    ///
    /// *Rounding* means that every vertex of a figure will be replaced by
    /// quad bezier curve with given **radius** according to **rule**.
    ///
    /// - Note: Call``ESubPath/thinned(minLength:)`` before rounding to
    /// prevent small elements from interfering a rounding process.
    ///
    public func rounded(radius: CGFloat, rule: ERoundingRule = .all) -> ESubPath {
        guard elements.count > 3 else { return self }
        guard
            elements[0].type == .moveToPoint,
            elements[elements.count-1].type == .closeSubpath
        else {
            print("🛑 subpath rounding is not possible")
            return self
        }
        
        var pathElements: [EPathElement] = []
        
        for (i, curr) in elements.enumerated() {
            let iPrev = i-1 >= 0 ? i-1 : elements.count-1
            let iNext = i+1 < elements.count ? i+1 : 0

            let next = elements[iNext]
            
            if curr.type == .moveToPoint {
                pathElements.append(curr)
                continue
            }
            
            if next.type == .closeSubpath { continue }
            
            if curr.type == .closeSubpath {
                closeWithRound(pathElements: &pathElements, fromIndex: iPrev, radius: radius, rule: rule)
                break
            }
            
            pathElements.append(
                contentsOf: round(prevIndex: i, nextIndex: iNext, radius: radius, rule: rule)
            )
        }
        
        return ESubPath(elements: pathElements)
    }
    
    private func round(
        prevIndex: Int,
        nextIndex: Int,
        radius: CGFloat,
        rule: ERoundingRule
    ) -> [EPathElement] {
        let curr = self.elements[prevIndex]
        let next = self.elements[nextIndex]
        
        // turn detection
        let ao = self.destinationVector(forIndex: prevIndex)
        let ob = self.startVector(forIndex: nextIndex )
        let turn = CGVector.cross(ao, ob)
        
//        let turnStr = switch turn {
//        case let x where x > 0: "right"
//        case let x where x < 0: "left"
//        default: "colinear"
//        }
//        let angle = "\(String(format: "%.1f", CGVector.angle(from: ao, to: ob) * 180.0 / CGFloat.pi))˚"
//        print("\(curr): \(turnStr) [\(angle)]")
//
//        guard turn > 0 else {
//            return [curr]
//        }

        guard rule.validate(turn) else {
            return [curr]
        }
        
        // skip curves turn if it is lesser than 10˚
        if
            curr.isCurve, next.isCurve,
            abs(CGVector.angle(from: ao, to: ob)) < 0.17
        {
            return [curr]
        }
        
        let a: CGPoint = self.startPoint(forIndex: prevIndex)
        let o: CGPoint = self.destionationPoint(forIndex: prevIndex)
        let b: CGPoint = self.destionationPoint(forIndex: nextIndex)
        
        // right turn rounding
        var roundedElements: [EPathElement] = []
        
        //begin
        switch curr.type {
        case .addLineToPoint:
            roundedElements.append(
                EPathElement(
                    type: .addLineToPoint,
                    point: ELine(from: a, to: o).point(distanceFromEnd: radius)
                )
            )
        case .addQuadCurveToPoint:
            let newCurEnd = QuadBezier(
                from: a,
                control: curr.points[0],
                to: o
            )
            .point(fromEnd: radius)
            
            roundedElements.append(
                EPathElement(
                    type: .addQuadCurveToPoint,
                    points: [curr.points[0], newCurEnd]
                )
            )
        case .addCurveToPoint:
            let newCurEnd = CubicBezier(
                from: a,
                control1: curr.points[0],
                control2: curr.points[1],
                to: o
            )
            .point(fromEnd: radius)

            roundedElements.append(
                EPathElement(
                    type: .addCurveToPoint,
                    points: [
                        curr.points[0],
                        curr.points[1],
                        newCurEnd
                    ]
                )
            )
        default:
            roundedElements = [curr]
        }
        
        //end
        switch next.type {
        case .addLineToPoint:
            roundedElements.append(
                EPathElement(
                    type: .addQuadCurveToPoint,
                    points: [
                        o,
                        ELine(from: o, to: b).point(distanceFromStart: radius)
                    ]
                )
            )
        case .addQuadCurveToPoint:
            let newNextStart = QuadBezier(
                from: o,
                control: next.points[0],
                to: b
            )
            .point(atLength: radius)
            
            roundedElements.append(
                EPathElement(
                    type: .addQuadCurveToPoint,
                    points: [o, newNextStart]
                )
            )
        case .addCurveToPoint:
            let newNextStart = CubicBezier(
                from: o,
                control1: next.points[0],
                control2: next.points[1],
                to: b
            )
            .point(atLength: radius)
            
            roundedElements.append(
                EPathElement(
                    type: .addQuadCurveToPoint,
                    points: [o, newNextStart]
                )
            )
        default:
            roundedElements = [curr]
        }
        
        return roundedElements
    }
    
    private func closeWithRound(
        pathElements: inout [EPathElement],
        fromIndex iPrev: Int,
        radius: CGFloat,
        rule: ERoundingRule
    ) {
        var iNext: Int? = nil

        var j = 0
        while j < elements.count {
            if elements[j].type != .moveToPoint, elements[j].type != .closeSubpath {
                iNext = j
                break
            }
            
            j += 1
        }
        
        guard let iNext else {
            pathElements.append(EPathElement(type: .closeSubpath, points: []))
            return
        }
        
        var closingSequence = round(prevIndex: iPrev, nextIndex: iNext, radius: radius, rule: rule)
        if closingSequence.count > 1 {
            pathElements.replace(
                at: 0,
                with: EPathElement(type: .moveToPoint, point: closingSequence.last!.destination)
            )
            
            closingSequence.append(EPathElement(type: .closeSubpath, points: []))
        }
        
        pathElements.append(contentsOf: closingSequence)
    }
}
