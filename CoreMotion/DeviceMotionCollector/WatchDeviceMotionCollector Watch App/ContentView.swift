//
//  ContentView.swift
//  WatchDeviceMotionCollector Watch App
//
//  Created by 김영빈 on 2023/07/08.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    let motionManager = CMMotionManager()
    let watchViewModel = WatchViewModel()
    
    @State var timestamp: Double = 0.0
    @State var accelerationX: Double = 0.0
    @State var accelerationY: Double = 0.0
    @State var accelerationZ: Double = 0.0
    @State var rotationRateX: Double = 0.0
    @State var rotationRateY: Double = 0.0
    @State var rotationRateZ: Double = 0.0
    
    @State private var isUpdating = false
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
    @State var csvString = "Time Stamp,Acceleration X,Acceleration Y,Acceleration Z,Rotation Rate X,Rotation Rate Y,Rotation Rate Z\n"
    
    var body: some View {
        VStack {
            HStack {
                //MARK: 기록 시작 버튼
                Button {
                    startRecording()
                    isUpdating = true
                } label: {
                    Text(isUpdating ? "Rcd..." : "Start")
                        .foregroundColor(isUpdating ? .gray : .green)
                }
                //MARK: 기록 중료 버튼
                Button {
                    stopRecording()
                    isUpdating = false
                } label: {
                    Text("Stop")
                        .foregroundColor(isUpdating ? .red : .gray)
                }
            }
            
            //MARK: 타임스탬프
            Text("\(timestamp)")
            
            //MARK: 센서값 보기
            ScrollView {
                Text("Acceleration").bold()
                Text("X: \(accelerationX)")
                Text("Y: \(accelerationY)")
                Text("Z: \(accelerationZ)")
                    .padding(.bottom, 5)
                Text("Rotation Rate").bold()
                Text("X: \(rotationRateX)")
                Text("Y: \(rotationRateY)")
                Text("Z: \(rotationRateZ)")
            }
        }
        .padding()
    }
}

extension ContentView {
    //MARK: Device Motion 레코딩 시작 함수
    func startRecording() {
        // 작업 큐 설정
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1 // 동시에 실행할 수 있는 대기 중 작업의 최대 개수
        
        // Device Motion 수집 가능한지 확인
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion data is not available!!!")
            return
        }
        
        // 모션 갱신 주기 설정 (몇 초마다 모션 데이터를 업데이트 할 지)
        motionManager.deviceMotionUpdateInterval = 0.1
        // Device Motion 업데이트 받기 시작
        motionManager.startDeviceMotionUpdates(to: queue) { (data, error) in
            guard let motion = data, error == nil else {
                print("Failed to get device motion data: \(error?.localizedDescription ?? "Uknown error")")
                return
            }
            // 스윙 모션 감지에 필요한 데이터 불러오기
            let acceleration = motion.userAcceleration
            let rotationRate = motion.rotationRate
            
            csvString = csvString + "\(timestamp), \(acceleration.x), \(acceleration.y), \(acceleration.z), \(rotationRate.x), \(rotationRate.y), \(rotationRate.z)\n"
            
            timestamp = motion.timestamp
            accelerationX = acceleration.x
            accelerationY = acceleration.y
            accelerationZ = acceleration.z
            rotationRateX = rotationRate.x
            rotationRateY = rotationRate.y
            rotationRateZ = rotationRate.z
        }
    }
    
    //MARK: Device Motion 레코딩 종료 함수
    func stopRecording() {
        motionManager.stopDeviceMotionUpdates()
        // 아이폰으로 csv 문자열 전송
        self.watchViewModel.session.transferUserInfo(["csv" : csvString])
        print("Send CSV string to iPhone.")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
