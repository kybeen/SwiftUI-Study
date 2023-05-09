//
//  TotalActivityView.swift
//  ReportExtension
//
//  Created by 김영빈 on 2023/05/09.
//

import SwiftUI

struct TotalActivityView: View {
    //let totalActivity: String
    var activityReport: ActivityReport
    
    var body: some View {
        //Text(totalActivity)
        VStack {
            Spacer(minLength: 50)
            Text("Total Screen Time")
            Spacer(minLength: 10)
            Text(activityReport.totalDuration.stringFromTimeInterval())
            List(activityReport.apps) { app in
                ListRow(eachApp: app)
            }
        }
    }
}

struct ListRow: View {
    var eachApp: AppDeviceActivity
    var body: some View {
        HStack {
            Text(eachApp.displayName)
            Spacer()
            Text(eachApp.id)
            Spacer()
            Text("\(eachApp.numberOfPickups)")
            Spacer()
            Text(String(eachApp.duration.formatted()))
        }
    }
}

// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.
//struct TotalActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        TotalActivityView(totalActivity: "1h 23m")
//    }
//}
