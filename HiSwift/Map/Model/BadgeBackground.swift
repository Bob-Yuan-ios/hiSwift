//
//  BadgeBackground.swift
//  HiSwift
//
//  Created by Bob on 2024/11/2.
//

import SwiftUI

struct BadgeBackground: View {
    var body: some View {
        Path{ path in
            var width: CGFloat = 100
            let height = width
            path.move(to: CGPoint(
                x: width * 0.95,
                y: height * (0.2 + HexagonParameters.adjustment)
            ))
            
            HexagonParameters.segments.forEach { segment in
                path.addLine(to: CGPoint(
                    x: width * segment.line.x,
                    y: height * segment.line.y
                ))
                
                path.addQuadCurve(to: CGPoint(
                    x: width * segment.curve.x,
                    y: height * segment.curve.y
                ), control: CGPoint(
                    x: width * segment.control.x,
                    y: height * segment.control.y
                ))
            }
        }
        .fill(.linearGradient(
            Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 0.6))
        )
    }
    
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)

}

#Preview {
    BadgeBackground()
}
