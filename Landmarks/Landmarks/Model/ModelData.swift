//
//  ModelData.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/14.
//

// ModelData.swift
import Foundation
import Combine

// Combine 프레임워크의 ObservableObject 프로토콜을 준수하는 새로운 모델 타입을 정의합니다.
final class ModelData: ObservableObject {
    // landmarkData.json 파일을 불러와서 배열로 저장합니다.
    // Observable 객체는 SwiftUI가 변경사항을 감지할 수 있도록 @Published 키워드를 붙여줍니다.
    @Published var landmarks: [Landmark] = load("landmarkData.json")
    // hikeData.json 파일을 불러와서 배열로 저장합니다. (이후 수정할 일이 없기 때문에 @Published 키워드 안붙여도 됨)
    var hikes: [Hike] = load("hikeData.json")
}

// json 파일로부터 데이터를 불러오는 함수
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    // 앱의 메인 번들로부터 JSON 파일을 갖고옵니다.
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    // json 파일로부터 데이터를 추출합니다.
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    // 추출한 데이터를 디코딩 해줍니다.
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
