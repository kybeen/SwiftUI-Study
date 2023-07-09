//
//  MyButton.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* Button */
import SwiftUI

struct MyButton: View {
    var body: some View {
        Button {
            print("Hited2") // action : 눌렀을 때의 동작 내용
        } label: { // label : View의 형태를 넣어줄 수 있음 (Text, Image 등등...)
            Text("kybeen")
                // modifier의 순서도 중요함
                .padding()
                .frame(width: 150)
                .background(.purple)
                .cornerRadius(13)
        }
        
//        Button("Delete", role: .destructive) {
//            print("deleted!")
//        }
    }
}

struct MyButton_Previews: PreviewProvider {
    static var previews: some View {
        MyButton()
    }
}
