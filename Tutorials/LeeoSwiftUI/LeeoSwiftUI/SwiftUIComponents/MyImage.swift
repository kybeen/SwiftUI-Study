//
//  MyImage.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* Image */
import SwiftUI

struct MyImage: View {
    var body: some View {
        Image("pig")
                // 사이즈 조절
            .resizable() // 크기 조절하려면 넣어줘야 함
            .aspectRatio(contentMode: .fit) // 비율 유지
            .frame(width: 200, height: 200) // 프레임 크기
            .background(.orange) // 배경 색
            .border(.blue, width: 2) // 경계선
    }
}

struct MyImage_Previews: PreviewProvider {
    static var previews: some View {
        MyImage()
    }
}
