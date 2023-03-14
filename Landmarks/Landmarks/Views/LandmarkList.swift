//
//  LandmarkList.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/14.
//

// LandmarkList.swift
import SwiftUI

struct LandmarkList: View {
    var body: some View {
        NavigationView { // 리스트를 내비게이션 뷰에 임베드 해줍니다.
            // List의 클로저에 LandmarkDetail() 뷰를 목적지로 하는 NavigationLink를 연결해줍니다.
            List(landmarks) { landmark in
                NavigationLink {
                    LandmarkDetail(landmark: landmark)
                } label: {
                    LandmarkRow(landmark: landmark)
                }
            }
            .navigationTitle("Landmarks") // 내비게이션 바의 제목을 설정해줍니다.
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (3nd generation)", "iPhone 14 Pro Max"], id: \.self) { deviceName in
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
        }
    }
}
