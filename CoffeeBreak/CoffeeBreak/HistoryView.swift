//
//  HistoryView.swift
//  testingAgainNC2
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI

struct HistoryView: View {

    
    var body: some View {
        
        
       
        
        NavigationStack {
            
            ScrollView {
                
                LazyVStack{
                    
                    Spacer().frame(height: 20.0)

                    Text("Your Match History")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    
                    Spacer().frame(height: 20.0)
                    
                    Group {
                        HistoryItem()
                        HistoryItem()
                        HistoryItem()
                        HistoryItem()
                        HistoryItem()
                        HistoryItem()
                        HistoryItem()
                        HistoryItem()
                        HistoryItem()
                        HistoryItem()
                    }
                  
                   

                    

                    
                    
                    
                    
                }
            
            }.background(CoffeeColors.backgroundColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }

    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
