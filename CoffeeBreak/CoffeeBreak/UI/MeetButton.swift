//
//  ActiveButton.swift
//  CoffeeBreak
//
//  Created by Elizaveta Petrovskaia on 13/12/22.
//

import SwiftUI

struct MeetButton: View {
    // Public
    let text: String
    let buttonClickable: Bool
    let state: LoadingState
    let action: (() -> Void)?
    // Private
    @State var animationAmountFirst = 1.0
    @State var animationAmountSecond = 1.0

    
    func activateAnimation(){

        animationAmountFirst += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            animationAmountSecond += 1
        }

    }

    
    
    init(text: String, buttonClickable: Bool, state: LoadingState, _ action: (() -> Void)? = nil) {
        self.text = text
        self.state = state
        self.action = action
        self.buttonClickable = buttonClickable
    }
    


    var body: some View {
        Button(action: action ?? { }) {
            ZStack {
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                CoffeeColors.MeetButtonColor,
                                ],
                            startPoint: UnitPoint(
                                x: 0.18045112971831223,
                                y: 0.12781956192006852),
                            endPoint: UnitPoint(
                                x: 0.500000040277953,
                                y: 1.0000000294662057
                            )
                        )
                    )
                Circle()
.strokeBorder(Color("Stroke"), lineWidth: 3)
                
                Text(text).font(.system(size: 28, weight: .bold)).foregroundColor(.white)
                    .tracking(-0.24).multilineTextAlignment(.center)
            }
            .compositingGroup()
            .frame(width: 266, height: 266)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius: 6, x: 0, y: 6)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color("Stroke"), lineWidth: 5)
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
                    .stroke(Color("Stroke"), lineWidth: 5)
                    .scaleEffect(animationAmountSecond)
                    .opacity(2 - animationAmountSecond)
                    .animation(
                        .easeInOut(duration: 2)
                        .repeatForever(autoreverses: false),
                        value: animationAmountSecond
                    )
            )


        }
        .disabled(!buttonClickable)
        .onAppear {
            if state == .searching{
                activateAnimation()
                
            }
        }
    
    
}
}

extension MeetButton {
    enum LoadingState {
        case idle, searching, failed
    }
}

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        MeetButton(text: "Take a Break", buttonClickable: false, state: .searching)
    }
}

