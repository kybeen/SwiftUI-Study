//
//  ContentView.swift
//  WatchCoreMotionTest Watch App
//
//  Created by 김영빈 on 2023/07/04.
//

import SwiftUI
import CoreMotion
import WatchConnectivity

struct ContentView: View {
    @StateObject private var viewModel = WatchConnectivityViewModel()
    private let motionManager = CMMotionManager()
    
    var body: some View {
        VStack {
            Text("Acceleration X: \(viewModel.watchAccelerationX)")
            Text("Acceleration Y: \(viewModel.watchAccelerationY)")
            Text("Acceleration Z: \(viewModel.watchAccelerationZ)")
        }
        .onAppear {
            guard motionManager.isDeviceMotionAvailable else {
                print("Device motion data is not available")
                return
            }
            motionManager.deviceMotionUpdateInterval = 0.1 // 모션 갱신 주기 설정
            // Device motion 업데이트 받기 시작
            motionManager.startDeviceMotionUpdates(to: .main) { accelerometerData, error in
                guard let data = accelerometerData, error == nil else {
                    print("Failed to get device motion data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                // 스윙 모션 감지에 필요한 데이터 불러오기
                let acceleration = data.userAcceleration
                
                let message = ["accelerationX": acceleration.x,
                               "accelerationY": acceleration.y,
                               "accelerationZ": acceleration.z]
                if WCSession.default.isReachable {
                    WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
                }
            }
        }
        .onDisappear() {
            motionManager.stopAccelerometerUpdates()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
