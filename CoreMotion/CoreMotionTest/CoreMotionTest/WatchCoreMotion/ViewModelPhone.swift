//
//  CoreMotionModel.swift
//  CoreMotionTest
//
//  Created by 김영빈 on 2023/07/05.
//

import Foundation
import WatchConnectivity
import SwiftUI

/* WatchConnectivity를 사용하기 위한 ViewModel */
// WCSessionDelegate 프로토콜을 채택하고 WCSession을 초기화하여 WatchConnectivity를 활성화합니다.
class ViewModelPhone: NSObject, ObservableObject, WCSessionDelegate {
    var session: WCSession
    
    @Published var watchAccelerationX: Double = 0.0
    @Published var watchAccelerationY: Double = 0.0
    @Published var watchAccelerationZ: Double = 0.0
    @Published var watchAccX: [[Double]] = [[]]
    @Published var watchAccY: [[Double]] = [[]]
    @Published var watchAccZ: [[Double]] = [[]]
    
//    override init() {
//        super.init()
//
//        if WCSession.isSupported() {
//            WCSession.default.delegate = self
//            WCSession.default.activate() // 세션 활성화
//        }
//    }
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // 세션 활성화가 완료되었을 때 호출되는 메서드
    }
    
//    // 아래 2개의 델리게이트 메서드는 watchOS에서 사용할 수 없기 때문에 플랫폼에 대한 컴파일러 체크를 해 줄 필요가 있습니다.
//    #if os(iOS)
//    func sessionDidBecomeInactive(_ session: WCSession) {
//        // 세션이 비활성화되었을 때 호출되는 메서드
//    }
//    func sessionDidDeactivate(_ session: WCSession) {
//        // 세션이 비활성화된 후 다시 활성화되었을 때 호출되는 메서드
//        session.activate()
//    }
//    #endif
    func sessionDidBecomeInactive(_ session: WCSession) {
        // 세션이 비활성화되었을 때 호출되는 메서드
    }
    func sessionDidDeactivate(_ session: WCSession) {
        // 세션이 비활성화된 후 다시 활성화되었을 때 호출되는 메서드
        session.activate()
    }
    
    // watchOS 앱으로부터 데이터를 받아오고, 메세지에서 가속도 값을 추출하여 x,y,z 각각의 acceleration 값들을 업데이트
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            let acc = userInfo["acc"] as? [Double] ?? [0.0, 0.0, 0.0]
            self.watchAccelerationX = acc[0]
            self.watchAccelerationY = acc[1]
            self.watchAccelerationZ = acc[2]
            self.watchAccX[self.watchAccX.count - 1].append(contentsOf: [self.watchAccelerationX])
            self.watchAccY[self.watchAccY.count - 1].append(contentsOf: [self.watchAccelerationY])
            self.watchAccZ[self.watchAccZ.count - 1].append(contentsOf: [self.watchAccelerationZ])
        }
    }
}
