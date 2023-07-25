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
    
    let MODEL_NAME = "TeringClassifier_marcus_bazzi_totalData_window200"
    let WINDOW_SIZE = 200 // 슬라이딩 윈도우 크기 설정
    let PRE_BUFFER_SIZE = 70 // 미리 채워놓을 버퍼 사이즈 (WINDOW_SIZE 절반 정도)
    let FREQUENCY = 50 // 데이터 빈도수
    let THRESHOLD: Double = 0.8 // Perfect-Bad 기준
    @Published var classLabel: String = "?" // 동작 분류 결과 라벨
    @Published var resultLabel: String = "?"
//    @Published var confidence: Double = 0.0 // 분류 Confidence
    @Published var confidence: String = "0.0" // 분류 Confidence
    
    @Published var forehandPerfectCount: Int = 0 // 포핸드 perfect 스윙 횟수
    @Published var forehandBadCount: Int = 0 // 포핸드 bad 스윙 횟수
    @Published var backhandPerfectCount: Int = 0 // 백핸드 perfect 스윙 횟수
    @Published var backhandBadCount: Int = 0 // 백핸드 bad 스윙 횟수
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
        let updateInterval = 1.0 / Double(FREQUENCY) //TODO: 빈도수 확인 필요
//        motionManager.deviceMotionUpdateInterval = TimeInterval(1 / FREQUENCY) // 센서 데이터 빈도수 설정
        motionManager.deviceMotionUpdateInterval = updateInterval // 센서 데이터 빈도수 설정
        print("모션 갱신 주기 설정 : \(FREQUENCY)Hz -> \(motionManager.deviceMotionUpdateInterval)")
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
            //print(timestamp)
            
            // PRE_BUFFER_SIZE 크기만큼 버퍼 세팅이 안돼있으면 채워준다.
            if self.bufferRotZ.count < self.PRE_BUFFER_SIZE {
                self.bufferAccX.append(deviceMotionData.userAcceleration.x)
                self.bufferAccY.append(deviceMotionData.userAcceleration.y)
                self.bufferAccZ.append(deviceMotionData.userAcceleration.z)
                self.bufferRotX.append(deviceMotionData.rotationRate.x)
                self.bufferRotY.append(deviceMotionData.rotationRate.y)
                self.bufferRotZ.append(deviceMotionData.rotationRate.z)
            }
            else { // PRE_BUFFER_SIZE 크기만큼 버퍼 세팅이 완료되었으면
                if self.isSwinging == false {
                    // 스윙이 감지되면 isSwinging 값을 바꿔준다.
                    if self.detectSwing(type: "Forehand", accX: deviceMotionData.userAcceleration.x, accY: deviceMotionData.userAcceleration.y, accZ: deviceMotionData.userAcceleration.z) {
                        print("스윙 감지!!! 예측 수행 시작")
                        self.isSwinging = true
                    }
                    else { // 스윙이 감지되지 않으면 버퍼 맨 앞을 제거하여 한 칸씩 조정해준다.
                        self.bufferAccX.removeFirst()
                        self.bufferAccY.removeFirst()
                        self.bufferAccZ.removeFirst()
                        self.bufferRotX.removeFirst()
                        self.bufferRotY.removeFirst()
                        self.bufferRotZ.removeFirst()
                        //print("버퍼 한칸씩 제거 -> \(self.bufferAccX.count), \(self.bufferAccY.count), \(self.bufferAccZ.count), \(self.bufferRotX.count), \(self.bufferRotY.count), \(self.bufferRotZ.count)")
                    }
                } else { // isSwinging == true 일 때
                    // 버퍼 길이가 WINDOW_SIZE에 도달하면 인풋을 만들고 예측을 수행해준다.
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
                        for i in 0..<400 {
                            MultiArrayStateIn[i] = NSNumber(value: 0.0) // 배열의 각 요소를 0.0으로 초기화
                        }
                        
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
                        let prob = output.labelProbability[output.label]!
                        self.classLabel = label
                        self.confidence = String(prob)
                        print("output.label: \(output.label), output.labelProb: \(String(prob))")
                        print("Confidence: Forehand: \(String(output.labelProbability["Forehand"]!)) || Backhand: \(String(output.labelProbability["Backhand"]!))")
                        
                        // 포핸드라면
                        if label == "Forehand" {
                            if prob >= self.THRESHOLD {
                                self.forehandPerfectCount += 1
                                self.resultLabel = "Perfect"
                            } else {
                                self.forehandBadCount += 1
                                self.resultLabel = "Bad"
                            }
                        } else { // 백핸드라면
                            if prob >= self.THRESHOLD {
                                self.backhandPerfectCount += 1
                                self.resultLabel = "Perfect"
                            } else {
                                self.backhandBadCount += 1
                                self.resultLabel = "Bad"
                            }
                        }
                        self.totalCount += 1
                        
                        // 예축 수행 뒤 버퍼 초기화
                        self.bufferAccX = []
                        self.bufferAccY = []
                        self.bufferAccZ = []
                        self.bufferRotX = []
                        self.bufferRotY = []
                        self.bufferRotZ = []
//                        print("버퍼 초기화 -> \(self.bufferAccX), \(self.bufferAccY), \(self.bufferAccZ), \(self.bufferRotX), \(self.bufferRotY), \(self.bufferRotZ)")
                        self.isSwinging = false // isSwinging도 다시 false로 돌려놓는다.
                        
                        // 아이폰으로 데이터 전송
                        self.watchViewModel.session.transferUserInfo([
                            "label": self.classLabel,
                            "result": self.resultLabel,
                            "confidence": self.confidence,
                            "forehandPerfectCount": self.forehandPerfectCount,
                            "forehandBadCount": self.forehandBadCount,
                            "backhandPerfectCount": self.backhandPerfectCount,
                            "backhandBadCount": self.backhandBadCount,
                            "totalCount": self.totalCount
                        ])
                        print("아이폰으로 데이터 전송 완료!!! ==> label: \(self.classLabel), result: \(self.resultLabel), confidence: \(self.confidence), forehandPerfectCount: \(self.forehandPerfectCount), forehandBadCount: \(self.forehandBadCount), backhandPerfectCount: \(self.backhandPerfectCount), backhandBadCount: \(self.backhandBadCount), totalCount: \(self.totalCount)")
                    }
                    else { // 버퍼 길이가 WINDOW_SIZE보다 작으면 계속 채워준다.
                        self.bufferAccX.append(deviceMotionData.userAcceleration.x)
                        self.bufferAccY.append(deviceMotionData.userAcceleration.y)
                        self.bufferAccZ.append(deviceMotionData.userAcceleration.z)
                        self.bufferRotX.append(deviceMotionData.rotationRate.x)
                        self.bufferRotY.append(deviceMotionData.rotationRate.y)
                        self.bufferRotZ.append(deviceMotionData.rotationRate.z)
                    }
                }
            }
        }
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
//        // 포핸드
//        if type == "Forehand" {
//            if accX < 0.0 && accZ >= 2.0 {
//                return true
//            } else {
//                return false
//            }
//        // 백핸드
//        } else if type == "Backhand" {
//            if accX < 0.0 && accZ >= 2.0 {
//                return true
//            } else {
//                return false
//            }
//        } else {
//            return false
//        }
        let sumOfAbsAcc = abs(accX) + abs(accY) + abs(accZ)
        let subOfAccXZ = accX + accZ
