//
//  PhoneViewModel.swift
//  TennisClassifierTest
//
//  Created by 김영빈 on 2023/07/13.
//

import Foundation
import WatchConnectivity

class PhoneViewModel: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    @Published var forehandLabel = "?"
    @Published var confidence: Double = 0.0
    @Published var forehandCount: Int = 0
    
    //MARK: 델리게이트 메서드
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    //MARK: 다른 기기의 세션으로부터 transferUserInfo(_:) 메서드로 데이터를 받았을 때 호출되는 메서드
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            // 받아온 데이터 저장
            print("Received data from apple watch")
            self.forehandLabel = userInfo["forehandLabel"] as? String ?? "?"
            self.confidence = userInfo["confidence"] as? Double ?? 0.0
            self.forehandCount = userInfo["forehandCount"] as? Int ?? 0
        }
    }
}
