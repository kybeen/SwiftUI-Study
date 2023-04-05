//
//  ImageSelectView.swift
//  AnimalsClassificationApp
//
//  Created by 김영빈 on 2023/04/05.
//

import SwiftUI

struct ImageSelectView: View {
    @State var pickedImage: Image = Image(systemName: "star.fill")
    
    // 부모의 상태가 변경될 때 자녀의 View를 변경하고 싶으면 @Binding으로 값을 받아와야 함
    @Binding var showingDialog: Bool
    @Binding var showingImagePicker: Bool
    
    let viewModel: ContentViewManager
    
    var body: some View {
        VStack(spacing: 20) {
            pickedImage
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .foregroundColor(.accentColor)
            
            Button {
                self.viewModel.changeDialog()
            } label: {
                Text("get Picture")
            }
            // confirmationDialog를 통해서 Alert를 생성할 수 있다.
            .confirmationDialog("사진 선택하기", isPresented: $showingDialog) {
                Button {
                    self.viewModel
                        .changeImagePicker(sourceType: .camera)
                } label: {
                    Text("카메라")
                }
                Button {
                    self.viewModel
                        .changeImagePicker(sourceType: .photoLibrary)
                } label: {
                    Text("앨범")
                }
            }
            // 화면 전체를 Present하는 방법
            .fullScreenCover(isPresented: $showingImagePicker) {
                ImagePickerViewController(sourceType: self.viewModel.sourceType, callBack: { image in
                    self.pickedImage = Image(uiImage: image)
                    self.viewModel.imageAnalizeSetup(image: image)
                })
            }
        }
    }
}

struct ImageSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSelectView()
    }
}
