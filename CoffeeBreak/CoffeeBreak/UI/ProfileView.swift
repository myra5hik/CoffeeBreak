//
//  ProfileView.swift
//  testingAgainNC2
//
//  Created by Ravi  on 12/7/22.
//

import SwiftUI
import Combine

struct Profile {
    var name: String
    var interests: [DiscussionTopic]
    
    static func anonymusData() -> Profile {
        Profile(name: "Anonymus", interests: [])
    }
}

final class ProfileViewModel<U: IUserService>: ObservableObject {
    @Published var currentProfile: Profile
    @Published var editingName: String
    
    @Published var userService: U
    var store = Set<AnyCancellable>()
    
    
    init(userService: U) {
        self.userService = userService
        let profile: Profile
        if let currentUser = userService.currentUser {
            profile = Profile(name: currentUser.name, interests: currentUser.interests)
        } else {
            profile = Profile.anonymusData()
        }
        self.editingName = profile.name
        self.currentProfile = profile
        userService.currentUserPublisher.sink { [weak self] newUser in
            guard let self = self else { return }
            guard let currentUser = newUser else { return }
            self.currentProfile = Profile(name: currentUser.name, interests: currentUser.interests)
        }
        .store(in: &store)
        $currentProfile.sink { [weak self] newProfile in
            guard let self = self else { return }
            self.editingName = newProfile.name
        }
        .store(in: &store)
    }
    
    func setNewUserData() {
        self.userService.updateUserInfo(name: self.editingName, surname: nil, interests: self.currentProfile.interests)
    }
}

struct ProfileView<U: IUserService> : View {
    @State private var isEditing: Bool = false
    
    @ObservedObject var vm: ProfileViewModel<U>
    
    init(userService: U) {
        self.vm = ProfileViewModel(userService: userService)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack{
                    Spacer().frame(height: 20.0)
                    HStack {
                        Image("ProfileImage")
                            .padding(.horizontal, 30)
                        VStack(alignment: .leading){
                            Spacer().frame(height: 20.0)
                            if isEditing {
                                TextField("Your name:", text: $vm.editingName,axis: .vertical)
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    
                            } else {
                                Text(vm.currentProfile.name)
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    
                            }
                            Spacer().frame(height: 10.0)
                            Text("Apple developer adcademy")
                                .foregroundColor(.gray)
                                .font(.title3)
                            Spacer().frame(height: 20.0)
                            
                            Button(action: {
                                if isEditing == true {
                                    vm.setNewUserData()
                                }
                                self.isEditing.toggle()
                                
                            }) {
                                Text(self.isEditing ? "Confirm" : "Edit")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                    .underline()
                            }
                            
                        }
                    } //end of header Hstack
                    Spacer().frame(height: 60.0)
                    
                    VStack{
                        
                        Text("Interested in...")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.semibold)
                        Text("Click interests to edit:")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        
                        Spacer().frame(height: 20.0)
                        
                        
                        Group {
                            InterestsView(interests: vm.currentProfile.interests)
                        }
                        
                        Spacer().frame(height: 30)
                        
                        Text("Link to connect:")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Button(action: {
                            
                        }) {
                            Text("Discordapp.com/users/Roman")
                                .foregroundColor(CoffeeColors.innerBox)
                                .opacity(0.75)
                            Image(systemName: "square.and.pencil")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            
                        }
                        .padding(.bottom, 16)
                        .padding(.top, 16)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        
                        .background(CoffeeColors.interestsBackground)   .cornerRadius(30)
                        .opacity(0.75)
                    }
                    .padding()
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    .background(CoffeeColors.innerBox.clipShape(RoundedRectangle(cornerRadius:10)))
                    Spacer()
                    Text("Logout")
                        .underline()
                        .foregroundColor(CoffeeColors.innerBox)
                    
                    Spacer()
                }
            }   .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(CoffeeColors.backgroundColor)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userService: user)
    }
}

