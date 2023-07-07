//
//  ContentView.swift
//  WatchCoreMotionTest Watch App
//
//  Created by 김영빈 on 2023/07/04.
//

/* watchOS에서 Core Motion 데이터 수집하기 */
import SwiftUI
import CoreMotion
import WatchConnectivity

struct ContentView: View {
    @StateObject private var viewModel = WatchConnectivityViewModel()
    private let motionManager = CMMotionManager()
    
    var body: some View {
        VStack {
            Text("Acceleration")
            Text("X: \(viewModel.watchAccelerationX)")
            Text("Y: \(viewModel.watchAccelerationY)")
            Text("Z: \(viewModel.watchAccelerationZ)")
            HStack {
                Button {
                    startRecordingDeviceMotion()
                    print("Start Button Clicked on Watch!!!")
                } label: {
                    Text("Start")
                        .foregroundColor(.green)
                }
                Button {
                    stopRecordingDeviceMotion()
                    print("Stop Button Clicked on Watch!!!")
                } label: {
                    Text("Stop")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

extension ContentView {
    func startRecordingDeviceMotion() {
        // Device motion을 수집 가능한지 확인
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion data is not available")
            return
        }
        
        // 모션 갱신 주기 설정
        motionManager.deviceMotionUpdateInterval = 0.1
        // Device motion 업데이트 받기 시작
        motionManager.startDeviceMotionUpdates(to: .main) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            guard let data = deviceMotion, error == nil else {
                print("Failed to get device motion data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // 필요한 센서값 불러오기
            let acceleration = data.userAcceleration
            
            let message = ["accelerationX": acceleration.x,
                           "accelerationY": acceleration.y,
                           "accelerationZ": acceleration.z]
            if WCSession.default.isReachable {
                WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
            }
        }
    }
    
    func stopRecordingDeviceMotion() {
        motionManager.stopDeviceMotionUpdates()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
