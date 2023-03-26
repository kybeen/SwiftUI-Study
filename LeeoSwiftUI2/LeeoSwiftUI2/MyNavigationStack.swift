//
//  MyNavigationStack.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/26.
//

/* NavigationStack */
import SwiftUI

struct MyNavigationStack: View {
    var body: some View {
        NavigationStack {
            NavigationLink(value: 3) { // 다음 화면에 값을 넘겨줌
                Text("test3")
            }.navigationDestination(for: Int.self) { value in // 다음 화면에 값을 넘겨줌
                Text("Kybeen tried \(value) times")
            }
        }
    }
}

struct MyNavigationStack_Previews: PreviewProvider {
    static var previews: some View {
        MyNavigationStack()
    }
}
