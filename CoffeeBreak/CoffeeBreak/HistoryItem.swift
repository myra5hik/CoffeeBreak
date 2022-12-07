//
//  HistoryItem.swift
//  CoffeeBreak
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI

struct HistoryItem: View {
    var body: some View {
        
        
        Button(action: {
            
            //go to specific history page 
            
        }) {
            
            VStack(alignment: .leading){
                
                HStack {
                    Image("PotentialMatch")    .resizable()
                        .frame(width: 60.0, height: 60.0)
                    
                    Spacer().frame(width: 14.0)
                    
                    VStack (alignment: .leading){
                        Text("Lisa").fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("Discordapp.com/users/Lisa")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)

                        
                    }
                    Spacer().frame(width: 10.0)

                    VStack(alignment: .center){
                        Text("19/11/22")
                            .foregroundColor(.gray)
                            .fontWeight(.light)

                    }
                    Spacer().frame(width: 10.0)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                }
                
                
            }
            .padding(20)
            .background(CoffeeColors.interestsBackground)
            .cornerRadius(6)
            
        }//end category item
        
        

       
        
    }
}

struct HistoryItem_Previews: PreviewProvider {
    static var previews: some View {
        HistoryItem()
    }
}
