//
//  ContentView.swift
//  CoreMLStudy
//
//  Created by 김영빈 on 2023/04/06.
//

import CoreML
import SwiftUI
import Vision

struct ContentView: View {
    @State var classificationResultLabel: String = "분류 시작 버튼을 눌러주세요."
    let imageName = "myImage2"
    
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

        }
        .padding()
    }
    
    func classifyAnimals(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Mo)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





//func classifyAnimals() {
////        do {
//
//    // 이미지를 불러와서 CIImage로 변환하기
//    let image = UIImage(named: imageName)!
//    guard let ciImage = CIImage(image: image) else {
//        fatalError("CIImage 변환 실패")
//    }
//
//    // CoreML 모델 불러오기
//    let config = MLModelConfiguration()
//    guard let model = try? VNCoreMLModel(for: AnimalsClassifierModel(configuration: config).model) else {
//        fatalError("CoreML 모델 불러오기 실패")
//    }
//
//    // Vision을 이용해 이미지 처리 요청
//    let request = VNCoreMLRequest(model: model) { request, error in
////                guard let results = request.results as? [VNClassificationObservation],
////                      let topResult = results.first else {
////                    self.classificationResultLabel = "이미지를 분류할 수 없습니다."
////                    fatalError("VNClassificationObservation로 변환하기 실패")
////                    return
////                }
//        // 식별자의 이름(분류 결과)를 확인하기 위해 VNClassificationObservation로 변환
//        guard let results = request.results as? [VNClassificationObservation] else {
//            fatalError("VNClassificationObservation로 변환하기 실패")
//        }
//        print(results)
//        //self.classificationResultLabel = "\(topResult.identifier) - \(topResult.confidence)"
//    }
//
//    // CoreML 모델은 이미지를 CVPixelBuffer 형식으로 입력받는다.
//    // 입력 이미지는 CIImage 형식이지만 VNImageRequestHandler 객체는 내부적으로 이미지를 CVPixelBuffer로 변환하여 모델에 입력해주기 때문에 ㄱㅊ
//    let handler = VNImageRequestHandler(ciImage: ciImage)
//    try? handler.perform([request])
//
//
//
//        // Mode code to come here
////        } catch {
////            // Something went wrong!
////            fatalError("분류 도중 문제가 생겼습니다.")
////        }
//}
