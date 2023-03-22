//
//  RotateBadgeSymbol.swift
//  LandmarksKybeen
//
//  Created by 김영빈 on 2023/03/22.
//

import SwiftUI

// 회전 효과가 적용된 심볼
struct RotateBadgeSymbol: View {
    let angle: Angle
    
    var body: some View {
        BadgeSymbol()
            .padding(-60)
            .rotationEffect(angle, anchor: .bottom)
    }
}

struct RotateBadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        RotateBadgeSymbol(angle: Angle(degrees: 5))
    }
}
