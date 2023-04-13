//
//  ContentView.swift
//  Animals
//
//  Created by 김영빈 on 2023/04/08.
//

import SwiftUI
import CoreML
import Vision

struct ContentView: View {
    @State var classificationResultLabel: String = "분류 시작 버튼을 눌러주세요."
    @State var imageName = "myImage"
    var images = ["myImage", "myImage1", "myImage2"]
    
    var body: some View {
        VStack {
            Text("동물 분류기")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Image(imageName)
                .resizable()
                .frame(width: 300, height: 300)
                .padding()
            
            Text("분류 결과")
                .font(.title)
                .fontWeight(.bold)
            Text(classificationResultLabel)
            
            Button {
                classifyAnimals()
            } label: {
                Text("분류 시작!")
            }
            .padding()
            
            Picker("사진 선택", selection: $imageName) {
                ForEach(images, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding()
    }
    
    func classifyAnimals() {
        let image = UIImage(named: imageName)!
        guard let ciImage = CIImage(image: image) else {
            fatalError("CIImage 변환 실패")
        }
        
        // CoreML 모델 불러오기
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: AnimalsClassifier(configuration: config).model) else {
            fatalError("CoreML 모델 불러오기 실패")
        }
        
        // Vision을 이용해 이미지 처리 요청
        let request = VNCoreMLRequest(model: model) { request, error in
            guard error == nil else {
                fatalError("요청 실패")
            }
            // 식별자의 이름(동물 이름)을 확인하기 위해 VNClassificationObservation로 변환해준다.
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                self.classificationResultLabel = "이미지를 분류할 수 없습니다."
                fatalError("VNClassificationObservation로 변환 실패")
                return
            }
            print(results)
            self.classificationResultLabel = "\(topResult.identifier) - \(topResult.confidence)"
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
