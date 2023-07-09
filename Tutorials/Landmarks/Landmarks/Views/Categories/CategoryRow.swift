//
//  CategoryRow.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/15.
//

//  CategoryRow.swift
import SwiftUI

struct CategoryRow: View {
    var categoryName: String // 카테고리 이름
    var items: [Landmark] // 카테고리의 랜드마크들
    
    var body: some View {
        VStack(alignment: .leading) {
            // 카테고리명
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            // 각 카테고리 별 가로 방향 스크롤뷰
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { landmark in
                        NavigationLink {
                            // 랜드마크를 누르면 해당 랜드마크의 디테일 페이지로 이동
                            LandmarkDetail(landmark: landmark)
                        } label: {
                            // 카테고리의 각 랜드마크 항목들이 곧 버튼의 라벨임
                            CategoryItem(landmark: landmark)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var landmarks = ModelData().landmarks
    
    static var previews: some View {
        CategoryRow(
            categoryName: landmarks[0].category.rawValue,
            items: Array(landmarks.prefix(4))
        )
    }
}
