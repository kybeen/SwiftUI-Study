//
//  MyForm.swift
//  LeeoSwiftUI3
//
//  Created by 김영빈 on 2023/03/26.
//

/* Form (여러 개의 컴포넌트 묶어주기) */
import SwiftUI

struct MyForm: View {
    var body: some View {
        Form {
            Section {
                HStack {
                    Image(systemName: "heart")
                    Text("Kybeen")
                }
            }
            
            HStack {
                Image(systemName: "heart.fill")
                Text("Leeo")
            }
        
            HStack {
                Image(systemName: "bolt")
                Text("Dodo")
            }
        }
    }
}

struct MyForm_Previews: PreviewProvider {
    static var previews: some View {
        MyForm()
    }
}
