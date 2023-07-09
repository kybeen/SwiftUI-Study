//
//  LandmarkList.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/14.
//

// LandmarkList.swift
import SwiftUI

struct LandmarkList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false // 즐겨찾기 여부에 따른 필터링을 위한 state 변수
    
    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter { landmark in
            /*
             showFavoritesOnly가 true면 landmark.isFavorite==true인 랜드마크만
             showFavoritesOnly가 true면 모든 랜드마크
             */
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    
    var body: some View {
        NavigationView { // 리스트를 내비게이션 뷰에 임베드 해줍니다.
            // List의 클로저에 LandmarkDetail() 뷰를 목적지로 하는 NavigationLink를 연결해줍니다.
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink {
                        LandmarkDetail(landmark: landmark)
                    } label: {
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
            .navigationTitle("Landmarks") // 내비게이션 바의 제목을 설정해줍니다.
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
//        ForEach(["iPhone SE (3nd generation)", "iPhone 14 Pro Max"], id: \.self) { deviceName in
//            LandmarkList()
//                .previewDevice(PreviewDevice(rawValue: deviceName))
//        }
        LandmarkList()
            .environmentObject(ModelData())
    }
}
