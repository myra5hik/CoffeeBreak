////
////  InterestsView.swift
////  CoffeeBreak
////
////  Created by Ravi  on 12/7/22.
////
//
//import SwiftUI
//
//struct InterestsView: View {
//    @Binding var interests: [DiscussionTopic]
//    @State var options = ["Coding", "UI Design", "UX Design", "Gaming", "Game Development", "Hiking", "Football"]
//    @State var selectedItem = "Pick Your Interest"
//    
//    var body: some View {
//        Menu {
//            ForEach(options, id: \.self) { index in
//                Button(action: {
//                    interests.0 = "\(index)"
//                }){
//                    if interests.0 == "\(index)"{
//                        Label("\(index)", systemImage: "checkmark")
//                    }else {
//                        Text("\(index)")
//                    }
//                }
//                
//            }
//        } label: {
//            Text(interests.0 ?? "Pick Your Interest")
//                .foregroundColor(.black)
//             Image(systemName: "wand.and.stars.inverse")
//                .foregroundColor(.black)
//
//        }
//        .padding()
//        .padding(.leading, 30)
//        .padding(.trailing, 30)
//        .background(CoffeeColors.interestsBackground)
//        .cornerRadius(6)
//
//        
//        
//        Spacer().frame(height: 20.0)
//        
//        //menu 2
//        Menu {
//            
//            ForEach(options, id: \.self) { index in
//                Button(action: {
//                    interests.1 = "\(index)"
//                    UserDefaults.standard.set(interests.1, forKey: "interest2")
//
//                    //let _2 = print("Interest 2: \(interest2)")
//
//                }){
//                    if interests.1 == "\(index)"{
//                        Label("\(index)", systemImage: "checkmark")
//                    }else {
//                        Text("\(index)")
//                    }
//                }
//
//            }
//        } label: {
//            Text(interests.1 ?? "Pick Your Interest")
//                .foregroundColor(.black)
//             Image(systemName: "wand.and.stars.inverse")
//                .foregroundColor(.black)
//
//        }
//        .padding()
//        .padding(.leading, 30)
//        .padding(.trailing, 30)
//        .background(CoffeeColors.interestsBackground)
//        .cornerRadius(6)
//        
//        
//        
//        Spacer().frame(height: 20.0)
//        
//        
//        //menu 3
//        Menu {
//            
//            ForEach(options, id: \.self) { index in
//                Button(action: {
//                    interests.2 = "\(index)"
//                    UserDefaults.standard.set(interests.2, forKey: "interest3")
//
//                    //let _ = print("Interest 3: \(interest3)")
//
//                }){
//                    if interests.2 == "\(index)"{
//                        Label("\(index)", systemImage: "checkmark")
//                    }else {
//                        Text("\(index)")
//                    }
//                }
//
//            }
//        } label: {
//            Text(interests.2 ?? "Pick Your Interest")
//                .foregroundColor(.black)
//             Image(systemName: "wand.and.stars.inverse")
//                .foregroundColor(.black)
//
//        }
//        .padding()
//        .padding(.leading, 30)
//        .padding(.trailing, 30)
//        .background(CoffeeColors.interestsBackground)
//        .cornerRadius(6)
//
//
//        
//        
//  
//    } //end of body
//}
//
//
