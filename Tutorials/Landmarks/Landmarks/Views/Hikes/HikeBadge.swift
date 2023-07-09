//
//  HikeBadge.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/17.
//

//  HikeBadge.swift
import SwiftUI

struct HikeBadge: View {
    var name: String
    
    var body: some View {
        VStack(alignment: .center) {
            // 배지는 렌더링되는 프레임의 크기에 따라 달라지기 때문에 300x300 크기의 프레임을 기준으로 렌더링되도록 고정?해줍니다.
            Badge()
                .frame(width: 300, height: 300)
                .scaleEffect(1.0 / 3.0)
                .frame(width: 100, height: 100)
            Text(name)
                .font(.caption)
                .accessibilityLabel("Badge for \(name).")
        }
    }
}

struct HikeBadge_Previews: PreviewProvider {
    static var previews: some View {
        HikeBadge(name: "Preview Testing")
    }
}
