//
//  Landmark.swift
//  LandmarksKybeen
//
//  Created by 김영빈 on 2023/03/19.
//

// Landmark 데이터 모델
import Foundation
import SwiftUI
import CoreLocation

struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var state: String
    var detailAddress: String
    var description: String
    var isFavorite: Bool // 즐겨찾기 여부
    var isFeatured: Bool // 추천장소 여부
    
    var category: Category
    enum Category: String, CaseIterable, Codable {
        case postech = "POSTECH"
        case tourSpot = "관광지"
        case etc = "기타"
    }

    private var imageName: String
    var image: Image {
        Image(imageName)
    }

    private var coordinates: Coordinates
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
