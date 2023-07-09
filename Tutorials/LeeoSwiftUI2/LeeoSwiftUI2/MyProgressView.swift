//
//  MyProgressView.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/26.
//

/* ProgressView (진행도 표시) */
import SwiftUI

struct MyProgressView: View {
    @State var progress: Double = 0 // 프로그레스 바의 현재 값
    
    var body: some View {
        VStack {
            ProgressView("Loading...", value: progress, total: 100)
            ProgressView()
            Button {
                progress += 5 // 버튼을 누를 때마다 progress값 증가
            } label: {
                Text("Go!!")
            }

        }
        .padding()
    }
}

struct MyProgressView_Previews: PreviewProvider {
    static var previews: some View {
        MyProgressView()
    }
}
