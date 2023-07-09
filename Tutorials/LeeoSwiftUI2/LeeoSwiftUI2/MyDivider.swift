//
//  MyDivider.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/26.
//

/* Divider() - 구분선 */
import SwiftUI

struct MyDivider: View {
    var body: some View {
        VStack {
            Divider()
            HStack {
                Image(systemName: "star.fill")
                Divider()
                    .frame(height: 30) // 높이 설정
                Text("Kybeen!")
            }
            
            Divider()
                .background(.red) // 배경색 설정
                .frame(width: 150) // 너비 설정
            HStack {
                Image(systemName: "star")
                Divider()
                    .frame(height: 30)
                Text("Leeo!")
            }
            Divider()
        }
    }
}

struct MyDivider_Previews: PreviewProvider {
    static var previews: some View {
        MyDivider()
    }
}
