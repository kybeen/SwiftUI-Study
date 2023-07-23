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
    
    let MODEL_NAME = "TeringClassifier_window50"
    let WINDOW_SIZE = 50 // 슬라이딩 윈도우 크기 설정
    let FREQUENCY = 50 // 데이터 빈도수
    let THRESHOLD: Double = 0.8 // Perfect-Bad 기준
    @Published var classLabel: String = "?" // 동작 분류 결과 라벨
    @Published var resultLabel: String = "?"
    @Published var confidence: Double = 0.0 // 분류 Confidence
    @Published var perfectCount: Int = 0 // perfect 스윙 횟수
    @Published var badCount: Int = 0 // bad 스윙 횟수
    @Published var totalCount: Int = 0 // 전체 스윙 횟수
    @Published var timestamp: Double = 0.0

    // 스윙 중인지 체크하는 변수
    @Published var isSwinging = false
    // 슬라이딩 윈도우 버퍼
    var bufferAccX: [Double] = []
    var bufferAccY: [Double] = []
    var bufferAccZ: [Double] = []
    var bufferRotX: [Double] = []
    var bufferRotY: [Double] = []
    var bufferRotZ: [Double] = []
    
    //MARK: 감지 시작
    func startTracking() {
        print("==============================================================================")
        // 모델 불러오기
        guard let modelURL = Bundle.main.url(forResource: self.MODEL_NAME, withExtension: "mlmodelc") else {
            fatalError("Failed to locate the model file.")
        }
        guard let model = try? RightHandTennisActivityClassifier(contentsOf: modelURL) else {
            fatalError("Failed to create the model.")
        }
        print("모델 불러오기 성공!!! : \(model)")
        
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion service is not available")
            return
        }
        var startTime: TimeInterval = 0.0 // 시작 시간 저장 변수
        motionManager.deviceMotionUpdateInterval = TimeInterval(1 / FREQUENCY) // 센서 데이터 빈도수 설정
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
            
            // 스윙 감지 알고리즘 통과하면 인풋 데이터 준비와 예측 시작
            if self.isSwinging == false {
                if self.detectSwing(type: "Forehand", accX: deviceMotionData.userAcceleration.x, accY: deviceMotionData.userAcceleration.y, accZ: deviceMotionData.userAcceleration.z) {
                    print("스윙 감지!!! 예측 수행 시작")
                    self.isSwinging = true
                }
            }
            
            // 스윙 감지 시 동작
            if self.isSwinging {
                self.bufferAccX.append(deviceMotionData.userAcceleration.x)
                self.bufferAccY.append(deviceMotionData.userAcceleration.y)
                self.bufferAccZ.append(deviceMotionData.userAcceleration.z)
                self.bufferRotX.append(deviceMotionData.rotationRate.x)
                self.bufferRotY.append(deviceMotionData.rotationRate.y)
                self.bufferRotZ.append(deviceMotionData.rotationRate.z)
                
                // 입력 데이터가 windowSize에 도달하면 예측 수행
                if self.bufferRotZ.count >= self.WINDOW_SIZE {
                    // 입력값 준비
                    let startIndex = 0
                    let endIndex = self.WINDOW_SIZE - 1
                    let MultiArrayAccX = try! MLMultiArray(shape: [NSNumber(value: self.WINDOW_SIZE)], dataType: .double)
                    let MultiArrayAccY = try! MLMultiArray(shape: [NSNumber(value: self.WINDOW_SIZE)], dataType: .double)
                    let MultiArrayAccZ = try! MLMultiArray(shape: [NSNumber(value: self.WINDOW_SIZE)], dataType: .double)
                    let MultiArrayRotX = try! MLMultiArray(shape: [NSNumber(value: self.WINDOW_SIZE)], dataType: .double)
                    let MultiArrayRotY = try! MLMultiArray(shape: [NSNumber(value: self.WINDOW_SIZE)], dataType: .double)
                    let MultiArrayRotZ = try! MLMultiArray(shape: [NSNumber(value: self.WINDOW_SIZE)], dataType: .double)
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
                    
                    // 예측 수행
                    guard let output = try? model.prediction(input: input) else {
                        fatalError("Failed to predict.")
                    }
                    let label = output.label
                    let prob = output.labelProbability[output.label] ?? 0.0
                    self.classLabel = label
                    self.confidence = prob
                    print("output.label: \(output.label), output.labelProb: \(output.labelProbability[output.label] ?? 0.0)")
                    // 포핸드라면
                    if label == "Forehand" {
                        if prob >= self.THRESHOLD {
                            self.perfectCount += 1
                            self.resultLabel = "Perfect"
                        } else {
                            self.badCount += 1
                            self.resultLabel = "Bad"
                        }
                        self.totalCount += 1
                    } else {
                        self.resultLabel = "Not Forehand"
                    }
                    print("Swing type: \(label) - Confidence: \(prob)")
                    print("Result: \(self.resultLabel)")
                    
                    self.bufferAccX = []
                    self.bufferAccY = []
                    self.bufferAccZ = []
                    self.bufferRotX = []
                    self.bufferRotY = []
                    self.bufferRotZ = []
                    print("버퍼 초기화 -> \(self.bufferAccX), \(self.bufferAccY), \(self.bufferAccZ), \(self.bufferRotX), \(self.bufferRotY), \(self.bufferRotZ)")
                    self.isSwinging = false
                    
//                    // 이후 처리를 위해 윈도우 버퍼 한 칸씩 조정
//                    self.bufferAccX.removeFirst()
//                    self.bufferAccY.removeFirst()
//                    self.bufferAccZ.removeFirst()
//                    self.bufferRotX.removeFirst()
//                    self.bufferRotY.removeFirst()
//                    self.bufferRotZ.removeFirst()
//                    print("버퍼 한칸씩 제거 -> \(self.bufferAccX.count), \(self.bufferAccY.count), \(self.bufferAccZ.count), \(self.bufferRotX.count), \(self.bufferRotY.count), \(self.bufferRotZ.count)")
                    
                    // 아이폰으로 데이터 전송
                    self.watchViewModel.session.transferUserInfo(["label": self.classLabel, "result": self.resultLabel, "confidence": self.confidence, "perfectCount": self.perfectCount, "badCount": self.badCount, "totalCount": self.totalCount])
                    print("아이폰으로 데이터 전송 완료!!! ==> label: \(self.classLabel), result: \(self.resultLabel), confidence: \(self.confidence), perfectCount: \(self.perfectCount), badCount: \(self.badCount), totalCount: \(self.totalCount)")
                }
            }
        }
        print("==============================================================================")
    }
    
    //MARK: 감지 종료
    func stopTracking() {
        motionManager.stopDeviceMotionUpdates()
        // 버퍼 초기화
        self.bufferAccX = []
        self.bufferAccY = []
        self.bufferAccZ = []
        self.bufferRotX = []
        self.bufferRotY = []
        self.bufferRotZ = []
        print("버퍼 초기화 \(self.bufferAccX), \(self.bufferAccY), \(self.bufferAccZ), \(self.bufferRotX), \(self.bufferRotY), \(self.bufferRotZ)")
    }
    
    //MARK: 스윙 감지 알고리즘
    func detectSwing(type: String, accX: Double, accY: Double, accZ: Double) -> Bool {
        if type == "Forehand" {
            if accX <= 0.0 && accY >= 0.0, accY <= 1.0 && accZ >= 0.5 {
                return true
            } else {
                return false
            }
        } else if type == "Backhand" {
            if accX <= -1.0 && accY >= 0.0 && accY <= 1.0 && accZ >= 1.0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
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
