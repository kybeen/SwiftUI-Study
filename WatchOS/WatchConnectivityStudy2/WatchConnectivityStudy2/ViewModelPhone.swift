//
//  ViewModelPhone.swift
//  WatchConnectivityStudy2
//
//  Created by 김영빈 on 2023/07/07.
//

import Foundation
import WatchConnectivity

// watchOS와의 연결을 관리하는 클래스 -> NSObject, WCSessionDelegate 프로토콜을 준수해야 함
// WCSessionDelegate 프로토콜 준수 시에 아래 3가지 델리게이트 메서드를 정의해줘야함
class ViewModelPhone: NSObject, WCSessionDelegate {
    var session: WCSession
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    /**
     델리게이트 메서드
        - 맨 아래 2개 메서드는 watchOS에서는 구현 X
        - iOS에서는 3개 다 구현
     */
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
