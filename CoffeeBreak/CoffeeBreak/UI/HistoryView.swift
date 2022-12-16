//
//  HistoryView.swift
//  testingAgainNC2
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI


struct HistoryStandard: Identifiable {
    var id = UUID()
    var name: String
    var discordLink: String
    //    var interests: Array<Any>
}



struct historyRow: View {

    @State var name: String
    @State var discordLink: String
    
    
    var body: some View {
        VStack(alignment: .leading){
            
            HStack {
                Image("PotentialMatch")    .resizable()
                    .frame(width: 60.0, height: 60.0)
                
                Spacer().frame(width: 14.0)
                
                VStack (alignment: .leading){
                    Text(name).fontWeight(.bold)
                    
                        .foregroundColor(.white)
                    Text(discordLink)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    
                    
                }
                Spacer().frame(width: 10.0)
                
                VStack(alignment: .center){
                    Text("19/11/22")
                        .foregroundColor(.gray)
                        .fontWeight(.light)
                    
                }
                Spacer().frame(width: 10.0)
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(20)
        .background(CoffeeColors.innerBox)
        .cornerRadius(6)
    }
}


struct HistoryView: View {
    
    @State private var name: String = ""
    @State private var goesToHistoryDetail: Bool = true
    let haptics = HapticFeedback()

    
    
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor.clear
        navBarAppearance.barTintColor = UIColor(CoffeeColors.innerBox)
        
    }
    
    let history = [
        HistoryStandard(name: "Mario", discordLink: "Discord.com/user/mario"),
        HistoryStandard(name: "Angie", discordLink: "Discord.com/user/angie"),
        HistoryStandard(name: "Luigi", discordLink: "Discord.com/user/luigi"),
        HistoryStandard(name: "Tara Socc", discordLink: "Discord.com/user/tara"),
        HistoryStandard(name: "Brois", discordLink: "Discord.com/user/brois"),
        HistoryStandard(name: "sdfk Ks", discordLink: "Discord.com/user/sdfks"),
    ]
    
    var body: some View {
        
        
        
        
        VStack {
            
            NavigationView {
                
                ScrollView {
                    
                    LazyVStack {
                        Spacer().frame(height: 30)

                        
                        
                        ForEach(0 ..< history.count, id: \.self) { value in
                            NavigationLink(destination: HistoryDetailsView(name: history[value].name, discordLink: history[value].discordLink))
                            {
                                
                                historyRow(name: history[value].name, discordLink: history[value].discordLink)
                            }.onTapGesture{
                                haptics.lightSelection.impactOccurred()
                            }
                            
                        }
                        
                        
                    }
                    
                }
                .navigationBarTitle(Text("Match History"))
                .background(CoffeeColors.backgroundColor)
                
            }
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
    }
}







struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
