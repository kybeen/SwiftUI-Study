//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/13.
//

//  LandmarksApp.swift
import SwiftUI

@main
struct LandmarksApp: App {
    // @StateObject : 앱의 생명 주기 동안 모델 객체를 한번만 초기화 하도록 해줍니다.
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
