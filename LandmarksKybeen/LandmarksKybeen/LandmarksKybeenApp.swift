//
//  LandmarksKybeenApp.swift
//  LandmarksKybeen
//
//  Created by 김영빈 on 2023/03/19.
//

import SwiftUI

@main
struct LandmarksKybeenApp: App {
    // @StateObject : 앱의 생명 주기 동안 모델 객체를 한번만 초기화 하도록 해줌
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
