//
//  BadgeBackground.swift
//  Landmarks2
//
//  Created by 김영빈 on 2023/06/28.
//

import SwiftUI

struct BadgeBackground: View {
    var body: some View {
        // 배지가 현재 뷰의 사이즈에 적절하게 들어오도록 Path를 GeometryReader로 감싸준다.
        GeometryReader { geometry in
            // Path를 사용하여 선, 곡선 등의 그림을 그리며 복잡한 도형을 그릴 수 있습니다.
            Path { path in
                var width: CGFloat = min(geometry.size.width, geometry.size.height)
                let height: CGFloat = width
                let xScale: CGFloat = 0.832
                let xOffset = (width * (1.0 - xScale)) / 2.0
                width *= xScale
                path.move( // move() 메서드로 지정한 범위를 그리며 도형을 만들 수 있습니다.
                    to: CGPoint(
                        x: width * 0.95 + xOffset,
                        y: height * (0.20 + HexagonParameters.adjustment)
                    )
                )
                
                HexagonParameters.segments.forEach { segment in
                    path.addLine( // addLine() 메서드는 한개의 포인트를 취해서 그려줍니다. 연속적으로 addLine() 메서드를 호출하면 이전 addLine()의 도착 포인트에서 그리기 시작합니다.
                        to: CGPoint(
                            x: width * segment.line.x + xOffset,
                            y: height * segment.line.y
                        )
                    )
                    
                    // addQuadCurve() 메서드를 사용해서 배지어 곡선을 그려줍니다.
                    path.addQuadCurve(
                        to: CGPoint(
                            x: width * segment.curve.x + xOffset,
                            y: height * segment.curve.y
                        ),
                        control: CGPoint(
                            x: width * segment.control.x + xOffset,
                            y: height * segment.control.y
                        )
                    )
                }
            }
            // 그라데이션 색 넣어주기
            .fill(.linearGradient(
                Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.6)
            ))
        }
        .aspectRatio(1, contentMode: .fit)
    }
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
}

struct BadgeBackground_Previews: PreviewProvider {
    static var previews: some View {
        BadgeBackground()
    }
}
