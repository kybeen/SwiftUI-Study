//
//  MyPicker.swift
//  LeeoSwiftUI3
//
//  Created by 김영빈 on 2023/03/26.
//

import SwiftUI

struct MyPicker: View {
    @State var selectedItem: Int = 0
    
    var body: some View {
        VStack {
            Text(selectedItem.description)
            Picker(selection: $selectedItem, label: Text("Picker")) {
                Text("1 입니다.").tag(1)
                Text("2 입니다.").tag(2)
            }
            .pickerStyle(.inline)
            .cornerRadius(20)
            .padding()
        }
    }
}

struct MyPicker_Previews: PreviewProvider {
    static var previews: some View {
        MyPicker()
    }
}
