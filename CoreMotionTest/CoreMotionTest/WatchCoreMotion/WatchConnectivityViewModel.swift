//
//  CoreMotionModel.swift
//  CoreMotionTest
//
//  Created by 김영빈 on 2023/07/05.
//

import Foundation
import WatchConnectivity

// WatchConnectivity를 사용하기 위한 ViewModel
// WCSessionDelegate 프로토콜을 채택하고 WCSession을 초기화하여 WatchConnectivity를 활성화합니다.
class WatchConnectivityViewModel: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchConnectivityViewModel()
    @Published var accelerationX: Double = 0.0
    @Published var accelerationY: Double = 0.0
    @Published var accelerationZ: Double = 0.0
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // 세션 활성화가 완료되었을 때 호출되는 메서드
    }
    
    // 아래 2개의 델리게이트 메서드는 watchOS에서 사용할 수 없기 때문에 플랫폼에 대한 컴파일러 체크를 해 줄 필요가 있습니다.
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        // 세션이 비활성화되었을 때 호출되는 메서드
    }
    func sessionDidDeactivate(_ session: WCSession) {
        // 세션이 비활성화된 후 다시 활성화되었을 때 호출되는 메서드
        session.activate()
    }
    #endif
    
    // watchOS 앱으로부터 메세지를 받아오고, 메세지에서 가속도 값을 추출하여 x,y,z 각각의 acceleration 값들을 업데이트
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let accelerationX = message["accelerationX"] as? Double,
            let accelerationY = message["accelerationY"] as? Double,
            let accelerationZ = message["accelerationZ"] as? Double {
                self.accelerationX = accelerationX
                self.accelerationY = accelerationY
                self.accelerationZ = accelerationZ
            }
        }
    }
}




//struct NotificationMessage: Identifiable {
//    let id = UUID()
//    let text: String
//}
//
//// WCSessionDelegate 프로토콜이 NSObjectProtocol로부터 상속되기 때문에 WatchConnectivityManager클래스는 NSObject로부터 상속받을 필요가 있습니다.
//final class WatchConnectivityManager: NSObject, ObservableObject {
//    static let shared = WatchConnectivityManager()
//    @Published  var notificationMessage: NotificationMessage? = nil
//
//    private override init() {
//        super.init()
//
//        // 세션을 구성하고 활성화하기
//        if WCSession.isSupported() {
//            WCSession.default.delegate = self
//            WCSession.default.activate()
//        }
//    }
//
//    private let kMessageKey = "message"
//
//    func send(_ message: String) {
//        guard WCSession.default.activationState == .activated else {
//            return
//        }
//        #if os(iOS)
//        guard WCSession.default.isWatchAppInstalled else {
//            return
//        }
//        #else
//        guard WCSession.default.isCompanionAppInstalled else {
//            return
//        }
//        #endif
//
//        WCSession.default.sendMessage([kMessageKey : message], replyHandler: nil) { error in
//            print("Cannot send message: \(String(describing: error))")
//        }
//    }
//}
//
//extension WatchConnectivityManager: WCSessionDelegate {
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//        if let notificationText = message[kMessageKey] as? String {
//            DispatchQueue.main.async { [weak self] in
//                self?.notificationMessage = NotificationMessage(text: notificationText)
//            }
//        }
//    }
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
//
//    // 아래 2개의 델리게이트 메서드는 watchOS에서 사용할 수 없기 때문에 플랫폼에 대한 컴파일러 체크를 해 줄 필요가 있습니다.
//    #if os(iOS)
//    func sessionDidBecomeInactive(_ session: WCSession) {}
//    func sessionDidDeactivate(_ session: WCSession) {
//        // 라인 25는 비활성화될 경우를 대비하여 세션을 활성화합니다. 이것은 사용자가 여러 개의 시계를 소유하고 있고 시계 전환을 지원해야 하는 경우 발생할 수 있습니다.
//        session.activate()
//    }
//    #endif
//}
