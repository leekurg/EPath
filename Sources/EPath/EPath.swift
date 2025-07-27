//
//  EPath.swift
//  SwiftUI26
//
//  Created by Илья Аникин on 23.07.2025.
//

import CoreGraphics
import Foundation
import SwiftUI

///Represents a general path of 2D form.
///
///A ``EPath`` does not have any direct drawable elements, instead, it includes
///a collection if ``ESubPath`` components to operate with.
///
/// Usage
///-----------
///You can create a ``EPath`` with a ``CGPath`` instance or by passing a collection of
///``ESubPath``s.
///A **cgPath** property returns a ``CGPath`` representation of this ``EPath`` to further
///utilization within SDK's frameworks.
///
public struct EPath {
    private(set) var subPaths: [ESubPath] = []
    
    public init(subPaths: [ESubPath] = []) {
        self.subPaths = subPaths
    }
    
    public init(cgPath: CGPath) {
        var elements: [EPathElement] = []
        
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
                subPaths.append(ESubPath(elements: elements))
                elements.removeAll(keepingCapacity: true)
            @unknown default:
                break
            }
        }
    }
    
    public var cgPath: CGPath {
        subPaths.reduce(into: CGMutablePath()) { cgPath, subPath in
            cgPath.addPath(subPath.cgPath)
        }
    }
    
    /// Returns a **rounded** representation of this ``EPath``.
    ///
    /// *Rounding* means that every vertex of a figure will be replaced by
    /// quad bezier curve with given **radius** according to **rule**.
    /// Rounding is applied to every ``ESubPath`` separatly. Rounding of a subpath is possible
    /// if it is respecting the following rules:
    /// - Starts with **.moveToLine**
    /// - Ends with **.closePath**
    /// - Icludes at least 3 components
    ///
    /// - Note: During rounding process a ``ESubPath/thinned(minLength:)`` will be called for
    /// every subpath.
    ///
    public func rounded(radius: CGFloat, rule: ERoundingRule = .all) -> EPath {
        EPath(
            subPaths: subPaths.reduce(into: [ESubPath]()) { acc, subPath in
                acc.append(
                    subPath
                        .thinned(minLength: radius/2)
                        .rounded(radius: radius, rule: rule)
                )
            }
        )
    }
    
    /// Returns a **thinned** representation of this ``EPath``.
    ///
    /// *Thinning* means that all small elements of subpaths will be merged into one
    /// with respect to figure's general form. An element is considered small, if its
    /// *vector length* is lesser than **minLength**.
    ///
    public func thinned(minLength: CGFloat = 1) -> EPath {
        EPath(subPaths: subPaths.map { $0.thinned(minLength: minLength) })
    }
}

@available(iOS 15, macOS 12, *)
public extension EPath {
    /// Draws destination point for every element of this path.
    func drawDestinations(
        in context: GraphicsContext,
        size: CGSize = .side(5),
        color: Color = .red
    ) {
        subPaths.forEach { $0.drawDestinations(in: context, size: size, color: color) }
    }
    
    /// Draws destination point of every element of this path, which vector length is lesser than **minLength**.
    func drawWarnings(
        in context: GraphicsContext,
        minLength: CGFloat = 2,
        size: CGSize = CGSize(width: 5, height: 2),
        color: Color = .orange
    ) {
        subPaths.forEach { $0.drawWarnings(in: context, minLength: minLength, size: size, color: color) }
    }
    
    /// Draws start point of every subpath.
    func drawStarts(
        in context: GraphicsContext,
        size: CGSize = .side(3),
        color: Color = .red
    ) {
        subPaths.forEach { $0.drawStarts(in: context, size: size, color: color) }
    }
    
    /// Draws prelast destination point of every subpath.
    func drawEnds(
        in context: GraphicsContext,
        size: CGSize = .side(3),
        color: Color = .blue
    ) {
        subPaths.forEach { $0.drawEnds(in: context, size: size, color: color) }
    }
}

extension EPath: CustomStringConvertible {
    public var description: String {
        subPaths.enumerated().reduce("") { desc, element in
            desc + "SubPath #\(element.offset):\n\(element.element)\n"
        }
    }
    
    /// Returns an analysis of subpaths with list of elements with vector length lessser than **minLength**.
    public func analysisDescription(minLength: CGFloat = 1) -> String {
        subPaths.enumerated().reduce("") { desc, element in
            desc + "SubPath #\(element.offset):\n\(element.element.analysisDescription(minLength: minLength))\n"
        }
    }
}
