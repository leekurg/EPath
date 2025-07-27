//
//  CGSize+.swift
//  SwiftUI26
//
//  Created by Илья Аникин on 22.07.2025.
//

import Foundation

public extension CGSize {
    static func side(_ value: CGFloat) -> CGSize {
        CGSize(width: value, height: value)
    }
}
