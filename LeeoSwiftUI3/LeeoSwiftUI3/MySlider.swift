//
//  MySlider.swift
//  LeeoSwiftUI3
//
//  Created by 김영빈 on 2023/03/26.
//

import SwiftUI

struct MySlider: View {
    @State var myPoint: Float = 50
    
    var body: some View {
        VStack {
            Text(myPoint.description)
            Slider(value: $myPoint, in: 0...100, step: 1) {
                Text("My Slider")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("100")
            }
            .tint(.orange)
        }
    }
}

struct MySlider_Previews: PreviewProvider {
    static var previews: some View {
        MySlider()
    }
}
