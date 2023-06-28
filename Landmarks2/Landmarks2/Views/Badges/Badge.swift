//
//  Badge.swift
//  Landmarks2
//
//  Created by 김영빈 on 2023/06/28.
//

//  Badge.swift
import SwiftUI

struct Badge: View {
    var badgeSymbols: some View {
        // 배지 심볼을 회전시킵니다.
        ForEach(0..<8) { index in
            RotatedBadgeSymbol(
                angle: .degrees(Double(index) / Double(8)) * 360.0
            )
        }
        .opacity(0.5)
    }
    
    var body: some View {
        // 배지 심볼을 Z스택에서 배지 백그라운드보다 위에 둡니다.
        ZStack {
            BadgeBackground() // 배지 백그라운드
            
            // 주변의 지오메트리를 읽고 배지 심볼의 크기를 조절합니다.
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
