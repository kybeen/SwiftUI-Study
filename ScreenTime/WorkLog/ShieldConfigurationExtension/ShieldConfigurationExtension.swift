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
    
    let title = "😴\n잠에 들 시간이에요"
    let body = "\n(설정한 시간)이상의 수면은\n내일의 계획을 지키는 데 필수에요\n\n내일의 계획을 지키려면\n지금 반드시 주무셔야 해요\n\n내일의 계획을 지키기 위해\n이제 그만 앱을 종료해볼까요?\n"
    
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
            backgroundBlurStyle: UIBlurEffect.Style.extraLight,
            backgroundColor: UIColor.white.withAlphaComponent(0.1),
            icon: UIImage(systemName: "stopwatch"),
            title: ShieldConfiguration.Label(text: self.title, color: .black),
            //subtitle: ShieldConfiguration.Label(text: "Sorry, no apps for you", color: .black),
            subtitle: ShieldConfiguration.Label(text: "\n(설정한 시간)이상의 수면은\n내일의 계획을 지키는 데 필수에요\n\n내일의 계획을 지키려면\n지금 반드시 주무셔야 해요\n\n내일의 계획을 지키기 위해\n이제 그만 앱을 종료해볼까요?\n\(testInt)", color: .black),
            primaryButtonLabel: ShieldConfiguration.Label(text: "종료하기", color: .black),
            secondaryButtonLabel: ShieldConfiguration.Label(text: "내일의 계획 안지키기", color: .black)
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
