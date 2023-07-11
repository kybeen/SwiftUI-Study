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
    
//    @Published var csvString = ""
    @Published var activityType = ""
    @Published var handType = ""
    @Published var csvFileName = ""
    
    //MARK: 델리게이트 메서드 3개 정의
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
//    //MARK: 다른 기기의 세션으로부터 transferUserInfo(_:) 메서드로 데이터를 받았을 떄 호출되는 메서드
//    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
//        DispatchQueue.main.async {
//            // 받아온 데이터 저장
//            self.csvString = userInfo["csv"] as? String ?? ""
//            self.activityType = userInfo["activity"] as? String ?? ""
//            self.handType = userInfo["hand"] as? String ?? ""
//            self.saveToCSV()
//        }
//    }
    //MARK: 다른 기기의 세션으로부터 transferFile(_:metadata:) 메서드로 파일을 받았을 떄 호출되는 메서드
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        DispatchQueue.main.async {
            // 전송된 파일의 메타데이터 확인
            self.activityType = file.metadata?["activity"] as? String ?? "Unknown"
            self.handType = file.metadata?["hand"] as? String ?? "Unknown"
            
            // 전송된 파일의 임시 경로
            let tempURL = file.fileURL
            
            // 파일을 저장할 경로 설정
            let fileManager = FileManager.default
            let folderName = "DeviceMotionData"
            self.csvFileName = file.metadata?["fileName"] as? String ?? "Unknown" // 파일명

            // 폴더 경로
            guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Failed to access documents directory.")
                return
            }
            let directoryURL = documentURL.appendingPathComponent(folderName)
            print("Directory URL : \(directoryURL)")
            
            // DeviceMotionData 폴더가 이미 존재하는지 확인 후 생성
            if fileManager.fileExists(atPath: directoryURL.path) {
                do {
                    try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
                    print("디렉토리 생성 : \(directoryURL.path)")
                }
                catch let error as NSError {
                    print("폴더 생성 에러!!!: \(error)")
                }
            }
            
            // 파일명이 포함된 저장 경로
            let fileURL = directoryURL.appendingPathComponent(self.csvFileName)
            print("File URL : \(fileURL)")
            // 같은 이름의 파일이 이미 존재하는 경우 삭제
            if fileManager.fileExists(atPath: fileURL.path) {
                do {
                    try fileManager.removeItem(at: fileURL)
                    print("Removed existing file: \(fileURL)")
                } catch {
                    print("Failed to remove existing file: \(fileURL), error: \(error.localizedDescription)")
                }
            }
            
            // 파일 이동
            do {
                try fileManager.moveItem(at: tempURL, to: fileURL)
                print("Received and saved CSV file: \(fileURL)")
                print("File name : \(self.csvFileName)")
            } catch {
                print("Failed to save received CSV file!!!: \(error.localizedDescription)")
            }
            
        }
    }
    
//    //MARK: CSV 파일 만드는 함수
//    func saveToCSV() {
//        let fileManager = FileManager.default
//
//        // 폴더명
//        let folderName = "DeviceMotionData"
//        // 파일명
//        var activityLabel = ""
//        var handLabel = ""
//        if self.activityType == "포핸드" {
//            activityLabel = "forehand"
//        } else {
//            activityLabel = "backhand"
//        }
//        if self.handType == "오른손잡이" {
//            handLabel = "right_"
//        } else {
//            handLabel = "left_"
//        }
//        let csvFileName = handLabel + activityLabel + ".csv"
//
//        // 폴더 생성
//        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("Failed to access documents directory.")
//            return
//        }
//        let directoryURL = documentURL.appendingPathComponent(folderName)
//        do {
//            try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true)
//        }
//        catch let error as NSError {
//            print("폴더 생성 에러!!!: \(error)")
//        }
//
//        // CSV 파일 생성
//        let fileURL = directoryURL.appendingPathComponent(csvFileName)
//        do {
//            try self.csvString.write(to: fileURL, atomically: true, encoding: .utf8)
//            print("CSV file saved at: \(fileURL)")
//            print("File name : \(csvFileName)")
//        }
//        catch let error as NSError {
//            print("Failed to save CSV file!!!: \(error.localizedDescription)")
//        }
//    }
}

