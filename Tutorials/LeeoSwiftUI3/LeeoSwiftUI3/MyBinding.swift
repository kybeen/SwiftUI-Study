//
//  MyBinding.swift
//  LeeoSwiftUI3
//
//  Created by 김영빈 on 2023/03/26.
//

/* @Binding (바인딩) */
import SwiftUI

struct MyBinding: View {
    @State var isTurnedOn = false
    @State var textValue = ""
    
    var body: some View {
        VStack {
            Toggle(isOn: $isTurnedOn) { // 바인딩 변수 $isTurnedOn 사용
                Text("스위치")
            }
            TextField("텍스트 입력", text: $textValue) // 바인딩 변수 $textValue 사용
        }
    }
}

struct MyBinding_Previews: PreviewProvider {
    static var previews: some View {
        MyBinding()
    }
}
