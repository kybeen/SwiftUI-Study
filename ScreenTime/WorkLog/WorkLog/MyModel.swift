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
    var sleepStartDateComponent = DateComponents(hour: 10, minute: 00) // 밤 테스트용
//    @AppStorage("sleepStartDateComponent", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
//    var sleepStartDateComponent = DateComponents(hour: 07, minute: 00) // 낮 테스트용
    
    // MARK: 스케쥴 종료 시간을 담기 위한 변수
    @AppStorage("sleepEndDateComponent", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
    var sleepEndDateComponent = DateComponents(hour: 17, minute: 22) // 밤 테스트용
//    @AppStorage("sleepEndDateComponent", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
//    var sleepEndDateComponent = DateComponents(hour: 22, minute: 7) // 낮 테스트용
    
    @AppStorage("testInt", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
    var testInt = 0
    
    // MARK: 오늘 수면 계획 동안 15분 연장 횟수
    @AppStorage("additionalCount", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
    var additionalCount: Int = 0
    // MARK: 스케줄 종료 지점 판별을 위한 변수
    @AppStorage("isEndPoint", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
    var isEndPoint: Bool = true
    
    
    let store = ManagedSettingsStore()
    let deviceActivityCenter = DeviceActivityCenter()
    
    func handleResetSelection() {
        selectedApps = FamilyActivitySelection()
    }
    
    func handleStartDeviceActivityMonitoring(includeUsageThreshold: Bool = true) {
        // 새 스케쥴 시간 설정 - 하루
        let currentDateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date()) // 현재시간
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: currentDateComponents.hour, minute: currentDateComponents.minute!+2),
            intervalEnd: DateComponents(hour: 17, minute: 45),
            repeats: true,
            warningTime: DateComponents(minute: 5)
        )
        //print("Test Schedule: \(currentDateComponents.hour!):\(currentDateComponents.minute!+2) ~ 17:45")
        do {
            print("additionalCount: \(additionalCount)")
            print("isEndPoint: \(isEndPoint)")
            print("Stop monitoring... --> \(deviceActivityCenter.activities.description)")
            deviceActivityCenter.stopMonitoring() // 기존 스케줄의 모니터링 중단
            try deviceActivityCenter.startMonitoring(
                .test,
                during: schedule
//                events: includeUsageThreshold ? [.tenSeconds: event] : [:]
                
            )
            print("Monitoring started --> \(deviceActivityCenter.activities.description)")
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
            warningTime: DateComponents(minute: 5) // 5분 전 알림
        )
        print("Daily Sleep Schedule: \(sleepStartDateComponent.hour!):\(sleepStartDateComponent.minute!) ~ \(sleepEndDateComponent.hour!):\(sleepEndDateComponent.minute!)")
        do {
            print("additionalCount: \(additionalCount)")
            print("isEndPoint: \(isEndPoint)")
            print("Stop monitoring... --> \(deviceActivityCenter.activities.description)")
            deviceActivityCenter.stopMonitoring() // 기존 스케줄의 모니터링 중단
            try deviceActivityCenter.startMonitoring(
                .dailySleep,
                during: dailySleepSchedule
            ) // 모니터링 시작
            print("Monitoring started --> \(deviceActivityCenter.activities.description)")
        } catch {
            // Handle error
            print("Unexpected error: \(error).")
        }
    }
    
    /* 15분 추가 시간 설정 */
    func setAdditionalFifteenScheduleOne() { //MARK: 1차 연장 스케줄
        let currentDateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date()) // 현재시간
        let startHour = currentDateComponents.hour ?? 0
        let startMinute  = currentDateComponents.minute ?? 0
        var endHour = startHour + 0
        var endMinute = startMinute + 2 // 15분
        if endMinute >= 60 {
            endMinute -= 60
            endHour += 1
        }
        if endHour > 23 {
            endHour = 23
            endMinute = 59
        }
        print("Additional time schedule: \(startHour):\(startMinute) ~ \(endHour):\(endMinute)")
        
        // (추가시간 15분 종료 시점 ~ 수면 종료 시간)의 새로운 스케줄 생성하기
        let additionalSchedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: endHour, minute: endMinute),
            intervalEnd: sleepEndDateComponent,
            repeats: false,
            warningTime: DateComponents(minute: 5) // 종료 5분 전에 알림
        )
        
//        // 15분동안 앱 사용을 허용할 이벤트 생성 -> 이벤트 감지는 무조건 앱을 15분 사용하고 있어야 감지하기 때문에 이 방식은 사용 X
//        let additionalEvent = DeviceActivityEvent(
//    //        applications: selectedApps.applicationTokens,
//    //        categories: selectedApps.categoryTokens,
//            threshold: DateComponents(minute: 15)
//        )
        do {
            print("Stop monitoring... --> \(deviceActivityCenter.activities.description)")
            deviceActivityCenter.stopMonitoring()
            try deviceActivityCenter.startMonitoring(
                .additionalFifteenOne,
                during: additionalSchedule
            )
            print("Monitoring started --> \(deviceActivityCenter.activities.description)")
        } catch {
            print("Unexpected error: \(error).")
        }
    }
    func setAdditionalFifteenScheduleTwo() { //MARK: 2차 연장 스케줄
        let currentDateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date()) // 현재시간
        let startHour = currentDateComponents.hour ?? 0
        let startMinute  = currentDateComponents.minute ?? 0
        var endHour = startHour + 0
        var endMinute = startMinute + 2 // 15분
        if endMinute >= 60 {
            endMinute -= 60
            endHour += 1
        }
        if endHour > 23 {
            endHour = 23
            endMinute = 59
        }
        
        // (추가시간 15분 종료 시점 ~ 수면 종료 시간)의 새로운 스케줄 생성하기
        let additionalSchedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: endHour, minute: endMinute),
            intervalEnd: sleepEndDateComponent,
            repeats: false,
            warningTime: DateComponents(minute: 5) // 종료 5분 전에 알림
        )
        do {
            deviceActivityCenter.stopMonitoring()
            try deviceActivityCenter.startMonitoring(
                .additionalFifteenTwo,
                during: additionalSchedule
            )
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
    static let test = Self("test")
    static let dailySleep = Self("dailySleep")
    //static let additionalFifteen = Self("additionalFifteen")
    static let additionalFifteenOne = Self("additionalFifteenOne")
    static let additionalFifteenTwo = Self("additionalFifteenTwo")
}

////MARK: Schedule Event Name List
//extension DeviceActivityEvent.Name {
//    static let tenSeconds = Self("threshold.seconds.ten")
//    static let additionalFifteen = Self("additionalFifteen")
//}

extension ManagedSettingsStore.Name {
    static let dailySleep = Self("dailySleep")
}
