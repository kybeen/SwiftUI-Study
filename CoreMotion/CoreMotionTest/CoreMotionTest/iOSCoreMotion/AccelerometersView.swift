//
//  MotionManagerView.swift
//  CoreMotionTest
//
//  Created by 김영빈 on 2023/07/02.
//

/* 가속도계 센서 데이터 - iOS */
import SwiftUI
import CoreMotion
import Charts

struct AccelerometersView: View {
    @State private var accX: [[Double]] = [[]]
    @State private var accY: [[Double]] = [[]]
    @State private var accZ: [[Double]] = [[]]
    @State private var timer: Timer?
    @State private var scrollWidth: CGFloat = UIScreen.main.bounds.width
    
    @State private var isSwinging = false
    @State private var isUpdating = false
    
    @State private var accelerationX: Double = 0
    @State private var accelerationY: Double = 0
    @State private var accelerationZ: Double = 0
    
    // CMMotionManager: 모션에 대한 이벤트들을 처리할 수 있게 도와주는 오픈 클래스
    let motionManager = CMMotionManager()
    
    var body: some View {
        VStack {
            Text("Accelerometers")
                .font(.largeTitle)
                .bold()
            
            Text(isSwinging ? "Swinging" : "Not Swinging")
                .font(.title2)
                .foregroundColor(isSwinging ? .green : .red)
            
            Text("Acceleration").bold()
            Text("X: \(accelerationX), Y: \(accelerationY), Z: \(accelerationZ)")
            
            VStack {
                Text("X").bold()
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(accX.indices, id: \.self) { index in
                            GraphView(dataPoints: accX[index])
                                .frame(width: UIScreen.main.bounds.width, height: 120)
                        }
                    }
                }
                .frame(width: scrollWidth, height: 120)
                Text("Y").bold()
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(accY.indices, id: \.self) { index in
                            GraphView(dataPoints: accY[index])
                                .frame(width: UIScreen.main.bounds.width, height: 120)
                        }
                    }
                }
                .frame(width: scrollWidth, height: 120)
                Text("Z").bold()
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(accZ.indices, id: \.self) { index in
                            GraphView(dataPoints: accZ[index])
                                .frame(width: UIScreen.main.bounds.width, height: 120)
                        }
                    }
                }
                .frame(width: scrollWidth, height: 120)
            }
            
            HStack {
                Button {
                    startMotionUpdates()
                    isUpdating = true
                } label: {
                    Text(isUpdating ? "Swinging..." : "Start Swing")
                        .font(.title)
                        .padding()
                        .background(isUpdating ? .gray : .green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button {
                    stopMotionUpdates()
                    isUpdating = false
                } label: {
                    Text("Stop Swing")
                        .font(.title)
                        .padding()
                        .background(isUpdating ? .red : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

extension AccelerometersView {
    func startMotionUpdates() {
        // 가속도계 업데이트를 위한 큐 설정
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1 // 동시에 실행할 수 있는 대기 중 작업의 최대 개수
        
        // MotionManager 사용 가능 여부 확인
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion data is not available")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 0.1 // 모션 갱신 주기 설정
        // device motion 업데이트를 받기 시작함
        motionManager.startDeviceMotionUpdates(to: queue) { (motion, error) in
            guard let motion = motion, error == nil else {
                print("Failed to get device motion data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // 스윙 모션 감지에 필요한 데이터 불러오기 (가속도계나 자이로스코프 데이터 등... 필요한거 추가)
            let acceleration = motion.userAcceleration
            accelerationX = acceleration.x
            accelerationY = acceleration.y
            accelerationZ = acceleration.z
            accX[accX.count - 1].append(contentsOf: [acceleration.x])
            accY[accY.count - 1].append(contentsOf: [acceleration.y])
            accZ[accZ.count - 1].append(contentsOf: [acceleration.z])
            
            scrollWidth += 1
            
            //MARK: 스윙 감지 로직 작성 필요
            // 스윙 감지 로직 작성
            if acceleration.x > 2.0 || acceleration.y > 2.0 || acceleration.z > 2.0 {
                // 동작 감지됨
                DispatchQueue.main.async {
                    let isSwingDetected = true
                    isSwinging = isSwingDetected
                }
            } else {
                // 동작 감지 안됨
                DispatchQueue.main.async {
                    let isSwingDetected = false
                    isSwinging = isSwingDetected
                }
            }
        }
    }
    
    func stopMotionUpdates() {
        // device motion 업데이트 받기를 중지
        motionManager.stopDeviceMotionUpdates()
    }
}

struct AccelerometersView_Previews: PreviewProvider {
    static var previews: some View {
        AccelerometersView()
    }
}
