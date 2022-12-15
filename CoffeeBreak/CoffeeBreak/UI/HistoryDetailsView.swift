//
//  HistoryDetailsView.swift
//  CoffeeBreak
//
//  Created by Ravi  on 12/15/22.
//

import SwiftUI

struct HistoryDetailsView: View {
    
    @State var name: String
    @State var discordLink: String

  
    
    
    var body: some View {
        VStack {
            Spacer()
            VStack (alignment: .center){
                
                Image("PotentialMatch")
                    .resizable()
                    .frame(width: 200.0, height: 200.0)
                
                Text(name)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
            }
            
            Spacer().frame(height: 10)
            
            VStack (alignment: .leading){
                
                Text(discordLink).font(.title)
                    .foregroundColor(.white)
                
            }
            
            Spacer()
        
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(CoffeeColors.backgroundColor)
        
    }
}

struct HistoryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDetailsView(name: ("Margaret Leemonas"), discordLink: ("Discord.com/user/mario32"))
    }
}
