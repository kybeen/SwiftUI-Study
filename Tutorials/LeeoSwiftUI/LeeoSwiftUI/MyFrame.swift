//
//  MyFrame.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* .frame() */
import SwiftUI

struct MyFrame: View {
    var body: some View {
        Image(systemName: "bolt")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 200, alignment: .trailing)
            .background(.green)
    }
}

struct MyFrame_Previews: PreviewProvider {
    static var previews: some View {
        MyFrame()
    }
}
