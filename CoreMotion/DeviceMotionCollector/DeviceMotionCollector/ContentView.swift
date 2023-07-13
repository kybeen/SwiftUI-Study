//
//  ContentView.swift
//  DeviceMotionCollector
//
//  Created by 김영빈 on 2023/07/08.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var phoneViewModel = PhoneViewModel()
    @State var reachable = "No"
    
    @State private var selectedFrequency = 9
    let HzOptions = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    
    var body: some View {
        VStack {
            HStack {
                Text("Frequency select").font(.title2).bold()
                Picker("Frequency", selection: $selectedFrequency) {
                    ForEach(0..<HzOptions.count) { index in
                        Text("\(HzOptions[index])Hz")
                    }
                }
                .pickerStyle(.automatic)
                .onChange(of: selectedFrequency) { newValue in
                    phoneViewModel.session.transferUserInfo(["hz": self.HzOptions[newValue]])
                }
            }
            .padding()
            
            
            VStack {
                Text("Received data").font(.title).bold()
                HStack {
                    Text("Reachable: \(reachable)")
                    Button("Update") {
                        if self.phoneViewModel.session.isReachable {
                            self.reachable = "Yes"
                            print("YES!!!")
                        } else {
                            self.reachable = "No"
                            print("NO...")
                        }
                    }
                    .padding(5)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(.leading, 20)
                }
                Text("CSV file name : \(phoneViewModel.csvFileName)").bold()
            }
            .padding()
            
            VStack {
                HStack {
                    Text("Save Status :")
                    Text(phoneViewModel.isSucceeded)
                        .foregroundColor(phoneViewModel.isSucceeded=="Success!!!" ? .green : .red)
                        .bold()
                }
                Text("Saved data").font(.title).bold()
                if let savedCSVFiles = phoneViewModel.savedCSV {
                    List(savedCSVFiles, id: \.self) { savedCSVFile in
                        Text("\(savedCSVFile)")
                    }
                } else {
                    Text("No items")
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
