//
//  CircleImage.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/13.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("turtlerock") // 이미지
            .clipShape(Circle()) // 원 모양으로 이미지 자르기
            .overlay {
                Circle().stroke(.white, lineWidth: 4) // 회색 원 추가해서 보더 넣어주기
            }
            .shadow(radius: 7) // 그림자
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
