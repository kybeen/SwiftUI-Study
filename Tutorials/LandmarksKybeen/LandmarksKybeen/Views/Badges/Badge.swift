//
//  Badge.swift
//  LandmarksKybeen
//
//  Created by 김영빈 on 2023/03/22.
//

import SwiftUI

struct Badge: View {
    var badgeSymbols: some View {
        // 심볼 회전
        ForEach(0..<8) { index in
            RotateBadgeSymbol(
                angle: .degrees(Double(index) / Double(8)) * 360.0
            )
        }
        .opacity(0.5)
    }
    var body: some View {
        ZStack {
            BadgeBackground()
            
            GeometryReader { geometry in
                badgeSymbols
                    .scaleEffect(1.0 / 4.0, anchor: .top)
                    .position(x: geometry.size.width / 2.0, y: (3.0 / 4.0) * geometry.size.height)
            }
        }
        .scaledToFit()
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge()
    }
}
