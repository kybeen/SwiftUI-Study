//
//  MyOnAppeaarDisappear.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/26.
//

/* .onAppear() / .onDisappear() (화면이 나올 때 / 사라질 때 동작 처리) */
import SwiftUI

struct MyOnAppeaarDisappear: View {
    var body: some View {
        NavigationView {
            NavigationLink("Test") {
                Text("Sample")
                    .onAppear {
                        print("On Appear2")
                    }
                    .onDisappear {
                        print("On Disappear2")
                    }
            }
        }
        .onAppear {
            print("On Appear1")
        }
        .onDisappear {
            print("On Disappear1")
        }
    }
}

struct MyOnAppeaarDisappear_Previews: PreviewProvider {
    static var previews: some View {
        MyOnAppeaarDisappear()
    }
}
