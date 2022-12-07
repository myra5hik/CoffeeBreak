//
//  InterestsView.swift
//  CoffeeBreak
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI

struct InterestsView: View {
    var body: some View {
        Menu {
            //start button
            Button {
                // do something
            } label: {
                Text("Coding")
                Image(systemName: "star.fill")
            }//end button
            
            //start button
            Button {
                // do something
            } label: {
                Text("UI Design")
                Image(systemName: "star.fill")
            }//end button
           
            //start button
            Button {
                // do something
            } label: {
                Text("UX Design")
                Image(systemName: "star.fill")
            }//end button
            
            //start button
            Button {
                // do something
            } label: {
                Text("Gaming")
                Image(systemName: "star.fill")
            }//end button
            
            //start button
            Button {
                // do something
            } label: {
                Text("Game Development")
                Image(systemName: "star.fill")
            }//end button
            
            //start button
            Button {
                // do something
            } label: {
                Text("Hiking")
                Image(systemName: "star.fill")
            }//end button
            
            //start button
            Button {
                // do something
            } label: {
                Text("Football")
                Image(systemName: "star.fill")
            }//end button
            
        } label: {
            Text("Pick Your Interest")
                .foregroundColor(.black)
             Image(systemName: "wand.and.stars.inverse")
                .foregroundColor(.black)

        }
        
    }
}

struct InterestsView_Previews: PreviewProvider {
    static var previews: some View {
        InterestsView()
    }
}
