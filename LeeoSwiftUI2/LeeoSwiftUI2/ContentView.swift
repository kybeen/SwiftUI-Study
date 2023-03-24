//
//  ContentView.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/24.
//

import SwiftUI

struct ContentView: View {
    @State var isShowingModal: Bool = false
    
    var body: some View {
        Button {
            isShowingModal = true
        } label: {
            Text("Call modal")
        }
        .fullScreenCover(isPresented: $isShowingModal) {
            ZStack {
                Color.orange.ignoresSafeArea()
                VStack {
                    Text("Modal View")
                    Button {
                        isShowingModal = false
                    } label: {
                        Text("dismiss")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
