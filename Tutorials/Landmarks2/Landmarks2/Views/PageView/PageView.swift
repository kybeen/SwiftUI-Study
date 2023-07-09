//
//  PageView.swift
//  Landmarks2
//
//  Created by 김영빈 on 2023/06/29.
//

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // 자식 뷰인 PageViewController가 생성될 때 바인딩을 넘겨줍니다.
            PageViewController(pages: pages, currentPage: $currentPage)
            PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                .frame(width: CGFloat(pages.count * 18))
                .padding(.trailing)
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        // PreviewProvider를 업데이트하여 필요한 뷰의 배열을 전달해주면 미리보기 화면에 나오는 것을 볼 수 있다.
        PageView(pages: ModelData().features.map { FeatureCard(landmark: $0) })
            .aspectRatio(3 / 2, contentMode: .fit)
    }
}
