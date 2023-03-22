//
//  CircleImage.swift
//  LandmarksKybeen
//
//  Created by 김영빈 on 2023/03/19.
//

// 랜드마크 원형 이미지 뷰
import SwiftUI

struct CircleImage: View {
    var image: Image
    
    var body: some View {
        image
            .resizable() // 프레임 크기 지정 가능해짐
            .clipShape(Circle()) // 원 모양
            .overlay {
                Circle().stroke(.white, lineWidth: 4) // 원 겹치기
            }
            .shadow(radius: 7) // 그림자
            .frame(width: 200,height: 200)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("효자시장"))
    }
}
