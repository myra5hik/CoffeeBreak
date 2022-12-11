//
//  ProfileView.swift
//  testingAgainNC2
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI

struct ProfileView: View {
    

    
    @State private var interest1 =  UserDefaults.standard.string(forKey: "interest1")  ?? "Pick Your Interest"
    @State private var interest2 =  UserDefaults.standard.string(forKey: "interest2")  ?? "Pick Your Interest"

    @State private var interest3 =  UserDefaults.standard.string(forKey: "interest3")  ?? "Pick Your Interest"
    
 
    
    var body: some View {
        
        VStack {
            ScrollView {
                VStack{
                    Spacer().frame(height: 20.0)
                    HStack {
                        Image("ProfileImage")
                        Spacer().frame(width: 30.0)
                        VStack(alignment: .leading){
                            Spacer().frame(height: 20.0)

                            Text("Roman")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer().frame(height: 10.0)
                            Text("Apple Developer Academy")
                                .foregroundColor(.gray)
                                .font(.title3)
                            Spacer().frame(height: 20.0)

                            Text("Edit Profile")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                                .underline()
                                
                        }
                    } //end of header Hstack
                    Spacer().frame(height: 60.0)
                    
                    VStack{
                        
                        Text("Interested in...")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.semibold)
                        Text("Click interests to edit:")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        
                        Spacer().frame(height: 20.0)

                        
                        Group {
                            InterestsView(interest1: $interest1, interest2: $interest2, interest3: $interest3)
                                
                            
                            
                            
                          
                        }
                        
                        
                        Spacer().frame(height: 30)

                        Text("Link to connect:")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Button(action: {
                            
                            
                            
                        }) {
                            

                              
                            Text("Discordapp.com/users/Roman")
                                .foregroundColor(CoffeeColors.innerBox)
                                .opacity(0.75)
                            Image(systemName: "square.and.pencil")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                
                            
                        }
                        .padding(.bottom, 16)
                        .padding(.top, 16)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)

                        .background(CoffeeColors.interestsBackground)   .cornerRadius(30)
                        .opacity(0.75)

                        
                        
                        
                        
                    }
                    .padding()
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    .background(CoffeeColors.innerBox.clipShape(RoundedRectangle(cornerRadius:10)))
                    
                  
                Spacer()
                Text("Logout")
                        .underline()
                        .foregroundColor(CoffeeColors.innerBox)
                    
                Spacer()
                    
                    
                    
                }

            }   .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(CoffeeColors.backgroundColor)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

