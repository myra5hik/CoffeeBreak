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
        UITabBar.appearance().unselectedItemTintColor = UIColor.label
    }
    
    var body: some View {
        TabView(selection: $tabViewSelection) {
            factory.makeHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }.tag(0)
                .foregroundColor(Color("TextColor"))
            factory.makeMeetView()
                .tabItem {
                    Label("Coffee Break", systemImage: "cup.and.saucer.fill").environment(\.symbolVariants, .none)
                }.tag(1)
                .foregroundColor(Color("TextColor"))
            factory.makeProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill").environment(\.symbolVariants, .none)
                }.tag(2)
                .foregroundColor(Color("TextColor"))
        }
        .accentColor(Color("Stroke")) //tabview end
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
