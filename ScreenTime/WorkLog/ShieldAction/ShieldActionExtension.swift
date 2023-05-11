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
            completionHandler(.defer)
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
//                /*
//                 커스텀 실드 화면이 기본 실드로 잠깐 변경되는 이유는 completionHandler가 .defer로 설정되어 있기 때문입니다.
//                 이 경우, 실드 화면이 닫히기 전에 다음 액션을 처리하기 위해 잠시 기본 실드 화면으로 전환됩니다.
//                 - 라는 대답을 챗 지피티한테 들음
//                 - 근데 WWDC영상 보면 아예 다른 화면도 가능할 것 같긴 한데.. .none으로 되면 신경 안써도 될 것 같기도
//                */
//            } else {
//                testInt += 1
//                completionHandler(.defer)
//            }
            
//            testInt += 1
//            actionSheetViewController?.showActionSheet()
//            completionHandler(.defer)
            
            testInt += 1
            MyModel.shared.setAdditionalFifteenSchedule()
            completionHandler(.none)
            
        
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
