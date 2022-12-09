//
//  ContentView.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 06/12/22.
//

import SwiftUI







struct ContentView: View {
    
    @State public var tabViewSelection = 1
    
    init() {
    UITabBar.appearance().unselectedItemTintColor = UIColor.white

    }
    
    
    
    var body: some View {
        
        TabView(selection: $tabViewSelection){
            HistoryView()
                .preferredColorScheme(.dark)

                .tabItem {
                    Label("History", systemImage: "clock")
                
                }.tag(0)
                .foregroundColor(.white)
            MeetView()
                .preferredColorScheme(.dark)

                .tabItem {
                    Label("Coffee Break", systemImage: "cup.and.saucer.fill").environment(\.symbolVariants, .none)
                
                }.tag(1)
            ProfileView()
                .preferredColorScheme(.dark)

                .tabItem {
                    Label("Profile", systemImage: "person.fill").environment(\.symbolVariants, .none)
                }.tag(2)
            




           
        }
        .accentColor(.red) //tabview end
        
    }
        
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
