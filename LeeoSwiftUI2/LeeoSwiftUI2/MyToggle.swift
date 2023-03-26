//
//  MyToggle.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/26.
//

/* Toggle (값 변경 스위치) */
import SwiftUI

struct MyToggle: View {
    @State var isLightOn: Bool = false
    
    var body: some View {
        Toggle(isOn: $isLightOn) {
            isLightOn ? Text("Light On") : Text("Light Off")
        }
        .toggleStyle(.switch) // 토글 스타일 설정
        .tint(.blue) // 토글 색 설정
        .padding()
    }
}

struct MyToggle_Previews: PreviewProvider {
    static var previews: some View {
        MyToggle()
    }
}
