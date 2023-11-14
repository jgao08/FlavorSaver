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
                    CookingModeIntro(recipe: recipe)
                    ForEach(recipe.getRecipeStepsWithAmounts(), id: \.0){ (stepIndex, step, ingredients) in
                        ScrollView {
                            CookingModeStep(recipe: recipe, stepIndex: stepIndex, step: step, ingredients: ingredients)
                        }
                    }
                    CookingModeOutro(recipe: recipe, sheetOpen: sheetOpen).environmentObject(user)
                }
                .tabViewStyle(.page)
            }
        }
    }
}

struct CookingModeIntro: View {
    var recipe: Recipe
    
    var body: some View {
        VStack {
            CookingModeHeader(title: recipe.name, progressValue: 0)
            
            VStack (spacing: 128){
                Text("Welcome to Cooking Mode!")
                    .font(.title)
                    .foregroundStyle(Color.gray)
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
}

struct CookingModeStep: View {
    @State var recipe: Recipe
    @State var stepIndex: Int
    @State var step: String
    @State var ingredients: [String]
    
    var body: some View {
        VStack {
            CookingModeHeader(title: "Step \(stepIndex) of \(recipe.getRecipeStepsWithAmounts().count)", progressValue: (Float(stepIndex)/Float(recipe.getRecipeStepsWithAmounts().count+1)))
            VStack {
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
            .padding(.top, 16)
            .padding(.horizontal, 16)
        }
    }
}

struct CookingModeOutro: View {
    @EnvironmentObject var user: User
    @State var recipe : Recipe
    @Environment(\.presentationMode) var presentationMode
    @State var sheetOpen: Bool
    
    var body: some View {
        VStack{
            CookingModeHeader(title: "Recipe Complete!", progressValue: 1)
            GeometryReader { proxy in
                ZStack{
                    AsyncImage(url: URL(string: recipe.image)) { phase in
                        switch phase {
                        case .empty:
                            Image(systemName: "photo")
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: proxy.size.width, height: proxy.size.height / (3/2))
                                .clipped()
                                .cornerRadius(10)
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    HStack {
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
                    .padding(16)
                    .padding(.bottom, 32)
                    .frame(width: proxy.size.width, height: proxy.size.height / (3/2))
                    
                }
                .padding(.top, 16)
                Spacer()
                //            NavigationLink(destination: SavedRecipesView().environmentObject(user), label: {Text("Go to Saved Recipes")})
                //                .buttonStyle(.borderedProminent)
                //                .frame(alignment: .trailing)
            }
        }
    }
}

struct CookingModeHeader: View {
    @Environment(\.presentationMode) var presentationMode
    @State var title: String
    @State var progressValue: Float
    
    var body: some View {
        VStack {
            HStack (spacing: 4) {
                Text(title)
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.black)
                        .font(.system(size: 24))
                }
            }.padding(.top, 16)
        }.padding(.horizontal, 16)
        ProgressView(value: progressValue)
    }
}
