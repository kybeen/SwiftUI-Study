//
//  MyColorHex.swift
//  LeeoSwiftUI3
//
//  Created by 김영빈 on 2023/03/26.
//

/* ColorHex (디자이너가 주는 색상을 그려보기) */
import SwiftUI

struct MyColorHex: View {
    var body: some View {
        // 직접 추가한 컬러셋 사용하기 - #FFDE43
        //Color("DesignBackground")
        
        // RGB값으로 입력받기 - 255 222 67
        // Color(red: 255/255, green: 222/255, blue: 67/255)
        
        // 익스텐션을 만들어서 Hex값으로 색 사용하기
        Color(0xFFDE43)
    }
}

// Hex값을 입력받아서 색상을 보여줄 수 있는 Color 이니셜라이저를 만들어준다.
extension Color {
    init(_ hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double((hex >> 0) & 0xFF) / 255,
            opacity: alpha
        )
    }
}

struct MyColorHex_Previews: PreviewProvider {
    static var previews: some View {
        MyColorHex()
    }
}
