//
//  ContentView.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 06/12/22.
//

import SwiftUI

struct ContentView<M: IMatchService>: View {
    
    @State public var tabViewSelection = 1
    private let matchService: M
    
    init(matchService: M) {
        self.matchService = matchService
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
            MeetView(matchService: matchService)
                .preferredColorScheme(.dark)

                .tabItem {
                    Label("Coffee Break", systemImage: "cup.and.saucer.fill").environment(\.symbolVariants, .none)
                
                }.tag(1)
            ProfileView(userService: user)
                .preferredColorScheme(.dark)

                .tabItem {
                    Label("Profile", systemImage: "person.fill").environment(\.symbolVariants, .none)
                }.tag(2)
              
        }
        .accentColor(.red) //tabview end
        
    }
  
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
