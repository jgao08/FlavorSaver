//
//  RecipeView.swift
//  FlavorSaver
//
//  Created by Jennifer Zhang on 11/2/23.
//

import SwiftUI

struct RecipeView: View {
//  let vodkaSearch = RecipeSearch(recipeID: 640026)
  @State var recipeSearch : RecipeSearch
  let sectionSpacing: CGFloat = 32
  let paraSpacing: CGFloat = 16
  @State private var cookingMode = false
  @State var recipe : Recipe? = nil
  @State var recipeSteps : [(String, [String])] = []
  @State var recipeIngredients : [String] = []
  @State var recipeDescription : String = ""
  @State var tags : [String] = []
  @State var authorName : String = ""

  func fetchRecipe() {
    Task {
      print("Starting search...")
      recipe = await recipeSearch.getRecipeInfo()
      if let recipeResult = recipe {
        print("Success!")
        recipeSteps = recipeResult.getRecipeSteps()
        recipeIngredients = recipeResult.getIngredientsWithAmounts()
        recipeDescription = recipeResult.summary
        tags = recipeResult.dishTypes
        authorName = recipeResult.author
      }
    }
  }
  
  var body: some View {
    ScrollView{
      VStack{
        ZStack{
          Image("testimg2")
            .resizable()
            .frame(height: UIScreen.main.bounds.height / (3/2))
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
          
          VStack(spacing: paraSpacing){
            Spacer()
            HStack{
              Text("Recipe Title")
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(Color.white)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
              Spacer()
            }
            .padding(.horizontal)
            
            
            HStack{
              Button(action: {
                cookingMode.toggle()
              }, label: {
                Image(systemName: "play.fill")
                Text("Cooking Mode")
              })
              .tint(.white)
              .controlSize(.large)
              .buttonStyle(.borderedProminent)
              .foregroundStyle(Color.black)
              .shadow(radius: 10)
              .sheet(isPresented: $cookingMode, content: {
                CookingModeView()
              })
              Spacer()
            }
            .padding(.horizontal)
          }
          .padding(.bottom, sectionSpacing)
        }
        
        
        VStack(spacing: sectionSpacing){
          VStack(spacing: paraSpacing){
            Text(recipeDescription)
            
            
            HStack{
              ForEach(tags, id: \.self) {tag in
                Button(action: {}, label: {
                  Text(tag)
                })
                .buttonStyle(.bordered)
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .foregroundStyle(Color.black)
              }
              Spacer()
            }
            
            
            HStack{
              Text("by " + authorName)
                .font(.caption)
              Spacer()
            }
          }
          
          VStack(spacing: paraSpacing){
            HStack{
              Text("Ingredients")
                .font(.headline)
              Spacer()
            }
            
            
            VStack{
              ForEach(recipeIngredients, id: \.self){ ing in
                HStack{
                  Text("• " + ing)
                  Spacer()
                }
              }
            }
          }
          
          
          VStack(spacing: paraSpacing){
            HStack{
              Text("Steps")
                .font(.headline)
              Spacer()
            }
            
            
            HStack{
              ForEach(recipeSteps, id: \.0){ step, ingredients in
                Text(step)
                ForEach(ingredients, id: \.self){ ingredient in
                    Text(ingredient)
                }
              }
              Spacer()
            }
          }
        }
        .padding(.bottom, sectionSpacing)
        .padding(.top, paraSpacing)
        .padding(.horizontal, paraSpacing)
      }
    }
    .edgesIgnoringSafeArea(.top)
    .task {
      fetchRecipe()
    }
  }
  
}



//#Preview {
//    RecipeView()
//}
