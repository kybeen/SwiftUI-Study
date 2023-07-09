//
//  PhoneViewModel.swift
//  DeviceMotionCollector
//
//  Created by 김영빈 on 2023/07/09.
//

import Foundation
import WatchConnectivity

class PhoneViewModel: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    @Published var csvString = ""
    @Published var activityType = ""
    @Published var handType = ""
    
    //MARK: 델리게이트 메서드 3개 정의
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    //MARK: 다른 기기의 세션으로부터 transferUserInfo(_:) 메서드로 데이터를 받았을 떄 호출되는 메서드
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            // 받아온 데이터 저장
            self.csvString = userInfo["csv"] as? String ?? ""
            self.activityType = userInfo["activity"] as? String ?? ""
            self.handType = userInfo["hand"] as? String ?? ""
            self.saveToCSV()
        }
    }
    
    //MARK: CSV 파일 만드는 함수
    func saveToCSV() {
        let fileManager = FileManager.default

        // 폴더명
        let folderName = "DeviceMotionData"
        // 파일명
        var activityLabel = ""
        var handLabel = ""
        if self.activityType == "포핸드" {
            activityLabel = "forehand_"
        } else {
            activityLabel = "backhand_"
        }
        if self.handType == "오른손잡이" {
            handLabel = "right_"
        } else {
            handLabel = "left_"
        }
        let csvFileName = handLabel + activityLabel + "data.csv"

        // 폴더 생성
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to access documents directory.")
            return
        }
        let directoryURL = documentURL.appendingPathComponent(folderName)
        do {
            try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true)
        }
        catch let error as NSError {
            print("폴더 생성 에러!!!: \(error)")
        }

        // CSV 파일 생성
        let fileURL = directoryURL.appendingPathComponent(csvFileName)
        do {
            try self.csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV file saved at: \(fileURL)")
        }
        catch let error as NSError {
            print("Failed to save CSV file!!!: \(error.localizedDescription)")
        }
    }
}

