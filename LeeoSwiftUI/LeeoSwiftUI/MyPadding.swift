//
//  MyPadding.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* .padding() */
import SwiftUI

struct MyPadding: View {
    var body: some View {
        VStack {
            Image(systemName: "bolt")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .background(.green)
                .foregroundColor(.red)
                .padding(.bottom, 100)
            
                Image(systemName: "bolt")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .padding(.leading, 100)
                    .background(.green)
                    .foregroundColor(.red)
        }
    }
}

struct MyPadding_Previews: PreviewProvider {
    static var previews: some View {
        MyPadding()
    }
}
