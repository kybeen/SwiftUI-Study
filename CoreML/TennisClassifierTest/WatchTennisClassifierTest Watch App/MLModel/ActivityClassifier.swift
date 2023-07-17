//
//  TennisClassifier.swift
//  TennisClassifierTest
//
//  Created by 김영빈 on 2023/07/12.
//

import Foundation
import CoreML
import CoreMotion
import Combine

class ActivityClassifier: NSObject, ObservableObject {
    let motionManager = CMMotionManager()
    let watchViewModel = WatchviewModel()
    
    let windowSize = 300 // 슬라이딩 윈도우 크기 설정
    let frequency = 100 // 데이터 빈도수
    @Published var classLabel: String = "?" // 동작 분류 결과 라벨
    @Published var confidence: Double = 0.0 // 분류 Confidence
    @Published var forehandCount: Int = 0 // 포핸드 동작 횟수
    @Published var timestamp: Double = 0.0

    // 슬라이딩 윈도우 버퍼
    var bufferAccX: [Double] = []
    var bufferAccY: [Double] = []
    var bufferAccZ: [Double] = []
    var bufferRotX: [Double] = []
    var bufferRotY: [Double] = []
    var bufferRotZ: [Double] = []
    
    //MARK: 감지 시작
    func startTracking() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion service is not available")
            return
        }
        var startTime: TimeInterval = 0.0 // 시작 시간 저장 변수
        motionManager.deviceMotionUpdateInterval = TimeInterval(1 / frequency) // 센서 데이터 빈도수 설정
        motionManager.startDeviceMotionUpdates(to: .main) { (deviceMotion, error) in
            guard let deviceMotionData = deviceMotion, error==nil else {
                print("Failed to get device motion data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if startTime == 0.0 {
                startTime = deviceMotionData.timestamp // 첫 번째 데이터의 타임스탬프 저장
            }
            let timestamp = deviceMotionData.timestamp - startTime // 시작 시간으로부터 경과한 시간 계산
            self.timestamp = timestamp
            let accelerationX = deviceMotionData.userAcceleration.x
            let accelerationY = deviceMotionData.userAcceleration.y
            let accelerationZ = deviceMotionData.userAcceleration.z
            let rotationRateX = deviceMotionData.rotationRate.x
            let rotationRateY = deviceMotionData.rotationRate.y
            let rotationRateZ = deviceMotionData.rotationRate.z
            
            self.bufferAccX.append(accelerationX)
            self.bufferAccY.append(accelerationY)
            self.bufferAccZ.append(accelerationZ)
            self.bufferRotX.append(rotationRateX)
            self.bufferRotY.append(rotationRateY)
            self.bufferRotZ.append(rotationRateZ)
            
            // 입력 데이터가 windowSize에 도달하면 예측 수행
            if self.bufferAccX.count >= self.windowSize {
                // 입력값 준비
                let startIndex = 0
                let endIndex = self.windowSize - 1
                let MultiArrayAccX = try! MLMultiArray(shape: [NSNumber(value: self.windowSize)], dataType: .double)
                let MultiArrayAccY = try! MLMultiArray(shape: [NSNumber(value: self.windowSize)], dataType: .double)
                let MultiArrayAccZ = try! MLMultiArray(shape: [NSNumber(value: self.windowSize)], dataType: .double)
                let MultiArrayRotX = try! MLMultiArray(shape: [NSNumber(value: self.windowSize)], dataType: .double)
                let MultiArrayRotY = try! MLMultiArray(shape: [NSNumber(value: self.windowSize)], dataType: .double)
                let MultiArrayRotZ = try! MLMultiArray(shape: [NSNumber(value: self.windowSize)], dataType: .double)
                let MultiArrayStateIn = try! MLMultiArray(shape: [400], dataType: .double)
                
                for i in startIndex..<endIndex {
                    MultiArrayAccX[i] = NSNumber(value: self.bufferAccX[i])
                    MultiArrayAccY[i] = NSNumber(value: self.bufferAccY[i])
                    MultiArrayAccZ[i] = NSNumber(value: self.bufferAccZ[i])
                    MultiArrayRotX[i] = NSNumber(value: self.bufferRotX[i])
                    MultiArrayRotY[i] = NSNumber(value: self.bufferRotY[i])
                    MultiArrayRotZ[i] = NSNumber(value: self.bufferRotZ[i])
                }
                
                let input = RightHandTennisActivityClassifierInput(
                    Acceleration_X: MultiArrayAccX,
                    Acceleration_Y: MultiArrayAccY,
                    Acceleration_Z: MultiArrayAccZ,
                    Rotation_Rate_X: MultiArrayRotX,
                    Rotation_Rate_Y: MultiArrayRotY,
                    Rotation_Rate_Z: MultiArrayRotZ,
                    stateIn: MultiArrayStateIn
                )
                
                // 모델 불러오기
                guard let modelURL = Bundle.main.url(forResource: "RightHandTennisActivityClassifier", withExtension: "mlmodelc") else {
                    fatalError("Failed to locate the model file.")
                }
                guard let model = try? RightHandTennisActivityClassifier(contentsOf: modelURL) else {
                    fatalError("Failed to create the model.")
                }
                // 예측 수행
                guard let output = try? model.prediction(input: input) else {
                    fatalError("Failed to predict.")
                }
                
                if output.label == "Forehand" {
                    self.classLabel = "Forehand"
                    self.forehandCount += 1
                } else {
                    self.classLabel = "Backhand"
                }
                self.confidence = output.labelProbability[self.classLabel] ?? -1.0
                print("Predicted Label: \(output.label) - Confidence: \(output.labelProbability[output.label] ?? 0.0)")
                
                // 이후 처리를 위해 윈도우 버퍼 한 칸씩 조정
                self.bufferAccX.removeFirst()
                self.bufferAccY.removeFirst()
                self.bufferAccZ.removeFirst()
                self.bufferRotX.removeFirst()
                self.bufferRotY.removeFirst()
                self.bufferRotZ.removeFirst()
                
                // 아이폰으로 데이터 전송
                self.watchViewModel.session.transferUserInfo(["forehandLabel": self.classLabel, "confidence": self.confidence, "forehandCount": self.forehandCount])
            }
        }
    }
    
    func stopTracking() {
        // 버퍼 초기화
        self.bufferAccX = []
        self.bufferAccY = []
        self.bufferAccZ = []
        self.bufferRotX = []
        self.bufferRotY = []
        self.bufferRotZ = []
        
        motionManager.stopDeviceMotionUpdates()
    }
}










