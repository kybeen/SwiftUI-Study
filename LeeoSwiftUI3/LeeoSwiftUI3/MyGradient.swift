//
//  MyGradient.swift
//  LeeoSwiftUI3
//
//  Created by 김영빈 on 2023/03/26.
//

/* Gradient (여러 가지 색상 연결하기 - 그라데이션) */
import SwiftUI

struct MyGradient: View {
    var body: some View {
        ZStack {
            // Linear Gradient
//            LinearGradient(gradient: Gradient(colors: [.red, .green, .blue]),
//                           startPoint: .topLeading,
//                           endPoint: .bottomTrailing)
//            .ignoresSafeArea()
            
            // Angular Gradient
//            AngularGradient(gradient: Gradient(colors: [Color.red, Color.blue]), center: .center)
            
            // Elliptical Gradient
            EllipticalGradient(colors:[Color.blue, Color.green], center: .center, startRadiusFraction: 0.0, endRadiusFraction: 0.5)

            Text("Hi")
        }
    }
}

struct MyGradient_Previews: PreviewProvider {
    static var previews: some View {
        MyGradient()
    }
}
