//
//  FancyCircles.swift
//  AnimationStudy
//
//  Created by 김영빈 on 2023/04/14.
//

// 간지나는 원
import SwiftUI

struct FancyCircles: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            ForEach(0..<6) { index in
                Circle()
                    .stroke(lineWidth: 1)
                    .foregroundColor(.blue)
                    .frame(width: 50, height: 50)
                    .scaleEffect(isAnimating ? 1.0 : 0.0)
                    .opacity(isAnimating ? 0.0 : 1.0)
                    .animation(Animation.easeOut(duration: 1.2).repeatForever(autoreverses: false).delay(Double(index) / 30))
            }
        }
        .onAppear {
            self.isAnimating = true
        }
    }
}

struct FancyCircles_Previews: PreviewProvider {
    static var previews: some View {
        FancyCircles()
    }
}
