//
//  TotalActivityReport.swift
//  ReportExtension
//
//  Created by 김영빈 on 2023/05/09.
//

import DeviceActivity
import SwiftUI

extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let totalActivity = Self("Total Activity") // 활동 보고서 컨텍스트 -> 해당 컨텐스트로 보고서 내용 렌더링에 사용할 DeviceActivityReportScene에 대응하는 익스텐션 필요
}

struct TotalActivityReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    // 해당 장면이 나타내는 컨텍스트 정의
    let context: DeviceActivityReport.Context = .totalActivity
    
    // Define the custom configuration and the resulting view for this report.
    // String을 받아서 TotalActivityView를 반환하는 클로저
    //let content: (String) -> TotalActivityView
    let content: (ActivityReport) -> TotalActivityView
    
    // 활동 보고서의 구성을 만드는 메서드
    // data: 활동 보고서의 데이터
//    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> String {
//        // Reformat the data into a configuration that can be used to create
//        // the report's view.
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.day, .hour, .minute, .second]
//        formatter.unitsStyle = .abbreviated
//        formatter.zeroFormattingBehavior = .dropAll
//
//        let totalActivityDuration = await data.flatMap { $0.activitySegments }.reduce(0, {
//            $0 + $1.totalActivityDuration
//        })
//        return formatter.string(from: totalActivityDuration) ?? "No activity data"
//
//    }
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> ActivityReport {
        var res = ""
        var list: [AppDeviceActivity] = []
        
        let totalActivityDuration = await data.flatMap { $0.activitySegments }.reduce(0, {
            $0 + $1.totalActivityDuration
        })
        
        for await d in data {
            res += d.user.appleID!.debugDescription
            res += d.lastUpdatedDate.description
            for await a in d.activitySegments {
                res += a.totalActivityDuration.formatted()
                for await c in a.categories {
                    for await ap in c.applications {
                        let appName = (ap.application.localizedDisplayName ?? "nil")
                        let bundle = (ap.application.bundleIdentifier ?? "nil")
                        let duration = ap.totalActivityDuration
                        let numberOfPickups = ap.numberOfPickups
                        let app = AppDeviceActivity(id: bundle, displayName: appName, duration: duration, numberOfPickups: numberOfPickups)
                        list.append(app)
                    }
                }
            }
        }
        
        return ActivityReport(totalDuration: totalActivityDuration, apps: list)
    }
}
