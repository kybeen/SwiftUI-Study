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
    
    @Published var classLabel = "?"
    @Published var resultLabel = "?"
    @Published var confidence: String = "0.0"
    @Published var forehandPerfectCount: Int = 0
    @Published var forehandBadCount: Int = 0
    @Published var backhandPerfectCount: Int = 0
    @Published var backhandBadCount: Int = 0
    @Published var totalCount: Int = 0
    
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
            self.classLabel = userInfo["label"] as? String ?? self.classLabel
            self.resultLabel = userInfo["result"] as? String ?? self.resultLabel
            self.confidence = userInfo["confidence"] as? String ?? self.confidence
            self.forehandPerfectCount = userInfo["forehandPerfectCount"] as? Int ?? self.forehandPerfectCount
            self.forehandBadCount = userInfo["forehandBadCount"] as? Int ?? self.forehandBadCount
            self.backhandPerfectCount = userInfo["backhandPerfectCount"] as? Int ?? self.backhandPerfectCount
            self.backhandBadCount = userInfo["backhandBadCount"] as? Int ?? self.backhandBadCount
            self.totalCount = userInfo["totalCount"] as? Int ?? self.totalCount
        }
    }
}
