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
    @Published var confidence: Double = 0.0
    @Published var perfectCount: Int = 0
    @Published var badCount: Int = 0
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
            self.confidence = userInfo["confidence"] as? Double ?? self.confidence
            self.perfectCount = userInfo["perfectCount"] as? Int ?? self.perfectCount
            self.badCount = userInfo["badCount"] as? Int ?? self.badCount
            self.totalCount = userInfo["totalCount"] as? Int ?? self.totalCount
        }
    }
}
