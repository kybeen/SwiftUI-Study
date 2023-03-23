//
//  ProfileHost.swift
//  LandmarksKybeen
//
//  Created by 김영빈 on 2023/03/23.
//

import SwiftUI

struct ProfileHost: View {
    @Environment(\.editMode) var editMode // \.editMode를 키로 갖는 Environment 뷰 프로퍼티를 추가해줍니다.
    @EnvironmentObject var modelData: ModelData
    @State private var draftProfile = Profile.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel", role: .cancel) {
                        draftProfile = modelData.profile
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton() // editMode의 값을 제어하는 버튼
            }
            
            if editMode?.wrappedValue == .inactive {
                ProfileSummary(profile: modelData.profile)
            } else { // 편집 모드
                ProfileEditor(profile: $draftProfile)
                    .onAppear {
                        draftProfile = modelData.profile // 프로필의 복사본 수정
                    }
                    .onDisappear() {
                        modelData.profile = draftProfile // 수정 완료 시 수정된 프로필의 복사본으로 덮어씌움
                    }
            }
        }
        .padding()
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost()
            .environmentObject(ModelData())
    }
}
