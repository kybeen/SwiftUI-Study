//
//  Landmark.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/13.
//

//  Landmark.swift
import Foundation
import SwiftUI
import CoreLocation

// landmarkData.json 파일의 키:값에 맞는 구조체를 정의해준다.
// Codable 프로토콜 : 구조체와 데이터 파일 간에 데이터를 더 쉽게 이동할 수 있게 해준다. Codable의 컴포넌트인 Decodable을 사용해서 파일로부터 데이터를 읽어올 수 있다.
// Identifiable : 데이터가 identifiable하도록 준수하는 프로토콜
struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var park: String
    var state: String
    var description: String
    var isFavorite: Bool // 즐겨찾기 여부 프로퍼티
    var isFeatured: Bool // 추천 장소 여부 프로퍼티
    
    var category: Category
    enum Category: String, CaseIterable, Codable {
        case lakes = "Lakes"
        case rivers = "Rivers"
        case mountains = "Mountains"
    }
    
    private var imageName: String // 이미지 데이터의 이름을 불러오기 위한 프로퍼티
    var image: Image {
        Image(imageName)
    }
    // 주요 랜드마크 이미지가 존재한다면 반환해주는 계산 프로퍼티
    var featureImage: Image? {
        isFeatured ? Image(imageName + "_feature") : nil
    }
    
    // 좌표 속성
    private var coordinates: Coordinates
    // MapKit 프레임워크와 상호작용 하기 좋도록 좌표 프로퍼티를 처리해준다.
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
