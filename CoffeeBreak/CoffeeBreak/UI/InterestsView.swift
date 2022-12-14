//
//  InterestsView.swift
//  CoffeeBreak
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI

struct InterestsView: View {
    @Binding var isEditting: Bool
    @Binding var interests: (DiscussionTopic?, DiscussionTopic?, DiscussionTopic?)
    @State var options = DiscussionTopic.allCases
    @State var selectedItem = "Pick Your Interest"
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { index in
                Button(action: {
                    interests.0 = index
                }) {
                    if interests.0 == index {
                        Label("\(index.title)", systemImage: "checkmark")
                    } else {
                        Text("\(index.title)")
                    }
                }
                
            }
        } label: {
            Text(interests.0?.title ?? "Pick Your Interest")
                .foregroundColor(.black)
             Image(systemName: "wand.and.stars.inverse")
                .foregroundColor(.black)

        }
        .disabled(!isEditting)
        .padding()
        .padding(.leading, 30)
        .padding(.trailing, 30)
        .background(CoffeeColors.interestsBackground)
        .cornerRadius(6)

        
        
        Spacer().frame(height: 20.0)
        
        //menu 2
        Menu {
            
            ForEach(options, id: \.self) { index in
                Button(action: {
                    interests.1 = index
                }){
                    if interests.1 == index {
                        Label(index.title, systemImage: "checkmark")
                    }else {
                        Text(index.title)
                    }
                }

            }
        } label: {
            Text(interests.1?.title ?? "Pick Your Interest")
                .foregroundColor(.black)
             Image(systemName: "wand.and.stars.inverse")
                .foregroundColor(.black)

        }
        .disabled(!isEditting)
        .padding()
        .padding(.leading, 30)
        .padding(.trailing, 30)
        .background(CoffeeColors.interestsBackground)
        .cornerRadius(6)
        
        
        
        Spacer().frame(height: 20.0)
        
        
        //menu 3
        Menu {
            ForEach(options, id: \.self) { index in
                Button(action: {
                    interests.2 = index
                }){
                    if interests.2 == index {
                        Label(index.title, systemImage: "checkmark")
                    }else {
                        Text(index.title)
                    }
                }

            }
        } label: {
            Text(interests.2?.title ?? "Pick Your Interest")
                .foregroundColor(.black)
             Image(systemName: "wand.and.stars.inverse")
                .foregroundColor(.black)

        }
        .disabled(!isEditting)
        .padding()
        .padding(.leading, 30)
        .padding(.trailing, 30)
        .background(CoffeeColors.interestsBackground)
        .cornerRadius(6)
    }
}


