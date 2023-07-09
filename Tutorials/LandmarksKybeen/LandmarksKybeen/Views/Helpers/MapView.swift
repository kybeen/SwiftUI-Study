//
//  MapView.swift
//  LandmarksKybeen
//
//  Created by 김영빈 on 2023/03/19.
//

// 지도 뷰
import SwiftUI
import MapKit

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    
    // MKCoordinateRegion : 특정 위도/경도를 중심으로 하는 직사각형의 지리 영역
    // CLLocationCoordinate2D : 위도,경도로 위치를 구해준다.
    // MKCoordinateSpan : 맵에서 보여지는 지역의 범위 설정 (작을수록 구체적)
    @State private var region = MKCoordinateRegion() // 지역 정보를 저장하는 state 변수
    
    var body: some View {
        Map(coordinateRegion: $region)
            .onAppear {
                setRegion(coordinate)
            }
    }
    
    func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 36.014013011953935, longitude: 129.3259494523069))
    }
}
