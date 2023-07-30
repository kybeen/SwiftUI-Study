//
//  LocationDetailsDemo.swift
//  ChartsStudy
//
//  Created by 김영빈 on 2023/07/31.
//

import SwiftUI

struct LocationDetailsDemo: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Day + Location with Most Sales").font(.body).foregroundColor(.gray).bold()
            Text("Sundays in San Francisco").font(.title3).bold()
            LocationDetailsChart()
                .frame(height: UIScreen.main.bounds.height*0.3)
            Spacer()
        }
        .padding()
    }
}

struct LocationDetailsDemo_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailsDemo()
    }
}
