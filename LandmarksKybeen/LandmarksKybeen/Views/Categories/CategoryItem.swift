//
//  CategoryItem.swift
//  LandmarksKybeen
//
//  Created by 김영빈 on 2023/03/23.
//

import SwiftUI

struct CategoryItem: View {
    var landmark: Landmark
    
    var body: some View {
        VStack(alignment: .leading) {
            landmark.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
                .clipShape(Circle())
            Text(landmark.name)
                .font(.caption)
                .frame(width: 155)
                .foregroundColor(.primary)
        }
        .padding(.leading, 15)
    }
}

struct CategoryItem_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItem(landmark: ModelData().landmarks[0])
    }
}
