//
//  ContentView.swift
//  SwiftUIMarathonTask4
//
//  Created by Sergei Semko on 3/8/24.
//

import SwiftUI

struct ContentView: View {
    
    private let durationTestButton: TimeInterval = 1
    private let scaleTestButton: CGFloat = 0
    
    private let durationButton: TimeInterval = 0.22
    private let scaleButton: CGFloat = 0.86
    
    var body: some View {
        HStack(spacing: 50) {
            VStack {
                CustomButton(duration: durationTestButton, scale: scaleTestButton)
                Text("Duration = \(durationTestButton.description) \nScale = \(scaleTestButton.description)")
            }
            VStack {
                CustomButton(duration: durationButton, scale: scaleButton)
                Text("Duration = \(durationButton.description) \nScale = \(scaleButton.description)")
            }
        }
    }
}

struct CustomButton: View {
    
    let duration: TimeInterval
    let scale: CGFloat
    
    @State private var performAnimation: Bool = false
    
    var body: some View {
        Button {
            if !performAnimation {
                withAnimation(.interpolatingSpring(stiffness: 170, damping: 15)) {
                    performAnimation = true
                } completion: {
                    performAnimation = false
                }
            }
        } label: {
            GeometryReader { proxy in
                let width = proxy.size.width / 2
                let systemName = "play.fill"
                
                HStack(alignment: .center, spacing: 0, content: {
                    CustomImage(systemName: systemName)
                        .frame(width: performAnimation ? width : .zero)
                        .opacity(performAnimation ? 1 : .zero)
                    
                    CustomImage(systemName: systemName)
                        .frame(width: width)
                    
                    CustomImage(systemName: systemName)
                        .frame(width: performAnimation ? 0.5 : width)
                        .opacity(performAnimation ? .zero : 1)
                })
                .frame(maxHeight: .infinity, alignment: .center)
            }
        }
        .frame(width: 100, height: 100)
        .buttonStyle(CustomButtonStyle(duration: duration, scale: scale))
    }
}

struct CustomImage: View {
    
    let systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
    }
}

struct CustomButtonStyle: PrimitiveButtonStyle {
    
    @State private var isPressed = false
    
    let duration: TimeInterval
    let scale: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isPressed ? .gray.opacity(0.2) : .clear)
            .clipShape(Circle())
            .scaleEffect(isPressed ? scale : 1)
            .animation(.easeOut(duration: duration), value: isPressed)
            .onTapGesture {
                configuration.trigger()
                
                withAnimation(.interactiveSpring(duration: duration)) {
                    isPressed = true
                } completion: {
                    isPressed = false
                }
            }
    }
}

#Preview {
    ContentView()
}
