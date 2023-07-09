//
//  MyShape.swift
//  LeeoSwiftUI3
//
//  Created by 김영빈 on 2023/03/26.
//

/* 도형 그리기 (Shape) */
import SwiftUI

struct MyShape: View {
    var body: some View {
//        RoundedRectangle(cornerRadius: 30)
//        Ellipse()
//        Capsule()
        Circle()
            .foregroundColor(.green)
            .frame(height: 200)
    }
}

struct MyShape_Previews: PreviewProvider {
    static var previews: some View {
        MyShape()
    }
}
