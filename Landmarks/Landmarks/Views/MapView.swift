//
//  MapView.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/13.
//

//  MapView.swift
import SwiftUI
import MapKit

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    // 맵의 지역 정보를 저장하는 private state value를 선언해준다.
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        Map(coordinateRegion: $region) // state 변수인 region을 뷰에서 사용하려면 $키워드로 바인딩해준다.
            .onAppear { // 지도가 현재 좌표값에 기반한 지역을 계산하도록 .onAppear 뷰 모디파이어를 추가해준다.
                setRegion(coordinate)
            }
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
    }
}
