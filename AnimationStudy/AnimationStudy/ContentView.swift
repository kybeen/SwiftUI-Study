//
//  ContentView.swift
//  AnimationStudy
//
//  Created by 김영빈 on 2023/04/12.
//

import SwiftUI

struct ContentView: View {
    @State var imgLocation: String = "Image 위치 : "
    @State var imgSize: String = "Image 크기 : "
    @State var offset = CGSize.zero

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .onAppear {
                        let frame = geometry.frame(in: .global)
                        print("Image 위치: (\(frame.minX), \(frame.minY))")
                        print("Image 크기: (\(frame.width), \(frame.height))")
                        imgLocation = "Image 위치: (\(frame.minX), \(frame.minY))"
                        imgSize = "Image 크기: (\(frame.width), \(frame.height))"
                    }

                Text(imgLocation)
                Text(imgSize)
            }
            .position(x: geometry.size.width/2, y: geometry.size.height/2)
            .offset(offset)
            .gesture(
                // 드래그 이벤트 처리
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { gesture in
                        offset = .zero
                    }
            )
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
