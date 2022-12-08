//
//  MeetActiveView.swift
//  CoffeeBreak
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI

struct MeetActiveView: View {
    @State private var animationAmount = 1.0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Button("Search in process...") {
                animationAmount += 1
            }
            
            .padding(70)
            .background(
                LinearGradient(gradient: Gradient(colors: [ Color("Color"), .accentColor]), startPoint: .top, endPoint: .bottom)
            )
            .foregroundColor(Color("Color1"))
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.brown)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .animation(
                        .easeInOut(duration: 2)
                        .repeatForever(autoreverses: false),
                        value: animationAmount
                    )
            )
            .onAppear {
                animationAmount = 2.0
                
                //  }.onTapGesture {
                //     animationAmount+=1
            }
            
            
            VStack {
                Button(action: {
                    dismiss()
                    
                }) {
                    
                    Text("Cancel Search")
                    
                }
                
           
            }
            
        }
         
    }
}
struct MeetActiveView_Previews: PreviewProvider {
    static var previews: some View {
        MeetActiveView()
    }
}

