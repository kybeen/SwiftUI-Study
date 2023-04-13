//
//  ContentView.swift
//  StyleTransfer
//
//  Created by 김영빈 on 2023/04/08.
//

import SwiftUI
import CoreML
import Vision

struct ContentView: View {
    //@State var resultImage: Image = Image("cow")
    @State var result: UIImage? = UIImage(named: "cow")
    @State var imageName = "myImage"
    var images = ["myImage", "myImage1", "myImage2"]
    
    var body: some View {
        VStack {
            Text("그림을 선택해주세요.")
                .font(.largeTitle)
                .fontWeight(.bold) 
            
            HStack {
                Image("cow")
                    .resizable()
                    .frame(width: 130, height: 130)
                    .padding()
                
                Text("->")
                
                Image(imageName)
                    .resizable()
                    .frame(width: 130, height: 130)
                    .padding()
            }
            
            Text("변환 결과")
                .font(.title)
                .fontWeight(.bold)
            
            Image(uiImage: result!)
                .resizable()
                .frame(width: 130, height: 130)
                .padding()
            
            Button {
                transferStyle()
            } label: {
                Text("화풍 변환하기")
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
    
    func transferStyle() {
        if let pickedImage = UIImage(named: imageName) {
            
            let model = try! CowModel_S9.init(contentsOf: CowModel_S9.urlOfModelInThisBundle)
            
            if let image = pixelBuffer(from: pickedImage) {
                do {
                    let predictionOutput = try model.prediction(image: image)
                    
                    let ciImage = CIImage(cvPixelBuffer: predictionOutput.stylizedImage)
                    let tempContext = CIContext(options: nil)
                    let tempImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(predictionOutput.stylizedImage), height: CVPixelBufferGetHeight(predictionOutput.stylizedImage)))
                    result = UIImage(cgImage: tempImage!)
                } catch let error as NSError {
                    print("CoreML Model Error: \(error)")
                }
            }
        }
    }

}

func pixelBuffer(from image: UIImage) -> CVPixelBuffer? {
    
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), true, 2.0)
    image.draw(in: CGRect(x: 0, y: 0, width: 512, height: 512))
    _ = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()

    let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
    var pixelBuffer : CVPixelBuffer?
    let status = CVPixelBufferCreate(kCFAllocatorDefault, 512, 512, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
    guard (status == kCVReturnSuccess) else {
        return nil
    }

    CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: pixelData, width: 512, height: 512, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

    context?.translateBy(x: 0, y: 512)
    context?.scaleBy(x: 1.0, y: -1.0)

    UIGraphicsPushContext(context!)
    image.draw(in: CGRect(x: 0, y: 0, width: 512, height: 512))
    UIGraphicsPopContext()
    CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

    return pixelBuffer
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
