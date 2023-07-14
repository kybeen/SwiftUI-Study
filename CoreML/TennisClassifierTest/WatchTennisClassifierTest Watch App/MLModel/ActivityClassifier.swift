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
    
//    @Published var accelerationX = 0.0
//    @Published var accelerationY = 0.0
//    @Published var accelerationZ = 0.0
//    @Published var rotationRateX = 0.0
//    @Published var rotationRateY = 0.0
//    @Published var rotationRateZ = 0.0
    
//    private var inputData = [Double]()
    
//    lazy var model: RightHandTennisActivityClassifier = {
//        do {
//            let config = MLModelConfiguration()
//            return try RightHandTennisActivityClassifier(configuration: config)
//        } catch {
//            fatalError("Failed to load a model: \(error)")
//        }
//    }()
    
    @Published var classLabel: String = "?"
    @Published var confidence: Double = 0.0
    @Published var forehandCount: Int = 0
    
    func startTracking() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion data is not available")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 0.1 // 100Hz의 센서 데이터
        
        let windowSize = 100
        var inputData: [Double] = [] // 입력 데이터를 저장할 배열
  
        motionManager.startDeviceMotionUpdates(to: .main) { (deviceMotion, error) in
            guard let deviceMotionData = deviceMotion else {
                print("Failed to get device motion data: \(error?.localizedDescription ?? "")")
                return
            }
//            // 작업 큐 설정
//            let queue = OperationQueue()
//            queue.maxConcurrentOperationCount = 1 // 동시에 실행할 수 있는 대기 중 작업의 최대 개수
            
            let accelerationX = deviceMotionData.userAcceleration.x
            let accelerationY = deviceMotionData.userAcceleration.y
            let accelerationZ = deviceMotionData.userAcceleration.z
            let rotationRateX = deviceMotionData.rotationRate.x
            let rotationRateY = deviceMotionData.rotationRate.y
            let rotationRateZ = deviceMotionData.rotationRate.z
            
            inputData.append(accelerationX)
            inputData.append(accelerationY)
            inputData.append(accelerationZ)
            inputData.append(rotationRateX)
            inputData.append(rotationRateY)
            inputData.append(rotationRateZ)
            
            // 입력 데이터가 windowSize에 도달하면 예측 수행
            if inputData.count >= windowSize {
                let startIndex = inputData.count - windowSize // 최근 windowSize 개의 데이터를 추출하기 위한 시작 인덱스
                let endIndex = inputData.count - 1
                let inputArray = Array(inputData[startIndex...endIndex])
                
                // 모델 불러오기
                guard let modelURL = Bundle.main.url(forResource: "RightHandTennisActivityClassifier", withExtension: "mlmodelc") else {
                    fatalError("Failed to locate the model file")
                }
                guard let model = try? RightHandTennisActivityClassifier(contentsOf: modelURL) else {
                    fatalError("Failed to create the model.")
                }
                
                // 모델의 입력값 준비
                let inputMultiArray = try! MLMultiArray(shape: [NSNumber(value: windowSize)], dataType: .double)
                for (index, value) in inputArray.enumerated() {
                    inputMultiArray[index] = NSNumber(value: value)
                }
                let input = RightHandTennisActivityClassifierInput(
                    Acceleration_X: inputMultiArray,
                    Acceleration_Y: inputMultiArray,
                    Acceleration_Z: inputMultiArray,
                    Rotation_Rate_X: inputMultiArray,
                    Rotation_Rate_Y: inputMultiArray,
                    Rotation_Rate_Z: inputMultiArray,
                    stateIn: try! MLMultiArray(shape: [400], dataType: .double)
                )
                
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
                print("Predicted Label: \(self.classLabel) - Confidence: \(self.confidence)")

                // 이후 처리를 위해 windowSize 만큼 데이터를 제거합니다.
                inputData.removeFirst(windowSize)
            }
            //MARK: 아이폰으로 데이터 전송
            self.watchViewModel.session.transferUserInfo(["forehandLabel": self.classLabel, "confidence": self.confidence, "forehandCount": self.forehandCount])
        }
    }
    func stopTracking() {
        motionManager.stopDeviceMotionUpdates()
    }
}
