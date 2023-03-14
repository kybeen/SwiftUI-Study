//
//  LandmarkDetail.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/14.
//

//  LandmarkDetail.swift
import SwiftUI

struct LandmarkDetail: View {
    var landmark: Landmark
    
    var body: some View {
        ScrollView { // VStack --> ScrollView로 바꿔준다.
            MapView(coordinate: landmark.locationCoordinate) // 커스텀 뷰인 MapView 를 불러온다.
                .ignoresSafeArea(edges: .top) // 화면 상단(노치 부분)도 맵뷰가 사용할 수 있도록 허용
                .frame(height: 300) // height만 기술하면, 뷰는 자동으로 width를 콘텐츠의 크기에 맞게 조절해준다.
            
            CircleImage(image: landmark.image) // 커스텀 뷰인 CircleImage 불러오기
                .offset(y: -130) // 맵뷰와 약간 겹치도록 오프셋 조정
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) { // 스택의 이니셜라이저에 정렬 설정을 해줄 수 있다.
                Text(landmark.name)
                    .font(.title)
                
                HStack {
                    Text(landmark.park)
                    Spacer() // 디바이스의 전체 너비를 사용하도록 벌려준다.
                    Text(landmark.state)
                }
                .font(.subheadline) // 스택에 대해 modifier를 적용해주면 스택의 모든 요소에 적용된다.
                .foregroundColor(.secondary)
                
                Divider() // 구분선 추가
                
                Text("About \(landmark.name)")
                    .font(.title2)
                Text(landmark.description)
            }
            .padding() // 패딩 넣어주기
            
            //Spacer() // 콘텐츠 내용을 화면 상단에 올려주기 위해 아래에 Spacer를 넣어준다.
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail(landmark: landmarks[0])
    }
}
