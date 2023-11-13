//
//  CookingModeView.swift
//  FlavorSaver
//
//  Created by Jennifer Zhang on 11/2/23.
//

import SwiftUI

struct CookingModeView: View {
    @EnvironmentObject var user: User
    @State var recipe : Recipe
    @Environment(\.presentationMode) var presentationMode
    @State var sheetOpen: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                TabView {
                    CookingModeIntro()
                    ForEach(recipe.getRecipeStepsWithAmounts(), id: \.0){ (stepIndex, step, ingredients) in
                        ScrollView {
                            HStack (spacing: 4) {
                                Text("Step")
                                    .font(.headline)
                                Text(String(stepIndex))
                                    .font(.headline)
                                Text("of")
                                    .font(.headline)
                                Text(String(recipe.getRecipeStepsWithAmounts().count))
                                    .font(.headline)
                                
                                Spacer()
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image(systemName: "x.circle.fill")
                                        .foregroundColor(.black)
                                        .font(.system(size: 24))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            }
                            .padding(.vertical, 16)
                            HStack{
                                Text(step)
                                    .font(.title)
                                Spacer()
                            }
                            HStack{
                                VStack{
                                    ForEach(ingredients, id: \.self) { ingredient in
                                        HStack {
                                            Button(action: {}, label: {
                                                Text(ingredient)
                                                    .multilineTextAlignment(.leading)
                                            })
                                            .disabled(true)
                                            .buttonStyle(.bordered)
                                            .foregroundStyle(Color.black)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                    }
                    CookingModeOutro(recipe: recipe, sheetOpen: sheetOpen).environmentObject(user)
                }
                .tabViewStyle(.page)
            }
        }
    }
}

struct CookingModeIntro: View {
    var body: some View {
        
        VStack (spacing: 128){
            VStack (spacing: 64){
                HStack {
                    Text("Cooking Mode")
                        .font(.headline)
                    Spacer()
                }
                Text("Welcome to Cooking Mode!")
                    .font(.title)
                    .foregroundStyle(Color.gray)
            }
            HStack{
                Spacer()
                VStack (alignment: .trailing) {
                    HStack {
                        Text("To go to the next step")
                            .font(.body)
                        Image(systemName: "chevron.right")
                    }
                    Text("Swipe left")
                        .font(.title)
                }
            }
            
            HStack {
                VStack (alignment: .leading) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("To go to the previous step")
                            .font(.body)
                    }
                    Text("Swipe right")
                        .font(.title)
                }
                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 32)
    }
}

struct CookingModeOutro: View {
    @EnvironmentObject var user: User
    @State var recipe : Recipe
    @Environment(\.presentationMode) var presentationMode
    @State var sheetOpen: Bool
    
    var body: some View {
        VStack{
            ZStack{
                AsyncImage(url: URL(string: recipe.image)) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "photo")
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / (3/2))
                            .clipped()
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        // Since the AsyncImagePhase enum isn't frozen,
                        // we need to add this currently unused fallback
                        // to handle any new cases that might be added
                        // in the future:
                        EmptyView()
                    }
                }
                
                VStack(spacing: 16){
                    HStack(alignment: .bottom){
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(recipe.name)
                                .font(.largeTitle)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundStyle(Color.white)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                            SaveButton(recipe: recipe)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
            }
            NavigationLink(destination: SavedRecipesView().environmentObject(user), label: {Text("Go to Saved Recipes")})
                .buttonStyle(.borderedProminent)
                .frame(alignment: .trailing)
            //                NavigationLink(destination: SavedRecipesView(), isActive: $sheetOpen) {
            //                    SaveButton(recipe: recipe)
            //                }
            //            Button("Go to Saved Recipes") {
            //                sheetOpen = false
            //            }
            //            .padding()
            //            .background(NavigationLink("", destination: SavedRecipesView()))
//            NavigationLink(destination: SavedRecipesView()) {
//                Button("Go to Saved Recipes") {
//                    sheetOpen = false
//                }
//            }
//            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
