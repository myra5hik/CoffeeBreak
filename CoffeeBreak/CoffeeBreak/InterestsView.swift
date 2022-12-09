//
//  InterestsView.swift
//  CoffeeBreak
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI

struct InterestsView: View {
    
    @Binding var interest1: String
    @Binding var interest2: String
    @Binding var interest3: String
    
    
    @State var options = ["Coding", "UI Design", "UX Design", "Gaming", "Game Development", "Hiking", "Football"]
    
    @State var selectedItem = "Pick Your Interest"
    
    var body: some View {
        
        Menu {
            
            ForEach(options, id: \.self) { index in
                Button(action: {
                    interest1 = "\(index)"
                    UserDefaults.standard.set(interest1, forKey: "interest1")
                    
                    //let _3 = print("Interest 1: \(interest1)")

                }){
                    if interest1 == "\(index)"{
                        Label("\(index)", systemImage: "checkmark")
                    }else {
                        Text("\(index)")
                    }
                }
                
            }
        } label: {
            Text(interest1)
                .foregroundColor(.black)
             Image(systemName: "wand.and.stars.inverse")
                .foregroundColor(.black)

        }
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
                    interest2 = "\(index)"
                    UserDefaults.standard.set(interest2, forKey: "interest2")

                    //let _2 = print("Interest 2: \(interest2)")

                }){
                    if interest2 == "\(index)"{
                        Label("\(index)", systemImage: "checkmark")
                    }else {
                        Text("\(index)")
                    }
                }

            }
        } label: {
            Text(interest2)
                .foregroundColor(.black)
             Image(systemName: "wand.and.stars.inverse")
                .foregroundColor(.black)

        }
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
                    interest3 = "\(index)"
                    UserDefaults.standard.set(interest3, forKey: "interest3")

                    //let _ = print("Interest 3: \(interest3)")

                }){
                    if interest3 == "\(index)"{
                        Label("\(index)", systemImage: "checkmark")
                    }else {
                        Text("\(index)")
                    }
                }

            }
        } label: {
            Text(interest3)
                .foregroundColor(.black)
             Image(systemName: "wand.and.stars.inverse")
                .foregroundColor(.black)

        }
        .padding()
        .padding(.leading, 30)
        .padding(.trailing, 30)
        .background(CoffeeColors.interestsBackground)
        .cornerRadius(6)


        
        
  
    } //end of body
}


