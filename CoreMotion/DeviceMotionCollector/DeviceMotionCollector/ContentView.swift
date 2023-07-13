//
//  ContentView.swift
//  DeviceMotionCollector
//
//  Created by 김영빈 on 2023/07/08.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var phoneViewModel = PhoneViewModel()
    @State var reachable = "No"
    
    @State private var selectedFrequency = 9
    let HzOptions = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    
    var body: some View {
        VStack {
            HStack {
                Text("Frequency select").font(.title2).bold()
                Picker("Frequency", selection: $selectedFrequency) {
                    ForEach(0..<HzOptions.count) { index in
                        Text("\(HzOptions[index])Hz")
                    }
                }
                .pickerStyle(.automatic)
                .onChange(of: selectedFrequency) { newValue in
                    phoneViewModel.session.transferUserInfo(["hz": self.HzOptions[newValue]])
                }
            }
            .padding()
            
            
            VStack {
                Text("Received data").font(.title).bold()
                HStack {
                    Text("Reachable: \(reachable)")
                    Button("Update") {
                        if self.phoneViewModel.session.isReachable {
                            self.reachable = "Yes"
                            print("YES!!!")
                        } else {
                            self.reachable = "No"
                            print("NO...")
                        }
                    }
                    .padding(5)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(.leading, 20)
                }
                Text("CSV file name : \(phoneViewModel.csvFileName)").bold()
            }
            .padding()
            
            VStack {
                HStack {
                    Text("Save Status :")
                    Text(phoneViewModel.isSucceeded)
                        .foregroundColor(phoneViewModel.isSucceeded=="Success!!!" ? .green : .red)
                        .bold()
                }
                Text("Saved data").font(.title).bold()
                if let savedCSVFiles = phoneViewModel.savedCSV {
                    List(savedCSVFiles, id: \.self) { savedCSVFile in
                        Text("\(savedCSVFile)")
                    }
                } else {
                    Text("No items")
                }
            }
        }
        .padding()
        .onAppear() {
            // 처음 화면이 로드될 때 디렉토리 생성 체크하고, 저장된 CSV 파일들 목록을 불러옴
            createDirectory()
            loadCSVFiles()
        }
    }
}

extension ContentView {
    //MARK: CSV 파일을 저장할 디렉토리를 만드는 함수
    func createDirectory() {
        // 파일을 저장할 경로 설정
        let fileManager = FileManager.default // FileManager 인스턴스 생성
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] // documents 디렉토리 경로 (계속 바뀌기 때문에 새로 불러와야 함)
        print("documentsURL: \(documentsURL)")
        let directoryName = "DeviceMotionData" // 디렉토리명

        // 디렉토리 만들기
        let directoryURL = documentsURL.appendingPathComponent(directoryName)
        // DeviceMotionData 폴더가 이미 존재하는지 확인 후 생성
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
                print("DeviceMotionData 디렉토리 생성 완료!!! : \(directoryURL)")
            } catch {
                NSLog("Couldn't create document directory.")
            }
        } else {
            print("디렉토리가 이미 존재하기 때문에 생성하지 않았습니다.\nDirectory URL : \(directoryURL)")
        }
    }
    
    //MARK: CSV 파일을 불러오는 함수
    func loadCSVFiles() {
        let fileManager = FileManager.default // FileManager 인스턴스 생성
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] // documents 디렉토리 경로 (계속 바뀌기 때문에 새로 불러와야 함)
        print("documentsURL: \(documentsURL)")
        let directoryName = "DeviceMotionData" // 디렉토리명
        let directoryURL = documentsURL.appendingPathComponent(directoryName)
        
        // 저장된 항목들 확인
        var fileList : [String] = []
        do {
            fileList = try FileManager.default.contentsOfDirectory(atPath: directoryURL.path)
        }
        catch {
            print("[Error] : \(error.localizedDescription)")
        }
        phoneViewModel.savedCSV = fileList.sorted()
        print("디렉토리 내용 확인: \(phoneViewModel.savedCSV!))")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
