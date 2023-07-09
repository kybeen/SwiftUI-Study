//
//  MyModal.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/26.
//

/* Modal */
import SwiftUI

struct MyModal: View {
    @State var isShowingModal: Bool = false
    
    var body: some View {
        Button {
            isShowingModal = true
        } label: {
            Text("Call modal")
        }
        .sheet(isPresented: $isShowingModal) {
            ZStack {
                Color.orange.ignoresSafeArea()
                Text("Model View")
            }
        }
    }
}

struct MyModal_Previews: PreviewProvider {
    static var previews: some View {
        MyModal()
    }
}
