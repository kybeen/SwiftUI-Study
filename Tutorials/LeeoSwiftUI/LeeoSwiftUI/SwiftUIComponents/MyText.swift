//
//  MyText.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* Text */
import SwiftUI

struct MyText: View {
    var body: some View {
        VStack {
            Text("Hello kybeen")
                .bold()
                .italic()
            .strikethrough()
            Text("Hello kybeen")
                .font(.system(size: 60))
            Text("Hello kybeen")
                .underline(true, color: .orange)
                .foregroundColor(.red)
                .background(.purple)
            Text("Hello kybeen")
                .foregroundColor(.green)
                .bold()
                .font(.system(size: 39, weight: .bold, design: .rounded))
        }
    }
}

struct MyText_Previews: PreviewProvider {
    static var previews: some View {
        MyText()
    }
}
