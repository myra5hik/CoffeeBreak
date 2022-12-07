//
//  MeetView.swift
//  testingAgainNC2
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI


struct MeetView: View {
    

    
    @State private var TakeABreakPressed = false

    var body: some View {
        
        VStack{
            
            VStack(alignment: .leading, spacing: 4){
                Spacer().frame(height: 60.0)
                Text("Coffee Break")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Find others who are taking a break \nand connect.")
                    .font(.subheadline)
                    .foregroundColor(CoffeeColors.subText)
            }
            
            
            Spacer()
            
            Button(action: {
                TakeABreakPressed.toggle()
                
            }) {
                
                Image("MeetButton")
                    .padding()
                
            }//end category item
            .fullScreenCover(isPresented: $TakeABreakPressed, content: MeetActiveView.init)

            Spacer().frame(height: 60.0)

            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CoffeeColors.backgroundColor)
    }
}

struct MeetView_Previews: PreviewProvider {
    static var previews: some View {
        MeetView()
    }
}