//        print("AccX: \(accX), AccY: \(accY), AccZ: \(accZ)")
        // 포핸드 기준
        if sumOfAbsAcc >= 6.0 && abs(accX) >= 3.0 && abs(accZ) >= 2.5 && abs(subOfAccXZ) <= 2.0 {
            print("============================================================")
            print("Acc 스칼라 합: \(sumOfAbsAcc)")
            print("AccX와 AccZ의 합: \(subOfAccXZ)")
            print("AccX: \(accX), AccY: \(accY), AccZ: \(accZ)")
            print("============================================================")
            return true
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
//    let MODEL_NAME = "TeringClassifier_window200"
//    let WINDOW_SIZE = 200 // 슬라이딩 윈도우 크기 설정
//    let PRE_BUFFER_SIZE = 100 // 미리 채워놓을 버퍼 사이즈 (WINDOW_SIZE 절반 정도)
//    let FREQUENCY = 50 // 데이터 빈도수
//    let THRESHOLD: Double = 0.8 // Perfect-Bad 기준
//    @Published var classLabel: String = "?" // 동작 분류 결과 라벨
//    @Published var resultLabel: String = "?"
//    @Published var confidence: Double = 0.0 // 분류 Confidence
//    @Published var perfectCount: Int = 0 // perfect 스윙 횟수
//    @Published var badCount: Int = 0 // bad 스윙 횟수
//    @Published var totalCount: Int = 0 // 전체 스윙 횟수
//    @Published var timestamp: Double = 0.0
//
//    // 스윙 중인지 체크하는 변수
//    @Published var isSwinging = false
//    // 슬라이딩 윈도우 버퍼
//    var bufferAccX: [Double] = []
//    var bufferAccY: [Double] = []
//    var bufferAccZ: [Double] = []
//    var bufferRotX: [Double] = []
//    var bufferRotY: [Double] = []
//    var bufferRotZ: [Double] = []
//
//    //MARK: 감지 시작
//    func startTracking() {
//        print("==============================================================================")
//        // 모델 불러오기
//        guard let modelURL = Bundle.main.url(forResource: self.MODEL_NAME, withExtension: "mlmodelc") else {
//            fatalError("Failed to locate the model file.")
//        }
//        guard let model = try? RightHandTennisActivityClassifier(contentsOf: modelURL) else {
//            fatalError("Failed to create the model.")
//        }
//        print("모델 불러오기 성공!!! : \(model)")
//
//        guard motionManager.isDeviceMotionAvailable else {
//            print("Device motion service is not available")
//            return
//        }
//        var startTime: TimeInterval = 0.0 // 시작 시간 저장 변수
//        motionManager.deviceMotionUpdateInterval = TimeInterval(1 / FREQUENCY) // 센서 데이터 빈도수 설정
//        motionManager.startDeviceMotionUpdates(to: .main) { (deviceMotion, error) in
//            guard let deviceMotionData = deviceMotion, error==nil else {
//                print("Failed to get device motion data: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            if startTime == 0.0 {
//                startTime = deviceMotionData.timestamp // 첫 번째 데이터의 타임스탬프 저장
//            }
//            let timestamp = deviceMotionData.timestamp - startTime // 시작 시간으로부터 경과한 시간 계산
//            self.timestamp = timestamp
//
//            // 버퍼 채워놓기 (PRE_BUFFER_SIZE 만큼만)
//            if self.bufferRotZ.count < self.PRE_BUFFER_SIZE {
//                self.bufferAccX.append(deviceMotionData.userAcceleration.x)
//                self.bufferAccY.append(deviceMotionData.userAcceleration.y)
//                self.bufferAccZ.append(deviceMotionData.userAcceleration.z)
//                self.bufferRotX.append(deviceMotionData.rotationRate.x)
//                self.bufferRotY.append(deviceMotionData.rotationRate.y)
//                self.bufferRotZ.append(deviceMotionData.rotationRate.z)
//            }
//
//            // 스윙 감지 알고리즘 통과하면 인풋 데이터 준비와 예측 시작
//            if self.isSwinging == false {
//                if self.detectSwing(type: "Forehand", accX: deviceMotionData.userAcceleration.x, accY: deviceMotionData.userAcceleration.y, accZ: deviceMotionData.userAcceleration.z) {
//                    print("스윙 감지!!! 예측 수행 시작")
//                    self.isSwinging = true
//                }
//            }
//
//            // 스윙 감지 시 동작
//            if self.isSwinging {
//
//                // 입력 데이터가 windowSize에 도달하면 예측 수행
//                if self.bufferRotZ.count >= self.WINDOW_SIZE {
//                    // 입력값 준비
//                    let startIndex = 0
//                    let endIndex = self.WINDOW_SIZE - 1
//                    let MultiArrayAccX = try! MLMultiArray(shape: [NSNumber(value: self.WINDOW_SIZE)], dataType: .double)
//                    let MultiArrayAccY = try! MLMultiArray(shape: [NSNumber(value: self.WINDOW_SIZE)], dataType: .double)
//                    let MultiArrayAccZ = try! MLMultiArray(shape: [NSNumber(value: self.WINDOW_SIZE)], dataType: .double)
//                    let MultiArrayRotX = try! MLMultiArray(shape: [NSNumber(value: self.WINDOW_SIZE)], dataType: .double)
//                    let MultiArrayRotY = try! MLMultiArray(shape: [NSNumber(value: self.WINDOW_SIZE)], dataType: .double)
//                    let MultiArrayRotZ = try! MLMultiArray(shape: [NSNumber(value: self.WINDOW_SIZE)], dataType: .double)
//                    let MultiArrayStateIn = try! MLMultiArray(shape: [400], dataType: .double)
//
//                    for i in startIndex..<endIndex {
//                        MultiArrayAccX[i] = NSNumber(value: self.bufferAccX[i])
//                        MultiArrayAccY[i] = NSNumber(value: self.bufferAccY[i])
//                        MultiArrayAccZ[i] = NSNumber(value: self.bufferAccZ[i])
//                        MultiArrayRotX[i] = NSNumber(value: self.bufferRotX[i])
//                        MultiArrayRotY[i] = NSNumber(value: self.bufferRotY[i])
//                        MultiArrayRotZ[i] = NSNumber(value: self.bufferRotZ[i])
//                    }
//
//                    let input = RightHandTennisActivityClassifierInput(
//                        Acceleration_X: MultiArrayAccX,
//                        Acceleration_Y: MultiArrayAccY,
//                        Acceleration_Z: MultiArrayAccZ,
//                        Rotation_Rate_X: MultiArrayRotX,
//                        Rotation_Rate_Y: MultiArrayRotY,
//                        Rotation_Rate_Z: MultiArrayRotZ,
//                        stateIn: MultiArrayStateIn
//                    )
//
//                    // 예측 수행
//                    guard let output = try? model.prediction(input: input) else {
//                        fatalError("Failed to predict.")
//                    }
//                    let label = output.label
//                    let prob = output.labelProbability[output.label] ?? 0.0
//                    self.classLabel = label
//                    self.confidence = prob
//                    //TODO: 포핸드가 감지 자체가 되지 않는 경우 처리하기
//                    print("output.label: \(output.label), output.labelProb: \(output.labelProbability[output.label] ?? 0.0)")
//                    // 포핸드라면
//                    if label == "Forehand" {
//                        if prob >= self.THRESHOLD {
//                            self.perfectCount += 1
//                            self.resultLabel = "Perfect"
//                        } else {
//                            self.badCount += 1
//                            self.resultLabel = "Bad"
//                        }
//                        self.totalCount += 1
//                    } else {
//                        self.resultLabel = "Not Forehand"
//                    }
//                    print("Swing type: \(label) - Confidence: \(prob)")
//                    print("Result: \(self.resultLabel)")
//
//                    self.bufferAccX = []
//                    self.bufferAccY = []
//                    self.bufferAccZ = []
//                    self.bufferRotX = []
//                    self.bufferRotY = []
//                    self.bufferRotZ = []
//                    print("버퍼 초기화 -> \(self.bufferAccX), \(self.bufferAccY), \(self.bufferAccZ), \(self.bufferRotX), \(self.bufferRotY), \(self.bufferRotZ)")
//                    self.isSwinging = false
//
////                    // 이후 처리를 위해 윈도우 버퍼 한 칸씩 조정
////                    self.bufferAccX.removeFirst()
////                    self.bufferAccY.removeFirst()
////                    self.bufferAccZ.removeFirst()
////                    self.bufferRotX.removeFirst()
////                    self.bufferRotY.removeFirst()
////                    self.bufferRotZ.removeFirst()
////                    print("버퍼 한칸씩 제거 -> \(self.bufferAccX.count), \(self.bufferAccY.count), \(self.bufferAccZ.count), \(self.bufferRotX.count), \(self.bufferRotY.count), \(self.bufferRotZ.count)")
//
//                    // 아이폰으로 데이터 전송
//                    self.watchViewModel.session.transferUserInfo(["label": self.classLabel, "result": self.resultLabel, "confidence": self.confidence, "perfectCount": self.perfectCount, "badCount": self.badCount, "totalCount": self.totalCount])
//                    print("아이폰으로 데이터 전송 완료!!! ==> label: \(self.classLabel), result: \(self.resultLabel), confidence: \(self.confidence), perfectCount: \(self.perfectCount), badCount: \(self.badCount), totalCount: \(self.totalCount)")
//                }
//            }
//        }
//        print("==============================================================================")
//    }
//
//    //MARK: 감지 종료
//    func stopTracking() {
//        motionManager.stopDeviceMotionUpdates()
//        // 버퍼 초기화
//        self.bufferAccX = []
//        self.bufferAccY = []
//        self.bufferAccZ = []
//        self.bufferRotX = []
//        self.bufferRotY = []
//        self.bufferRotZ = []
//        print("버퍼 초기화 \(self.bufferAccX), \(self.bufferAccY), \(self.bufferAccZ), \(self.bufferRotX), \(self.bufferRotY), \(self.bufferRotZ)")
//    }
//

//    //MARK: 스윙 감지 알고리즘
//    func detectSwing(type: String, accX: Double, accY: Double, accZ: Double) -> Bool {
//
//        if type == "Forehand" {
//            if accX <= 0.0 && accY >= 0.0, accY <= 1.0 && accZ >= 0.5 {
//                return true
//            } else {
//                return false
//            }
//        } else if type == "Backhand" {
//            if accX <= -1.0 && accY >= 0.0 && accY <= 1.0 && accZ >= 1.0 {
//                return true
//            } else {
//                return false
//            }
//        } else {
//            return false
//        }
//    }
//}
