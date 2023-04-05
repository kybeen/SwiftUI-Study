import SwiftUI

struct ContentView: View {
    @ObservableObject var viewModel = ContentViewManager()
    
    var body: some View {
        VStack {
            Spacer()
            
            ImageSelectView(showingDialog: $viewModel.showingDialog, showingImagePicker: $viewModel.showingImagePicker, viewModel: viewModel)
            
            Spacer()
            
            ImageResultView(imageClasificationDone: $viewModel.imageClassificationDone, viewModel: viewModel)
        }
        .padding()
    }
}
