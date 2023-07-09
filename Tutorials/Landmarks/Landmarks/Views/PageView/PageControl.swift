//
//  PageControl.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/18.
//

//  PageControl.swift
import SwiftUI
import UIKit

struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    @Binding var currentPage: Int
    
    // 새로운 코디네이터를 만들고 리턴
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        // 코디네이터를 valueChanged 이벤트의 타겟으로 추가하고, updateCurrentPage(sender:) 메서드를 수행될 작업으로 지정해줍니다.
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(sender:)),
            for: .valueChanged)
        
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    // UIPageControl과 같은 UIControl의 하위 클래스는 델리게이션(위임) 대신 target-action 패턴을 사용하기 때문에, 이 코디네이터는 현재 페이지 바인딩을 업데이트 하기 위해 @objc 메서드를 구현해줍니다.
    class Coordinator: NSObject {
        var control: PageControl
        
        init(_ control: PageControl) {
            self.control = control
        }
        
        @objc
        func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
    
}
