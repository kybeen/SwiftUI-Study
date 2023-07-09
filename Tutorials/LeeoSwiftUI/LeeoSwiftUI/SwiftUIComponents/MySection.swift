//
//  MySection.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* Section */
import SwiftUI

struct MySection: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "heart")
                    Text("Kybeen")
                }
                HStack {
                    Image(systemName: "heart.fill")
                    Text("Leeo")
                }
                HStack {
                    Image(systemName: "bolt")
                    Text("Dodo")
                }
            } header: {
                Text("A Class")
            }

            Section {
                HStack {
                    Image(systemName: "heart")
                    Text("Kybeen")
                }
                HStack {
                    Image(systemName: "heart.fill")
                    Text("Leeo")
                }
                HStack {
                    Image(systemName: "bolt")
                    Text("Dodo")
                }
            } header: {
                Text("B Class")
            } footer: {
                Text("Footer")
            }
        }
    }
}

struct MySection_Previews: PreviewProvider {
    static var previews: some View {
        MySection()
    }
}
