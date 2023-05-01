//
//  MyMonitor.swift
//  Worklog
//
//  Created by 김영빈 on 2023/05/02.
//

/*
 DeviceActivityMonitor를 상속받는 클래스를 정의하고
 지정된 메소드를 오버라이드해주면 사용을 제한시킬 앱들에 shield를 적용해줄 수 있음
 
 - familyActivityPicker로 선택된 값들이 저장된 모델을 불러와서 application shield restriction를 구성해줌
 - application shield restriction에 접근하려면 ManagedSettings를 임포트 해줘야함
 - application shield restriction 적용 해제는 nil값을 대입
*/
import DeviceActivity
import ManagedSettings

class MyMonitor: DeviceActivityMonitor {
    let store = ManagedSettingsStore()
    
    // schedule의 시작 시점 이후 처음으로 기기가 사용될 때 호출
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
//        let model = MyModel()
//        let applications = model.selectionToDiscourage
//
//        store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
//        store.shield.applicationCategories = applications.categoryTokens.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
    }
    
    // schedule의 종료 시점 이후 처음으로 기기가 사용될 때 호출
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        store.shield.applications = nil
        
    }
}
