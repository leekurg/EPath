//
//  QuadBezier.swift
//  SwiftUI26
//
//  Created by Илья Аникин on 18.07.2025.
//

import Foundation

struct QuadBezier {
    let p0: CGPoint
    let p1: CGPoint
    let p2: CGPoint
    
    init(from p0: CGPoint, control p1: CGPoint, to p2: CGPoint) {
        self.p0 = p0
        self.p1 = p1
        self.p2 = p2
    }

    /// Computes point B(t) on the curve
    func B(t: CGFloat) -> CGPoint {
        let mt = 1 - t
        let x = mt * mt * p0.x + 2 * mt * t * p1.x + t * t * p2.x
        let y = mt * mt * p0.y + 2 * mt * t * p1.y + t * t * p2.y
        return CGPoint(x: x, y: y)
    }

    /// Numerically calculates an arc length from *0* to *t*
    func arcLength(to t: CGFloat, steps: Int = 20) -> CGFloat {
        var length: CGFloat = 0
        var prev = B(t: 0)
        let step = t / CGFloat(steps)
        
        for i in 1...steps {
            let curr = B(t: CGFloat(i) * step)
            length += hypot(curr.x - prev.x, curr.y - prev.y)
            prev = curr
        }
        
        return length
    }

    var totalLength: CGFloat { arcLength(to: 1) }

    /// Returns point on curve with given **atLength** form the curve's start
    func point(atLength len: CGFloat, steps: Int = 20, tolerance: CGFloat = 0.5) -> CGPoint {
        guard len > 0 else { return p0 }
        guard len < totalLength else { return p2 }

        var t0: CGFloat = 0
        var t1: CGFloat = 1
        var tm: CGFloat = 0.5

        for _ in 0..<steps {
            tm = (t0 + t1) / 2
            let d = arcLength(to: tm, steps: steps)
            if abs(d - len) < tolerance {
                break
            }
            if d < len {
                t0 = tm
            } else {
                t1 = tm
            }
        }
        return B(t: tm)
    }

    /// Returns point on curve with given **fromLength** form the curve's end
    func point(fromEnd len: CGFloat) -> CGPoint {
        point(atLength: totalLength - len)
    }
}
