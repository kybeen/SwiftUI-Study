//
//  MyLabel.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/26.
//

/* Label - 텍스트와 레이블을 동시에 보여주기 */
import SwiftUI

struct MyLabel: View {
    var body: some View {
        VStack {
            // Label
            Label("Kybeen", systemImage: "bolt")
            
            // Image와 Text를 합쳐서도 Label처럼 보일 수 있다.
            HStack {
                Image(systemName: "bolt")
                Text("Kybeen")
            }
        }
    }
}

struct MyLabel_Previews: PreviewProvider {
    static var previews: some View {
        MyLabel()
    }
}
