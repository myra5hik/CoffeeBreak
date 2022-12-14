//
//  MeetActiveView.swift
//  CoffeeBreak
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI

struct MeetActiveView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var exitWarningConfirm: Bool = false
    @State private var displayCopied: Bool = false
    @Binding var matchID: String
    
    let imageLink: String = "PotentialMatch"
    let interests = ["Gaming", "Hiking", "UX Design"]
    let discordLink: String = "Discordapp.com/users/Andrea"
    let https: String = "https://"

    //ENTIRE PROFILE OF PERSON
    
    @ScaledMetric var textSize: CGFloat = 1
    
    var body: some View {
        
        VStack {
            Spacer().frame(height: 20 + textSize)
            Text("Your coffee mate is...")
                .foregroundColor(CoffeeColors.subText)
                .font(.system(size: 20 + textSize))
            Spacer().frame(height: 20 + textSize)
            VStack{
                
                
                Text(matchID)
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.bold)
                Image(imageLink)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 100, maxWidth: 200)
                
                Spacer().frame(height: 20)

                HStack{
                    
                    
                    Text(interests[0])
                        .foregroundColor(.gray)
                        .bold()
                        .padding(.leading, 24)
                        .padding(.trailing, 24)
                        .padding(.bottom, 10)
                        .padding(.top, 10)
                        .background(Rectangle()
                            .fill(CoffeeColors.innerBox)
                            .cornerRadius(10))
                    Text(interests[1])
                        .foregroundColor(.gray)
                        .bold()
                        .padding(.leading, 24)
                        .padding(.trailing, 24)
                        .padding(.bottom, 10)
                        .padding(.top, 10)
                        .background(Rectangle()
                            .fill(CoffeeColors.innerBox)
                            .cornerRadius(10))
                    
                      } //end of hstack
                
                Text(interests[2])
                    .foregroundColor(.gray)
                    .bold()
                    .padding(.leading, 24)
                    .padding(.trailing, 24)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .background(Rectangle()
                        .fill(CoffeeColors.innerBox)
                        .cornerRadius(10)
                    )
                    
            }
            
            //meeting point discussion VStack
            
            Spacer().frame(height: 20)

            VStack{
                Text("Tell them where to meet you:")
                    .foregroundColor(.gray)
                    .bold()
                    .padding(.leading, 24)
                    .padding(.trailing, 24)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
   
                Button(action: {
           
                    UIPasteboard.general.setValue(https+discordLink, forPasteboardType: "public.plain-text")

                    displayCopied = true
                             
                }) {
                    
                    Text(discordLink)
                        .foregroundColor(.white)
                        .opacity(0.75)
                    
                    Image(systemName: "doc.on.doc.fill")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                }
                .alert("Profile link copied!", isPresented: $displayCopied) {
                            Button("OK") { }
                        }
                .padding(.leading, 10+textSize)
                .padding(.trailing, 10+textSize)
                .padding(.bottom, 20)
                .padding(.top, 20)
                .frame(maxWidth: .infinity)
                .background(CoffeeColors.backgroundColor)   .cornerRadius(30)
                .opacity(0.9)
                

                Spacer().frame(height: 20)

                Button(action: {
                    if let url = URL(string: https+discordLink) {
                           UIApplication.shared.open(url)
                        }
                }) {
                    Text("Connect Us")
                        .foregroundColor(CoffeeColors.innerBox)
                        .bold()
                        .padding(.bottom, 16)
                        .padding(.top, 16)
                        .frame(maxWidth: .infinity)
                        .background(.green).cornerRadius(10)
                        .opacity(0.9)
                }
                    
            }
            .padding()
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .background(CoffeeColors.innerBox.clipShape(RoundedRectangle(cornerRadius:10)))
            Spacer()

            Button(action: {
                exitWarningConfirm = true
              
                
            }) {
                
                Text("End Break")
                    .bold()
                    .foregroundColor(.red)
                
            }
            .confirmationDialog("Are you sure?",
              isPresented: $exitWarningConfirm) {
              Button("End Break Now", role: .destructive) {
                  
                dismiss()
               }
             }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CoffeeColors.backgroundColor)
    }
}

struct MeetActiveView_Previews: PreviewProvider {
    static var previews: some View {
        MeetActiveView(matchID: .constant("Valerie Constantine"))
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        MeetActiveView(matchID: .constant("Valerie Constantine"))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))

    }
}

