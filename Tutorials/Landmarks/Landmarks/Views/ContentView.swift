//
//  ContentView.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/13.
//

//  ContentView.swift
import SwiftUI

// View 프로토콜을 상속받으며 뷰의 콘텐츠와 레이아웃을 보여준다.
struct ContentView: View {
    // 탭 바 선택을 위한 @State 변수를 추가해주고, 기본값은 .featured로 줍니다.
    @State private var selection: Tab = .featured
    
    // 탭 바 항목의 열거형을 추가해줍니다.
    enum Tab {
        case featured
        case list
    }
    
    var body: some View {
        // 탭 뷰로 감싸줍니다.
        TabView(selection: $selection) {
            CategoryHome()
                .tabItem {
                    Label("Featured", systemImage: "star")
                }
                .tag(Tab.featured)
            
            LandmarkList()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(Tab.list)
        }
    }
}

// 뷰에 대한 미리보기를 선언한다.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
