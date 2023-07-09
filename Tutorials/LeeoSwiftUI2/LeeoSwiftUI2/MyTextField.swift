//
//  MyTextField.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/26.
//

/* TextField (글자 입력 받기) */
import SwiftUI

struct MyTextField: View {
    @State var userID: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("ID")
                Text(userID)
            }
            TextField("Enter your ID", text: $userID)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
    }
}

struct MyTextField_Previews: PreviewProvider {
    static var previews: some View {
        MyTextField()
    }
}
