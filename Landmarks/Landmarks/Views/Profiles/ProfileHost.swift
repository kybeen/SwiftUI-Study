//
//  ProfileHost.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/17.
//

//  ProfileHost.swift
import SwiftUI

struct ProfileHost: View {
    @Environment(\.editMode) var editMode // \.editMode를 키로 갖는 Environment 뷰 프로퍼티를 추가해줍니다.
    @EnvironmentObject var modelData: ModelData
    @State private var draftProfile = Profile.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel", role: .cancel) { // Cancel 버튼 추가
                        draftProfile = modelData.profile
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton() // editMode의 값을 제어하는 버튼
            }
            
            if editMode?.wrappedValue == .inactive {
                ProfileSummary(profile: modelData.profile) // PRofileSummary로부터 유저의 프로필 데이터를 읽어와서 ProfileHost에서 데이터를 제어할 수 있도록 해줍니다.
            } else { // 편집 모드로 들어가기
                ProfileEditor(profile: $draftProfile)
                    .onAppear {
                        draftProfile = modelData.profile // 프로필의 복사본을 수정해주고
                    }
                    .onDisappear() {
                        modelData.profile = draftProfile // 프로필 수정이 완료되면 수정된 복사본으로 덮어씌워줍니다.
                    }
            }
        }
        .padding()
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        // 이 뷰에서는 @EnvironmenObject 프로퍼티를 사용하지 않지만, 자식 뷰인 ProfileSummary에서 사용하기 때문에 .environmentObject() 수정자가 없으면 오류가 발생합니다.
        ProfileHost()
            .environmentObject(ModelData())
    }
}
