//
//  ModelData.swift
//  LandmarksKybeen
//
//  Created by 김영빈 on 2023/03/19.
//

// JSON 파일로부터 데이터를 읽어오기 위한 파일
import Foundation
import Combine

final class ModelData: ObservableObject {
    // SwiftUI가 값의 변화를 감지할 수 있도록 ObservableObject 프로토콜을 준수하는 클래스의 프로퍼티에 @Published를 붙여준다.
    @Published var landmarks: [Landmark] = load("landmarkKybeenData.json")
    var hikes: [Hike] = load("hikeData.json") // 이후 수정할 일 없기 때문에 @Published 안붙혀도 됨
    @Published var profile = Profile.default
    
    // 추천 장소들
    // $0 : 클로저에서 현재 처리 중인 요소를 나타냄
    var features: [Landmark] {
        landmarks.filter { $0.isFeatured }
    }
    
    // 각 카테고리의 이름을 key로 갖는 카테고리 딕셔너리
    var categories: [String: [Landmark]] {
        Dictionary(
            grouping: landmarks,
            by: { $0.category.rawValue }
        )
    }
}

// landmarkKybeenData.json 파일을 불러와서 Landmark 타입의 배열로 저장
// var landmarks: [Landmark] = load("landmarkKybeenData.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    // 메인 번틀로부터 JSON 파일 갖고오기
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    // JSON 파일로부터 데이터를 추출
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) in main bundle:\n\(error)")
    }

    // 추출한 데이터를 디코딩
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
