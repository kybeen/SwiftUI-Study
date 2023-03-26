//
//  MyAlert.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/26.
//

/* Alert */
import SwiftUI

struct MyAlert: View {
    @State var isShowingAlert: Bool = false
    
    var body: some View {
        Button {
            isShowingAlert = true
        } label: {
            Text("Show alert")
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("This is Alert"),
                  primaryButton: .default(Text("OK")),
                  secondaryButton: .default(Text("Cancel")))
        }
    }
}

struct MyAlert_Previews: PreviewProvider {
    static var previews: some View {
        MyAlert()
    }
}
