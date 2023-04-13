//
//  DragObjectView.swift
//  AnimationStudy
//
//  Created by 김영빈 on 2023/04/12.
//

// 드래그 앤 드롭 해보기
import SwiftUI

struct DragAndDropView: View {
    @State var boltOffset = CGSize.zero // 번개 이미지 위치
    @State var dragging = false
    @State var showPersonHighlight = false // 사람 이미지에 갖다댔을 때 표시
    @State var personPoint: CGPoint = .zero// 사람 이미지 좌표

    // 특정 거리만큼 움직였을 때 처리되도록
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                Image(systemName: "bolt")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
                    .background(.yellow)
                    .cornerRadius(15)
                    .overlay(
                        Rectangle()
                            .stroke(Color.red, lineWidth: dragging ? 5 : 0)
                    )
                    .offset(boltOffset)
                    .gesture(
                        // 드래그 이벤트 처리
                        DragGesture()
                            .onChanged { gesture in
                                print("gesture.location: \(gesture.location)")
                                print("personPoint: \(personPoint)")
                                boltOffset = gesture.translation
                                print("boltOffset: \(boltOffset)")
                                dragging = true
                                showPersonHighlight = isOverlapping(boltPoint: gesture.location)
                                print("showPersonHighlit: \(showPersonHighlight)")
                            }
                            .onEnded { _ in
                                boltOffset = .zero
                                dragging = false
                                showPersonHighlight = false
                            }
                    )

                Image(systemName: "person")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
                    .background(showPersonHighlight ? .yellow : .blue)
                    .cornerRadius(15)
                    .background(GeometryReader { proxy in
                        Color.clear
                            .onAppear{
                                let imgFrame = proxy.frame(in: .global)
                                print("imgFrame: \(imgFrame)")
                                personPoint = CGPoint(x: imgFrame.minX, y: imgFrame.minY)
                                print("personPoint: \(personPoint)")
                            }
                    })
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

                Text("으악!!")
                    .foregroundColor(showPersonHighlight ? .black : .white)

                Spacer()
            }
        }
    }

    // 번개 이미지와 사람 이미지가 겹치는지 확인하는 함수
    func isOverlapping(boltPoint: CGPoint) -> Bool {
        let boltImageFrame = CGRect(origin: boltPoint, size: CGSize(width: 100, height: 100))
        let personImageFrame = CGRect(origin: personPoint, size: CGSize(width: 100, height: 100))
        print("Bolt : \(boltImageFrame)")
        print("Person : \(personImageFrame)")
        print(boltImageFrame.intersects(personImageFrame))
        return boltImageFrame.intersects(personImageFrame)
    }
}

struct DragAndDropView_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropView()
    }
}

