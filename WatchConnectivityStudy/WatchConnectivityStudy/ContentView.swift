//
//  ContentView.swift
//  WatchConnectivityStudy
//
//  Created by 김영빈 on 2023/07/05.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        // 애플워치로 메세지 보내기
        Button {
            WatchConnectivityManager.shared.send("From iPhone!!!\n\(Date().ISO8601Format())")
        } label: {
            Text("Send message to Apple Watch.")
                .font(.title2)
        }
        // 애플워치에서 받은 메세지 Alert
        .alert(item: $connectivityManager.notificationMessage) { message in
            Alert(title: Text(message.text), dismissButton: .default(Text("Dismiss")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
