//
//  CGVector+.swift
//  SwiftUI26
//
//  Created by Илья Аникин on 19.07.2025.
//

import Foundation

public extension CGVector {
    /// For Quartz coordinate axis, `n>0` - right, `n<0` - left, `n=0` - colinear.
    static func cross(_ v1: CGVector, _ v2: CGVector) -> CGFloat {
        v1.dx * v2.dy - v1.dy * v2.dx
    }
    
    /// Returns angle of turn from v1 to v2 in radians.
    static func angle(from v1: CGVector, to v2: CGVector) -> CGFloat {
        let cross = cross(v1, v2)
        let dot = v1.dx * v2.dx + v1.dy * v2.dy
        return atan2(cross, dot)
    }
}

public extension CGVector {
    init(p1: CGPoint, p2: CGPoint) {
        self.init(
            dx: p2.x - p1.x,
            dy: p2.y - p1.y
        )
    }
    
    var length: CGFloat {
        sqrt(dx * dx + dy * dy)
    }
    
    var normalized: CGVector {
        CGVector(dx: dx / length, dy: dy / length)
    }
}
