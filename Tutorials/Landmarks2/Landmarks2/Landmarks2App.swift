//
//  Landmarks2App.swift
//  Landmarks2
//
//  Created by 김영빈 on 2023/06/26.
//

import SwiftUI

@main
struct Landmarks2App: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
