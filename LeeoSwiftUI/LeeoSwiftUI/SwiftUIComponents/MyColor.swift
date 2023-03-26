//
//  MyColor.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* Color() */
import SwiftUI

struct MyColor: View {
    var body: some View {
        //Color(.blue).edgesIgnoringSafeArea(.all)
        
//        Color(.blue)
//            .frame(width: 200, height: 200)
//            .clipShape(Circle())
        
        Color("KybeenColor")
    }
}

struct MyColor_Previews: PreviewProvider {
    static var previews: some View {
        MyColor()
    }
}
