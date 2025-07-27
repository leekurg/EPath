//
//  GraphicsContext+.swift
//  SwiftUI26
//
//  Created by Илья Аникин on 25.07.2025.
//

import SwiftUI

@available(iOS 15, macOS 12, *)
public extension GraphicsContext {
    func drawGrid(
        size: CGSize,
        step: CGFloat = 10,
        markStep: CGFloat = 50
    ) {
        let grid = Path { p in
            let step = abs(step)
            
            var y: CGFloat = 0
            
            while y < size.height {
                p.move(to: CGPoint(x: 0, y: y + step))
                p.addLine(to: CGPoint(x: size.width, y: y + step))
      
                y = y + step
            }
            
            var x: CGFloat = 0
            
            while x < size.width {
                p.move(to: CGPoint(x: x + step, y: 0))
                p.addLine(to: CGPoint(x: x + step, y: size.height))
      
                x = x + step
            }
        }

        self
            .stroke(
                grid,
                with: .color(.gray.opacity(0.5)),
                lineWidth: 0.5
            )
        
        //horizontal marks
        var x: CGFloat = 0
        
        while x < size.width {
            self
                .draw(
                    Text("\(Int(x + markStep))").font(.caption).foregroundColor(.secondary),
                    at: CGPoint(x: x + markStep, y: size.height - 10)
                )
            
            x += markStep
        }
        
        //vertical marks
        var y: CGFloat = 0
        
        while y < size.height {
            self
                .draw(
                    Text("\(Int(y + markStep))").font(.caption).foregroundColor(.secondary),
                    at: CGPoint(x: 15, y: y + markStep)
                )
            
            y += markStep
        }
    }
    
    func drawCross(at point: CGPoint, size: CGSize = .side(3), color: Color = .red, lineWidth: CGFloat = 1) {
        let path = Path { p in
            let dx = size.width / 2
            let dy = size.height / 2
            
            p.move(to: CGPoint(x: point.x - dx, y: point.y - dy))
            p.addLine(to: CGPoint(x: point.x + dx, y: point.y + dx))
            
            p.move(to: CGPoint(x: point.x - dx, y: point.y + dy))
            p.addLine(to: CGPoint(x: point.x + dx, y: point.y - dx))
            
            p.closeSubpath()
        }
        
        self
            .stroke(path, with: .color(color), lineWidth: lineWidth)
    }
}
