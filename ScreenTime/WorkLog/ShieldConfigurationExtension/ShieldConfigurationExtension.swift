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
import Foundation

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    @AppStorage("testInt", store: UserDefaults(suiteName: "group.com.shield.dreamon"))
    var testInt = 0
    
    let imageName = "stopwatch"
    let title = "😴 잠에 들 시간이에요\n\(MyModel.shared.additionalCount)"
    let subtitle = "\n(N)시간 이상의 숙면은\n내일의 계획을 지키는 데 필수적이에요\n\n내일의 계획을 지키려면\n지금 반드시 잠에 들어야 해요\n\n내일의 계획을 지키기 위해\n이제 그만 앱을 종료해볼까요?"
    let primaryButtonnText = "내일의 계획 지키기"
    let secondaryButtonText = "내일의 계획 안지키기"
    
    let uiColorValue = UIColor(red: 15/255, green: 0/255, blue: 148/255, alpha: 1.0) // Hex 0x0F0094의 UIColor값
    
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
            icon: UIImage(systemName: imageName),
            title: ShieldConfiguration.Label(text: "😴 잠에 들 시간이에요\n\(MyModel.shared.additionalCount)", color: .black),
            subtitle: ShieldConfiguration.Label(text: subtitle, color: .black),
            primaryButtonLabel: ShieldConfiguration.Label(text: primaryButtonnText, color: .white),
            primaryButtonBackgroundColor: uiColorValue,
            secondaryButtonLabel: ShieldConfiguration.Label(text: secondaryButtonText, color: uiColorValue)
        )
//        if MyModel.shared.additionalCount >= 2 {
//            return ShieldConfiguration(
//                backgroundBlurStyle: UIBlurEffect.Style.extraLight,
//                backgroundColor: UIColor.white.withAlphaComponent(0.1),
//                icon: UIImage(systemName: imageName),
//                title: ShieldConfiguration.Label(text: "😴 잠에 들 시간이에요\n\(MyModel.shared.additionalCount)", color: .black),
//                subtitle: ShieldConfiguration.Label(text: subtitle, color: .black),
//                primaryButtonLabel: ShieldConfiguration.Label(text: primaryButtonnText, color: .white),
//                primaryButtonBackgroundColor: uiColorValue
//            )
//        } else {
//            return ShieldConfiguration(
//                backgroundBlurStyle: UIBlurEffect.Style.extraLight,
//                backgroundColor: UIColor.white.withAlphaComponent(0.1),
//                icon: UIImage(systemName: imageName),
//                title: ShieldConfiguration.Label(text: "😴 잠에 들 시간이에요\n\(MyModel.shared.additionalCount)", color: .black),
//                subtitle: ShieldConfiguration.Label(text: subtitle, color: .black),
//                primaryButtonLabel: ShieldConfiguration.Label(text: primaryButtonnText, color: .white),
//                primaryButtonBackgroundColor: uiColorValue,
//                secondaryButtonLabel: ShieldConfiguration.Label(text: secondaryButtonText, color: uiColorValue)
//            )
//        }
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
