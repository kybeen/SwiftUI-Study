//
//  ProfileEditor.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/17.
//

//  ProfileEditor.swift
import SwiftUI

struct ProfileEditor: View {
    @Binding var profile: Profile
    
    // 날짜 선택 범위
    var dateRage: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: profile.goalDate)!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: profile.goalDate)!
        return min...max
    }
    
    var body: some View {
        List {
            // 사용자 이름 편집
            HStack {
                Text("Username").bold()
                Divider()
                TextField("Username", text: $profile.username)
            }
            
            // 랜드마크 관련 이벤트 등의 알림 수신 여부 편집
            Toggle(isOn: $profile.prefersNotifications) {
                Text("Enable Notifications").bold()
            }
            
            // 랜드마크 선호 계절 값 편집
            VStack(alignment: .leading, spacing: 20) {
                Text("Seasonal Photo").bold()
                
                Picker("Seasonal Photo", selection: $profile.seasonalPhoto) {
                    ForEach(Profile.Season.allCases) { season in
                        Text(season.rawValue).tag(season)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            // 랜드마크 방문 목표 날짜 편집
            DatePicker(selection: $profile.goalDate, in: dateRage, displayedComponents: .date) {
                Text("Goal Date").bold()
            }
        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(profile: .constant(.default))
    }
}
