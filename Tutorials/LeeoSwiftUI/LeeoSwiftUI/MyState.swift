//
//  MyState.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* @State */
import SwiftUI

struct MyState: View {
    @State var name: String = ""
    
    var body: some View {
        VStack {
            Text("Hi \(name)")
            
            Button {
                name = "Kybeen!" // State변수인 name의 값이 바뀐다.
            } label: {
                Text("Click")
            }
        }
    }
}

struct MyState_Previews: PreviewProvider {
    static var previews: some View {
        MyState()
    }
}
