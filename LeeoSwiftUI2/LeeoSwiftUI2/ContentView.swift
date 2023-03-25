//
//  ContentView.swift
//  LeeoSwiftUI2
//
//  Created by 김영빈 on 2023/03/24.
//

/*
 [ 배운 내용 ]
 Color(다크모드)
 Divider
 sheet, modal
 Alert
 TabView
 onAppear, onDisappear
 ProgressView
 TextField
 SecureField
 Toggle
 NavigationView, NavigationLink
 NavigationStack
 Label
 */
import SwiftUI

struct ContentView: View {
    @State var userID: String = ""
    @State var userPassword: String = ""
    @State var hasLoggedIn: Bool = false
    @State var visiblePassword: Bool = false
    
    var body: some View {
        VStack {
            // ID 입력
            HStack {
                Label("ID", systemImage: "person.fill")
                TextField("Enter ID", text: $userID)
            }
            // PW 입력
            HStack {
                Label("PW", systemImage: "lock.fill")
                if visiblePassword {
                    TextField("Enter password", text: $userPassword)
                } else {
                    SecureField("Enter password", text: $userPassword)
                }
            }
            
            // visiblePassword 값 토글 스위치
            Toggle(isOn: $visiblePassword) {
                Label("See password", systemImage: "eye")
            }
            .frame(width: 200)
            .padding(10)

            // 로그인 버튼
            Button {
                if userID == "Kybeen" && userPassword == "1234" {
                    hasLoggedIn = true
                } else {
                    hasLoggedIn = false
                }
            } label: {
                Text("Sign in")
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(10)
            }

        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .sheet(isPresented: $hasLoggedIn) {
            Text("Hello \(userID)! Welcome!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
