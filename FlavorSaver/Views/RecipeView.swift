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
  @State var recipeSteps : [(String, [String])] = [("In a large heavy-bottomed French or Dutch oven, heat the oil over medium high heat.", ["cooking oil"]), ("Add the garlic and shallots and gently saute for 3-5 minutes, stirring constantly until fragrant and translucent. Lower the heat if the garlic starts to brown.", ["shallot", "garlic"]), ("Add the piment dEspelette or red pepper flakes, if using.", ["red pepper flakes"]), ("Pour in the vodka and let reduce by half, another 3-5 minutes.", ["vodka"]), ("Add in the tomatoes and a sprinkling of salt. Bring to a boil and let simmer, uncovered, stirring often to break up the tomatoes, until sauce is thick, about 15 minutes.", ["tomato", "sauce", "salt"]), ("Meanwhile, bring a large stockpot of water to a boil over high heat. Once the water boils, salt the water and cook penne until just under al dente, about 9 minutes and then drain in a colander.", ["penne", "water", "salt"]), ("While the pasta cooks, stir cream into the thickened tomato sauce. Bring to a boil and lower heat to a simmer. Season again with salt and pepper to taste.", ["salt and pepper", "tomato sauce", "cream", "pasta"]), ("Add the drained pasta to the tomato sauce and stir to coat the pasta with the sauce. The sauce should be thick enough to coat the pasta; continue to stir and reduce if needed.", ["tomato sauce", "pasta", "sauce"]), ("Turn off the heat and sprinkle Parmigiano-Reggiano over the pasta and toss to coat evenly.", ["parmigiano reggiano", "pasta"]), ("Just before serving, thinly slice or tear up the basil leaves. Divide pasta among 4 serving platters.", ["fresh basil", "pasta"]), ("Garnish with a sprinkling of Parmigiano-Reggiano and basil.", ["parmigiano reggiano", "basil"])]
  @State var recipeIngredients : [String] = []
  @State var recipeDescription : String = ""
  @State var tags : [String] = []
  @State var authorName : String = ""

  func fetchRecipe() {
    Task {
      print("Starting search on \(recipeSearch.getRecipeID())...")
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
            
            
            VStack{
              ForEach(recipeSteps, id: \.0){ step, ingredients in
                VStack{
                  HStack{
                    Text(step)
                    Spacer()
                  }
                  HStack{
                    VStack{
                      ForEach(ingredients, id: \.self){ ingredient in
                        HStack{
                          Button(action: {}, label: {
                            Text(ingredient)
                          })
                          .disabled(true)
                          .buttonStyle(.bordered)
                          Spacer()
                        }
                      }
                    }
                  }
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
