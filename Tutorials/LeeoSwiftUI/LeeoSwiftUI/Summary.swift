//
//  Summary.swift
//  LeeoSwiftUI
//
//  Created by 김영빈 on 2023/03/26.
//

/* Text, Image, List, Stack, frame, padding 등 사용해보자 */
import SwiftUI

struct Summary: View {
    @State var isLighting: Bool = false
    
    var body: some View {
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image(systemName: isLighting ? "bolt.fill" : "bolt")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                
                Spacer()
                
                HStack {
                    Text("번개를 원하시면")
                    
                    Button {
                        // toggle() : true를 false로, false를 true로 바꿔줌
                        isLighting.toggle()
                    } label: {
                        Text("번쩍!")
                            .padding()
                            .background(.orange)
                            .cornerRadius(10)
                    }

                }
            }
        }
    }
}

struct Summary_Previews: PreviewProvider {
    static var previews: some View {
        Summary()
    }
}
