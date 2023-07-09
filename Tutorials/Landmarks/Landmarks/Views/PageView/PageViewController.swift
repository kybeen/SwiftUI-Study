//
//  PageViewController.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/18.
//

//  PageViewController.swift
import SwiftUI
import UIKit

// 페이지 뷰 컨트롤러는 View 타입의 Page 인스턴스의 배열을 저장합니다. 이 배열은 랜드마크 간에 스크롤을 할 수 있는 페이지들입니다.
struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]
    @Binding var currentPage: Int // 현재 페이지(현재 추천 랜드마크) 정보
    
    // SwiftUI는 makeUIViewController(context:) 전에 이 메서드를 호출합니다.
    // 이 덕분에 뷰 컨트롤러를 구성할 때 Coordinator 객체에 액세스 할 수 있습니다.
    // 이 Coordinator를 사용하여 델리게이트, 데이터 소스, 타겟 액션을 통한 사용자 이벤트에 대한 응답 같은 일반적인 Cocoa 패턴을 구현할 수 있습니다.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // UIPageViewController를 생성해주는 메서드
    // SwiftUI에서는 뷰가 화면에 보여질 준비가 됐을 때 이 메서드를 한 번 호출해주고, 이후에는 생명 주기를 관리해줍니다.
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator // UIPageViewController의 데이터 소스로 코디네이터를 할당해줍니다.
        pageViewController.delegate = context.coordinator // UIPageViewController의 델리게이터로 코디네이터를 할당해줍니다. -> 바인딩이 양방향으로 연결되고 나면, 텍스트 뷰의 currentPage 값이 제대로 업데이트 되는 것을 볼 수 있습니다.
        
        return pageViewController
    }
    
    // setViewControllers(_:direction:animated:)를 호출하여 디스플레이용 뷰 컨트롤러를 제공하는 메서드
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            // 시스템은 당신이 뷰 컨트롤러를 업데이트 하기 위해 필요로 하기 전에 딱 한번만 컨트롤러를 초기화하기 때문에, 코디네이터는 이런 컨트롤러를 저장하기에 좋은 곳입니다.
            [context.coordinator.controllers[currentPage]], direction: .forward, animated: true)
    }
    
    // PageViewController.swift 안에 중첩된 Coordinator 클래스를 선언해줍니다.
    // SwiftUI는 UIViewControllerRepresentable 타입의 Coordinator를 관리하고, 위에서 만든 메서드를 호출할 때 이를 컨텍스트의 일부로 제공합니다.
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var controllers = [UIViewController()]
        
        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0) }
        }
        
        // 뷰 컨트롤러 간의 관계를 설정하여 뷰 컨트롤러를 앞뒤로 스와이프 할 수 있게 해줍니다.
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return controllers.last
            }
            return controllers[index - 1]
        }
        
        // 뷰 컨트롤러 간의 관계를 설정하여 뷰 컨트롤러를 앞뒤로 스와이프 할 수 있게 해줍니다.
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == controllers.count {
                return controllers.first
            }
            return controllers[index + 1]
        }
        
        // SwiftUI는 페이지 전환 애니메이션이 완료될 때마다 이 메서드를 호출하기 때문에, 현재 뷰 컨트롤러의 인덱스를 찾고 바인딩을 업데이트 할 수 있습니다.
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
    }
}
