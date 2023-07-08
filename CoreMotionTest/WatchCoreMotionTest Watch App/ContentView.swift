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
    let watchWidth = WKInterfaceDevice.current().screenBounds.width
    let watchHeight = WKInterfaceDevice.current().screenBounds.height
    @State private var watchScrollWidth: CGFloat = WKInterfaceDevice.current().screenBounds.width
    @State var accX = 0.0
    @State var accY = 0.0
    @State var accZ = 0.0
    @State private var accArrX: [[Double]] = [[]]
    @State private var accArrY: [[Double]] = [[]]
    @State private var accArrZ: [[Double]] = [[]]
    
    var viewModel = ViewModelWatch()
    private let motionManager = CMMotionManager()
    
    var body: some View {
        VStack {
//            Text("Acceleration")
//            Text("X: \(accX)")
//            Text("Y: \(accY)")
//            Text("Z: \(accZ)")
            VStack {
                Text("X").bold()
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(accArrX.indices, id: \.self) { index in
                            GraphView(dataPoints: accArrX[index])
                                .frame(width: watchWidth, height: 20)
                        }
                    }
                }
                .frame(width: watchScrollWidth, height: 20)
                Text("Y").bold()
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(accArrY.indices, id: \.self) { index in
                            GraphView(dataPoints: accArrY[index])
                                .frame(width: watchWidth, height: 20)
                        }
                    }
                }
                .frame(width: watchScrollWidth, height: 20)
                Text("Z").bold()
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(accArrZ.indices, id: \.self) { index in
                            GraphView(dataPoints: accArrZ[index])
                                .frame(width: watchWidth, height: 20)
                        }
                    }
                }
                .frame(width: watchScrollWidth, height: 20)
            }
            HStack {
                Button {
                    startRecordingDeviceMotion()
                    print("Start Button Clicked on Watch!!!")
                } label: {
                    Text("Start")
                        .font(.body)
                        .foregroundColor(.green)
                }
                Button {
                    stopRecordingDeviceMotion()
                    print("Stop Button Clicked on Watch!!!")
                } label: {
                    Text("Stop")
                        .font(.body)
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
            
//            let message = ["accelerationX": acceleration.x,
//                           "accelerationY": acceleration.y,
//                           "accelerationZ": acceleration.z]
//            if WCSession.default.isReachable {
//                WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
//            }
            accX = acceleration.x
            accY = acceleration.y
            accZ = acceleration.z
            accArrX[accArrX.count - 1].append(contentsOf: [acceleration.x])
            accArrY[accArrY.count - 1].append(contentsOf: [acceleration.y])
            accArrZ[accArrZ.count - 1].append(contentsOf: [acceleration.z])
            let userInfo = ["acc": [acceleration.x, acceleration.y, acceleration.z]]
            self.viewModel.session.transferUserInfo(userInfo)
            self.watchScrollWidth += 1
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
