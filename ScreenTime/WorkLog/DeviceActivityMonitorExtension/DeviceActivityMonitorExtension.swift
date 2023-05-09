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

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    @AppStorage("selectedApps", store: UserDefaults(suiteName: "group.com.worklog"))
    var shieldedApps = FamilyActivitySelection()
    
    // schedule의 시작 시점 이후 처음으로 기기가 사용될 때 호출
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        if activity == .daily {
            let store = ManagedSettingsStore(named: .tenSeconds)
            store.shield.applications = shieldedApps.applicationTokens.isEmpty ? nil : shieldedApps.applicationTokens
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(shieldedApps.categoryTokens)
        }
    }
    
    // schedule의 종료 시점 이후 처음으로 기기가 사용될 때 호출
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        // Handle the end of the interval.
        
        if activity == .daily {
            let store = ManagedSettingsStore(named: .tenSeconds)
            store.clearAllSettings()
            print("Schedule is ended!!")
        }
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    // activity가 시작되기 전에 지정한 시간에 다가오는 activity에 대해 앱에 알림
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        NotificationManager.shared.scheduleNotification()
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}

//MARK: FamilyActivitySelection Parser
extension FamilyActivitySelection: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension DeviceActivityName {
    static let daily = Self("daily")
    static let weekend = Self("weekend")
}

extension ManagedSettingsStore.Name {
    static let tenSeconds = Self("threshold.seconds.ten")
    static let weekend = Self("weekend")
}
