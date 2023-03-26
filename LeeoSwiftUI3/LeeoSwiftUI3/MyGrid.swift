//
//  MyGrid.swift
//  LeeoSwiftUI3
//
//  Created by 김영빈 on 2023/03/26.
//

import SwiftUI

struct MyGrid: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(), // Vertical Grid의 열 개수 지정
                            GridItem(),
                            GridItem()]) {
            
            Text("1")
                .frame(width: 100, height: 100)
                .background(.purple)
            Text("2")
                .frame(width: 100, height: 100)
                .background(.purple)
            Text("3")
                .frame(width: 100, height: 100)
                .background(.purple)
            Text("4")
                .frame(width: 100, height: 100)
                .background(.purple)
            Text("5")
                .frame(width: 100, height: 100)
                .background(.purple)
            Text("6")
                .frame(width: 100, height: 100)
                .background(.purple)
            Text("7")
                .frame(width: 100, height: 100)
                .background(.purple)
        }
    }
}

struct MyGrid_Previews: PreviewProvider {
    static var previews: some View {
        MyGrid()
    }
}
