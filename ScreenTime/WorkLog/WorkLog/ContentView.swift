//
//  ContentView.swift
//  Worklog
//
//  Created by 김영빈 on 2023/04/26.
//

/*
 - FamilyControls 프레임워크에는 작업을 위한 SwiftUI 요소인 familyActivityPicker가 있다.
 - 기본 앱의 UI에서 이 피커를 표시하고, 앱 or 웹을 카테고리 목록에서 선택한다.
 - 버튼을 통해 불러온 피커는 반환값을 모델의 속성에 바인딩한다.($model.selectionToDiscourage)
   - selection에 지정된 모델의 선택 값 프로퍼티는 피커로 선택한 값이 변경될 때마다 갱신됨
 - 앱을 선택한 뒤에는 familyActivityPicker에서 반환된 토큰을 사용할 수 있음.
   - 이 토큰은 각각의 앱과 웹사이트 등을 나타내며, 토큰을 통해 해당하는 앱 등에 제한을 적용해준다.
*/
import SwiftUI

struct ContentView: View {
    @State private var isDiscouragedPresented = false
    @State private var isEncouragedPresented = false
    
    @EnvironmentObject var model: MyModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Select apps to Discourage / Encourage")
                .font(.title)
                .padding()
            Spacer()
            
            Button("Select Apps to Discourage") {
                isDiscouragedPresented = true
            }
            .familyActivityPicker(isPresented: $isDiscouragedPresented, selection: $model.selectionToDiscourage)
            .padding()
            
            Button("Select Apps to Encourage") {
                isEncouragedPresented = true
            }
            .familyActivityPicker(isPresented: $isEncouragedPresented, selection: $model.selectionToEncourage)
            Spacer()

        }
        .padding()
        // selectionToDiscourage 값이 변경될 때마다 모델의 shield 세팅 값 변경
        .onChange(of: model.selectionToDiscourage) { newSelection in
            MyModel.shared.setShieldRestriction()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MyModel())
    }
}
