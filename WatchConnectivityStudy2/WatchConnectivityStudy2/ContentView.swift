//
//  ContentView.swift
//  WatchConnectivityStudy2
//
//  Created by 김영빈 on 2023/07/07.
//

import SwiftUI

struct ContentView: View {
    var model = ViewModelPhone()
    @State var reachable = "No"
    @State var messsageText = ""
    @State var numberValue = 0
    
    var body: some View {
        VStack {
            Text("Reachable \(reachable)")
            
            /**
             WCSession의 isReachanle 프로퍼티를 사용해서 시계 앱이 설치되어 있는지 또는 현재 시계에 연결할 수 있는지를 확인
                --> 워치에서 앱 실행하고 Update 버튼을 누르면 No -> Yes로 변함
                --> 워치 홈 화면으로 나가고 Update 버튼을 누르면 다시 Yes -> No로 변함
             */
            Button {
                if self.model.session.isReachable {
                    self.reachable = "Yes"
                }
                else {
                    self.reachable = "No"
                }
            } label: {
                Text("Update")
            }
            
            /** 텍스트를 입력하고, 버튼을 누르면 애플워치로 데이터가 전송됨 */
            HStack {
                TextField("Input your message", text: $messsageText)
                Button {
                    self.model.session.sendMessage(["message" : self.messsageText], replyHandler: nil) { error in
                        /**
                         다음의 상황에서 오류가 발생할 수 있음
                            -> property-list 데이터 타입이 아닐 때
                            -> watchOS가 reachable 상태가 아닌데 전송할 때
                         */
                        print(error.localizedDescription)
                    }
                } label: {
                    Text("Send Message")
                }
            }
            .padding()
            
            /** 번호를 입력하고, 버튼을 누르면 데이터가 전송됨 */
            HStack {
                Button("-") {
                    if numberValue > 0 {
                        numberValue -= 1
                    }
                }
                Text("\(numberValue)")
                Button("+") {
                    numberValue += 1
                }
            }
            .padding()
            Button {
                self.model.session.transferUserInfo(["number" : String(self.numberValue)])
            } label: {
                Text("Send number")
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
