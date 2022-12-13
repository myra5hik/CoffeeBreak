//
//  ActiveButton.swift
//  CoffeeBreak
//
//  Created by Elizaveta Petrovskaia on 13/12/22.
//

import SwiftUI
struct MeetButton: View {
    @State private var animationAmountFirst = 1.0
    @State private var animationAmountSecond = 1.0
    @State private var text: String
    init () {
        text = "Take a break"
  
    }
    var body: some View {
        Button(action: {
            animationAmountFirst += 1
            text = "Search in process..."
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animationAmountSecond += 1
            }
        }) {
            Text (text)
         
            
        }
        .padding(70)
        .background(
            LinearGradient(gradient: Gradient(colors: [ Color("Color"), Color("Color1")]), startPoint: .top, endPoint: .trailing)
        )
        .foregroundColor(.white)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color("Stroke"))
                .scaleEffect(animationAmountFirst )
                .opacity(2 - animationAmountFirst )
                .animation(
                    .easeInOut(duration: 2)
                    .repeatForever(autoreverses: false),
                    value: animationAmountFirst
                )
        )
        .overlay(
            Circle()
                .stroke(Color("Stroke"))
                .scaleEffect(animationAmountSecond)
                .opacity(2 - animationAmountSecond)
                .animation(
                    .easeInOut(duration: 2)
                    .repeatForever(autoreverses: false),
                    value: animationAmountSecond
                )
        )
        
    }
}


struct Button_Previews: PreviewProvider {
    static var previews: some View {
        MeetButton()
    }
}

