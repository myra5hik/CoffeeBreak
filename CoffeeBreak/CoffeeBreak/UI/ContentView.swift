//
//  ContentView.swift
//  CoffeeBreak
//
//  Created by Alexander Tokarev on 06/12/22.
//

import SwiftUI

struct ContentView<SF: IScreenFactory>: View {
    
    @State public var tabViewSelection = 1
    private weak var factory: SF!
    
    init(factory: SF) {
        self.factory = factory
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }
    
    var body: some View {
        TabView(selection: $tabViewSelection) {
            factory.makeHistoryView()
                .preferredColorScheme(.dark)
                .tabItem {
                    Label("History", systemImage: "clock")
                }.tag(0)
                .foregroundColor(.white)
            factory.makeMeetView()
                .preferredColorScheme(.dark)
                .tabItem {
                    Label("Coffee Break", systemImage: "cup.and.saucer.fill").environment(\.symbolVariants, .none)
                }.tag(1)
            factory.makeProfileView()
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
