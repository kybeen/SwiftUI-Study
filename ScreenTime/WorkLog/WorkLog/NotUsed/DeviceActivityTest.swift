//
//  DeviceActivityTest.swift
//  Worklog
//
//  Created by 김영빈 on 2023/05/15.
//

//import DeviceActivity
//import FamilyControls
//import ManagedSettings
//import SwiftUI
//import Foundation
//
//
//// Optionally override any of the functions below.
//// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
//class DeviceActivityMonitorExtension: DeviceActivityMonitor {
//    var selectionToDiscourage = ScreenTimeVM.shared.selectionToDiscourage
//
//    // MARK: 스케줄 시작 시점에 호출
//    override func intervalDidStart(for activity: DeviceActivityName) {
//        super.intervalDidStart(for: activity)
//        // Handle the start of the interval.
//        if activity == .dailySleep { //MARK: 수면 계획 스케줄 시작
//            ScreenTimeVM.shared.additionalCount = 0 // 오늘 스케줄의 additionalCount값 0으로 초기화
//        }
//        ScreenTimeVM.shared.isEndPoint = true // 현재 스케줄을 종료 지점이라고 봄
//        // 앱 제한 적용 시작
//        let managedSettingsStore = ManagedSettingsStore(named: .dailySleep)
//        managedSettingsStore.shield.applications = selectionToDiscourage.applicationTokens.isEmpty ? nil : selectionToDiscourage.applicationTokens
//        managedSettingsStore.shield.applicationCategories = selectionToDiscourage.categoryTokens.isEmpty
//        ? nil
//        : ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens)
//    }
//
//    // MARK: 스케줄 종료 시점 or 모니터링 중단 시 호출
//    override func intervalDidEnd(for activity: DeviceActivityName) {
//        super.intervalDidEnd(for: activity)
//        //TODO: MyModel.shared.isEndPoint == true 조건이 계속 적용될거임 --> 수정 필요
//        if activity == .additionalTime && ScreenTimeVM.shared.isEndPoint == true {
//            ScreenTimeVM.shared.additionalCount = 0 // 스케줄 중단이 아니라 종료일 경우 additionalCount를 초기화 해줌
//        }
//        // TODO: 스케줄 종료 시에 dailySleep 모니터링 다시 시작하도록 코드 작성
////        if 스케줄 종료일 경우 {
////            ScreenTimeVM.shared.handleStartDeviceActivityMonitoring(
////                startTime: ScreenTimeVM.shared.sleepStartDateComponent,
////                endTime: ScreenTimeVM.shared.sleepEndDateComponent,
////                deviceActivityName: .dailySleep
////            )
////        }
//
//        let managedSettingsStore = ManagedSettingsStore(named: .dailySleep)
//        managedSettingsStore.clearAllSettings()
//    }
//
//    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
//        super.eventDidReachThreshold(event, activity: activity)
//
//        // Handle the event reaching its threshold.
//    }
//
//    //MARK: 스케줄 시작 전 설정한 시간 (warningTime)에 미리 알림
//    override func intervalWillStartWarning(for activity: DeviceActivityName) {
//        super.intervalWillStartWarning(for: activity)
//        // Handle the warning before the interval starts.
//        //MARK: 사용자가 알림을 켜놨으면 동작
//        if ScreenTimeVM.shared.isUserNotificationOn {
//            if activity == .dailySleep { //MARK: 수면 스케줄 시작 알림
//                NotificationManager.shared.requestNotificationCreate(
//                    title: "수면 계획이 곧 시작됩니다.",
//                    subtitle: "5분 뒤에 설정한 수면 계획 시작"
//                )
//            } else if activity == .additionalTime {
//                if ScreenTimeVM.shared.additionalCount < 2 { //MARK: 1회째 연장 이후 수면 스케줄 시작 알림
//                    NotificationManager.shared.requestNotificationCreate(
//                        title: "약속한 시간이 다가옵니다.",
//                        subtitle: "5분 뒤에 설정한 수면 계획 시작"
//                    )
//                } else { //MARK: 2회째 연장 이후 수면 스케줄 시작 알림
//                    NotificationManager.shared.requestNotificationCreate(
//                        title: "최후의 약속이 끝나갑니다.",
//                        subtitle: "5분 뒤에 설정한 수면 계획 다시 시작"
//                    )
//                }
//            }
//        }
//    }
//
//    override func intervalWillEndWarning(for activity: DeviceActivityName) {
//        super.intervalWillEndWarning(for: activity)
//
//        // Handle the warning before the interval ends.
//    }
//
//    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
//        super.eventWillReachThresholdWarning(event, activity: activity)
//
//        // Handle the warning before the event reaches its threshold.
//    }
//}
