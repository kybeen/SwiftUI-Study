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
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkRow(landmark: landmarks[0]) // 이니셜라이저에 landmark 파라미터를 넣어준다.
    }
}
