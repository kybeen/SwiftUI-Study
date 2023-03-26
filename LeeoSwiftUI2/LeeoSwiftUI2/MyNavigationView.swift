//
//  MyNavigationView.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/26.
//

/* NavigationView, NavigationLink */
import SwiftUI

struct MyNavigationView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: Text("My View1")) { // destination : 이동할 뷰
                // 현재 뷰
                ZStack {
                    Color.green
                    Text("test")
                }
            }
            .navigationTitle("Hello") // 내비게이션 바 제목
        }
    }
}

struct MyNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MyNavigationView()
    }
}
