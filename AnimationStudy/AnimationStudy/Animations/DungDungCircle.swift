//
//  DungDungCircle.swift
//  AnimationStudy
//
//  Created by 김영빈 on 2023/04/14.
//

// 원이 둥둥거리는 효과
import SwiftUI

struct DungDungCircle: View {
    @State private var shouldAnimate = false // 애니메이션 효과 On/Off 스위치
    
    var body: some View {
        RadialGradient(
            gradient: Gradient(colors: [.white, .blue]),
            center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
            startRadius: 5,
            endRadius: 50
        )
        .frame(width: 100, height: 100)
        .clipShape(Circle())
        .opacity(0.3)
        .scaleEffect(shouldAnimate ? 1.5 : 1) // 크기 변화 애니메이션
        .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true))
        .onAppear {
            self.shouldAnimate = true
        }
    }
}

struct DungDungCircle_Previews: PreviewProvider {
    static var previews: some View {
        DungDungCircle()
    }
}



