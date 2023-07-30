//
//  ContentView.swift
//  ChartsStudy
//
//  Created by 김영빈 on 2023/07/30.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Most Sold Style Over The Last 30 Days").font(.body).foregroundColor(.gray).bold()
            Text("Cachapa").font(.title3).bold()
            StylesDetailChart()
                .frame(height: UIScreen.main.bounds.height*0.4)
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
