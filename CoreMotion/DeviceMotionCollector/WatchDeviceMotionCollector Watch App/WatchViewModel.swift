//
//  WatchViewModel.swift
//  WatchDeviceMotionCollector Watch App
//
//  Created by 김영빈 on 2023/07/09.
//

import Foundation
import WatchConnectivity

class WatchViewModel: NSObject, WCSessionDelegate {
    var session: WCSession
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}
