//
//  ContentView.swift
//  ConnectedWatch2 Watch App
//
//  Created by 김영빈 on 2023/07/07.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = viewModelWatch()
    
    var body: some View {
        VStack {
            Text(self.model.messageText)
            Text(self.model.number)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
