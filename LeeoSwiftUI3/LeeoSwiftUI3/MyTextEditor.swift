//
//  MyTextEditor.swift
//  LeeoSwiftUI3
//
//  Created by 김영빈 on 2023/03/26.
//

/* TextEditor (장문의 글 입력하기) */
import SwiftUI

struct MyTextEditor: View {
    @State var inputText: String = "default"
    var body: some View {
        TextEditor(text: $inputText)
            .padding()
            .background(.green)
            .foregroundColor(.orange)
            .frame(height: 300)
            .multilineTextAlignment(.center) // 텍스트 입력 정렬하기
            .onChange(of: inputText) { newValue in // 텍스트 입력 값이 변할 때마다 호출
                print(newValue)
            }
    }
}

struct MyTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        MyTextEditor()
    }
}