//import Foundation
//import CoreML
//import CoreMotion
//import Combine
//
//class ActivityClassifier: NSObject, ObservableObject {
//    let motionManager = CMMotionManager()
//    let watchViewModel = WatchviewModel()
//
//    @Published var classLabel: String = "?"
//    @Published var confidence: Double = 0.0
//    @Published var forehandCount: Int = 0
//    @Published var timestamp: Double = 0.0
//
//    func startTracking() {
//        let windowSize = 300 // prediction window 크기 설정
//        var inputData: [Double] = [] // 입력 데이터를 저장할 배열
////        // 작업 큐 설정
////        let queue = OperationQueue()
////        queue.maxConcurrentOperationCount = 1 // 동시에 실행할 수 있는 대기 중 작업의 최대 개수
//
//        guard motionManager.isDeviceMotionAvailable else {
//            print("Device motion data is not available")
//            return
//        }
//
//        var startTime: TimeInterval = 0.0 // 시작 시간 저장 변수
//        motionManager.deviceMotionUpdateInterval = 0.1 // 100Hz의 센서 데이터
//        motionManager.startDeviceMotionUpdates(to: .main) { (deviceMotion, error) in
//            guard let deviceMotionData = deviceMotion else {
//                print("Failed to get device motion data: \(error?.localizedDescription ?? "")")
//                return
//            }
//
//            if startTime == 0.0 {
//                startTime = deviceMotionData.timestamp // 첫 번째 데이터의 타임스탬프 저장
//            }
//            let timestamp = deviceMotionData.timestamp - startTime // 시작 시간으로부터 경과한 시간 계산
//            self.timestamp = timestamp
//            let accelerationX = deviceMotionData.userAcceleration.x
//            let accelerationY = deviceMotionData.userAcceleration.y
//            let accelerationZ = deviceMotionData.userAcceleration.z
//            let rotationRateX = deviceMotionData.rotationRate.x
//            let rotationRateY = deviceMotionData.rotationRate.y
//            let rotationRateZ = deviceMotionData.rotationRate.z
//
//            inputData.append(accelerationX)
//            inputData.append(accelerationY)
//            inputData.append(accelerationZ)
//            inputData.append(rotationRateX)
//            inputData.append(rotationRateY)
//            inputData.append(rotationRateZ)
//
//            // 입력 데이터가 windowSize에 도달하면 예측 수행
//            if inputData.count >= windowSize {
//                let startIndex = inputData.count - windowSize // 최근 windowSize 개의 데이터를 추출하기 위한 시작 인덱스
//                let endIndex = inputData.count - 1
//                let inputArray = Array(inputData[startIndex...endIndex])
//
//                // 모델 불러오기
//                guard let modelURL = Bundle.main.url(forResource: "RightHandTennisActivityClassifier", withExtension: "mlmodelc") else {
//                    fatalError("Failed to locate the model file")
//                }
//                guard let model = try? RightHandTennisActivityClassifier(contentsOf: modelURL) else {
//                    fatalError("Failed to create the model.")
//                }
//
//                // 모델의 입력값 준비
//                let inputMultiArray = try! MLMultiArray(shape: [NSNumber(value: windowSize)], dataType: .double)
//                for (index, value) in inputArray.enumerated() {
//                    inputMultiArray[index] = NSNumber(value: value)
//                }
//                let input = RightHandTennisActivityClassifierInput(
//                    Acceleration_X: inputMultiArray,
//                    Acceleration_Y: inputMultiArray,
//                    Acceleration_Z: inputMultiArray,
//                    Rotation_Rate_X: inputMultiArray,
//                    Rotation_Rate_Y: inputMultiArray,
//                    Rotation_Rate_Z: inputMultiArray,
//                    stateIn: try! MLMultiArray(shape: [400], dataType: .double)
//                )
//
//                guard let output = try? model.prediction(input: input) else {
//                    fatalError("Failed to predict.")
//                }
//
//                if output.label == "Forehand" {
//                    self.classLabel = "Forehand"
//                    self.forehandCount += 1
//                } else {
//                    self.classLabel = "Backhand"
//                }
//                self.confidence = output.labelProbability[self.classLabel] ?? -1.0
//                print("Predicted Label: \(self.classLabel) - Confidence: \(self.confidence)")
//
//                // 이후 처리를 위해 windowSize 만큼 데이터를 제거합니다.
//                inputData.removeFirst(windowSize)
//            }
//            //MARK: 아이폰으로 데이터 전송
//            self.watchViewModel.session.transferUserInfo(["forehandLabel": self.classLabel, "confidence": self.confidence, "forehandCount": self.forehandCount])
//        }
//    }
//    func stopTracking() {
//        motionManager.stopDeviceMotionUpdates()
//    }
//}
