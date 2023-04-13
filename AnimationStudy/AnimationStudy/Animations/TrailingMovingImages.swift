//
//  TrailingMovingImages.swift
//  AnimationStudy
//
//  Created by 김영빈 on 2023/04/14.
//

import SwiftUI

struct TrailingMovingImages: View {
    @State private var offset: CGFloat = UIScreen.main.bounds.width
    
    var images = ["person", "bolt", "heart", "star", "cloud"]
    
    var body: some View {
        NavigationView {
            HStack {
                ForEach(0..<images.count) { i in
                    Image(systemName: images[i])
                        .resizable()
                        .frame(width: 100, height: 100)
                        .offset(x: offset + CGFloat(i * 100))
                }
            }
            .onAppear {
                withAnimation(Animation.linear(duration: 15.0).repeatForever(autoreverses: false)) {
                    offset = -UIScreen.main.bounds.width - CGFloat((images.count - 1) * 100)
                }
            }
            .padding()
        }
        .navigationViewStyle(.stack)
        .navigationBarHidden(true)
    }
}

struct TrailingMovingImages_Previews: PreviewProvider {
    static var previews: some View {
        TrailingMovingImages()
    }
}
