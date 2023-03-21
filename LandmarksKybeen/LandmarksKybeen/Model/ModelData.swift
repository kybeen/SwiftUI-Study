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
}

//// landmarkKybeenData.json 파일을 불러와서 Landmark 타입의 배열로 저장
//var landmarks: [Landmark] = load("landmarkKybeenData.json")

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
