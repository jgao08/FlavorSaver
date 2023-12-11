//
//  ProfileView.swift
//  FlavorSaver
//
//  Created by Jacky Gao on 10/29/23.
//

import Foundation
import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var user: User
    @State var signOut : Bool = false
    @State var folders: [Folder] = []
    @State var savedRecipes: [Recipe] = []
    
    
    var body: some View{
        NavigationStack{
            
            VStack{
                if user.getProfileID() == 0 {
                    Image("rat")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else if user.getProfileID() == 1 {
                    Image("raccoon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else if user.getProfileID() == 2 {
                    Image("guy")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                
                Text(user.getUsername())
                    .font(.title)
                    .bold()
                Divider()
                NavigationLink(destination: SavedRecipesView(), label: {
                    VStack{
                        HStack{
                            Text("Saved Recipes")
                                .font(.title)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.title)
                        }
                        .foregroundStyle(Color.black)
                        .padding()
                        
                        HStack {
                            ScrollView (.horizontal, showsIndicators: false ){
                                HStack{
                                    ForEach(savedRecipes, id: \.self){ recipe in
                                        RecipeCardLarge(recipe: recipe)
                                    }
                                }
                            }
                            .scrollClipDisabled()
                        }.padding(.horizontal)
                    }
                    
                })
            }
            .navigationBarItems(trailing:
            Button{
                signOut = true
            } label: {
                Image(systemName: "ellipsis")
            })
            .confirmationDialog("Select a color", isPresented: $signOut) {
                Button("Sign Out", role: .destructive) {
                    do{
                        try AccountManager.signOut(user: user)
                    } catch {
                        print("signout failed")
                        print(error)
                    }
                }
            }
            .onAppear() {
                savedRecipes = user.getSavedRecipes()
            }
            .onChange(of: user.getSavedRecipes()) {
                savedRecipes = user.getSavedRecipes()
            }
        }
    }
}

//#Preview {
//  ProfileView()
//}
