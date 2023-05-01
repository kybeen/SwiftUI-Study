//
//  MySchedule.swift
//  Worklog
//
//  Created by 김영빈 on 2023/05/01.
//

/*
 DeviceActivity 구성을 위해
 activity(DeviceActivityName)와 event(DeviceActivityEvent.Name)에 대한 익스텐션을 만들어주고
 schedule(DeviceActivitySchedule)도 정의해준다.
*/
import Foundation
import DeviceActivity

// 활동을 참조할 수 있는 이름 생성
extension DeviceActivityName {
    static let daily = Self("daily") // 열거형에 daily라는 이름의 케이스 추가
}

// 사용 장려 앱에 대한 자녀의 사용량이 충분해지면 앱 제한 쉴드를 제거해주기 위함
extension DeviceActivityEvent.Name {
    static let encouraged = Self("encouraged")
}

class MySchedule {
    static public func setSchedule() {
//        print("Setting schedule...")
//        print("Hour is: ", Calendar.current.dateComponents([.hour, .minute], from: Date()).hour!) // 현재 시간 불러오기
        
        // schedule
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 3, minute: 13),
            intervalEnd: DateComponents(hour: 3, minute: 18),
            repeats: true
        )
        
        // event
        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            .encouraged: DeviceActivityEvent(
                applications: MyModel.shared.selectionToEncourage.applicationTokens,
                threshold: DateComponents(minute: 5)
            )
        ]
        
        let center = DeviceActivityCenter()
        do {
            print("Try to start monitoring...")
            try center.startMonitoring(.daily, during: schedule, events: events)
        } catch {
            print("Error monitoring schedule: ", error)
        }
    }
}




