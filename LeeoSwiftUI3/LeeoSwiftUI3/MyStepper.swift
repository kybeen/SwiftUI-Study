//
//  MyStepper.swift
//  LeeoSwiftUI3
//
//  Created by 김영빈 on 2023/03/26.
//

import SwiftUI

struct MyStepper: View {
    @State var myLevel: Int = 1
    
    var body: some View {
        Stepper(value: $myLevel, in: 1...10) {
            Text("Level\(myLevel)")
        }
        .padding()
        .colorMultiply(.green) // 색깔 지정
    }
}

struct MyStepper_Previews: PreviewProvider {
    static var previews: some View {
        MyStepper()
    }
}
