//
//  MyView.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* View */
import SwiftUI

struct MyView: View {
    var body: some View {
        MyView2()
    }
}

struct MyView2: View {
    var body: some View {
        HStack {
            Image(systemName: "bolt.fill")
            Text("Kybeen")
        }
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}
