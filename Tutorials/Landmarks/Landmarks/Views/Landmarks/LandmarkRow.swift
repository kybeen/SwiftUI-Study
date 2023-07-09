//
//  LandmarkRow.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/14.
//

// LandmarkRow.swift
import SwiftUI

struct LandmarkRow: View {
    var landmark: Landmark
    
    var body: some View {
        HStack {
            landmark.image // landmark.image는 Image() 뷰임
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
            
            Spacer() // 랜드마크 정보를 행의 왼쪽으로 밀어주기 위해 넣어줌
            
            if landmark.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var landmarks = ModelData().landmarks
    
    static var previews: some View {
        Group {
            LandmarkRow(landmark: landmarks[0]) // 이니셜라이저에 landmark 파라미터를 넣어준다.
            LandmarkRow(landmark: landmarks[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
