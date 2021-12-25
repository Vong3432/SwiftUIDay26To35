//
//  Project6AnimationLearningAppView.swift
//  SwiftUIDay26To35
//
//  Created by Vong Nyuksoon on 24/12/2021.
//
// You can control the initial stiffness of the spring (which sets its initial velocity when the animation starts), and also how fast the animation should be “damped” – lower values cause the spring to bounce back and forth for longer.

import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped() // The addition of clipped() there means that when the view rotates the parts that are lying outside its natural rectangle don’t get drawn.
    }
}

extension AnyTransition {
    
    /**
     Rotate from -90 to 0 on its top leading corner
     */
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct Project6AnimationLearningAppView: View {
    
    @State private var scaleAnimationAmount = 1.0
    @State private var rotateAnimationAmount = 0.0
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    private let letters = Array("Hello SwiftUI")
    @State private var letterAnimationEnabled = false
    @State private var letterAnimationDragAmount = CGSize.zero
    
    private var drag: some Gesture {
        DragGesture()
            .onChanged({ (action) in
                dragAmount = action.translation
            })
            .onEnded { _ in
                withAnimation(.spring()) {
                    dragAmount = .zero
                }
            }
    }
    
    @State private var isShowingRed = false
    
    var body: some View {
        animatingShowHideView
    }
}

struct Project6AnimationLearningAppView_Previews: PreviewProvider {
    static var previews: some View {
        Project6AnimationLearningAppView()
    }
}

extension Project6AnimationLearningAppView {
    private var animatingWithModifier: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
    
    private var animatingShowHideView: some View {
        VStack {
            Button("Tap Me") {
                withAnimation(.spring()) {
                    isShowingRed.toggle()
                }
            }.offset(isShowingRed ? CGSize(width: 0, height: -20) : .zero)
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .cornerRadius(18)
                    .frame(width: 200, height: 200)
//                    .transition(.scale)
                    .transition(
                        .asymmetric(
                            insertion: .scale.animation(.easeOut.delay(0.5)),
                            removal: .scale.animation(.easeOut.delay(0))
                        )
                    )
                //                .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
    }
    private var animatingGestureView: some View {
        VStack {
            LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 300, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(dragAmount)
                .gesture(drag)
            
            HStack(spacing: 0) {
                ForEach(0..<letters.count) { num in
                    Text(String(letters[num]))
                        .padding(5)
                        .font(.title)
                        .background(enabled ? .blue : .red)
                        .offset(letterAnimationDragAmount)
                        .animation(
                            .default.delay(Double(num) / 20),
                            value: letterAnimationDragAmount)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { letterAnimationDragAmount = $0.translation }
                    .onEnded { _ in
                        letterAnimationDragAmount = .zero
                        letterAnimationEnabled.toggle()
                    }
            )
        }
    }
    
    // orders matter
    private var stackAnimationView: some View {
        VStack {
            Button("Tap Me") {
                // do nothing
                enabled.toggle()
            }
            .frame(width: 200, height: 200)
            .background(enabled ? .blue : .red)
            .animation(.default, value: enabled)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
            .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
        }
    }
    
    private var explicitAnimationView: some View {
        VStack {
            Button("Tap Me") {
                // do nothing
                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                    rotateAnimationAmount += 360
                }
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .rotation3DEffect(.degrees(rotateAnimationAmount), axis: (x: 1, y: 1, z: 0))
        }
    }
    
    private var implicitAndBindingView: some View {
        VStack {
            Stepper("Scale amount", value: $scaleAnimationAmount.animation(
                .easeOut(duration: 1)
                    .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            
            Button("Tap me") {
                scaleAnimationAmount += 1
            }
            .onAppear {
                scaleAnimationAmount = 2
            }
            .padding(50)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(Circle())
            //        .blur(radius: (scaleAnimationAmount - 1) * 3)
            //        .scaleEffect(scaleAnimationAmount)
            .overlay(
                Circle()
                    .stroke(.red)
                    .scaleEffect(scaleAnimationAmount)
                    .opacity(2 - scaleAnimationAmount)
                    .animation(
                        .easeOut(duration: 1)
                            .repeatForever(autoreverses: false),
                        value: scaleAnimationAmount
                    )
            )
            .animation(
                .easeInOut(duration: 1),
                //                .repeatForever(autoreverses: true),
                //                .repeatCount(3, autoreverses: true ),
                value: scaleAnimationAmount
            )
        }
        //        .animation(
        //            .easeOut(duration: 1)
        //                .delay(1),
        //            value: scaleAnimationAmount
        //        )
        //        .animation(.easeOut(duration: 1), value: scaleAnimationAmount)
        //        .animation(.interpolatingSpring(stiffness: 50, damping: 30))
        //        .animation(.easeIn, value: scaleAnimationAmount)
    }
}
