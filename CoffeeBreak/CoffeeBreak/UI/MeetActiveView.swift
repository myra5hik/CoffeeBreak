//
//  MeetActiveView.swift
//  CoffeeBreak
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI

struct MeetActiveView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            Button(action: {
                dismiss()
                
            }) {
                
                Text("Close Modal")
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CoffeeColors.backgroundColor)
    }
}

struct MeetActiveView_Previews: PreviewProvider {
    static var previews: some View {
        MeetActiveView()
    }
}
