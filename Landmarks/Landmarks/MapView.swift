//
//  MapView.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/13.
//

import SwiftUI
import MapKit

struct MapView: View {
    // 맵의 지역 정보를 저장하는 pricate state value를 선언해준다.
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    var body: some View {
        Map(coordinateRegion: $region) // state 변수인 region을 뷰에서 사용하려면 $키워드로 바인딩해준다.
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
