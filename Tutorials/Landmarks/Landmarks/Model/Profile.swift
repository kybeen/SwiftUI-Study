//
//  Profile.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/17.
//

//  Profile.swift
import Foundation

struct Profile {
    var username: String // 사용자명
    var prefersNotifications = true // 알림 수신 여부
    var seasonalPhoto = Season.winter // 랜드마크 선호 계절
    var goalDate = Date() // 랜드마크 방문 목표 날짜
    
    static let `default` = Profile(username: "kybeen") // 디폴트 프로필
    
    enum Season: String, CaseIterable, Identifiable {
        case spring = "🌷"
        case summer = "🌞"
        case autumn = "🍂"
        case winter = "☃️"
        
        var id: String { rawValue }
    }
}
