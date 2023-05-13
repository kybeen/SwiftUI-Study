//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitorExtension
//
//  Created by 김영빈 on 2023/05/06.
//

/*
 DeviceActivityMonitor를 상속받는 클래스를 정의하고
 지정된 메소드를 오버라이드해주면 사용을 제한시킬 앱들에 shield를 적용해줄 수 있음

 - familyActivityPicker로 선택된 값들이 저장된 모델을 불러와서 application shield restriction를 구성해줌
 - application shield restriction에 접근하려면 ManagedSettings를 임포트 해줘야함
 - application shield restriction 적용 해제는 nil값을 대입
*/
import DeviceActivity
import ManagedSettings
import SwiftUI
import FamilyControls
import Foundation

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    @AppStorage("selectedApps", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
    var shieldedApps = FamilyActivitySelection()
    
    
    // schedule의 시작 시점 이후 처음으로 기기가 사용될 때 호출
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        if activity == .test || activity == .dailySleep { //MARK: 수면 계획 스케줄 시작
            MyModel.shared.additionalCount = 0
        }
        MyModel.shared.isEndPoint = true // 현재 스케줄을 종료 지점이라고 봄
        let store = ManagedSettingsStore(named: .dailySleep)
        store.shield.applications = shieldedApps.applicationTokens.isEmpty ? nil : shieldedApps.applicationTokens
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(shieldedApps.categoryTokens)
    }
    
    // schedule의 종료 시점 이후 처음으로 기기가 사용될 때 호출 or 모니터링 중단 시에도 호출
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        // Handle the end of the interval.
        
//        if activity == .daily {
//
//        } else if activity == .dailySleep { //MARK: 수면 계획 스케줄 종료
//            if MyModel.shared.isEndPoint == true { // 시간을 다 채워서 스케줄 종료
//                MyModel.shared.additionalCount = 0
//            }
//
//        } else if activity == .additionalFifteenOne { //MARK: 1차 추가 15분 스케줄 종료
//            if MyModel.shared.isEndPoint == true { // 시간을 다 채워서 스케줄 종료
//                MyModel.shared.additionalCount = 0
//            }
//
//        } else if activity == .additionalFifteenTwo { //MARK: 2차 추가 15분 스케줄 종료
//            MyModel.shared.additionalCount = 0
//
//        }
        
        //아래 코드가 계속 실행되는것 같음
//        if MyModel.shared.isEndPoint == true { // 시간을 다 채워서 스케줄 종료
//            MyModel.shared.additionalCount = 0
//        }
        let store = ManagedSettingsStore(named: .dailySleep)
        store.clearAllSettings()
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        // additionalFifteen의 event threshold에 도달하면(15분)
//        if activity == .additionalFifteen {
//            //MyModel.shared.deviceActivityCenter.stopMonitoring([.additionalFifteen]) // additionalFifteen 스케줄의 모니터링 중단
//            MyModel.shared.deviceActivityCenter.stopMonitoring()
//            MyModel.shared.setDailySleepSchedule() // 기존 데일리 수면 스케줄 모니터링 다시 시작
//        }
        
//        MyModel.shared.deviceActivityCenter.stopMonitoring()
//        MyModel.shared.setDailySleepSchedule() // 기존 데일리 수면 스케줄 모니터링 다시 시작
        
        // Handle the event reaching its threshold.
    }
    
    // activity가 시작되기 전에 지정한 시간에 다가오는 activity에 대해 앱에 알림
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        if activity == .dailySleep { // 기존 수면 스케줄 종료 알림
            NotificationManager.shared.scheduleNotification(title: "수면 계획이 곧 시작됩니다.", subTitle: "5분 뒤에 설정한 수면 계획 시작")
        } else if activity == .additionalFifteenOne { // 1회째 연장 시간 종료 알림
            NotificationManager.shared.scheduleNotification(title: "약속한 시간이 다가옵니다.", subTitle: "5분 뒤에 설정한 수면 계획 시작")
        } else { // 2회째 연장 시간 종료 알림
            NotificationManager.shared.scheduleNotification(title: "최후의 약속이 끝나갑니다.", subTitle: "5분 뒤에 설정한 수면 계획 다시 시작")
        }
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        // Handle the warning before the event reaches its threshold.
//        if activity == .additionalFifteen {
//            // 추가시간 5분 남음 알림
//            NotificationManager.shared.additionalFifteenNotification()
//        }
//        // 추가시간 5분 남음 알림
//        NotificationManager.shared.additionalFifteenNotification()
    }
}
