//
//  MyList.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* List */
import SwiftUI

struct MyList: View {
    var body: some View {
        List {
            HStack {
                Image(systemName: "heart")
                Text("kybeen")
            }
            HStack {
                Image(systemName: "heart.fill")
                Text("Leeo")
            }
            HStack {
                Image(systemName: "bolt")
                Text("Olivia")
            }
        }
    }
}

struct MyList_Previews: PreviewProvider {
    static var previews: some View {
        MyList()
    }
}
