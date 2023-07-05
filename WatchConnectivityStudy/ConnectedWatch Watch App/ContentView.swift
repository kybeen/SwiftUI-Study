//
//  ContentView.swift
//  ConnectedWatch Watch App
//
//  Created by 김영빈 on 2023/07/05.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        // 아이폰으로 메세지 보내기
        Button {
            WatchConnectivityManager.shared.send("From Apple Watch!!!\n\(Date().ISO8601Format())")
        } label: {
            Text("Send message to iPhone.")
        }
        // 아이폰에서 받은 메세지 Alert
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
