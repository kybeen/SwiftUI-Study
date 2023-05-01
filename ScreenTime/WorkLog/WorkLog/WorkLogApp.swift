//
//  WorklogApp.swift
//  Worklog
//
//  Created by 김영빈 on 2023/04/26.
//

import SwiftUI
import FamilyControls
import ManagedSettings

@main
struct WorklogApp: App {
    let center = AuthorizationCenter.shared // 앱이 시작될 때 FamilyControls 승인 요청 (최초 1회)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MyModel())
                .onAppear {
                    Task {
                        do {
                            try await center.requestAuthorization(for: .individual)
                            print("Approved Status: \(AuthorizationStatus.approved)")
                        } catch {
                            print("Failed to enroll User with error: \(error)")
                        }
                    }
                }
        }
    }
}
