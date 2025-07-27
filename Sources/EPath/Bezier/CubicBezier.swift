//
//  CubicBezier.swift
//  SwiftUI26
//
//  Created by Илья Аникин on 23.07.2025.
//

import Foundation

struct CubicBezier {
    let p0: CGPoint
    let p1: CGPoint
    let p2: CGPoint
    let p3: CGPoint
    
    init(from p0: CGPoint, control1 p1: CGPoint, control2 p2: CGPoint, to p3: CGPoint) {
        self.p0 = p0
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
    }

    /// Computes point B(t) on the curve
    func B(t: CGFloat) -> CGPoint {
        let mt = 1 - t
        let mt2 = mt * mt
        let t2 = t * t

        let x = mt2 * mt * p0.x
              + 3 * mt2 * t * p1.x
              + 3 * mt * t2 * p2.x
              + t2 * t * p3.x

        let y = mt2 * mt * p0.y
              + 3 * mt2 * t * p1.y
              + 3 * mt * t2 * p2.y
              + t2 * t * p3.y

        return CGPoint(x: x, y: y)
    }
    
    var totalLength: CGFloat {
        arcLength(to: 1)
    }

    /// Numerically calculates an arc length from *0* to *t*
    func arcLength(to t: CGFloat, steps: Int = 20) -> CGFloat {
        var length: CGFloat = 0
        var prev = B(t: 0)
        let step = t / CGFloat(steps)
        for i in 1...steps {
            let ti = CGFloat(i) * step
            let curr = B(t: ti)
            length += hypot(curr.x - prev.x, curr.y - prev.y)
            prev = curr
        }
        return length
    }

    /// Returns point on curve with given **atLength** form the curve's start
    func point(atLength len: CGFloat, steps: Int = 20, tolerance: CGFloat = 0.5) -> CGPoint {
        guard len > 0 else { return p0 }
        guard len < totalLength else { return p3 }

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
