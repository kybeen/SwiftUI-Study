//
//  MyModel.swift
//  Worklog
//
//  Created by 김영빈 on 2023/04/28.
//

import SwiftUI
import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

class MyModel: ObservableObject {
    static let shared = MyModel() // 싱글톤 패턴 사용
    private init() {}
    
    @AppStorage("selectedApps", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
    var selectedApps = FamilyActivitySelection() {
        didSet {
            handleSetBlockApplication()
        }
    }
    
    // MARK: 스케쥴 시작 시간을 담기 위한 변수
    @AppStorage("sleepStartDateComponent", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
    var sleepStartDateComponent = DateComponents(hour: 23, minute: 00)
    
    // MARK: 스케쥴 종료 시간을 담기 위한 변수
    @AppStorage("sleepEndDateComponent", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
    var sleepEndDateComponent = DateComponents(hour: 07, minute: 00)
    
    @AppStorage("testInt", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
    var testInt = 0
    
    let store = ManagedSettingsStore()
    let deviceActivityCenter = DeviceActivityCenter()
    
    func handleResetSelection() {
        selectedApps = FamilyActivitySelection()
    }
    
    func handleStartDeviceActivityMonitoring(includeUsageThreshold: Bool = true) {
        // 새 스케쥴 시간 설정 - 하루
        let currentDateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date()) // 현재시간
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: currentDateComponents.hour, minute: currentDateComponents.minute! + 1, second: currentDateComponents.second),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true,
            warningTime: DateComponents(minute: 1)
        )
        print("Current Time: \(currentDateComponents.hour!):\(currentDateComponents.minute!)")
        // 새 이벤트 생성
        let event = DeviceActivityEvent(
            applications: selectedApps.applicationTokens,
            categories: selectedApps.categoryTokens,
            webDomains: selectedApps.webDomainTokens,
            // 앱 사용을 허용할 시간
            threshold: DateComponents(second: 10)
        )
        print("Selected apps: \(selectedApps.applications)")
        print("Selected categories: \(selectedApps.categories.first)")
        do {
            MyModel.shared.deviceActivityCenter.stopMonitoring()
            try MyModel.shared.deviceActivityCenter.startMonitoring(
                .daily,
                during: schedule,
                events: includeUsageThreshold ? [.tenSeconds: event] : [:]
                
            )
            print("Monitoring started")
        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    
    func handleSetBlockApplication() {
        store.shield.applications = selectedApps.applicationTokens.isEmpty ? nil : selectedApps.applicationTokens
        store.shield.applicationCategories = selectedApps.categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(selectedApps.categoryTokens)
    }
    
    /* 수면시간 스케줄 등록 */
    func setDailySleepSchedule() {
        let dailySleepSchedule = DeviceActivitySchedule(
            intervalStart: sleepStartDateComponent,
            intervalEnd: sleepEndDateComponent,
            repeats: true,
            warningTime: DateComponents(minute: 5)
        )
        print("Daily Sleep Schedule: \(sleepStartDateComponent.hour!):\(sleepStartDateComponent.minute!) ~ \(sleepEndDateComponent.hour!):\(sleepEndDateComponent.minute!)")
        do {
            try deviceActivityCenter.startMonitoring(.dailySleep, during: dailySleepSchedule)
            print("Daily sleep monitoring started")
        } catch {
            // Handle error
            print("Unexpected error: \(error).")
        }
    }
    
    /* 15분 추가 시간 설정 */
    func setAdditionalFifteenSchedule() {
        let currentDateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date()) // 현재시간
        let currentHour = currentDateComponents.hour ?? 0
        let currentMinute = currentDateComponents.minute ?? 0
        var endHour = currentHour + 0
        var endMinute = currentMinute + 8 // 원래 15분으로 해줘야함
        if endMinute >= 60 {
            endMinute -= 60
            endHour += 1
        }
        if endHour > 23 {
            endHour = 23
            endMinute = 59
        }
        print("Additional time schedule: \(currentHour):\(currentMinute) ~ \(endHour):\(endMinute)")
        
        // 현재 시간부터 15분 동안의 새로운 스케줄 생성
        let additionalSchedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: currentHour, minute: currentMinute + 1, second: currentDateComponents.second),
            //intervalEnd: DateComponents(hour: endHour, minute: endMinute),
            intervalEnd: sleepEndDateComponent,
            repeats: true,
            warningTime: DateComponents(minute: 5) // 15분 추가시간 종료 5분 전에 알림
        )
        
        // 15분동안 앱 사용을 허용할 이벤트 생성
        let additionalEvent = DeviceActivityEvent(
            applications: selectedApps.applicationTokens,
            categories: selectedApps.categoryTokens,
            // 앱 사용을 허용할 시간
            threshold: DateComponents(minute: 15)
        )
        
        do {
            MyModel.shared.deviceActivityCenter.stopMonitoring([.dailySleep]) // 기존 수면시간 스케줄의 모니터링 중단
            try MyModel.shared.deviceActivityCenter.startMonitoring(
                .additionalFifteen,
                during: additionalSchedule,
                events: [.additionalFifteen: additionalEvent]
            )
            print("Additional 15minutes Monitoring started!!")
        } catch {
            print("Unexpected error: \(error).")
        }
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

//MARK: DateComponents Parser
extension DateComponents: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(DateComponents.self, from: data)
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

//MARK: Schedule Name List
extension DeviceActivityName {
    static let daily = Self("daily")
    static let dailySleep = Self("dailySleep")
    static let additionalFifteen = Self("additionalFifteen")
}

//MARK: Schedule Event Name List
extension DeviceActivityEvent.Name {
    static let tenSeconds = Self("threshold.seconds.ten")
    static let additionalFifteen = Self("additionalFifteen")
}
