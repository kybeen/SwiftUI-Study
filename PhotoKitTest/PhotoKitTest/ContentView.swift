//
//  ContentView.swift
//  PhotoKitTest
//
//  Created by 김영빈 on 2023/07/06.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Representable
struct PhotoPickerViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        PhotoPickerViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

import PhotosUI
import UIKit

// ViewController
final class PhotoPickerViewController: UIViewController, PHPickerViewControllerDelegate {
    
    // configuration이 먼저 생성이 되어 있어야 하기 때문에 lazy var로 선언 (lazy 키워드 변수는 프로퍼티가 생성되고 나서 사용됨)
    private lazy var phPickerViewController = PHPickerViewController(configuration: configuration)
    private let configuration = PHPickerConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad() // 기본적으로 실행?
        
        addChild(phPickerViewController)
        phPickerViewController.delegate = self // 델리게이트 지정을 해줘야 함. 이거 안해줘서 안되는 경우 많이 봄
        // Layout 설정
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 유저가 사진 선택했을 때
        print("select photo!!")
    }
}
