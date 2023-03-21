//
//  ContentView.swift
//  LandmarksKybeen
//
//  Created by 김영빈 on 2023/03/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
    }
}

// 미리보기
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
