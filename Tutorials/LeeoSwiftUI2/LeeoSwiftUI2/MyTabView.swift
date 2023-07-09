//
//  MyTabView.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/26.
//

/* TabView (탭 뷰) */
import SwiftUI

struct MyTabView: View {
    var body: some View {
        TabView {
            ZStack {
                Color.orange
                Text("Kybeen")
            }
                .tabItem {
                    Label("item1", systemImage: "bolt")
                }
            Text("Leeo")
                .tabItem {
                    // Label 말고 Text랑 Image로도 가능
                    Text("item2")
                    Image(systemName: "heart")
                }
        }
    }
}

struct MyTabView_Previews: PreviewProvider {
    static var previews: some View {
        MyTabView()
    }
}
