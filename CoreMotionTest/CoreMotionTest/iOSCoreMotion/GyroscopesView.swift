//
//  BatchedSensorManagerView.swift
//  CoreMotionTest
//
//  Created by 김영빈 on 2023/07/02.
//

import SwiftUI
import CoreMotion

struct GyroscopesView: View {
    @State private var rotX: [[Double]] = [[]]
    @State private var rotY: [[Double]] = [[]]
    @State private var rotZ: [[Double]] = [[]]
    @State private var timer: Timer?
    @State private var scrollWidth: CGFloat = UIScreen.main.bounds.width
    
    @State private var isSwinging = false
    @State private var isUpdating = false
    
    @State private var rotationX: Double = 0
    @State private var rotationY: Double = 0
    @State private var rotationZ: Double = 0
    
    // CMMotionManager: 모션에 대한 이벤트들을 처리할 수 있게 도와주는 오픈 클래스
    let motionManager = CMMotionManager()
    
    var body: some View {
        VStack {
            Text("Gyroscopes")
                .font(.largeTitle)
                .bold()
            
            Text(isSwinging ? "Swinging" : "Not Swinging")
                .font(.title2)
                .foregroundColor(isSwinging ? .green : .red)
            
//            Text("Acceleration").bold()
//            Text("X: \(accelerationX), Y: \(accelerationY), Z: \(accelerationZ)")
            Text("Rotation Rate").bold()
            Text("X: \(rotationX), Y: \(rotationY), Z: \(rotationZ)")
            
            VStack {
                Text("X").bold()
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(rotX.indices, id: \.self) { index in
                            GraphView(dataPoints: rotX[index])
                                .frame(width: UIScreen.main.bounds.width, height: 120)
                        }
                    }
                }
                .frame(width: scrollWidth, height: 120)
                Text("Y").bold()
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(rotY.indices, id: \.self) { index in
                            GraphView(dataPoints: rotY[index])
                                .frame(width: UIScreen.main.bounds.width, height: 120)
                        }
                    }
                }
                .frame(width: scrollWidth, height: 120)
                Text("Z").bold()
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(rotZ.indices, id: \.self) { index in
                            GraphView(dataPoints: rotZ[index])
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

extension GyroscopesView {
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
            let rotationRate = motion.rotationRate
            rotationX = rotationRate.x
            rotationY = rotationRate.y
            rotationZ = rotationRate.z
            rotX[rotX.count - 1].append(contentsOf: [rotationRate.x])
            rotY[rotY.count - 1].append(contentsOf: [rotationRate.y])
            rotZ[rotZ.count - 1].append(contentsOf: [rotationRate.z])
            
            scrollWidth += 1
            
            //MARK: 스윙 감지 로직 작성 필요
            // 스윙 감지 로직 작성
            if rotationRate.x > 2.0 || rotationRate.y > 2.0 || rotationRate.z > 2.0 {
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

struct GyroscopesView_Previews: PreviewProvider {
    static var previews: some View {
        GyroscopesView()
    }
}
