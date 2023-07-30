//
//  CupertinoDetailsDemo.swift
//  ChartsStudy
//
//  Created by 김영빈 on 2023/07/30.
//

import SwiftUI

struct CupertinoDetailsDemo: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Day with most sales in Cupertino").font(.body).foregroundColor(.gray).bold()
            Text("Saturdays").font(.title3).bold()
            CupertinoDetailsChart()
                .frame(height: UIScreen.main.bounds.height*0.3)
            Spacer()
        }
        .padding()
    }
}

struct CupertinoDetailsDemo_Previews: PreviewProvider {
    static var previews: some View {
        CupertinoDetailsDemo()
    }
}
