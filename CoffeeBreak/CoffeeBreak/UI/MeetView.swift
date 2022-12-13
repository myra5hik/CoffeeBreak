//
//  MeetView.swift
//  testingAgainNC2
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI

struct MeetView<M: IMatchService>: View {
    
    @State private var matchID = "Sample Name"
    @State private var exitSearchWarning: Bool = false
    @ObservedObject private var service: M
    
    init(matchService: M) {
        self.service = matchService
    }

    let topic = DiscussionTopic.coding
    var interestsArray = ["Gaming", "Hiking", "Biking"]
    @State private var takeABreakPressed = false

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
            Spacer().frame(height: 50.0)

            Image("funIllustration")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200.0)
                .opacity(0.5)

            Spacer()
            
   
            Button(action: {
//                takeABreakPressed.toggle()
                service.requestCoffeeBreak()
                
            }) {
                switch service.matchState {
                    case .uninitiated:
                        Text("Loading: State Uninitiated").foregroundColor(.white)
                    case .idle: Image("MeetButton").padding()
                    case .searching: Image("searching").padding()
                    case .match(let counterpartId):
                        let _ = print(counterpartId)
                    case .error(let error):
                        Text(error.localizedDescription)
                }
  
            }//end category item
            .disabled(service.matchState == .uninitiated) //edit this!
            .opacity(service.readyForRequests ? 1 : 0.1)
            .fullScreenCover(isPresented: $takeABreakPressed,
                             content: {MeetActiveView(matchID: $matchID)})
            .onChange(of: service.matchState, perform: { state in
                if case .match(with: let counterpartId) = state {
                    matchID = counterpartId
                    takeABreakPressed = true
                }else{
                    matchID = ""
                    takeABreakPressed = false 
                }
                
                if case .error(let error) = state {
                    print(error)
                }
            })

            if (service.matchState == .searching){
                Button(action: {
                    exitSearchWarning = true
                    
                }) {
                    
                    Text("Cancel Search")
                        .bold()
                        .foregroundColor(.red)
                    
                }
                .confirmationDialog("Are you sure?",
                  isPresented: $exitSearchWarning) {
                  Button("End Search", role: .destructive) {
                      service.cancelCoffeeBreakRequest()
                   }
                 }
            }//end of cancel search button
  
            Spacer().frame(height: 60.0)
 
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CoffeeColors.backgroundColor)
    }
}

//struct MeetView_Previews: PreviewProvider {
//    static var previews: some View {
//        MeetView()
//    }
//}
