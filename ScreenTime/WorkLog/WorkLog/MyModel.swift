//
//  MyModel.swift
//  Worklog
//
//  Created by 김영빈 on 2023/04/28.
//

import Foundation
import FamilyControls
import ManagedSettings

// MyModel 클래스의 인스턴스를 만들고, _MyModel이라는 이름으로 전역 상수로 저장
private let _MyModel = MyModel()

class MyModel: ObservableObject {
    let store = ManagedSettingsStore()
    
    // FamilyActivitySelection : 사용자가 선택한 앱,카테고리,웹도메인의 모음
    @Published var selectionToDiscourage: FamilyActivitySelection
    @Published var selectionToEncourage: FamilyActivitySelection
    
    init() {
        selectionToDiscourage = FamilyActivitySelection() // selection 인스턴스 생성
        selectionToEncourage = FamilyActivitySelection()
    }
    
    // 공유 인스턴스를 반환하는 정적 메서드
    class var shared: MyModel {
        return _MyModel
    }
    
    func setShieldRestriction() {
        // Pull the selection out of the app's model and configure the application shield restriction accordingly
        let applications = MyModel.shared.selectionToDiscourage // 사용자가 선택한 제한시킬 앱 리스트

        // shield : Settings that affect what activities the system covers with a shielding view on this device.
        // FamilyActivitySelection인스턴스에는 사용자가 선택한 카테고리와 앱을 나타내는 토큰값이 들어 있음
        store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens // ManagedSettingsStore에 토큰값 저장? (Set<ApplicationToken>)
        store.shield.applicationCategories = applications.categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens) // Set<ActivityCategoryToken>
    }
}









