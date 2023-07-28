//
//  WatchTennisClassifierTestApp.swift
//  WatchTennisClassifierTest Watch App
//
//  Created by 김영빈 on 2023/07/13.
//

import SwiftUI

@main
struct WatchTennisClassifierTest_Watch_AppApp: App {
    @StateObject var workoutManager = WorkoutManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workoutManager)
        }
    }
}
