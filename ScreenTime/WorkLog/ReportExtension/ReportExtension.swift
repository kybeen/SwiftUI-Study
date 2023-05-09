//
//  ReportExtension.swift
//  ReportExtension
//
//  Created by 김영빈 on 2023/05/09.
//

import DeviceActivity
import SwiftUI

/* DeviceActivityReport() 시 전달받은 Context에 맞게 호출되는듯 */
@main
struct ReportExtension: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            //TotalActivityView(totalActivity: totalActivity)
            return TotalActivityView(activityReport: totalActivity)
        }
        // Add more reports here...
    }
}
