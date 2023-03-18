//
//  PageViewController.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/18.
//

//  PageViewController.swift
import SwiftUI
import UIKit

// 페이지 뷰 컨트롤러는 Page라는 뷰의 인스턴스의 배열을 저장합니다. 이 배열은 랜드마크 간에 스크롤을 할 수 있는 페이지들입니다.
struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]
    @Binding var currentPage: Int // 현재 페이지(현재 추천 랜드마크) 정보
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // UIPageViewController를 생성해주는 메서드
    // SwiftUI에서는 뷰가 화면에 보여질 준비가 됐을 때 이 메서드를 한 번 호출해주고, 이후 생명 주기를 관리해줍니다.
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator // UIPageViewController의 델리게이트로 코디네이터를 할당해줍니다.

        return pageViewController
    }
    
    // 현재 모든 업데이트에서 SwiftUI 뷰 페이지를 호스팅하는 UIHostingController를 만들어줍니다. 나중에 페이지 뷰 컨트롤러의 생명주기 동안 컨트롤러를 한번만 초기화하여 이를 더 효율적으로 만들 수 있습니다.
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]], direction: .forward, animated: true)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var controllers = [UIViewController]()
        
        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0) }
        }
        
        // pageViewController 메소드들은 뷰 컨트롤러 사이의 관계를 정립해줍니다. 이 메소드들을 통해 뷰 사이에 스와이프로 왔다갔다 할 수 있게 됩니다.
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return controllers.last
            }
            return controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == controllers.count {
                return controllers.first
            }
            return controllers[index + 1]
        }
        
        // SwiftUI에서는 페이지 전환 애니메이션이 끝날 때마다 이 메서드를 호출하기 때문에, 현재 뷰 컨트롤러의 인덱스를 찾고 바인딩을 업데이트 해줄 수 있다.
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
    }
}
