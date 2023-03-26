//
//  MyStack.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* VStack / HStack / ZStack / ScrollView */
import SwiftUI

struct MyStack: View {
    var body: some View {
        VStack {
            Text("1")
            Text("2")
            Text("3")
        }
        .frame(width: 100, height: 100, alignment: .leading)
        .background(.green)
    }
}

struct MyStack_Previews: PreviewProvider {
    static var previews: some View {
        MyStack()
    }
}
