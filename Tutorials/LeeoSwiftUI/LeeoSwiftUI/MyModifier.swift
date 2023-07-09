//
//  MyModifier.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* modifier */
import SwiftUI

struct MyModifier: View {
    var body: some View {
        Image(systemName: "bolt")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
            .background(.green)
            .foregroundColor(.red)
    }
}

struct MyModifier_Previews: PreviewProvider {
    static var previews: some View {
        MyModifier()
    }
}
