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
    
    @State var title: String = ""
    @State var progressValue: Float = 0
    @State var selected: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                CookingModeHeader(title: $title, progressValue: $progressValue)
                TabView (selection: $selected) {
                    CookingModeIntro(recipe: recipe, title: $title, progressValue: $progressValue, selected: $selected)
                        .tag(0)
                    ForEach(recipe.getRecipeStepsWithAmounts(), id: \.0){ (stepIndex, step, ingredients) in
                        ScrollView {
                            CookingModeStep(recipe: recipe, stepIndex: stepIndex, step: step, ingredients: ingredients, title: $title, progressValue: $progressValue, selected: $selected)
                                .tag(stepIndex)
                        }
                    }
                    CookingModeOutro(recipe: recipe, sheetOpen: sheetOpen, title: $title, progressValue: $progressValue, selected: $selected).environmentObject(user)
                        .tag(100)
                }
                .tabViewStyle(.page)
            }
        }
        .onAppear {
            title = recipe.name
        }
    }
}

struct CookingModeIntro: View {
    var recipe: Recipe
    @Binding var title: String
    @Binding var progressValue: Float
    @Binding var selected: Int
    
    var body: some View {
        VStack {
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
                
                Text("Ready in \(recipe.readyInMinutes)")
                Text("\(recipe.getRecipeStepsWithAmounts().count) steps")

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
        }.onChange(of: selected) {
            if selected == 0 {
                title = recipe.name
                progressValue = 0
            }
        }
    }
}

struct CookingModeStep: View {
    @State var recipe: Recipe
    @State var stepIndex: Int
    @State var step: String
    @State var ingredients: [String]
    @Binding var title: String
    @Binding var progressValue: Float
    @Binding var selected: Int

    
    var body: some View {
        VStack {
//            CookingModeHeader(title: "Step \(stepIndex) of \(recipe.getRecipeStepsWithAmounts().count)", progressValue: (Float(stepIndex)/Float(recipe.getRecipeStepsWithAmounts().count+1)))
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
        .onChange(of: selected) {
            if selected == stepIndex {
                title = "Step \(stepIndex) of \(recipe.getRecipeStepsWithAmounts().count)"
                progressValue = (Float(stepIndex)/Float(recipe.getRecipeStepsWithAmounts().count+1))
            }
        }
    }
}

struct CookingModeOutro: View {
    @EnvironmentObject var user: User
    @State var recipe : Recipe
    @Environment(\.presentationMode) var presentationMode
    @State var sheetOpen: Bool
    @Binding var title: String
    @Binding var progressValue: Float
    @Binding var selected: Int

    
    var body: some View {
        VStack {
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
        .onChange(of: selected) {
            if selected == 100 {
                title = "Recipe Complete!"
                progressValue = 1
            }
        }
    }
}

struct CookingModeHeader: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var title: String
    @Binding var progressValue: Float
    
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
