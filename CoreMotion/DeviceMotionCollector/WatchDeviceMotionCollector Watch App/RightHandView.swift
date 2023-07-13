//
//  BackhandView.swift
//  WatchDeviceMotionCollector Watch App
//
//  Created by 김영빈 on 2023/07/09.
//

import SwiftUI
import CoreMotion

struct RightHandView: View {
    let motionManager = CMMotionManager()
    @ObservedObject var watchViewModel = WatchViewModel()
    
    @State var timestamp: Double = 0.0
    @State var accelerationX: Double = 0.0
    @State var accelerationY: Double = 0.0
    @State var accelerationZ: Double = 0.0
    @State var rotationRateX: Double = 0.0
    @State var rotationRateY: Double = 0.0
    @State var rotationRateZ: Double = 0.0
    
    @State private var isUpdating = false
    @State var isSentCSV = false
    @State var csvString = ""
    @State var activityType = "forehand_"
    @State var activityLabel = "포핸드"
    @State var handType = "right_"
    @State var num = 1
    
    var body: some View {
        VStack {
            Text("\(handType)\(activityType)\(num).csv").bold()
            HStack {
                Text("\(watchViewModel.hzValue)Hz - ").bold().foregroundColor(.indigo)
                Text("\(timestamp)") // 타임스탬프
            }
            HStack {
                Button("-") {
                    if num > 1 {
                        num -= 1
                    }
                }.frame(width: 50, height: 50)
                Text("\(num)")
                Button("+") {
                    num += 1
                }.frame(width: 50, height: 50)
            }
            HStack {
                Button(activityLabel) {
                    if activityType == "forehand_" {
                        activityType = "backhand_"
                        activityLabel = "백핸드"
                        num = 1
                    }
                    else {
                        activityType = "forehand_"
                        activityLabel = "포핸드"
                        num = 1
                    }
                }
                .foregroundColor(activityType=="forehand_" ? .orange : .purple)
                
                //MARK: 측정 버튼
                if isUpdating {
                    //MARK: 기록 중료 버튼
                    Button("Stop") {
                        stopRecording()
                        isUpdating = false
                    }.foregroundColor(.red)
                }
                else {
                    //MARK: 기록 시작 버튼
                    Button("Start") {
                        startRecording()
                        isUpdating = true
                        isSentCSV = false
                    }.foregroundColor(.green)
                }
            }
            
            if isSentCSV {
                Text("전송완료!!!").bold().foregroundColor(.blue)
            }
//            //MARK: 센서값 보기
//            ScrollView {
//                Text("Acceleration").bold()
//                Text("X: \(accelerationX)")
//                Text("Y: \(accelerationY)")
//                Text("Z: \(accelerationZ)")
//                    .padding(.bottom, 5)
//                Text("Rotation Rate").bold()
//                Text("X: \(rotationRateX)")
//                Text("Y: \(rotationRateY)")
//                Text("Z: \(rotationRateZ)")
//            }
        }
        .padding()
    }
}

extension RightHandView {
    //MARK: Device Motion 레코딩 시작 함수
    func startRecording() {
        self.csvString = "Time Stamp,Acceleration X,Acceleration Y,Acceleration Z,Rotation Rate X,Rotation Rate Y,Rotation Rate Z\n"
        // 작업 큐 설정
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1 // 동시에 실행할 수 있는 대기 중 작업의 최대 개수
        
        // Device Motion 수집 가능한지 확인
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion data is not available!!!")
            return
        }
        
        // 모션 갱신 주기 설정 (몇 초마다 모션 데이터를 업데이트 할 지)
        motionManager.deviceMotionUpdateInterval = TimeInterval(1 / watchViewModel.hzValue)
        print("모션 갱신 주기(deviceMotionUpdateInterval) : \(watchViewModel.hzValue)Hz -> \(TimeInterval(1 / watchViewModel.hzValue))")
        var startTime: TimeInterval = 0.0 //MARK: 시작 시간 저장 변수
        // Device Motion 업데이트 받기 시작
        motionManager.startDeviceMotionUpdates(to: queue) { (data, error) in
            guard let motion = data, error == nil else {
                print("Failed to get device motion data: \(error?.localizedDescription ?? "Uknown error")")
                return
            }
            // 스윙 모션 감지에 필요한 데이터 불러오기
            let acceleration = motion.userAcceleration
            let rotationRate = motion.rotationRate
            
            if startTime == 0.0 {
                startTime = motion.timestamp //MARK: 첫 번째 데이터의 타임스탬프 저장
            }
            let timestamp = motion.timestamp - startTime //MARK: 시작 시간으로부터 경과한 시간 계산
            let addCSV = "\(timestamp), \(acceleration.x), \(acceleration.y), \(acceleration.z), \(rotationRate.x), \(rotationRate.y), \(rotationRate.z)\n"
            csvString = csvString + addCSV
            print("Timestamp : \(timestamp)")
            
            self.timestamp = timestamp //MARK: UI 업데이트는 메인 큐에서 실행
            self.accelerationX = acceleration.x
            self.accelerationY = acceleration.y
            self.accelerationZ = acceleration.z
            self.rotationRateX = rotationRate.x
            self.rotationRateY = rotationRate.y
            self.rotationRateZ = rotationRate.z
        }
    }
    
    //MARK: Device Motion 레코딩 종료 함수
    func stopRecording() {
        motionManager.stopDeviceMotionUpdates()
//        // 아이폰으로 csv 문자열 전송
//        self.watchViewModel.session.transferUserInfo(["csv" : csvString, "activity" : activityType, "hand" : handType])
//        print("Send CSV string to iPhone.")
//        self.isSentCSV = true
        
        // .csv 파일로 만들고 전송
        saveAndSendToCSV()
    }
    
    //MARK: CSV 파일 만들고 아이폰으로 전송해주는 함수
    func saveAndSendToCSV() {
        let fileManager = FileManager.default
        
        // 폴더명 설정
        let folderName = "DeviceMotionData"
        // 파일명 설정
        let csvFileName = self.handType + self.activityType + String(num) + ".csv"

        //MARK: 폴더 생성
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print("documentsURL: \(documentsURL)")
        let directoryURL = documentsURL.appendingPathComponent(folderName)
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
                print("DeviceMotionData 디렉토리 생성 완료!!! : \(directoryURL)")
            } catch {
                NSLog("Couldn't create directory")
            }
        } else {
            print("Directory URL : \(directoryURL)")
        }

        //MARK: CSV 파일 생성(저장)
        let csvURL = directoryURL.appendingPathComponent(csvFileName)
        print("File URL : \(csvURL)")
        print("저장될 파일 경로 : \(csvURL)")
        do {
            try self.csvString.write(to: csvURL, atomically: true, encoding: .utf8)
            print("CSV file saved at: \(csvURL)")
            print("File name : \(csvFileName)")
        }
        catch let error as NSError {
            print("Failed to save CSV file!!!: \(error.localizedDescription)")
        }
        
        //MARK: CSV 파일 아이폰으로 전송
        watchViewModel.session.transferFile(csvURL, metadata: ["activity": activityType, "hand": handType, "fileName": csvFileName])
        print("Send CSV file to iPhone.")
        isSentCSV = true
    }
}

struct RightHandView_Previews: PreviewProvider {
    static var previews: some View {
        RightHandView()
    }
}
