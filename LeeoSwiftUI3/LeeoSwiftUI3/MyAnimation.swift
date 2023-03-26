//
//  MyAnimation.swift
//  LeeoSwiftUI3
//
//  Created by 김영빈 on 2023/03/26.
//

/* Animation (움직임 만들기) */
import SwiftUI

struct MyAnimation: View {
    @State var isLighting: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: "cloud")
                .offset(y: -200)
            
            HStack {
                Image(systemName: "bolt")
                    .rotationEffect(isLighting ? .degrees(0) : .degrees(540)) // 회전 효과
                    .offset(y: isLighting ? 0 : -200) // 오프셋 설정
                    .padding()
                    .animation(.easeIn(duration: 3), value: isLighting) // 애니메이션 적용
                Image(systemName: "bolt")
                    .rotationEffect(isLighting ? .degrees(0) : .degrees(540))
                    .offset(y: isLighting ? 0 : -200)
                    .padding()
                    .animation(.easeOut(duration: 3), value: isLighting)
                Image(systemName: "bolt")
                    .rotationEffect(isLighting ? .degrees(0) : .degrees(540))
                    .offset(y: isLighting ? 0 : -200)
                    .padding()
                    .animation(.easeInOut(duration: 3), value: isLighting)
            }
            
            Button {
                isLighting.toggle()
            } label: {
                Text("Click")
            }

        }
    }
}

struct MyAnimation_Previews: PreviewProvider {
    static var previews: some View {
        MyAnimation()
    }
}
