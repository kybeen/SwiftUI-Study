//
//  ShieldConfigurationExtension.swift
//  ShieldConfigurationExtension
//
//  Created by 김영빈 on 2023/05/06.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit
import SwiftUI

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    @AppStorage("testInt", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
    var testInt = 0
    
    let title = "Worklog"
    let body = "해당 앱은 현재 사용이 제한됩니다."
    
    // 애플리케이션 단위로 선택했을 때
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.systemThickMaterial,
            backgroundColor: UIColor.white,
            icon: UIImage(systemName: "stopwatch"),
            title: ShieldConfiguration.Label(text: "No app for you???: \(testInt)", color: .blue),
            subtitle: ShieldConfiguration.Label(text: "Sorry, no apps for you", color: .black),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Ask for a break?", color: .black),
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Quick Quick", color: .black)
        )
    }
    
    // 카테고리 단위로 선택했을 때
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.systemThickMaterial,
            backgroundColor: UIColor.white,
            icon: UIImage(systemName: "stopwatch"),
            title: ShieldConfiguration.Label(text: "No app for you!!!!: : \(testInt)", color: .blue),
            //subtitle: ShieldConfiguration.Label(text: "Sorry, no apps for you", color: .black),
            subtitle: ShieldConfiguration.Label(text: "7일 이상의 충분한 잠은\n계획 달성의 필수 조건이에요.\n\n내일의 계획을 지키기 위해\n이제 그만 유튜브를 종료해볼까요?\n\n현재 12일 연속 달성 중", color: .black),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Ask for a break?", color: .black),
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Quick Quick", color: .black)
        )
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
}
