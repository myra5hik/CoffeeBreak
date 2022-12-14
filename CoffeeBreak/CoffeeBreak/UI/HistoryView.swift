//
//  HistoryView.swift
//  testingAgainNC2
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI

struct HistoryView: View {

    @State private var name: String = ""

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
                        VStack {
                            HistoryItem(name: .constant("Alexandra"))
                            HistoryItem(name: .constant("Pedro"))
                            HistoryItem(name: .constant("Mario"))
                            HistoryItem(name: .constant("Lexi"))
                            HistoryItem(name: .constant("Mama"))
                            HistoryItem(name: .constant("Mia"))
                            HistoryItem(name: .constant("Luigi"))
                            HistoryItem(name: .constant("Brielle"))
                            HistoryItem(name: .constant("Bob"))
                            HistoryItem(name: .constant("Fire"))
                        }
                        
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
