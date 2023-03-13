//
//  ModelData.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/14.
//

// ModelData.swift
import Foundation

// landmarkData.json 파일을 불러와서 배열로 저장합니다.
var landmarks: [Landmark] = load("landmarkData.json")

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
