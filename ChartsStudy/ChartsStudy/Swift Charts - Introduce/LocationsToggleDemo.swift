//
//  LocationsToggleDemo.swift
//  ChartsStudy
//
//  Created by 김영빈 on 2023/07/30.
//

import SwiftUI

struct LocationsToggleDemo: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Day + Location with Most Sales").font(.body).foregroundColor(.gray).bold()
            Text("Sundays in San Francisco").font(.title3).bold()
            LocationsToggleChart()
                .frame(height: UIScreen.main.bounds.height*0.3)
            Spacer()
        }
        .padding()
    }
}

struct LocationsToggleDemo_Previews: PreviewProvider {
    static var previews: some View {
        LocationsToggleDemo()
    }
}
