//
//  AppDeviceActivity.swift
//  ReportExtension
//
//  Created by 김영빈 on 2023/05/09.
//

import SwiftUI

struct ActivityReport {
    let totalDuration: TimeInterval
    let apps: [AppDeviceActivity]
}

struct AppDeviceActivity: Identifiable {
    var id: String
    var displayName: String
    var duration: TimeInterval
    var numberOfPickups: Int
}

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%0.2d:%0.2d", hours,minutes)
    }
}
