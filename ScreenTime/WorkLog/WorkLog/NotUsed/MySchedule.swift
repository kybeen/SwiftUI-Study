//
//  MySchedule.swift
//  Worklog
//
//  Created by 김영빈 on 2023/05/01.
//

///*
// DeviceActivity 구성을 위해
// activity(DeviceActivityName)와 event(DeviceActivityEvent.Name)에 대한 익스텐션을 만들어주고
// schedule(DeviceActivitySchedule)도 정의해준다.
//*/
//import Foundation
//import DeviceActivity
//
//// 활동을 참조할 수 있는 이름 생성
//extension DeviceActivityName {
//    static let daily = Self("daily") // 열거형에 daily라는 이름의 케이스 추가
//}
//
//
//extension DeviceActivityEvent.Name {
//    static let discouraged = Self("discouraged")
//}
//
//class MySchedule {
//    static public func setSchedule(curHour: Int, curMins: Int, endHour: Int, endMins: Int) {
//        // 시간 설정
//        print("Setting schedule...")
//        print("CURRENT TIME: \(curHour):\(curMins)")
//        print("END TIME: \(endHour):\(endMins)")
//
//        // 실드 적용
//        MyModel.shared.setShieldRestriction()
//
//        // 스케줄 설정
//        let schedule = DeviceActivitySchedule(
//            intervalStart: DateComponents(hour: curHour, minute: curMins),
//            intervalEnd: DateComponents(hour: endHour, minute: endMins),
//            repeats: false
//        )
//
//        // 이벤트 설정 - 아직 XXX
//        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
//            .discouraged: DeviceActivityEvent(
//                applications: MyModel.shared.selectionToDiscourage.applicationTokens,
//                threshold: DateComponents(second: 15)
//            )
//        ]
//
//        // Device Activity Center 생성
//        let center = DeviceActivityCenter()
//        do {
//            print("Try to start monitoring...")
//            try center.startMonitoring(.daily, during: schedule, events: events)
//        } catch {
//            print("Error monitoring schedule: ", error)
//        }
//    }
//}





