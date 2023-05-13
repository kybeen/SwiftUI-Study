//
//  ShieldActionExtension.swift
//  ShieldAction
//
//  Created by 김영빈 on 2023/05/09.
//

import DeviceActivity
import ManagedSettings
import SwiftUI

class ActionSheetViewController: UIViewController {
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "이 시간만 더 보기로 약속해요", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "15분 더 보기", style: .default) { _ in
            // 15분 더 보기 버튼 액션
        })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let presentingViewController = presentingViewController {
            presentingViewController.present(actionSheet, animated: true, completion: nil)
        }
    }
}

// Override the functions below to customize the shield actions used in various situations.
// The system provides a default response for any functions that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldActionExtension: ShieldActionDelegate {
    var actionSheetViewController: ActionSheetViewController?
    
    @AppStorage("testInt", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
    var testInt = 0
    
    //let store = ManagedSettingsStore(named: .tenSeconds)
    
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
//            if MyModel.shared.additionalCount < 2 { //MARK: 연장 횟수 2회 미만
//                MyModel.shared.isEndPoint = false // 종료 지점 다음 스케줄로 변경
//                MyModel.shared.additionalCount += 1 // 연장 횟수 1 카운트
//                MyModel.shared.setAdditionalFifteenSchedule() // 15분 연장 스케줄 모니터링 시작
//            }
            completionHandler(.close)
        
        @unknown default:
            fatalError()
        }
    }
    
    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        completionHandler(.close)
    }
    
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        var additionalCount = MyModel.shared.additionalCount
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            // 지연 시간 후 처리되는 것은 확인했다.

//            if testInt >= 9
//            {
//                store.shield.applications = .none
//                store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy<Application>.none
//                testInt = 0
//
//                completionHandler(.none)
//            } else {
//                testInt += 1
//                completionHandler(.defer)
//            }
            
//            testInt += 1
//            actionSheetViewController?.showActionSheet()
//            completionHandler(.defer)
            
            // additionalFifteen 스케줄이 시작되면 실드 세팅을 초기화해줌
//            let store = ManagedSettingsStore(named: .dailySleep)
//            store.clearAllSettings()
            

//            if MyModel.shared.additionalCount < 2 { //MARK: 연장 횟수 2회 미만
//                MyModel.shared.isEndPoint = false // 종료 지점 다음 스케줄로 변경
//                MyModel.shared.additionalCount += 1 // 연장 횟수 1 카운트
//                MyModel.shared.setAdditionalFifteenSchedule() // 15분 연장 스케줄 모니터링 시작
//            }
            if MyModel.shared.additionalCount == 0 { //MARK: 연장 횟수 2회 미만
                MyModel.shared.isEndPoint = false // 종료 지점 다음 스케줄로 변경
                MyModel.shared.additionalCount += 1 // 연장 횟수 1 카운트
                MyModel.shared.setAdditionalFifteenScheduleOne() // 15분 연장 스케줄 모니터링 시작
                completionHandler(.defer)
            } else if MyModel.shared.additionalCount == 1 {
                MyModel.shared.isEndPoint = false // 종료 지점 다음 스케줄로 변경
                MyModel.shared.additionalCount += 1 // 연장 횟수 1 카운트
                MyModel.shared.setAdditionalFifteenScheduleTwo() // 15분 연장 스케줄 모니터링 시작
                completionHandler(.defer)
            } else {
                MyModel.shared.additionalCount += 1
                completionHandler(.defer)
            }
        
        @unknown default:
            fatalError()
        }
    }
}


//extension DeviceActivityName {
//    static let daily = Self("daily")
//}

//extension ManagedSettingsStore.Name {
//    static let tenSeconds = Self("threshold.seconds.ten")
////    static let weekend = Self("weekend")
//}
