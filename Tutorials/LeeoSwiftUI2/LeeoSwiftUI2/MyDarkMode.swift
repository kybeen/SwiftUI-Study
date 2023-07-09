//
//  MyDarkMode.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/26.
//

/* 다크 모드 적용하기 */
import SwiftUI

struct MyDarkMode: View {
    var body: some View {
        Text("Kybeen")
            .background(Color("KybeenColor"))
    }
}

struct MyDarkMode_Previews: PreviewProvider {
    static var previews: some View {
        MyDarkMode()
    }
}
