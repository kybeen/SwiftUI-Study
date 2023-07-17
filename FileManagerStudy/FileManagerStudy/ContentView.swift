//
//  ContentView.swift
//  FileManagerStudy
//
//  Created by 김영빈 on 2023/07/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("FILE SAVE TEST 1", action: {test1()})
            Button("FILE SAVE TEST 2", action: {test2()})
        }
        .padding()
    }
}

extension ContentView {
    func test1() {
        let fileManager = FileManager.default // FileManager 인스턴스 생성
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] // 요청된 도메인에서 지정된 공통 디렉토리에 대한 URL 배열을 리턴
        /* 디렉토리 만들기 */
        let directoryURL = documentsURL.appendingPathComponent("kybeen/test1")
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("Couldn't create document directory")
            }
        }
        /* 파일 만들기 */
        let fileURL = directoryURL.appendingPathComponent("kybeen.txt")
        let textString = NSString(string: "FileManager test. HELLO WORLD!!")
        try? textString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
        print("documentsURL: \(documentsURL)")
        print("directoryURL: \(directoryURL)")
        print("fileURL: \(fileURL)")
        print("\n")
        
    }
    func test2() {
        let fileManager = FileManager.default // FileManager 인스턴스 생성
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] // 요청된 도메인에서 지정된 공통 디렉토리에 대한 URL 배열을 리턴
        /* 디렉토리 만들기 */
        let directoryURL = documentsURL.appendingPathComponent("kybeen/test2")
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("Couldn't create document directory")
            }
        }
        /* 파일 만들기 */
        let fileURL = directoryURL.appendingPathComponent("kybeen2.txt")
        let textString = NSString(string: "Second file!!")
        try? textString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
        print("documentsURL: \(documentsURL)")
        print("directoryURL: \(directoryURL)")
        print("fileURL: \(fileURL)")
        print("\n")
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
