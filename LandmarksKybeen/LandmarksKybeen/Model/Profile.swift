//
//  Profile.swift
//  LandmarksKybeen
//
//  Created by 김영빈 on 2023/03/23.
//

import Foundation

struct Profile {
    var username: String
    var prefersNotifications = true
    var seasonalPhoto = Season.winter
    var goalDate = Date()
    
    // Profile의 기본 인스턴스 설정 (default는 예약어이기 때문에 ``를 붙여줘야 컴파일러가 프로퍼티로 인식함)
    static let `default` = Profile(username: "kybeen")
    
    enum Season: String, CaseIterable, Identifiable {
        case spring = "🌷"
        case summer = "🌞"
        case autumn = "🍂"
        case winter = "☃️"
        
        var id: String { rawValue }
    }
}
