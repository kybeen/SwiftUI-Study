//
//  FavoriteButton.swift
//  Landmarks
//
//  Created by 김영빈 on 2023/03/14.
//

//  FavoriteButton.swift
import SwiftUI

struct FavoriteButton: View {
    // 버튼의 현재 상태를 나타내는 @Binding 변수를 추가해줍니다.
    // 바인딩을 사용하면 뷰 내부에서의 변경 사항이 데이터 소스로 다시 전파됩니다.
    @Binding var isSet: Bool
    
    var body: some View {
        // 버튼 뷰 - isSet 값에 따라 다른 형태로 보이도록 해줍니다.
        Button {
            isSet.toggle()
        } label: {
            Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundColor(isSet ? .yellow : .gray)
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(isSet: .constant(true))
    }
}
