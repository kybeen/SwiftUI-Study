//
//  RotateBadgeSymbol.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/14.
//

//  RotatedBadgeSymbol.swift
import SwiftUI

struct RotatedBadgeSymbol: View {
    let angle: Angle
    
    var body: some View {
        BadgeSymbol()
            .padding(-60)
            .rotationEffect(angle, anchor: .bottom)
    }
}

struct RotateBadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        RotatedBadgeSymbol(angle: Angle(degrees: 5))
    }
}
