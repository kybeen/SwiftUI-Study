//
//  MySpacer.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* Spacer() */
import SwiftUI

struct MySpacer: View {
    var body: some View {
        VStack {
            Image(systemName: "bolt")
                .resizable()
                .frame(width: 60)
                .aspectRatio(contentMode: .fit)
            
            Spacer()
            Text("Bolt!")
            
            Spacer()
            Button {
                print("Blink!")
            } label: {
                Text("Hit!")
            }
        }
    }
}

struct MySpacer_Previews: PreviewProvider {
    static var previews: some View {
        MySpacer()
    }
}
