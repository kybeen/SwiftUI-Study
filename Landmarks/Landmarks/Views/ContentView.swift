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
    var body: some View {
        LandmarkList()
    }
}

// 뷰에 대한 미리보기를 선언한다.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
