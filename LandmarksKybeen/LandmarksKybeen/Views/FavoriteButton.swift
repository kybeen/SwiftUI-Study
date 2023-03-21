//
//  FavoriteButton.swift
//  LandmarksKybeen
//
//  Created by 김영빈 on 2023/03/21.
//

import SwiftUI

struct FavoriteButton: View {
    // @Binding : 하위 뷰에서 가져다 쓸 수 있는 state 변수를 만들어줌
    @Binding var isSet: Bool

    var body: some View {
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
