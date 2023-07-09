//
//  MySecureField.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/26.
//

/* SecureField (암호화 된 입력값을 입력받기) */
import SwiftUI

struct MySecureField: View {
    @State var myPassword: String = ""
    @State var isSecureMode: Bool = true
    
    var body: some View {
        VStack {
            Text(myPassword)
            HStack {
                if isSecureMode { // isSecureMode의 값에 따라 SecureField와 TextField 사이에서 바뀐다.
                    SecureField("Password", text: $myPassword)
                        .textFieldStyle(.roundedBorder)
                } else {
                    TextField("Password", text: $myPassword)
                        .textFieldStyle(.roundedBorder)
                }
                Button {
                    isSecureMode.toggle()
                } label: {
                    Image(systemName: "eye")
                }
            }
            .padding()
        }
    }
}

struct MySecureField_Previews: PreviewProvider {
    static var previews: some View {
        MySecureField()
    }
}
