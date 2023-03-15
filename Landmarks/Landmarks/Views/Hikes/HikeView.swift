/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view displaying information about a hike, including an elevation graph.
*/

// HikeView.swift
import SwiftUI

// AnyTransition에 스태틱 프로퍼티를 추가하고, 이 프로퍼티를 호출해봅니다.
extension AnyTransition {
    static var moveAndFade: AnyTransition {
//        AnyTransition.move(edge: .trailing) // 같은 쪽에서 나왔다가 들어가는 애니메이션 효과
        // 뷰가 나타나고 사라질 때 다른 애니메이션 효과를 적용해줍니다.
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}


struct HikeView: View {
    var hike: Hike
    @State private var showDetail = false

    var body: some View {
        VStack {
            HStack {
                HikeGraph(hike: hike, path: \.elevation)
                    .frame(width: 50, height: 30)

                VStack(alignment: .leading) {
                    Text(hike.name)
                        .font(.headline)
                    Text(hike.distanceText)
                }

                Spacer()

                Button {
                    withAnimation { // HikeDetail 뷰에도 애니메이션 효과 적용 (animation(_:value:) 모디파이어와 같은 종류의 애니메이션을 전달할 수 있습니다. --> withAnimation(.easeInOut(duration: 2)) 같은 식으로
                        showDetail.toggle()
                    }
                } label: {
                    Label("Graph", systemImage: "chevron.right.circle")
                        .labelStyle(.iconOnly)
                        .imageScale(.large)
                        .rotationEffect(.degrees(showDetail ? 90 : 0))
                        //.animation(nil, value: showDetail) // 직전의 .rotationEffect에 대한 애니메이션 효과를 막아줌 (90도로 회전하는 효과가 사라짐)
                        .scaleEffect(showDetail ? 1.5 : 1) // 크기가 변하는 애니메이션 효과
                        .padding()
                        //.animation(.spring(), value: showDetail) // showDetail 값이 변경될 때 동작하는 애니메이션 효과
                }
            }

            if showDetail {
                HikeDetail(hike: hike)
                    .transition(.moveAndFade)
            }
        }
    }
}

struct HikeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HikeView(hike: ModelData().hikes[0])
                .padding()
            Spacer()
        }
    }
}
